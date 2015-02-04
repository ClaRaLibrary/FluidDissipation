within FluidDissipation.Examples.TestCases.HeatTransfer;
model Plate "Test case for heat transfer of plate"

  FluidDissipation.Examples.Applications.HeatTransfer.PlateHeatTransferModel plate(
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    velocity=input_velocity.y,
    redeclare package HeatTransfer =
        FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Plate.Overall)
    annotation (Placement(transformation(extent={{-34,-34},{34,34}})));

  Modelica.Blocks.Sources.Constant pressure(k=1e5)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.Sine temperature(
    amplitude=2,
    freqHz=1,
    offset=20) "[degC]"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Sine input_velocity(
    freqHz=1,
    offset=0,
    amplitude=10) "[m/s]"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  inner StateForHeatTransfer stateForHeatTransfer(
    p_state=pressure.y,
    t_state=temperature.y,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa)
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
equation
  // medium.p = p_state;
  // medium.T = T_state;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-72,110},{72,68}},
          lineColor={0,0,255},
          textString="Test of implementation for plate functions")}),
    experiment(Interval=0.0002));
end Plate;
