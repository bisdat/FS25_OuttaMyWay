# Known Issues

> **Currency:** v4.7.0 Replacement-Core Bootstrap Candidate

## No gameplay functionality

v4.7.0 intentionally performs no worker observation, coordination, HUD output or physical intervention. Only the inert kernel loads. This is the expected bootstrap state, not a regression.

## Live FS25 load confirmation required

Offline syntax and conformance tests cannot prove that the package loads correctly in FS25. One basic game launch is required before canonicalisation.

## Deferred implementation

Observation, Job Episode admission, candidate generation, constraint evaluation, Decision, replay and all physical capabilities remain absent. Their absence must not be filled by importing archived legacy modules.
