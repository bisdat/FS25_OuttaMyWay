from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def flattened(relative):
    return " ".join(read(relative).split())


def test_repository_context_bootstrap_routes_current_responsibilities():
    agents=read("AGENTS.md")

    required=(
        "Repository Context Bootstrap",
        "docs/README.md",
        "docs/ENGINEERING_ARCHITECTURE.md",
        "docs/CONTINUATION_STATE.md",
        "docs/architecture/README.md",
        "docs/engine/README.md",
        "docs/engine/GIANTS_RUNTIME_KNOWLEDGE.md",
        "docs/IMPLEMENTATION_MAP.md",
        "docs/TESTING_METHODOLOGY.md",
        "tests/AGENTS.md",
    )
    for token in required:
        assert token in agents


def test_relevant_knowledge_sweep_requires_provenance_classification():
    agents=read("AGENTS.md")

    assert "Relevant Knowledge Sweep" in agents
    for classification in (
        "NEW",
        "KNOWN OPEN",
        "REGRESSION",
        "HISTORICAL / NOT CURRENTLY APPLICABLE",
    ):
        assert classification in agents

    assert "open GitHub Issues" in agents
    assert "closed GitHub Issues" in agents
    assert "open and merged pull requests" in agents
    assert "Absence of access is not evidence of novelty" in agents


def test_engineering_architecture_owns_bootstrap_and_current_ci_contract():
    engineering=flattened("docs/ENGINEERING_ARCHITECTURE.md")

    assert "Repository Context Bootstrap" in engineering
    assert "Relevant Knowledge Sweep" in engineering
    assert "PR Framing != Repository Context" in engineering
    assert "Structural contracts` and `Lua offline behavioural contracts` are blocking checks" in engineering
    assert "Lua harness remains non-blocking" not in engineering


def test_giants_runtime_knowledge_owns_observed_texture_font_constraint():
    knowledge=flattened("docs/engine/GIANTS_RUNTIME_KNOWLEDGE.md")

    assert "U+2022 BULLET (`•`)" in knowledge
    assert "Character '8226' not found in texture font" in knowledge
    assert "ASCII-safe `|`" in knowledge
    assert "not a complete Unicode capability map" in knowledge


def test_pull_request_template_surfaces_knowledge_trace():
    template=read(".github/pull_request_template.md")

    assert "## Knowledge trace" in template
    assert "Repository Context Bootstrap" in template
    assert "Relevant Knowledge Sweep" in template
    assert "NEW / KNOWN OPEN / REGRESSION / HISTORICAL" in template



def test_rendered_text_validation_uses_durable_engine_knowledge_without_unicode_overreach():
    agents=flattened("AGENTS.md")
    knowledge=flattened("docs/engine/GIANTS_RUNTIME_KNOWLEDGE.md")

    assert "Known Rendered Glyph Check" in agents
    assert "known unsupported glyphs" in agents
    assert "does not establish a generic non-ASCII ban" in agents
    assert "U+2022 BULLET (`•`)" in knowledge
    assert "ASCII-safe `|`" in knowledge
    assert "not a complete Unicode capability map" in knowledge
