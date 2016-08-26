within FluidDissipation.Examples.Verifications.PressureLoss.Valve;
model dp_severalGeometryOverall_DPMFLOW "Verification of function dp_severalGeometryOverall_DP AND dp_severalGeometryOverall_MFLOW"

  parameter Integer n=size(geometry, 1) "Number of different geometries";

  //valve variables
  FluidDissipation.Utilities.Types.ValveGeometry geometry[5]={FluidDissipation.Utilities.Types.ValveGeometry.Ball,
  FluidDissipation.Utilities.Types.ValveGeometry.Diaphragm,
  FluidDissipation.Utilities.Types.ValveGeometry.Butterfly,
  FluidDissipation.Utilities.Types.ValveGeometry.Gate,
  FluidDissipation.Utilities.Types.ValveGeometry.Sluice} "Choice of geometry for valve";
  SI.Diameter d_hyd=0.1 "Hydraulic diamter";
  Real Av=PI*d_hyd^2/4 "Av (metric) flow coefficient [Av]=m^2";
  Real opening=input_opening.y "Opening of valve | 0==closed and 1== fully opened";

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid";
  SI.Density rho=1000 "Density of fluid";

  //target variables (here: mass flow rate as input for inverse calculation)
  //compressible case
  //intended input variables for records
  SI.MassFlowRate input_mdot_1[n](start=zeros(n)) "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp_1[n](start=zeros(n)) = ones(n)*input_DP.y "(Input) pressure loss (for intended compressible case)";
  //variable opening
  SI.MassFlowRate input_mdot_2[n](start=zeros(n)) "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp_2[n](start=zeros(n)) = ones(n)*1e3 "(Input) pressure loss (for intended compressible case)";

  //incompressible case
  //constant opening
  SI.MassFlowRate input_mdot_3[n](start=zeros(n)) = ones(n)*input_mdot.y "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp_3[n](start=zeros(n)) "(Input) pressure loss (for intended incompressible case)";

  //intended output variables for records
  //compressible case
  //constant opening
  SI.MassFlowRate M_FLOW_1[n](start=zeros(n)) "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP_1[n](start=zeros(n)) = {input_dp_1[i] for i in 1:n} "(Output) pressure loss (for intended incompressible case)";
  //variable opening
  SI.MassFlowRate M_FLOW_2[n](start=zeros(n)) "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP_2[n](start=zeros(n)) = {input_dp_2[i] for i in 1:n} "(Output) pressure loss (for intended incompressible case)";
  //incompressible case
  //constant opening
  SI.MassFlowRate M_FLOW_3[n](start=zeros(n)) "(Output) mass flow rate (for intended incompressible case)";
  SI.Pressure DP_3[n](start=zeros(n)) = input_dp_3 "(Output) pressure loss (for intended incompressible case)";

  //compressible case
  //constant opening
  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_con m_flow_IN_con_1[n](
    geometry=geometry,
    each Av=Av,
    each zeta_tot_max=1e3)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_var m_flow_IN_var_1[n](each
      rho=rho, each opening=0.5)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_con dp_IN_con_1[n](
    geometry=geometry,
    each Av=Av,
    each zeta_tot_max=1e3)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_var dp_IN_var_1[n](each
      rho=rho, each opening=0.5)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  //variable opening
  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_con m_flow_IN_con_2[n](
    geometry=geometry,
    each Av=Av,
    each zeta_tot_max=1e3)
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_var m_flow_IN_var_2[n](each
      rho=rho, each opening=opening)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_con dp_IN_con_2[n](
    geometry=geometry,
    each Av=Av,
    each zeta_tot_max=1e3)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_var dp_IN_var_2[n](each
      rho=rho, each opening=opening)
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  //incompressible case
  //constant opening
  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_con m_flow_IN_con_3[n](
    geometry=geometry,
    each Av=Av,
    each zeta_tot_max=1e3)
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));

  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_var m_flow_IN_var_3[n](each
      rho=rho, each opening=0.5)
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));

  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_con dp_IN_con_3[n](
    geometry=geometry,
    each Av=Av,
    each zeta_tot_max=1e3)
    annotation (Placement(transformation(extent={{30,-20},{50,0}})));

  FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_var dp_IN_var_3[n](each
      rho=rho, each opening=0.5)
    annotation (Placement(transformation(extent={{50,-20},{70,0}})));

protected
  constant Real MIN=Modelica.Constants.eps;

  //compressible case
  //constant opening
  Real DP_plot_1[n]={DP_1[i] for i in 1:n} "Pressure loss [Pa]";
  Real zeta_TOT_1[n]={2*DP_1[i]*rho*Av^2/max(MIN, (input_mdot_1[i])^2) for i in
          1:n} "Pressure loss coefficients";
  Real Re_1[n]={input_mdot_1[i]*d_hyd/(eta*Av) for i in 1:n};

  //variable opening
  Real DP_plot_2[n]={DP_2[i] for i in 1:n} "Pressure loss [Pa]";
  Real zeta_TOT_2[n]={2*DP_2[i]*rho*Av^2/max(MIN, (input_mdot_2[i])^2) for i in
          1:n} "Pressure loss coefficients";
  Real Re_2[n]={input_mdot_2[i]*d_hyd/(eta*Av) for i in 1:n};
  //incompressible case
  Real DP_plot_3[n]={DP_3[i] for i in 1:n} "Pressure loss [Pa]";
  Real zeta_TOT_3[n]={2*DP_3[i]*rho*Av^2/max(MIN, (input_mdot_3[i])^2) for i in
          1:n} "Pressure loss coefficients";
  Real Re_3[n]={input_mdot_3[i]*d_hyd/(eta*Av) for i in 1:n};

public
  Modelica.Blocks.Sources.Ramp input_DP(height=1e3, duration=1) annotation (
       Placement(transformation(extent={{-70,-80},{
            -50,-60}})));

  Modelica.Blocks.Sources.Ramp input_opening(
    startTime=0,
    duration=1,
    height=1,
    offset=0) annotation ( Placement(transformation(
          extent={{50,-80},{70,-60}})));

  Modelica.Blocks.Sources.Ramp input_mdot(
    offset=0,
    duration=1,
    height=1e2) annotation ( Placement(
        transformation(extent={{-8,-80},{12,-60}})));

equation
  //compressible case
  //constant opening
  DP_1 = {FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_DP(
    m_flow_IN_con_1[i],
    m_flow_IN_var_1[i],
    input_mdot_1[i]) for i in 1:n};

  M_FLOW_1 = {
    FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_MFLOW(
    dp_IN_con_1[i],
    dp_IN_var_1[i],
    input_dp_1[i]) for i in 1:n};

  //variable opening
  DP_2 = {FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_DP(
    m_flow_IN_con_2[i],
    m_flow_IN_var_2[i],
    input_mdot_2[i]) for i in 1:n};

  M_FLOW_2 = {
    FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_MFLOW(
    dp_IN_con_2[i],
    dp_IN_var_2[i],
    input_dp_2[i]) for i in 1:n};

  //incompressible case
  //constant opening
  DP_3 = {FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_DP(
    m_flow_IN_con_3[i],
    m_flow_IN_var_3[i],
    input_mdot_3[i]) for i in 1:n};

  M_FLOW_3 = {
    FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_MFLOW(
    dp_IN_con_3[i],
    dp_IN_var_3[i],
    input_dp_3[i]) for i in 1:n};

  annotation (
    __Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/valve/dp_severalGeometryOverall_DPMFLOW.mos" "Verification of dp_severalGeometryOverall_DP and dp_severalGeometryOverall_MFLOW (inverse)"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of VALVE for OVERALL flow regime (different geometries | inverse)"),
          Text(
          extent={{-100,-50},{100,-25}},
          lineColor={0,0,255},
          textString=
            "here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)"),
          Text(
          extent={{-91,20},{-24,10}},
          lineColor={0,0,255},
          textString=" constant opening / variable pressure loss"),Text(
          extent={{25,20},{92,10}},
          lineColor={0,0,255},
          textString=" variable opening / constant pressure loss"),Text(
          extent={{-27,-6},{26,-16}},
          lineColor={0,0,255},
          textString="incompressible case"),Text(
          extent={{-33,-20},{34,-30}},
          lineColor={0,0,255},
          textString=" constant opening / variable mass flow rate"),Text(
          extent={{-27,52},{26,42}},
          lineColor={0,0,255},
          textString="compressible cases")}),
    experiment);
end dp_severalGeometryOverall_DPMFLOW;
