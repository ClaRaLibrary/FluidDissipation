within FluidDissipation.Examples.Verifications.PressureLoss.General;
model dp_nominalDensityViscosity
  "Verification of function dp_nominalDensityViscosity"

  parameter Integer n=size(rho, 1) "number of different fluid density values";
  parameter SI.KinematicViscosity nue=1e-6 "kinetic viscosity of fluid";

  //general variables
  parameter SI.Pressure dp_nom=50
    "Nominal pressure loss (at nominal values of mass flow rate and density)"
    annotation (Dialog(group="Generic variables"));
  parameter Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));
  parameter SI.MassFlowRate m_flow_nom=1
    "Nominal mass flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables"));
  parameter SI.Density rho_nom=1e3
    "Nominal density (at nominal values of mass flow rate and pressure loss)"
    annotation (Dialog(group="Generic variables"));
  parameter Real exp_eta=1.5 "Exponent for dynamic viscosity dependence"
    annotation (Dialog(group="Generic variables"));
  parameter SI.DynamicViscosity eta_nom=1e-3
    "Dynamic viscosity at nominal pressure loss"
    annotation (Dialog(group="Generic variables"));

  //fluid property variables
  SI.DynamicViscosity eta[:]={rho[i]*nue for i in 1:n}
    "Dynamic viscosity of fluid";
  SI.Density rho[:]={1e3,1.5e3,2e3} "Density of fluid";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) = ones(n)*input_mflow_0.y
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n]={DP[i] for i in 1:n}
    "(Input) pressure loss (for intended compressible case)";

  //input record
  //compressible fluid flow
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

  //incompressible fluid flow
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

  //output record
  //compressible fluid flow
  SI.MassFlowRate M_FLOW[n] "mass flow rate" annotation (Dialog(group="Output"));

  //incompressible fluid flow
  SI.Pressure DP[n] "pressure loss" annotation (Dialog(group="Output"));

  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_DP[n](m_flow=
       input_mdot, each target=FluidDissipation.Utilities.Types.PressureLossTarget.PressureLoss)
    annotation (Placement(transformation(extent={{-110,-8},{-90,12}})));
  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_MFLOW[n](dp=
        input_dp, each target=FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate)
    annotation (Placement(transformation(extent={{90,-6},{110,14}})));

  Modelica.Blocks.Sources.Ramp input_mflow_0(
    startTime=0,
    offset=0,
    duration=1,
    height=100) annotation ( Placement(
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
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";
equation
  for i in 1:n loop
    (,M_FLOW[i],,,,) =
      FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity(
      dp_IN_con[i],
      dp_IN_var[i],
      chosenTarget_MFLOW[i]);
  end for;

  for i in 1:n loop
    (DP[i],,,,,) =
      FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity(
      m_flow_IN_con[i],
      m_flow_IN_var[i],
      chosenTarget_DP[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/general/dp_nominalDensityViscosity.mos"
        "Verification of dp_nominalDensityViscosity"), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of GENERIC geometry (density and viscosity dependence)"),
          Text(
          extent={{-85,20},{-10,10}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)"),Text(
          extent={{11,20},{86,10}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)")}));
end dp_nominalDensityViscosity;
