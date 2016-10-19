within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses;
model pressureLoss_Tjunction

  import PI = Modelica.Constants.pi;
  import SI = Modelica.SIunits;
  import FD = FluidDissipation.PressureLoss.Junction;

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.FlowModel;

  extends Modelica.Fluid.Interfaces.PartialTwoPortTransport(redeclare package
      Medium = Modelica.Media.Air.DryAirNasa);

  //fluid flow situation
  FluidDissipation.Utilities.Types.JunctionFlowSituation flowSituation=
      FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left
    "fluid flow situation" annotation (Dialog(group="FlowSituation"));

  //geometry
  parameter Boolean united_converging_crossection=false
    "true == A_cross_conv = A_cross_straight + A_cross_side | false == A_cross_conv > A_cross_straight + A_cross_side"
    annotation (Dialog(group="Geometry"));

  parameter Integer dp_i(min=1,max=3)
    "location of pressure loss inside general Tjunction with 1== dp_1 | 2== dp_2 | 3== dp_3"
    annotation (Dialog(group="Geometry"));

  Real alpha= 90 "angle of branching"
    annotation (Dialog(group="Geometry"));
  parameter SI.Diameter d_hyd[3]={1.13e-2,1.13e-2,1.13e-2}
    "hydraulic diameter of passages [port_1, port_2, port_3]"
    annotation (Dialog(group="Geometry"));

  Medium.Density rho "fluid density for design flow direction";

  input Medium.MassFlowRate m_flow_junction[3](start=zeros(3))
    "mass flow rates at junction [left,right,bottom]"
    annotation (Dialog(group="Pressure loss"));

  //restrictions
  parameter SI.PressureDifference dp_min(min=1)=1
    "restriction for smoothing while changing of fluid flow situation"
    annotation (Dialog(group="Restriction"));
  parameter Medium.MassFlowRate m_flow_min(min=Modelica.Constants.eps)=1e-3
    "restriction for smoothing at reverse fluid flow"
    annotation (Dialog(group="Restriction"));
  parameter SI.Velocity v_max(max=343)=343
    "restriction for maximum fluid flow velocity"
    annotation (Dialog(group="Restriction"));
  parameter Real zeta_TOT_max=100
    "restriction for maximum value of total resistance coefficient"
    annotation (Dialog(group="Restriction",enable=velocity_reference_branches));

  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_con m_flow_IN_con(
    final united_converging_crossection=united_converging_crossection,
    final alpha=alpha,
    final d_hyd=d_hyd,
    final dp_min=dp_min,
    final m_flow_min=m_flow_min,
    final v_max=v_max,
    final zeta_TOT_max=zeta_TOT_max,
    final flowSituation=flowSituation)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_var m_flow_IN_var(final rho=
       rho) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  SI.PressureDifference DP[3]
    "(thermodynamic) pressure loss [left-internal,internal-right,internal-bottom]";

  Medium.MassFlowRate M_FLOW[3] "mass flow rate [side,straight,total]";

  TYP.LocalResistanceCoefficient zeta_LOC[2]
    "local resistance coefficient [side,straight]";

  Real cases[6]
    "fluid flow situation at Tjunction according to online documentation";

  Real failureStatus
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results";

protected
  parameter SI.Diameter d_hyd_intern=if dp_i == 1 then d_hyd[1] else if
      dp_i == 2 then d_hyd[2] else if dp_i == 3 then d_hyd[3] else 0;

  SI.Pressure dp_intern(start=0)
    "total pressure loss at component dp_i | POS == port_a.p > port_b.p";

equation
  //isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  //mass fractions remain constant:
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

  // Density:
  rho = Medium.density(Medium.setState_phX((port_a.p+port_b.p)/2, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)));

  (DP,M_FLOW,zeta_LOC,cases,failureStatus) =
    FluidDissipation.PressureLoss.Junction.dp_Tjunction(
    m_flow_IN_con,
    m_flow_IN_var,
    m_flow_junction);

  dp_intern = if dp_i == 1 then DP[1] else if dp_i == 2 then
          DP[2] else if dp_i == 3 then DP[3] else 0;

  dp = dp_intern;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-70,98},{68,64}},
          lineColor={0,0,255},
          textString="%name")}));
end pressureLoss_Tjunction;
