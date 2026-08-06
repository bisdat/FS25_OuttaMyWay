# Model Geometry Research

This directory contains Prototype 08B's reproducible, asset-bound collision-catalogue extraction workflow. It does **not** contain GIANTS game assets.

## Purpose

`extract_collision_catalogue.py` consumes a locally supplied vehicle XML, I3D and matching `.i3d.shapes` file. It extracts:

- physical `compoundChild` collision identities and filters;
- I3D mapping paths and hierarchy transforms;
- purchased folding-configuration membership;
- fold-animation segments;
- predicted collision-node origins at deployed and folded endpoints;
- SHA-256 identities binding the result to the exact source assets.

The proprietary binary `.i3d.shapes` file stores mesh geometry. This environment has no trusted GIANTS-compatible exporter for its local mesh bounds, so every mesh extent is emitted as `UNRESOLVED_BINARY_I3D_SHAPES`. Working width is never substituted.

## Reproduce

```text
python research/model_geometry/extract_collision_catalogue.py \
  --vehicle-xml /path/to/condorEndurance2.xml \
  --i3d /path/to/condorEndurance2.i3d \
  --shapes /path/to/condorEndurance2.i3d.shapes \
  --configuration 1 \
  --output research/model_geometry/catalogues/condorEndurance2_36m_collision_catalogue.json
```

The generated JSON is evidence and an offline prediction oracle for Prototype 08A. It is not yet an authoritative Physical Occupancy Envelope catalogue.
