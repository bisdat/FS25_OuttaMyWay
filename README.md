OuttaMyWay
===========

WORK IN PROGRESS — UNFINISHED

OuttaMyWay is a Farming Simulator 25 mod that helps native GIANTS AI field
workers cooperate when they compete for space inside a field. Its broader goal
is autonomous continuity: fewer situations in which AI workers need babysitting
or manual rescue.

GIANTS continues to own AI jobs, productive fieldwork, normal navigation,
turns, and ordinary worker continuation. OuttaMyWay intervenes only for the
bounded, temporary coordination needed to resolve competition for space, then
returns control to GIANTS as soon as that responsibility ends.

The supported design and validation envelope is at most three simultaneously
active GIANTS AI worker assemblies in one Operation, targeting different
agronomic roles. Player-controlled vehicles do not count toward that limit.
Larger groups and same-agronomy fleets may work incidentally, but are outside
the supported design obligation.

OuttaMyWay is not a replacement AI worker, productive route planner, agronomic
scheduler, general fleet coordinator, or off-field traffic/navigation system.
It is also not a replacement for Courseplay: Courseplay operates in a product
space involving its own fieldwork and course coordination, while OuttaMyWay
deliberately leaves normal job and navigation ownership with GIANTS AI and
negotiates only temporary competition for space.

The canonical v0.5.0.0 commit preserves the last accepted pre-rewrite baseline.
The 0.5 TEST build retains Configuration, Log Publication and the labelled
HUD/status shell. From TEST 0.5.0.2, Debug/DIAGNOSTIC optionally activates a
read-only blocked-state diagnostic probe. It does not load AI coordination,
semantic Situation Assessment, Regulation, Passage, Recovery or any vehicle
actuation module. Existing 0.4 Lua files are retained but not sourced.

The 0.5 design direction is reactive native GIANTS blocked evidence followed,
when justified, by bounded stop/relocation/restart and GIANTS-native replanning.
This is future architectural work, not a capability of the current shell.

Development / engineering documentation:

[docs/README.md](docs/README.md)
