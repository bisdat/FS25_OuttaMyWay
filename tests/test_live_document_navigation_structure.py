from __future__ import annotations

import re
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[1]
LIVE_ROOTS = (
    ROOT / "architecture",
    ROOT / "spec",
    ROOT / "docs",
)
ARCHIVE_ROOT = ROOT / "docs" / "archive"

INLINE_LINK_RE = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
REFERENCE_LINK_RE = re.compile(r"^\s*\[[^\]]+\]:\s*(\S+)", re.MULTILINE)
SCHEME_RE = re.compile(r"^[A-Za-z][A-Za-z0-9+.-]*:")


def _is_under(path: Path, parent: Path) -> bool:
    try:
        path.relative_to(parent)
        return True
    except ValueError:
        return False


def _is_live(path: Path) -> bool:
    return not _is_under(path, ARCHIVE_ROOT)


def _live_markdown_files() -> list[Path]:
    files: list[Path] = []
    for root in LIVE_ROOTS:
        files.extend(path for path in root.rglob("*.md") if _is_live(path))
    return sorted(set(files))


def _live_document_directories(files: list[Path]) -> set[Path]:
    directories: set[Path] = set()
    for path in files:
        current = path.parent
        while True:
            directories.add(current)
            matching_root = next((root for root in LIVE_ROOTS if _is_under(current, root)), None)
            if matching_root is None or current == matching_root:
                break
            current = current.parent
    return directories


def _without_fenced_code(text: str) -> str:
    retained: list[str] = []
    fence: str | None = None
    for line in text.splitlines():
        stripped = line.lstrip()
        marker = stripped[:3]
        if marker in ("```", "~~~"):
            if fence is None:
                fence = marker
            elif fence == marker:
                fence = None
            continue
        if fence is None:
            retained.append(line)
    return "\n".join(retained)


def _destination_token(raw: str) -> str:
    destination = raw.strip()
    if destination.startswith("<") and ">" in destination:
        return destination[1 : destination.index(">")]
    return destination.split(maxsplit=1)[0] if destination else ""


def _relative_destinations(markdown: str) -> list[str]:
    text = _without_fenced_code(markdown)
    raw_destinations = INLINE_LINK_RE.findall(text) + REFERENCE_LINK_RE.findall(text)
    destinations: list[str] = []
    for raw in raw_destinations:
        destination = _destination_token(raw)
        if not destination or destination.startswith("#") or SCHEME_RE.match(destination):
            continue
        destinations.append(destination)
    return destinations


def _resolve(owner: Path, destination: str) -> Path | None:
    repository_path = unquote(destination).split("#", 1)[0].split("?", 1)[0]
    if not repository_path:
        return None
    if repository_path.startswith("/"):
        target = ROOT / repository_path.lstrip("/")
    else:
        target = owner.parent / repository_path
    return target.resolve(strict=False)


def test_live_document_folders_have_complete_direct_breadcrumbs():
    files = _live_markdown_files()
    directories = _live_document_directories(files)
    errors: list[str] = []

    for directory in sorted(directories):
        readme = directory / "README.md"
        relative_directory = directory.relative_to(ROOT).as_posix()
        if not readme.is_file():
            errors.append(f"live documentation folder lacks README.md: {relative_directory}")
            continue

        linked_targets = {
            target
            for destination in _relative_destinations(readme.read_text(encoding="utf-8"))
            if (target := _resolve(readme, destination)) is not None
        }

        for child in sorted(directory.glob("*.md")):
            if child.name == "README.md" or not _is_live(child):
                continue
            if child.resolve() not in linked_targets:
                errors.append(
                    f"{readme.relative_to(ROOT)} does not breadcrumb direct live document {child.name}"
                )

        for child_directory in sorted(path for path in directory.iterdir() if path.is_dir()):
            if child_directory not in directories or not _is_live(child_directory):
                continue
            child_readme = child_directory / "README.md"
            if child_readme.resolve() not in linked_targets:
                errors.append(
                    f"{readme.relative_to(ROOT)} does not breadcrumb direct live folder "
                    f"{child_directory.name}/README.md"
                )

    assert not errors, "Live Breadcrumb Invariant is open:\n- " + "\n- ".join(errors)


def test_live_document_relative_links_resolve():
    errors: list[str] = []

    for document in _live_markdown_files():
        for destination in _relative_destinations(document.read_text(encoding="utf-8")):
            target = _resolve(document, destination)
            if target is None:
                continue
            if not _is_under(target, ROOT):
                errors.append(
                    f"{document.relative_to(ROOT)} link escapes repository: {destination}"
                )
            elif not target.exists():
                errors.append(
                    f"{document.relative_to(ROOT)} has unresolved relative link: {destination}"
                )

    assert not errors, "Live documentation link integrity is open:\n- " + "\n- ".join(errors)
