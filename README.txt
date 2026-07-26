FS25_OuttaMyWay v4.6.16

Physical Representation Architecture Consolidation — Release Candidate

Canonical implementation baseline: v4.6.15
Current package authority: noncanonical candidate awaiting repository-owner review

This candidate records the agreed architecture for constructing and interpreting plan-view
Physical Representations without requiring exact runtime collision identity as a prerequisite
for all useful occupancy knowledge. It accepts component footprints, a Convex Planar Envelope
and member/assembly rectangles as an explicitly qualified representation portfolio.

The Job-Scoped Representation Catalogue is built once at job start. Stable templates are
realised from current physical state and plan-view pose. Mixed precision is permitted: exact
and fallback regions may coexist, uncertainty remains local, and coverage takes priority over
uniform precision.

Coverage Closure is separated from Inventory Closure and may be enumerative, enclosing or
hybrid. Structural Closure belongs to the catalogue; Realised Closure additionally requires
current valid pose. Partial knowledge continues, but any relevant gap yields Clearance
Unresolved rather than an unsupported all-clear or an invented collision.

TS004 records the Valtra S 416 + Tiger 8 MT and John Deere 8RX 410 + TopDown 600 as static
contrast fixtures. Their different physics-component, hierarchy and mapping structures show
that component counts and direct mappings cannot establish collision inventory.

Repository text is now governed as LF through .gitattributes. Four historical CRLF files are
normalised to LF in this candidate. No Prototype 13 implementation or runtime behaviour is
introduced.

See docs/PHYSICAL_REPRESENTATION_ARCHITECTURE.md.
