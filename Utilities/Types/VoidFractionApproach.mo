within FluidDissipation.Utilities.Types;
type VoidFractionApproach = enumeration(
    Homogeneous "Homogeneous approach",
    Momentum "Analytical momentum flux approach (heterogeneous)",
    Energy "Kinetic energy flow approach w.r.t. Zivi (heterogeneous)",
    Chisholm "Empirical momentum flux approach w.r.t. Chisholm (heterogeneous)");
