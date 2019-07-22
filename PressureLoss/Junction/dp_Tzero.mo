within FluidDissipation.PressureLoss.Junction;
function dp_Tzero "zero mass flow rate through general T-junction"
  extends Modelica.Icons.Function;

  //input records
  input FluidDissipation.PressureLoss.Junction.dp_Tjoin_IN_con IN_con
    "input record for function dp_Tjunction"
    annotation (Placement(transformation(extent={{-100,12},{-80,32}})));
  input FluidDissipation.PressureLoss.Junction.dp_Tjoin_IN_var IN_var
    "input record for function dp_Tjunction"
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
  input SI.MassFlowRate m_flow[3]
    "mass flow rate in passages [side,straight,total]"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP[2] "(thermodynamic) pressure loss [side,straight]"
    annotation (Dialog(group="Output"));
  output SI.MassFlowRate M_FLOW[3] "mass flow rate [side,straight,total]"
    annotation (Dialog(group="Output"));
  output TYP.LocalResistanceCoefficient zeta_LOC[2]
    "local resistance coefficient [side,straight]"
    annotation (Dialog(group="Output"));
  output SI.ReynoldsNumber Re[3] "Reynolds number"
    annotation (Dialog(group="Output"));
  final output SI.PrandtlNumber Pr=0 "Prandtl number"
    annotation (Dialog(group="Output"));
  output Real failureStatus
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

algorithm
  failureStatus := 1.0;
  //joint := 0;
  zeta_LOC := zeros(2);
  Re := zeros(3);
  DP := zeros(2);
  M_FLOW := zeros(3);
  //velocity := zeros(3);
annotation (Inline=true, smoothOrder(normallyConstant=IN_con) = 2,
    Documentation);
end dp_Tzero;
