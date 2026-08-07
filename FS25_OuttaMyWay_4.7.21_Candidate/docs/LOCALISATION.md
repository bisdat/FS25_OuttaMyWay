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

The base-game semantic research used runtime localisation only as evidence for GIANTS' displayed English category, type and function text. A bounded readable-source search found no authoritative definitions for the required base-game keys, while the observed runtime resolved all 567 through `g_i18n:getText`.

This establishes Runtime Localisation Authority for the captured research environment. It does not copy GIANTS localisation data into mod-facing localisation files, change the five-language release policy above or prove hidden storage provenance.

A missing key may return a readable diagnostic such as `Missing '...' in l10n_en.xml`; non-empty text alone is therefore insufficient evidence of successful resolution.
