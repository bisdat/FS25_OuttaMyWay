# Current candidate lineage — v4.7.76 canonical candidate / live-tested v4.7.75 D-0141 closure

Owner-declared v4.7.49 remains canonical. v4.7.76 is the canonical candidate packaging the live-tested v4.7.75 closure behaviour, which fixed the final v4.7.74 role-reversal failure without changing the successful Regulation or Refuge behaviour.

The selected Yield worker may already own a generic progress AuthorityToken because it was the D-0141 regulated follower. The same Commitment now reuses that token for REPOSITION rather than rejecting the strategy revision. Central Control then clears only the superseded D-0141 speed lease on that Yield worker and settles its follower obligation. Compatible Regulation on the other worker remains untouched.

The integrated live test succeeded. Behavioural work is frozen for this tranche; remaining implementation issues are parked for later work while v4.7.76 is validated for canonical declaration.
