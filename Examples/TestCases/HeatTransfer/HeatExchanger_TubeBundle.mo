within FluidDissipation.Examples.TestCases.HeatTransfer;
model HeatExchanger_TubeBundle "Test case for heat transfer of heat exchanger"
  import SI = Modelica.SIunits;

  FluidDissipation.Examples.Applications.HeatTransfer.HeatExchangerHeatTransferModelWallState
    heatExchanger(
    m_flow=massFlowRate.y,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    redeclare model HeatTransfer =
        FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.RoundTubeBundle.RoundTubeBundleHeatTransferModel
        (n=5))
    annotation (Placement(transformation(extent={{-34,-34},{34,34}})));

  Modelica.Blocks.Sources.Constant pressure(k=1e5)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.Sine temperature(
    amplitude=2,
    freqHz=1,
    offset=20) "[degC]"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Sine massFlowRate(
    freqHz=1,
    offset=0,
    amplitude=1) "[kg/s]"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  inner StateForHeatTransfer stateForHeatTransfer(
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    p_state=pressure.y,
    t_state=temperature.y)
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  inner StateForHeatTransfer stateForHeatTransferWall(
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    p_state=pressure.y,
    t_state=temperature.offset) annotation (Placement(transformation(extent={{54,-100},{74,-80}})));
equation

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                        graphics={Text(
          extent={{-70,110},{74,68}},
          lineColor={0,0,255},
          textString="Test of implementation for heat exchanger functions"),
        Text(
          extent={{0,-72},{128,-78}},
          lineColor={255,0,0},
          textString="State at wall"),
        Text(
          extent={{27,-75},{155,-81}},
          lineColor={255,0,0},
          textString="Bulk flow state
")}));
end HeatExchanger_TubeBundle;
