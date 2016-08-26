within FluidDissipation.Examples.TestCases.HeatTransfer;
model HeatExchanger_TwoPhase "Test case for heat transfer of heat exchanger with two phase media"
  import SI = Modelica.SIunits;

  Applications.HeatTransfer.HeatExchangerHeatTransferModel_TwoPhase
    heatExchanger(
    m_flow=massFlowRate.y,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model HeatTransfer =
        FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.FilmCondensationTubeBundle.FilmCondensationTubeBundleHeatTransferModel)
    annotation (Placement(transformation(extent={{-34,-34},{34,34}})));

  Modelica.Blocks.Sources.Constant pressure(k=
        stateForHeatTransfer.Medium.saturationPressure(273.15 + 20))
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.Sine specificEnthalpy(
    freqHz=1,
    amplitude=1.2e6,
    offset=1.55e6) "[J/kg]"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Sine massFlowRate(
    freqHz=1,
    offset=0,
    amplitude=100) "[kg/s]"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  inner StateForHeatTransfer stateForHeatTransfer(
    p_state=pressure.y,
    h_state=specificEnthalpy.y,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=291.15)
                annotation (Placement(transformation(extent={{-20,50},{0,70}})));
equation

  connect(fixedTemperature.port, heatExchanger.thermalPort) annotation (Line(
      points={{0,60},{0,37.4}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-70,110},{74,68}},
          lineColor={0,0,255},
          textString="Test of implementation for two phase heat exchanger functions")}));
end HeatExchanger_TwoPhase;
