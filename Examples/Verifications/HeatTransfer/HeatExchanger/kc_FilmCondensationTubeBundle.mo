within FluidDissipation.Examples.Verifications.HeatTransfer.HeatExchanger;
model kc_FilmCondensationTubeBundle "Verification of function kc_FilmCondensationTubeBundle"

  //heat exchanger variables
  parameter Modelica.SIunits.Length d = 0.014 "Diameter of the bundle's tubes";
  parameter Modelica.SIunits.Area A_front = Modelica.Constants.pi/4*0.092^2 "Frontal area";
  parameter Real C = 1 "Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8";

  //Medium
  replaceable package Medium = Modelica.Media.Water.WaterIF97_pT constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium;

  //States
  Medium.ThermodynamicState[3] vap = Medium.setState_px(p,1);
  Medium.ThermodynamicState[3] liq = Medium.setState_px(p,0);

  //fluid property variables
  SI.Pressure[3] p = Medium.saturationPressure(T_s) "Vapour pressure";
  SI.SpecificHeatCapacityAtConstantPressure[3] cp_l = Medium.specificHeatCapacityCp(liq) "Specific heat capacity of liquid";
  SI.ThermalConductivity[3] lambda_l = Medium.thermalConductivity(liq) "Thermal conductivity of liquid";
  SI.Density[3] rho_g = Medium.density(vap) "Density of gas";
  SI.Density[3] rho_l = Medium.density(liq) "Density of liquid";
  SI.DynamicViscosity[3] eta_g = Medium.dynamicViscosity(vap) "Dynamic viscosity of gas";
  SI.DynamicViscosity[3] eta_l = Medium.dynamicViscosity(liq) "Dynamic viscosity of liquid";

  SI.SpecificEnthalpy[3] dh_lg = Medium.specificEnthalpy(vap) - Medium.specificEnthalpy(liq) "Evaporation enthalpy of fluid";

  //parameter Modelica.SIunits.Temperature T_s = 273.15 + 22.41
  parameter Modelica.SIunits.Temperature[3] T_s = {273.15 + 22.36, 273.15 + 23.1, 273.15 + 21.58} "Saturation temperature";
  //parameter Modelica.SIunits.Temperature T_w = T_s - 1.31 "Wall temperature";
  parameter Modelica.SIunits.Temperature[3] T_w = T_s - {1.05, 1.45, 1.96} "Wall temperature";

  //input variables
  SI.ReynoldsNumber Re = input_Re.y "Reynolds number" annotation (Dialog(group="Input"));

  //input records

  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_con
    m_flow_IN_con(
    d=d,
    A_front=A_front,
    C=C) annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var
    m_flow_IN_var_1(
    cp_l=cp_l[1],
    lambda_l=lambda_l[1],
    rho_g=rho_g[1],
    rho_l=rho_l[1],
    eta_g=eta_g[1],
    eta_l=eta_l[1],
    T_s=T_s[1],
    dh_lg=dh_lg[1],
    m_flow=m_flow[1],
    T_w=T_w[1]) annotation (Placement(transformation(extent={{0,0},{20,20}})));

  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var
    m_flow_IN_var_2(
    cp_l=cp_l[2],
    lambda_l=lambda_l[2],
    rho_g=rho_g[2],
    rho_l=rho_l[2],
    eta_g=eta_g[2],
    eta_l=eta_l[2],
    T_s=T_s[2],
    dh_lg=dh_lg[2],
    m_flow=m_flow[2],
    T_w=T_w[2]) annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var
    m_flow_IN_var_3(
    cp_l=cp_l[3],
    lambda_l=lambda_l[3],
    rho_g=rho_g[3],
    rho_l=rho_l[3],
    eta_g=eta_g[3],
    eta_l=eta_l[3],
    T_s=T_s[3],
    dh_lg=dh_lg[3],
    m_flow=m_flow[3],
    T_w=T_w[3])
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  //output variables
  SI.MassFlowRate[3] m_flow "Mass flow rate" annotation (Dialog(group="Output"));
  SI.NusseltNumber[3] Nu "Nusselt number" annotation (Dialog(group="Output"));
  SI.CoefficientOfHeatTransfer[3] kc;

public
  Modelica.Blocks.Sources.Ramp input_Re(
    duration=1,
    startTime=0,
    offset=1,
    height=2000000)
              annotation (Placement(transformation(
          extent={{-80,-80},{-60,-60}})));

equation
  //heat transfer calculation
  (kc[1],,Re,Nu[1]) =
    FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam(
    m_flow_IN_con, m_flow_IN_var_1);
  (kc[2],,Re,Nu[2]) =
    FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam(
    m_flow_IN_con, m_flow_IN_var_2);
  (kc[3],,Re,Nu[3]) =
    FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam(
    m_flow_IN_con, m_flow_IN_var_3);

  annotation (Diagram(graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Heat transfer of heat exchanger tube bundles with film condensation")}),
          __Dymola_Commands(file="modelica://FluidDissipation/Extras/Scripts/heatTransfer/heatExchanger/kc_FilmCondensationTubeBundle.mos" "Verification of kc_FilmCondensationTubeBundle"));
end kc_FilmCondensationTubeBundle;
