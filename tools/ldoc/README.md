# Generated source reference tooling

This directory configures the optional LDoc renderer used by the `Generated source reference` GitHub Actions job.

The renderer consumes disposable copies prepared from current production Lua by `tools/source_reference.py`. Generated HTML is a derived human-navigation aid only. It is not Architecture, Specification, production-source authority, or structural-conformance evidence.

The generated output lives under `.generated/source-reference/`, is excluded from Git, and is uploaded by GitHub Actions as the `outtamyway-source-reference` artifact.

The production source documentation and its visible `Specification Jurisdictions:` acknowledgements remain the authored source material. Renderer-only `@module` identities are added to generated copies so LDoc can present the complete source corpus without imposing LDoc boilerplate on production files.
