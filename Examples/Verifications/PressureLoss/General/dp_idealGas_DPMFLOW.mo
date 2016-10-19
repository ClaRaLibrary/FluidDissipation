within FluidDissipation.Examples.Verifications.PressureLoss.General;
model dp_idealGas_DPMFLOW
  "Verification of function dp_idealGas_DP and dp_idealGas_MFLOW"

  parameter Integer n=size(dp_nom, 1);

  Real frac_KmToRs[n]={Km[i]/R_s for i in 1:n};

  //general variables
  parameter Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));

  parameter Real p_1=1.1e5 "MEASURED pressure at input [Pa]";
  parameter Real dp_nom[3]={0.5e3,2e3,3e3} "Nominal pressure loss [Pa]";
  parameter Real p_2[n]={p_1 - dp_nom[i] for i in 1:n}
    "MEASURED pressure at output [Pa]";

  parameter Real m_flow_nom[n]=ones(n)*10 "Nominal mass flow rate [kg/s]";
  Real Km[n]={R_s*(p_1 - (p_2[i]))/((m_flow_nom[i])^exp/rho_m) for i in 1:n}
    "Coefficient for pressure loss law [(Pa)^2/{(kg/s)^exp*K}]";

  //fluid property variables
  parameter SI.SpecificHeatCapacity R_s=287
    "Specific gas constant of ideal gas";
  parameter SI.Density rho_m=p_m/(R_s*T_m) "Mean density of ideal gas";
  parameter SI.Temp_K T_m=(293 + 293)/2 "Mean temperature of ideal gas";
  parameter SI.Pressure p_m=(1e5 + 1e5)/2 "Mean pressure of ideal gas";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n))
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n](start=zeros(n)) = ones(n)*input_DP.y
    "(Input) pressure loss (for intended compressible case)";

  //intended output variables for records
  SI.MassFlowRate M_FLOW[n](start=zeros(n))
    "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP[n](start=zeros(n)) = {input_dp[i] for i in 1:n}
    "(Output) pressure loss (for intended incompressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.General.dp_idealGas_IN_con m_flow_IN_con[n](
    each exp=exp,
    each R_s=R_s,
    Km=Km) annotation (Placement(transformation(extent={{-70,20},{-50,42}})));

  FluidDissipation.PressureLoss.General.dp_idealGas_IN_var m_flow_IN_var[n](
    each rho_m=rho_m,
    each T_m=T_m,
    each p_m=p_m)
    annotation (Placement(transformation(extent={{-50,20},{-30,42}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.General.dp_idealGas_IN_con dp_IN_con[n](
    each exp=exp,
    each R_s=R_s,
    Km=Km) annotation (Placement(transformation(extent={{30,20},{50,42}})));

  FluidDissipation.PressureLoss.General.dp_idealGas_IN_var dp_IN_var[n](
    each rho_m=rho_m,
    each T_m=T_m,
    each p_m=p_m)
    annotation (Placement(transformation(extent={{50,20},{70,42}})));

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";

  Modelica.Blocks.Sources.Ramp input_DP(
    startTime=0,
    offset=0,
    duration=1,
    height=30) annotation ( Placement(
        transformation(extent={{60,-80},{80,-60}})));
equation
  //target == DP (incompressible)
  DP = {FluidDissipation.PressureLoss.General.dp_idealGas_DP(
    m_flow_IN_con[i],
    m_flow_IN_var[i],
    input_mdot[i]) for i in 1:n};

  //target == M_FLOW (compressible)
  M_FLOW = {FluidDissipation.PressureLoss.General.dp_idealGas_MFLOW(
    dp_IN_con[i],
    dp_IN_var[i],
    input_dp[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/general/dp_idealGas_DPMFLOW.mos"
        "Verification of dp_idealGas_DPMFLOW"), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of GENERIC geometry (ideal gas law dependence | inverse)"),
          Text(
          extent={{-83,14},{-8,4}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)"),Text(
          extent={{13,14},{88,4}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)"),Text(
          extent={{-100,-46},{100,-21}},
          lineColor={0,0,255},
          textString=
            "here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}));
end dp_idealGas_DPMFLOW;
