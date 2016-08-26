within FluidDissipation.Examples.Verifications.PressureLoss.General;
model dp_nominalDensityViscosity_DPMFLOW "Verification of function dp_nominalDensityViscosity_DP and dp_nominalDensityViscosity_MFLOW"

  parameter Integer n=size(rho, 1) "number of different fluid density values";
  parameter SI.KinematicViscosity nue=1e-6 "kinetic viscosity of fluid";

  //general variables
  parameter SI.Pressure dp_nom=50 "Nominal pressure loss (at nominal values of mass flow rate and density)"
    annotation (Dialog(group="Generic variables"));
  parameter Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));
  parameter SI.MassFlowRate m_flow_nom=1 "Nominal mass flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables"));
  parameter SI.Density rho_nom=1e3 "Nominal density (at nominal values of mass flow rate and pressure loss)"
    annotation (Dialog(group="Generic variables"));
  parameter Real exp_eta=1.5 "Exponent for dynamic viscosity dependence"
    annotation (Dialog(group="Generic variables"));
  parameter SI.DynamicViscosity eta_nom=1e-3 "Dynamic viscosity at nominal pressure loss"
    annotation (Dialog(group="Generic variables"));

  //fluid property PARAMETERS
  parameter SI.SpecificHeatCapacityAtConstantPressure cp=4190 "specific heat capacity at constant pressure of fluid"
    annotation (Dialog(group="FluidProperties"));
  SI.DynamicViscosity eta[:]={rho[i]*nue for i in 1:n} "dynamic viscosity of fluid"
                                 annotation (Dialog(group="FluidProperties"));
  parameter SI.ThermalConductivity lambda=0.6 "thermal conductivity of fluid"
    annotation (Dialog(group="FluidProperties"));
  SI.Density rho[:]={1e3,1.5e3,2e3} "density of fluid"
    annotation (Dialog(group="FluidProperties"));

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n](start=zeros(n)) = ones(n)*input_DP.y "(Input) pressure loss (for intended compressible case)";

  //intended output variables for records
  SI.MassFlowRate M_FLOW[n](start=zeros(n)) "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP[n](start=zeros(n)) = {input_dp[i] for i in 1:n};

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_IN_con m_flow_IN_con[n](
    each eta_nom=eta_nom,
    each exp=exp,
    each exp_eta=exp_eta,
    each m_flow_nom=m_flow_nom,
    each dp_nom=dp_nom,
    each rho_nom=rho_nom)
    annotation (Placement(transformation(extent={{-70,20},{-50,42}})));

  FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_IN_var m_flow_IN_var[n](eta=
        eta, rho=rho)
    annotation (Placement(transformation(extent={{-50,20},{-30,42}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_IN_con dp_IN_con[n](
    each dp_nom=dp_nom,
    each eta_nom=eta_nom,
    each exp=exp,
    each exp_eta=exp_eta,
    each m_flow_nom=m_flow_nom,
    each rho_nom=rho_nom)
    annotation (Placement(transformation(extent={{30,20},{50,42}})));

  FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_IN_var dp_IN_var[n](eta=
        eta, rho=rho)
    annotation (Placement(transformation(extent={{50,20},{70,42}})));

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";

  Modelica.Blocks.Sources.Ramp input_DP(
    startTime=0,
    offset=0,
    duration=1,
    height=5e5) annotation ( Placement(
        transformation(extent={{60,-80},{80,-60}})));
equation
  //target == DP (incompressible)
  DP = {FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_DP(
    m_flow_IN_con[i],
    m_flow_IN_var[i],
    input_mdot[i]) for i in 1:n};

  //target == M_FLOW (compressible)
  M_FLOW = {
    FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_MFLOW(
    dp_IN_con[i],
    dp_IN_var[i],
    input_dp[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/general/dp_nominalDensityViscosity_DPMFLOW.mos" "Verification of dp_nominalDensityViscosity_DPMFLOW"),
                                                               Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of GENERIC geometry (density and viscosity dependence | inverse)"),
          Text(
          extent={{-83,14},{-8,4}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)"),Text(
          extent={{13,14},{88,4}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)"),Text(
          extent={{-98,-44},{102,-19}},
          lineColor={0,0,255},
          textString=
            "here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}));
end dp_nominalDensityViscosity_DPMFLOW;
