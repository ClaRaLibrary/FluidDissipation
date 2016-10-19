within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.OverallTwoPhase;
model OverallTwoPhaseFlowModel
  "Straight pipe (overall): Application two phase flow model for straight pipe function in Modelica.Fluid"

  //base flow model
  extends
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.BaseStraightPipePL.BaseStraightPipeModel(redeclare
      package                                                                                                                               Medium =
        Modelica.Media.Water.WaterIF97_ph);

  //pressure loss calculation
  parameter SI.Area A_cross=PI*0.1^2/4 "Cross sectional area";
  parameter SI.Length perimeter=PI*0.1 "Wetted perimeter";
  parameter SI.Length length=1 "Length in fluid flow direction";


  Modelica.SIunits.SpecificEnthalpy h_dew_a = Medium.specificEnthalpy(Medium.setDewState(sat_a));
  Modelica.SIunits.SpecificEnthalpy h_bub_a = Medium.specificEnthalpy(Medium.setBubbleState(sat_a));
  Modelica.SIunits.SpecificEnthalpy h_dew_b = Medium.specificEnthalpy(Medium.setDewState(sat_b));
  Modelica.SIunits.SpecificEnthalpy h_bub_b = Medium.specificEnthalpy(Medium.setBubbleState(sat_b));
  Real x_flow_end = (Medium.specificEnthalpy(state_b)-h_bub_b)/(h_dew_b-h_bub_b);
  Real x_flow_sta = (Medium.specificEnthalpy(state_a)-h_bub_a)/(h_dew_a-h_bub_a);
  Modelica.SIunits.Density rho_g = Medium.dewDensity(sat);
  Modelica.SIunits.Density rho_l = Medium.bubbleDensity(sat);
  Modelica.SIunits.DynamicViscosity eta_g = Medium.dynamicViscosity(state=Medium.setDewState(sat));
  Modelica.SIunits.DynamicViscosity eta_l = Medium.dynamicViscosity(state=Medium.setBubbleState(sat));
  Modelica.SIunits.SurfaceTension sigma = Medium.surfaceTension(sat);

  Modelica.Media.R134a.R134a_ph.SaturationProperties sat = Medium.SaturationProperties(Tsat=Medium.saturationTemperature(state.p), psat=Medium.pressure(state));
  Modelica.Media.R134a.R134a_ph.SaturationProperties sat_a = Medium.SaturationProperties(Tsat=Medium.saturationTemperature(state_a.p), psat=Medium.pressure(state_a));
  Modelica.Media.R134a.R134a_ph.SaturationProperties sat_b = Medium.SaturationProperties(Tsat=Medium.saturationTemperature(state_b.p), psat=Medium.pressure(state_b));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.OverallTwoPhase.PressureLossInput_con
    IN_con(
    A_cross=A_cross,
    perimeter=perimeter,
    length=length) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.OverallTwoPhase.PressureLossInput_var
    IN_var(
    x_flow=(x_flow_end+x_flow_sta)/2,
    rho_g=rho_g,
    rho_l=rho_l,
    eta_g=eta_g,
    eta_l=eta_l,
    sigma=sigma)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  m_flow =  FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseMSH_MFLOW(
    IN_con,
    IN_var,
    dp);

  annotation (Diagram(graphics));
end OverallTwoPhaseFlowModel;
