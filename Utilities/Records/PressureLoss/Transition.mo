within FluidDissipation.Utilities.Records.PressureLoss;
record Transition "Input for transitions"
  extends Modelica.Icons.Record;

  SI.Length L_trans=L_1
    "Length of transition section (parallel to bulk fluid flow)"
    annotation (Dialog(group="Transition"));
  SI.Area A_1=PI*0.01^2/4 "Cross-sectional area 1"
    annotation (Dialog(group="Transition"));
  SI.Area A_2=4*A_1 "Cross-sectional area 2"
    annotation (Dialog(group="Transition"));
  SI.Length C_1=PI*0.01 "Perimeter 1" annotation (Dialog(group="Transition"));
  SI.Length C_2=2*C_1 "Perimeter 2" annotation (Dialog(group="Transition"));

  SI.Length L_1=0.1 "Length of straight pipe 1"
    annotation (Dialog(group="Straight pipe"));
  SI.Length L_2=L_1 "Length of straight pipe 2"
    annotation (Dialog(group="Straight pipe"));
  SI.Length K=2.5e-5 "Roughness (average height of surface asperities)"
    annotation (Dialog(group="Straight pipe"));

  //numerical aspects
  SI.Velocity velocity_small=1e-8
    "Regularisation for a velocity smaller then velocity_small"
    annotation (Dialog(group="Numerical aspects"));
  TYP.PressureLossCoefficient zeta_tot_min=1e-3
    "Minimal pressure loss coefficient"
    annotation (Dialog(group="Numerical aspects"));
  TYP.PressureLossCoefficient zeta_tot_max=1e2
    "Maximum pressure loss coefficient"
    annotation (Dialog(group="Numerical aspects"));
end Transition;
