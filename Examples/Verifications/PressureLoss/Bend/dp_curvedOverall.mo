within FluidDissipation.Examples.Verifications.PressureLoss.Bend;
model dp_curvedOverall "Verification of function dp_curvedOverall"
  parameter Integer n=size(R_0, 1)
    "Number of different relative curvature radii of bend";
  parameter Integer m=size(delta, 1)
    "Number of different angles of turning of bend";

  //bend variables
  parameter SI.Area A_cross=PI*d_hyd^2/4
    "Circular cross sectional area of bend";
  parameter SI.Conversions.NonSIunits.Angle_deg delta[3]={30,45,90}
    "Angle of turning";
  parameter SI.Diameter d_hyd=0.1 "Hydraulic diameter";
  parameter SI.Length K=0 "Roughness (average height of surface asperities)";
  parameter SI.Radius R_0[2]={2.26,11.71}*d_hyd "Curvature radius";

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid";
  SI.Density rho=1000 "Density of fluid";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot_1[n](start=zeros(n)) = ones(n)*input_mflow_0.y
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp_1[n]={DP_1[i] for i in 1:n}
    "(Input) pressure loss (for intended compressible case)";
  SI.MassFlowRate input_mdot_2[m](start=zeros(m)) = ones(m)*input_mflow_0.y
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp_2[m]={DP_2[i] for i in 1:m}
    "(Input) pressure loss (for intended compressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_con m_flow_IN_con_1[n](
    each d_hyd=d_hyd,
    L=PI*delta[3]/180*R_0,
    each delta=delta[3]*PI/180,
    R_0=R_0,
    each K=K) annotation (Placement(transformation(extent={{-92,20},{-72,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_var m_flow_IN_var_1[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-72,20},{-52,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_con m_flow_IN_con_2[m](
    each d_hyd=d_hyd,
    L=PI*delta/180*R_0[1],
    each K=K,
    delta=delta*PI/180,
    each R_0=R_0[1])
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_var m_flow_IN_var_2[m](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_con dp_IN_con_1[n](
    each d_hyd=d_hyd,
    L=PI*delta[3]/180*R_0,
    each delta=delta[3]*PI/180,
    each K=K,
    R_0=R_0) annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_var dp_IN_var_1[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_con dp_IN_con_2[m](
    each d_hyd=d_hyd,
    L=PI*delta/180*R_0[1],
    each K=K,
    delta=delta*PI/180,
    each R_0=R_0[1])
    annotation (Placement(transformation(extent={{52,20},{72,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_var dp_IN_var_2[m](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{72,20},{92,40}})));

  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_DP_1[n](m_flow=
       input_mdot_1, each target=FluidDissipation.Utilities.Types.PressureLossTarget.PressureLoss)
    annotation (Placement(transformation(extent={{-118,14},{-98,34}})));
  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_MFLOW_1[n](dp=
        input_dp_1, each target=FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate)
    annotation (Placement(transformation(extent={{98,-14},{118,6}})));
  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_DP_2[m](m_flow=
       input_mdot_2, each target=FluidDissipation.Utilities.Types.PressureLossTarget.PressureLoss)
    annotation (Placement(transformation(extent={{-118,-14},{-98,6}})));
  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_MFLOW_2[m](dp=
        input_dp_2, each target=FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate)
    annotation (Placement(transformation(extent={{98,14},{118,34}})));

  SI.Pressure DP_1[n] "pressure loss" annotation (Dialog(group="Output"));
  SI.Pressure DP_2[m] "pressure loss" annotation (Dialog(group="Output"));
  SI.MassFlowRate M_FLOW_1[n] "mass flow rate"
    annotation (Dialog(group="Output"));
  SI.MassFlowRate M_FLOW_2[m] "mass flow rate"
    annotation (Dialog(group="Output"));
  Utilities.Types.PressureLossCoefficient zeta_TOT_1[n]
    "Pressure loss coefficient" annotation (Dialog(group="Output"));
  Utilities.Types.PressureLossCoefficient zeta_TOT_2[m]
    "Pressure loss coefficient" annotation (Dialog(group="Output"));
  SI.ReynoldsNumber Re_1[n] "Reynolds number"
    annotation (Dialog(group="Output"));
  SI.ReynoldsNumber Re_2[m] "Reynolds number"
    annotation (Dialog(group="Output"));

  Modelica.Blocks.Sources.Ramp input_mflow_0(
    startTime=0,
    offset=0,
    duration=1,
    height=100) annotation (Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(
    offset=0,
    phase=0,
    startTime=0,
    freqHz=1,
    amplitude=100) annotation (Placement(
        transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    offset=0,
    startTime=0,
    riseTime=1e-2,
    riseTimeConst=1e-2,
    outMax=100) annotation (Placement(transformation(
          extent={{0,-80},{20,-60}})));

  //plotting
  Real DP_plot_1[n]={DP_1[i] for i in 1:n} "Pressure loss [Pa]";
  Real DP_plot_2[m]={DP_2[i] for i in 1:m} "Pressure loss [Pa]";

equation
  for i in 1:n loop
    (,M_FLOW_1[i],,,,) = FluidDissipation.PressureLoss.Bend.dp_curvedOverall(
      dp_IN_con_1[i],
      dp_IN_var_1[i],
      chosenTarget_MFLOW_1[i]);
  end for;

  for i in 1:n loop
    (DP_1[i],,zeta_TOT_1[i],Re_1[i],,) =
      FluidDissipation.PressureLoss.Bend.dp_curvedOverall(
      m_flow_IN_con_1[i],
      m_flow_IN_var_1[i],
      chosenTarget_DP_1[i]);
  end for;

  for i in 1:m loop
    (,M_FLOW_2[i],,,,) = FluidDissipation.PressureLoss.Bend.dp_curvedOverall(
      dp_IN_con_2[i],
      dp_IN_var_2[i],
      chosenTarget_MFLOW_2[i]);
  end for;

  for i in 1:m loop
    (DP_2[i],,zeta_TOT_2[i],Re_2[i],,) =
      FluidDissipation.PressureLoss.Bend.dp_curvedOverall(
      m_flow_IN_con_2[i],
      m_flow_IN_var_2[i],
      chosenTarget_DP_2[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/bend/dp_curvedOverall.mos"
        "Verification of dp_curvedOverall"), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Pressure loss of CURVED bend for OVERALL flow regime"),
          Text(
          extent={{-105,20},{-14,0}},
          lineColor={0,0,255},
          textString=
            "relative curvature radius dependence | constant angle of turning "),
          Text(
          extent={{11,20},{102,0}},
          lineColor={0,0,255},
          textString=
            "constant relative curvature radius | angle of turning dependence")}));
end dp_curvedOverall;
