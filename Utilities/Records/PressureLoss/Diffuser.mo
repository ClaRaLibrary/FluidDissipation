within FluidDissipation.Utilities.Records.PressureLoss;
record Diffuser "Input for diffuser"
  extends Modelica.Icons.Record;

  SI.Length L_d=L_1 "Length of diffuser section (parallel to bulk fluid flow)"
    annotation (Dialog(group="Diffuser"));
  SI.Area A_1=PI*0.01^2/4
    "Small constant cross sectional area at inlet of diffuser"
    annotation (Dialog(group="Diffuser"));
  SI.Area A_2=2*A_1 "Large constant cross sectional area at outlet of diffuser"
    annotation (Dialog(group="Diffuser"));
  SI.Length C_1=PI*0.01 "Small perimeter at inlet of diffuser"
    annotation (Dialog(group="Diffuser"));
  SI.Length C_2=2*C_1 "Large perimeter at outlet of diffuser"
    annotation (Dialog(group="Diffuser"));

  SI.Length L_1=0.1 "Length of straight pipe before diffuser section"
    annotation (Dialog(group="Straight pipe"));
  SI.Length L_2=L_1 "Length of straight pipe after diffuser section"
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
end Diffuser;
