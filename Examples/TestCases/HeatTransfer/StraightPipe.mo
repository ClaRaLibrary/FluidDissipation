within FluidDissipation.Examples.TestCases.HeatTransfer;
model StraightPipe "Test case for heat transfer of straight pipe"

  //heat transfer for straight pipe
  FluidDissipation.Examples.Applications.HeatTransfer.StraightPipeHeatTransferModel
    straightPipe(
    m_flow=massFlowRate.y,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    fluidFlowRegime=FluidDissipation.Utilities.Types.FluidFlowRegime.Overall)
    annotation (Placement(transformation(extent={{-34,-34},{34,34}})));

  //definition of (missing) thermodynamic state for heat transfer calculation

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
    amplitude=0.1) "[kg/s]"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  inner StateForHeatTransfer stateForHeatTransfer(
    t_state=temperature.y,
    p_state=pressure.y,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa)
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
equation
  /*medium.p = p_state;
  medium.T = T_state;*/

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-70,110},{74,68}},
          lineColor={0,0,255},
          textString="Test of implementation for straight pipe functions")}));
end StraightPipe;
