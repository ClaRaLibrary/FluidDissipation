within FluidDissipation.Utilities.Types;
type kc_evenGap = enumeration(
    DevOne
      "Hydrodynamically DEVELOPED laminar flow regime AND heat transfer at ONE side",
    DevBoth
      "Hydrodynamically DEVELOPED laminar flow regime AND heat transfer at BOTH sides",
    UndevOne
      "Hydrodynamic and thermal START of laminar flow regime AND heat transfer at ONE side",
    UndevBoth
      "Hydrodynamic and thermal START of laminar flow regime AND heat transfer at BOTH side");
