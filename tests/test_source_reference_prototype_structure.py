from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "tests/source_reference_prototype.py"
GENERATED = ROOT / "docs/research/prototypes/PROTOTYPE_35_SOURCE_REFERENCE.generated.md"


def test_source_reference_prototype_is_current() -> None:
    result = subprocess.run(
        [sys.executable, str(SCRIPT), "--check", str(GENERATED)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    assert result.returncode == 0, result.stderr or result.stdout
