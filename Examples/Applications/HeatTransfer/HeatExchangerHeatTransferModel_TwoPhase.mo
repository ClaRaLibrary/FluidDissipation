within FluidDissipation.Examples.Applications.HeatTransfer;
model HeatExchangerHeatTransferModel_TwoPhase "Application model for a heat exchanger in Modelica_Fluid"

  //icon
  extends FluidDissipation.Utilities.Icons.HeatTransfer.HeatExchanger_i;

  //interfaces
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermalPort "Thermal port"
                   annotation (Placement(transformation(extent={{-20,60},{20,80}},
          rotation=0), iconTransformation(extent={{-20,100},{20,120}})));

  replaceable package Medium = Modelica.Media.Water.WaterIF97_pT constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium "Medium in the component"
                              annotation (Dialog(group="Fluid properties"),
      choicesAllMatching=true);

  //choice for heat exchanger heat transfer model
  replaceable model HeatTransfer =
      FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.FilmCondensationTubeBundle.FilmCondensationTubeBundleHeatTransferModel
    constrainedby FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.BaseHeatExchangerHT.BaseHeatExchangerModel_TwoPhase "1st: choose heat transfer calculation | 2nd: edit corresponding record"
    annotation (Dialog(group="Heat transfer"), choicesAllMatching=true);

  //input
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //instance of chosen heat transfer model
  HeatTransfer heatTransferModel(
    cp_g = cp_g,
    cp_l = cp_l,
    eta_g = eta_g,
    eta_l = eta_l,
    lambda_g = lambda_g,
    lambda_l = lambda_l,
    rho_g = rho_g,
    rho_l = rho_l,
    pressure = pressure,
    dh_lg = dh_lg,
    x_flow = x_flow,
    m_flow=m_flow,
    T_s=T_s)   annotation (Placement(transformation(extent={{-18,-18},{18,18}})));

  //thermodynamic state from (missing) volume
  //outer Medium.ThermodynamicState state;
  outer FluidDissipation.Examples.TestCases.HeatTransfer.StateForHeatTransfer
    stateForHeatTransfer;

  Medium.ThermodynamicState vap = Medium.setState_px(stateForHeatTransfer.p_state,1);
  Medium.ThermodynamicState liq = Medium.setState_px(stateForHeatTransfer.p_state,0);

  //fluid properties
protected
  SI.Pressure pressure = stateForHeatTransfer.p_state;
  SI.SpecificHeatCapacityAtConstantPressure cp_g = Medium.specificHeatCapacityCp(vap);
  SI.SpecificHeatCapacityAtConstantPressure cp_l = Medium.specificHeatCapacityCp(liq);
  SI.ThermalConductivity lambda_g = Medium.thermalConductivity(vap);
  SI.ThermalConductivity lambda_l = Medium.thermalConductivity(liq);
  SI.Density rho_g = Medium.density(vap);
  SI.Density rho_l = Medium.density(liq);
  SI.DynamicViscosity eta_g = Medium.dynamicViscosity(vap);
  SI.DynamicViscosity eta_l = Medium.dynamicViscosity(liq);

  SI.SpecificEnthalpy dh_lg = Medium.specificEnthalpy(vap) - Medium.specificEnthalpy(liq);
  Real x_flow = max(0, min(1, (stateForHeatTransfer.medium.h - Medium.specificEnthalpy(liq))/dh_lg));

  Modelica.SIunits.Temperature T_s = Medium.saturationTemperature(pressure);

equation
  connect(heatTransferModel.thermalPort, thermalPort) annotation (Line(
      points={{0,19.8},{0,70}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-150,-114},{150,-154}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          fillColor={232,0,0},
          textString="%name")}),
    Documentation(revisions="<html>
<p>2011-03-28        XRG Simulation GmbH, Stefan Wischhusen: Removed erroneous temperature offset.</p>
</html>"));
end HeatExchangerHeatTransferModel_TwoPhase;
