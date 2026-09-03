# Localisation Policy

## Required first-release languages

- English (`en`)
- German (`de`)
- French (`fr`)
- Spanish (`es`)
- Italian (`it`)

These five languages are the minimum for every user-facing title, description, setting and warning added before release.

## Other FS25 languages

FS25 supports more languages, but all 26 are not required for the first release unless GIANTS specifically requests them. Additional translations should be accepted from trusted contributors after the official ModHub release.

## Rules

- Never hard-code user-facing HUD text in control logic.
- Use stable localisation keys.
- English is the source text.
- Keep messages short enough for HUD layouts in German and French.
- Technical debug logs may remain English.

## Research localisation authority

Runtime-resolved GIANTS text may be used as evidence for displayed category,
type, and function meaning in the captured environment. It does not change the
five-language policy above, authorise copying GIANTS text into mod localisation,
or prove hidden storage provenance. Missing-key diagnostics must not be mistaken
for successful resolution merely because they are non-empty.

The bounded readable-source search, 567-key runtime experiment, missing-key
control, and their evidence limits are preserved in
[Vehicle Definition Corpus and Semantic Review](research/VEHICLE_DEFINITION_CORPUS.md#stage-2b--runtime-localisation).
