#!/usr/bin/env python3
"""Extract a model-derived collision catalogue from GIANTS vehicle XML/I3D assets.

Prototype 08B deliberately separates what can be recovered from XML from the
mesh extents stored in the proprietary .i3d.shapes binary. It emits collision
identity, hierarchy, transforms, configuration membership, fold animation
segments, and predicted collision-node origins at deployed/folded endpoints.
Local mesh bounds remain null unless a future trusted exporter supplies them.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from dataclasses import dataclass, field
from pathlib import Path
import xml.etree.ElementTree as ET
from typing import Iterable


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def vec(text: str | None, default: tuple[float, float, float]) -> tuple[float, float, float]:
    if not text:
        return default
    values = [float(v) for v in text.split()]
    if len(values) != 3:
        raise ValueError(f"Expected three values, got {text!r}")
    return values[0], values[1], values[2]


def lerp(a: tuple[float, float, float], b: tuple[float, float, float], t: float) -> tuple[float, float, float]:
    return tuple(a[i] + (b[i] - a[i]) * t for i in range(3))  # type: ignore[return-value]


def mat_mul(a: list[list[float]], b: list[list[float]]) -> list[list[float]]:
    return [[sum(a[r][k] * b[k][c] for k in range(4)) for c in range(4)] for r in range(4)]


def local_matrix(translation: tuple[float, float, float], rotation_deg: tuple[float, float, float], scale: tuple[float, float, float]) -> list[list[float]]:
    # GIANTS I3D rotations are Euler degrees. This XYZ implementation is a
    # provisional offline prediction and must be validated against Prototype 08A.
    rx, ry, rz = [math.radians(v) for v in rotation_deg]
    cx, sx = math.cos(rx), math.sin(rx)
    cy, sy = math.cos(ry), math.sin(ry)
    cz, sz = math.cos(rz), math.sin(rz)
    mx = [[1,0,0,0],[0,cx,-sx,0],[0,sx,cx,0],[0,0,0,1]]
    my = [[cy,0,sy,0],[0,1,0,0],[-sy,0,cy,0],[0,0,0,1]]
    mz = [[cz,-sz,0,0],[sz,cz,0,0],[0,0,1,0],[0,0,0,1]]
    s = [[scale[0],0,0,0],[0,scale[1],0,0],[0,0,scale[2],0],[0,0,0,1]]
    t = [[1,0,0,translation[0]],[0,1,0,translation[1]],[0,0,1,translation[2]],[0,0,0,1]]
    return mat_mul(t, mat_mul(mz, mat_mul(my, mat_mul(mx, s))))


@dataclass
class SceneNode:
    name: str
    tag: str
    attrs: dict[str, str]
    parent: "SceneNode | None" = None
    children: list["SceneNode"] = field(default_factory=list)

    @property
    def translation(self) -> tuple[float, float, float]:
        return vec(self.attrs.get("translation"), (0.0, 0.0, 0.0))

    @property
    def rotation(self) -> tuple[float, float, float]:
        return vec(self.attrs.get("rotation"), (0.0, 0.0, 0.0))

    @property
    def scale(self) -> tuple[float, float, float]:
        return vec(self.attrs.get("scale"), (1.0, 1.0, 1.0))


@dataclass
class AnimSegment:
    start: float
    end: float
    start_trans: tuple[float, float, float] | None
    end_trans: tuple[float, float, float] | None
    start_rot: tuple[float, float, float] | None
    end_rot: tuple[float, float, float] | None


def build_scene(i3d_path: Path) -> tuple[SceneNode, dict[str, SceneNode]]:
    tree = ET.parse(i3d_path)
    scene = tree.getroot().find("Scene")
    if scene is None:
        raise ValueError("I3D Scene element not found")
    root = SceneNode("__SCENE__", "Scene", {})
    by_name: dict[str, SceneNode] = {}

    def visit(element: ET.Element, parent: SceneNode) -> None:
        node = SceneNode(element.attrib.get("name", f"unnamed-{element.attrib.get('nodeId','?')}"), element.tag, dict(element.attrib), parent)
        parent.children.append(node)
        by_name.setdefault(node.name, node)
        for child in element:
            if child.tag in {"TransformGroup", "Shape", "Camera", "Light"}:
                visit(child, node)

    for child in scene:
        if child.tag in {"TransformGroup", "Shape", "Camera", "Light"}:
            visit(child, root)
    return root, by_name


def parse_animation(vehicle_root: ET.Element, config_name: str) -> tuple[str, float, dict[str, list[AnimSegment]]]:
    config = None
    for candidate in vehicle_root.findall("./animations/animationConfigurations/animationConfiguration"):
        if candidate.attrib.get("name") == config_name:
            config = candidate
            break
    if config is None:
        raise ValueError(f"animationConfiguration {config_name} not found")
    animation = config.find("animation")
    if animation is None:
        raise ValueError("animation element not found")
    segments: dict[str, list[AnimSegment]] = {}
    duration = 0.0
    for part in animation.findall("part"):
        start = float(part.attrib.get("startTime", "0"))
        end = float(part.attrib.get("endTime", str(start)))
        duration = max(duration, end)
        node = part.attrib["node"]
        seg = AnimSegment(
            start=start,
            end=end,
            start_trans=vec(part.attrib.get("startTrans"), (0,0,0)) if "startTrans" in part.attrib else None,
            end_trans=vec(part.attrib.get("endTrans"), (0,0,0)) if "endTrans" in part.attrib else None,
            start_rot=vec(part.attrib.get("startRot"), (0,0,0)) if "startRot" in part.attrib else None,
            end_rot=vec(part.attrib.get("endRot"), (0,0,0)) if "endRot" in part.attrib else None,
        )
        segments.setdefault(node, []).append(seg)
    for value in segments.values():
        value.sort(key=lambda s: (s.start, s.end))
    return animation.attrib.get("name", "unknown"), duration, segments


def animated_value(base: tuple[float,float,float], segments: list[AnimSegment], time: float, kind: str) -> tuple[float,float,float]:
    value = base
    for seg in segments:
        start_value = seg.start_trans if kind == "translation" else seg.start_rot
        end_value = seg.end_trans if kind == "translation" else seg.end_rot
        if start_value is None or end_value is None:
            continue
        if time < seg.start:
            return value if value != base else start_value
        if seg.start <= time <= seg.end:
            factor = 1.0 if seg.end <= seg.start else (time - seg.start) / (seg.end - seg.start)
            return lerp(start_value, end_value, max(0.0, min(1.0, factor)))
        value = end_value
    return value


def world_matrix(node: SceneNode, time: float, animation: dict[str, list[AnimSegment]]) -> list[list[float]]:
    lineage: list[SceneNode] = []
    current: SceneNode | None = node
    while current is not None and current.name != "__SCENE__":
        lineage.append(current)
        current = current.parent
    matrix = [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]]
    for item in reversed(lineage):
        segs = animation.get(item.name, [])
        translation = animated_value(item.translation, segs, time, "translation")
        rotation = animated_value(item.rotation, segs, time, "rotation")
        matrix = mat_mul(matrix, local_matrix(translation, rotation, item.scale))
    return matrix


def origin(matrix: list[list[float]]) -> list[float]:
    return [round(matrix[0][3], 6), round(matrix[1][3], 6), round(matrix[2][3], 6)]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--vehicle-xml", required=True, type=Path)
    parser.add_argument("--i3d", required=True, type=Path)
    parser.add_argument("--shapes", required=True, type=Path)
    parser.add_argument("--configuration", default="1")
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()

    vehicle_tree = ET.parse(args.vehicle_xml)
    vehicle_root = vehicle_tree.getroot()
    _, by_name = build_scene(args.i3d)

    mappings = {e.attrib["id"]: e.attrib["node"] for e in vehicle_root.findall("./i3dMappings/i3dMapping")}
    folding = None
    for candidate in vehicle_root.findall("./foldable/foldingConfigurations/foldingConfiguration"):
        if candidate.attrib.get("name") == args.configuration:
            folding = candidate
            break
    if folding is None:
        raise ValueError(f"foldingConfiguration {args.configuration} not found")

    active_names = [e.attrib["node"] for e in folding.findall("objectChange") if e.attrib.get("compoundChildActive") == "true"]
    animation_name, duration, animation = parse_animation(vehicle_root, args.configuration)

    all_physical: list[dict[str, object]] = []
    for node in by_name.values():
        if node.tag != "Shape" or node.attrs.get("compoundChild") != "true":
            continue
        group = node.attrs.get("collisionFilterGroup")
        mask = node.attrs.get("collisionFilterMask")
        if group != "0x10004":
            continue
        item = {
            "name": node.name,
            "node_id": int(node.attrs["nodeId"]) if node.attrs.get("nodeId") else None,
            "shape_id": int(node.attrs["shapeId"]) if node.attrs.get("shapeId") else None,
            "mapping_path": mappings.get(node.name),
            "local_translation": list(node.translation),
            "local_rotation_deg": list(node.rotation),
            "local_scale": list(node.scale),
            "collision_filter_group": group,
            "collision_filter_mask": mask,
            "non_renderable": node.attrs.get("nonRenderable") == "true",
            "active_in_configuration": node.name in active_names,
            "mesh_local_bounds": None,
            "mesh_extent_status": "UNRESOLVED_BINARY_I3D_SHAPES",
        }
        if node.name in active_names:
            item["predicted_origin_deployed"] = origin(world_matrix(node, 0.0, animation))
            item["predicted_origin_folded"] = origin(world_matrix(node, duration, animation))
        all_physical.append(item)

    active = [item for item in all_physical if item["active_in_configuration"]]
    if len(active) != 8:
        raise ValueError(f"Expected eight active boom collision shapes, found {len(active)}")

    def span(key: str) -> dict[str, float]:
        points = [item[key] for item in active]
        xs = [p[0] for p in points]  # type: ignore[index]
        zs = [p[2] for p in points]  # type: ignore[index]
        return {
            "origin_span_x_m": round(max(xs) - min(xs), 6),
            "origin_span_z_m": round(max(zs) - min(zs), 6),
            "min_x": round(min(xs), 6), "max_x": round(max(xs), 6),
            "min_z": round(min(zs), 6), "max_z": round(max(zs), 6),
        }

    output = {
        "schema_version": 1,
        "prototype": "08B",
        "asset": {
            "vehicle_xml_name": args.vehicle_xml.name,
            "vehicle_xml_sha256": sha256(args.vehicle_xml),
            "i3d_name": args.i3d.name,
            "i3d_sha256": sha256(args.i3d),
            "shapes_name": args.shapes.name,
            "shapes_sha256": sha256(args.shapes),
            "shapes_size_bytes": args.shapes.stat().st_size,
        },
        "configuration": {
            "folding_configuration_id": args.configuration,
            "working_width_m": float(folding.attrib.get("workingWidth", "0")),
            "animation_name": animation_name,
            "animation_duration_s": duration,
            "deployed_animation_time_s": 0.0,
            "folded_animation_time_s": duration,
            "active_collision_node_names": active_names,
        },
        "evidence": {
            "physical_compound_child_count": len(all_physical),
            "active_configuration_collision_count": len(active),
            "i3d_mapping_count_for_active_nodes": sum(1 for n in active_names if n in mappings),
            "mesh_extent_extraction": "UNAVAILABLE_IN_THIS_ENVIRONMENT",
            "catalogue_completeness": "IDENTITY_HIERARCHY_POSE_ONLY",
            "no_working_width_substitution": True,
            "offline_euler_order": "PROVISIONAL_XYZ_VALIDATE_WITH_08A",
        },
        "predicted_origin_spans": {
            "deployed": span("predicted_origin_deployed"),
            "folded": span("predicted_origin_folded"),
        },
        "physical_collision_shapes": sorted(all_physical, key=lambda item: str(item["name"])),
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(output, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps({
        "result": "PASS_WITH_EXTENT_GAP",
        "physical_shapes": len(all_physical),
        "active_shapes": len(active),
        "output": str(args.output),
        "deployed_origin_span": output["predicted_origin_spans"]["deployed"],
        "folded_origin_span": output["predicted_origin_spans"]["folded"],
    }, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
