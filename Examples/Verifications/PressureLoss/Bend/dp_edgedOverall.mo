within FluidDissipation.Examples.Verifications.PressureLoss.Bend;
model dp_edgedOverall "Verification of function dp_edgedOverall"

  constant Real MIN=Modelica.Constants.eps;

  parameter Integer n=size(delta, 1)
    "Number of different angles of turning of bend";

  //bend variables
  parameter SI.Area A_cross=PI*d_hyd^2/4
    "Circular cross sectional area of bend";
  parameter SI.Conversions.NonSIunits.Angle_deg delta[4]={30,45,90,180}
    "Angle of turning";
  parameter SI.Diameter d_hyd=0.1 "Hydraulic diameter";
  parameter SI.Length K=2.5e-5
    "Roughness (average height of surface asperities)";
  parameter SI.Length L=d_hyd*10 "Length of bend along axis";

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid";
  SI.Density rho=1000 "Density of fluid";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) = ones(n)*input_mflow_0.y
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n]={DP[i] for i in 1:n}
    "(Input) pressure loss (for intended compressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_con m_flow_IN_con[n](
    delta=delta*PI/180,
    each d_hyd=d_hyd,
    each K=K,
    each L=L) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_var m_flow_IN_var[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_con dp_IN_con[n](
    delta=delta*PI/180,
    each d_hyd=d_hyd,
    each K=K,
    each L=L) annotation (Placement(transformation(extent={{20,20},{40,40}})));

  FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_var dp_IN_var[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  SI.Pressure DP[n] "pressure loss" annotation (Dialog(group="Output"));
  SI.MassFlowRate M_FLOW[n] "mass flow rate" annotation (Dialog(group="Output"));
  Utilities.Types.PressureLossCoefficient zeta_TOT[n], zeta_TOT2[n]
    "Pressure loss coefficient" annotation (Dialog(group="Output"));
  SI.ReynoldsNumber Re[n] "Reynolds number" annotation (Dialog(group="Output"));

  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_DP[n](m_flow=
       input_mdot, each target=FluidDissipation.Utilities.Types.PressureLossTarget.PressureLoss)
    annotation (Placement(transformation(extent={{-100,-16},{-80,4}})));
  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_MFLOW[n](dp=
        input_dp, each target=FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate)
    annotation (Placement(transformation(extent={{80,-16},{100,4}})));

  Modelica.Blocks.Sources.Ramp input_mflow_0(
    startTime=0,
    duration=1,
    offset=0,
    height=1e2) annotation ( Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(
    offset=0,
    phase=0,
    startTime=0,
    freqHz=1,
    amplitude=1e2)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    offset=0,
    startTime=0,
    riseTime=1e-2,
    riseTimeConst=1e-2,
    outMax=1e2) annotation (Placement(transformation(
          extent={{0,-80},{20,-60}})));

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";

equation
  for i in 1:n loop
    (,M_FLOW[i],zeta_TOT[i],,,) = FluidDissipation.PressureLoss.Bend.dp_edgedOverall(
      dp_IN_con[i],
      dp_IN_var[i],
      chosenTarget_MFLOW[i]);
  end for;

  for i in 1:n loop
    (DP[i],,zeta_TOT2[i],Re[i],,) =
      FluidDissipation.PressureLoss.Bend.dp_edgedOverall(
      m_flow_IN_con[i],
      m_flow_IN_var[i],
      chosenTarget_DP[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/bend/dp_edgedOverall.mos"
        "Verification of dp_edgedOverall"), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,52},{100,77}},
          lineColor={0,0,255},
          textString="Pressure loss of EDGED bend for OVERALL flow regime")}));
end dp_edgedOverall;
