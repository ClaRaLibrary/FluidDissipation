within FluidDissipation.Examples.TestCases.PressureLoss;
model Channel "Test cases of pressure loss functions for channels"

  inner Modelica.Fluid.System system(p_ambient(displayUnit="Pa") = 100000,
      m_flow_small=0.01) annotation (Placement(transformation(extent={{80, -100}, {100, -80}})));

public
  Modelica.Blocks.Sources.Sine input_mflow(
    freqHz=1,
    offset=0,
    amplitude=10) annotation (Placement(
        transformation(extent={{-100,-50},{-80,-30}})));

public
  Modelica.Blocks.Sources.RealExpression input_p(y=from_mflow.port_a.p)
    annotation (Placement(transformation(extent={{-100,
            10},{-80,30}})));
  Modelica.Fluid.Sources.Boundary_pT IN_p(
    nPorts=1,
    T(displayUnit="K") = system.T_ambient,
    p(displayUnit="Pa") = system.p_ambient,
    use_p_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  Modelica.Fluid.Sources.FixedBoundary OUT_dp(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,20})));

  Modelica.Fluid.Sources.FixedBoundary OUT_mflow(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-40})));

  Modelica.Fluid.Sources.MassFlowSource_T IN_mflow(
    T=system.T_ambient,
    nPorts=1,
    use_m_flow_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-40})));

  Applications.PressureLoss.ChannelFlowModel from_dp(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    "Calculate mass flow rate from pressure loss"
    annotation (Placement(transformation(extent={{-24,-4},{24,44}})));

  Applications.PressureLoss.ChannelFlowModel from_mflow(redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater)
    "Calculate pressure loss from mass flow rate"
    annotation (Placement(transformation(extent={{-24,-64},{24,-16}})));

equation
  connect(IN_p.ports[1], from_dp.port_a) annotation (Line(
      points={{-40,20},{-24,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_dp.port_b, OUT_dp.ports[1]) annotation (Line(
      points={{24,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow.port_b, OUT_mflow.ports[1]) annotation (Line(
      points={{24,-40},{80,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow.port_a, IN_mflow.ports[1]) annotation (Line(
      points={{-24,-40},{-40,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(input_mflow.y, IN_mflow.m_flow_in) annotation (Line(
      points={{-79,-40},{-70,-40},{-70,-32},{-60,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(input_p.y, IN_p.p_in) annotation (Line(
      points={{-79,20},{-72,20},{-72,28},{-62,28}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
Switch to the diagram or equation layer to see the model of a <b> Modelica.Fluid channel </b> using <b> FluidDissipation pressure loss calculations </b>.
</p>
</html>
"), experiment(Interval=0.0002),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-94,120},{88,58}},
          lineColor={0,0,255},
          textString="Test: Channel functions"), Text(
          extent={{-56,-2},{60,-18}},
          lineColor={255,0,0},
          textString=
              "set record parameters for chosen pressure loss function (inside flow model)")}));
end Channel;
