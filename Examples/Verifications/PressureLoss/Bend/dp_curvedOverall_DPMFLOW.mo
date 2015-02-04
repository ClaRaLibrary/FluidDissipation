within FluidDissipation.Examples.Verifications.PressureLoss.Bend;
model dp_curvedOverall_DPMFLOW
  "Verification of function dp_curvedOverall_DP AND dp_curvedOverall_MFLOW"

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
  SI.MassFlowRate input_mdot_1[n](start=zeros(n))
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp_1[n](start=zeros(n)) = ones(n)*input_DP.y
    "(Input) pressure loss (for intended compressible case)";

  //intended output variables for records
  SI.MassFlowRate M_FLOW_1[n](start=zeros(n))
    "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP_1[n](start=zeros(n)) = {input_dp_1[i] for i in 1:n}
    "(Output) pressure loss (for intended incompressible case)";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot_2[m](start=zeros(m))
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp_2[m](start=zeros(m)) = ones(m)*input_DP.y
    "(Input) pressure loss (for intended compressible case)";

  //intended output variables for records
  SI.MassFlowRate M_FLOW_2[m](start=zeros(m))
    "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP_2[m](start=zeros(m)) = {input_dp_2[i] for i in 1:m}
    "(Output) pressure loss (for intended incompressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_con m_flow_IN_con_1[n](
    each d_hyd=d_hyd,
    L=PI*delta[3]/180*R_0,
    each delta=delta[3]*PI/180,
    R_0=R_0,
    each K=K)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_var m_flow_IN_var_1[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_con m_flow_IN_con_2[m](
    each d_hyd=d_hyd,
    each L=PI*delta[3]/180*R_0[1],
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
    R_0=R_0,
    each K=K) annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_var dp_IN_var_1[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_con dp_IN_con_2[m](
    each d_hyd=d_hyd,
    each L=PI*delta[3]/180*R_0[1],
    each K=K,
    delta=delta*PI/180,
    each R_0=R_0[1])
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_var dp_IN_var_2[m](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

protected
  parameter Real frac_RD[n]={R_0[i]/d_hyd for i in 1:n}
    "Relative curvature radius";

  //plotting
  SI.Velocity velocity_1[n]={input_mdot_1[i]/(rho*A_cross) for i in 1:n}
    "Mean velocity";
  SI.ReynoldsNumber Re_1[n]={rho*velocity_1[i]*d_hyd/eta for i in 1:n};
  SI.Velocity velocity_2[m]={input_mdot_2[i]/(rho*A_cross) for i in 1:m}
    "Mean velocity";
  SI.ReynoldsNumber Re_2[m]={rho*velocity_2[i]*d_hyd/eta for i in 1:m};

  Real DP_plot_1[n]={DP_1[i] for i in 1:n} "Pressure loss [Pa]";
  Real DP_plot_2[m]={DP_2[i] for i in 1:m} "Pressure loss [Pa]";
  Real zeta_TOT_1[n]={2*abs(DP_plot_1[i])/(max(rho*(velocity_1[i])^2, 1e-5))
      for i in 1:n} "Pressure loss coefficients";
  Real zeta_TOT_2[m]={2*abs(DP_plot_2[i])/(max(rho*(velocity_2[i])^2, 1e-5))
      for i in 1:m} "Pressure loss coefficients";

public
  Modelica.Blocks.Sources.Ramp input_DP(
    startTime=0,
    duration=1,
    offset=1e-3,
    height=1.2e4) annotation (Placement(
        transformation(extent={{60,-80},{80,-60}})));

equation
  //target == DP (incompressible)
  DP_1 = {FluidDissipation.PressureLoss.Bend.dp_curvedOverall_DP(
    m_flow_IN_con_1[i],
    m_flow_IN_var_1[i],
    input_mdot_1[i]) for i in 1:n};

  //target == M_FLOW (compressible)
  M_FLOW_1 = {FluidDissipation.PressureLoss.Bend.dp_curvedOverall_MFLOW(
    dp_IN_con_1[i],
    dp_IN_var_1[i],
    input_dp_1[i]) for i in 1:n};

  //target == DP (incompressible)
  DP_2 = {FluidDissipation.PressureLoss.Bend.dp_curvedOverall_DP(
    m_flow_IN_con_2[i],
    m_flow_IN_var_2[i],
    input_mdot_2[i]) for i in 1:m};

  //target == M_FLOW (compressible)
  M_FLOW_2 = {FluidDissipation.PressureLoss.Bend.dp_curvedOverall_MFLOW(
    dp_IN_con_2[i],
    dp_IN_var_2[i],
    input_dp_2[i]) for i in 1:m};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/bend/dp_curvedOverall_DPMFLOW.mos"
        "Verification of dp_overall_DPMFLOW"), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of CURVED bend for OVERALL flow regime (considering surface roughness | inverse)"),
          Text(
          extent={{-103,22},{-12,2}},
          lineColor={0,0,255},
          textString=
            "relative curvature radius dependence | constant angle of turning "),
          Text(
          extent={{-100,-50},{100,-25}},
          lineColor={0,0,255},
          textString=
            "here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)"),
          Text(
          extent={{13,22},{104,2}},
          lineColor={0,0,255},
          textString=
            "constant relative curvature radius | angle of turning dependence")}));
end dp_curvedOverall_DPMFLOW;
