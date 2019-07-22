within FluidDissipation.Examples.TestCases;
model EngineFeedingSystem "Test cases of an aircraft engine feeding system"
  import SI = Modelica.SIunits;
  inner Modelica.Fluid.System system(
    p_ambient(displayUnit="Pa") = 100000,
    m_flow_small=0.01)       annotation (Placement(transformation(extent={{80, -100}, {100, -80}})));

  Modelica.Fluid.Sources.MassFlowSource_T engineLeft(
    T=system.T_ambient,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=1,
    use_m_flow_in=true,
    m_flow=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-82})));

  //pipes

  //valves

  Modelica.Fluid.Vessels.OpenTank leftTank(
    nPorts=1,
    height=1,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1)},
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    crossArea=(310/2)/1)
    annotation (Placement(transformation(extent={{-100,20},{-60,60}})));

  Modelica.Fluid.Vessels.OpenTank rightTank(
    nPorts=1,
    height=1,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1)},
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    crossArea=(310/2)/1)
    annotation (Placement(transformation(extent={{60,20},{100,60}})));

  Modelica.Fluid.Sources.MassFlowSource_T engineRight(
    T=system.T_ambient,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=1,
    use_m_flow_in=true,
    m_flow=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-82})));

  Applications.PressureLoss.StraightPipeFlowModel pipe_1(redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,0})));

  Modelica.Fluid.Valves.ValveIncompressible valve_5(
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 5e4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={56,-40})));

  Modelica.Fluid.Sources.Boundary_pT ambient(
    T=system.T_ambient,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=1,
    use_p_in=true,
    p(displayUnit="Pa")) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={78,-20})));

  Applications.PressureLoss.StraightPipeFlowModel pipe_3(redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,-56})));
  Applications.PressureLoss.StraightPipeFlowModel pipe_6(redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-56})));
  Applications.PressureLoss.StraightPipeFlowModel pipe_2(redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,0})));
  Modelica.Blocks.Sources.Ramp atmosphere(
    offset=1013e2,
    height=-(1013 - 265)*1e2,
    startTime=0,
    duration=30*60)
    annotation (Placement(transformation(extent={{64,-64},{74,-54}})));
  Modelica.Blocks.Sources.Constant massFlowRate(k=-15/60)
    annotation (Placement(transformation(extent={{-100,-100},{-90,-90}})));
  Modelica.Fluid.Valves.ValveIncompressible valve_78(
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 1e2)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Modelica.Blocks.Sources.Step valveOpening(startTime=15*60)
    annotation (Placement(transformation(extent={{-20,-10},{-10,0}})));
  Modelica.Fluid.Machines.Pump leftPump(
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    V=1e-3,
    nParallel=2,
    N_nominal=1500,
    redeclare function flowCharacteristic =
        Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow (
          head_nominal={1700e2/9.81/1e3,1450e2/9.81/1e3,720e2/9.81/1e3},
          V_flow_nominal={5e3/3.6,10e3/3.6,40e3/3.6}))
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));

  Modelica.Mechanics.Rotational.Sources.Speed pumpSpeedRight
    annotation (Placement(transformation(extent={{-34,66},{-22,78}})));
  Modelica.Blocks.Sources.Constant speed(k=1500/60*2*Modelica.Constants.pi)
    annotation (Placement(transformation(extent={{-60,70},{-50,80}})));
  Modelica.Fluid.Machines.Pump rightPump(
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare function flowCharacteristic =
        Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow (
          head_nominal={1700e2/9.81/1e3,1450e2/9.81/1e3,720e2/9.81/1e3},
          V_flow_nominal={5e3/3.6,10e3/3.6,40e3/3.6}),
    V=1e-3,
    nParallel=2,
    N_nominal=1500) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={40,50})));

  Modelica.Blocks.Sources.Ramp cabin(
    startTime=0,
    duration=10*60,
    height=(-250e2)/1e5,
    offset=(1013e2)/1e5)
    annotation (Placement(transformation(extent={{64,-80},{74,-70}})));
  Modelica.Blocks.Logical.Switch pressure
    annotation (Placement(transformation(extent={{81,-50},{91,-40}})));
  Modelica.Blocks.Logical.GreaterThreshold blowof(threshold=0.99)
    annotation (Placement(transformation(extent={{19,8},{29,18}})));
  Applications.PressureLoss.Tjunction      join1(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, flowSituation=
        FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right)
                                                          annotation (Placement(
        transformation(
        extent={{-8,8},{4,-4}},
        rotation=0,
        origin={42,-22})));
  Applications.PressureLoss.Tjunction      join2(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, flowSituation=
        FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right)
                                                          annotation (Placement(
        transformation(
        extent={{-8,8},{4,-4}},
        rotation=270,
        origin={34,-42})));
  Modelica.Blocks.Sources.Constant fuel(k=100e2)
    annotation (Placement(transformation(extent={{64,-98},{74,-88}})));
equation
  connect(valve_5.port_b, ambient.ports[1]) annotation (Line(
      points={{66,-40},{66,-20},{68,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(engineRight.m_flow_in, engineLeft.m_flow_in) annotation (Line(
      points={{12,-92},{-48,-92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(engineLeft.m_flow_in, massFlowRate.y) annotation (Line(
      points={{-48,-92},{-48,-95},{-89.5,-95}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe_1.port_b, valve_78.port_a) annotation (Line(
      points={{-40,-10},{-40,-20},{-10,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valveOpening.y, valve_78.opening) annotation (Line(
      points={{-9.5,-5},{0,-5},{0,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(leftTank.ports[1], leftPump.port_a) annotation (Line(
      points={{-80,20},{-80,14},{-56,14},{-56,50},{-50,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_1.port_a, leftPump.port_b) annotation (Line(
      points={{-40,10},{-40,28},{-24,28},{-24,50},{-30,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(speed.y, pumpSpeedRight.w_ref) annotation (Line(
      points={{-49.5,75},{-40.75,75},{-40.75,72},{-35.2,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(leftPump.shaft, pumpSpeedRight.flange) annotation (Line(
      points={{-40,60},{-20,60},{-20,72},{-22,72}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(pipe_3.port_b, engineLeft.ports[1]) annotation (Line(
      points={{-40,-66},{-40,-72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_1.port_b, pipe_3.port_a) annotation (Line(
      points={{-40,-10},{-40,-46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpSpeedRight.flange, rightPump.shaft) annotation (Line(
      points={{-22,72},{40,72},{40,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(rightPump.port_a, rightTank.ports[1]) annotation (Line(
      points={{50,50},{54,50},{54,14},{80,14},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rightPump.port_b, pipe_2.port_a) annotation (Line(
      points={{30,50},{24,50},{24,26},{40,26},{40,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pressure.y, ambient.p_in) annotation (Line(
      points={{91.5,-45},{94,-45},{94,-28},{90,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(atmosphere.y, pressure.u1) annotation (Line(
      points={{74.5,-59},{76,-59},{76,-41},{80,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valveOpening.y, valve_5.opening) annotation (Line(
      points={{-9.5,-5},{14,-5},{14,-32},{56,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valveOpening.y, blowof.u) annotation (Line(
      points={{-9.5,-5},{14,-5},{14,13},{18,13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(blowof.y, pressure.u2) annotation (Line(
      points={{29.5,13},{96,13},{96,-45},{80,-45}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(valve_78.port_b, join1.port_1) annotation (Line(
      points={{10,-20},{34,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_2.port_b, join1.port_3) annotation (Line(
      points={{40,-10},{40,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(join2.port_3, valve_5.port_a) annotation (Line(
      points={{42,-40},{46,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_6.port_a, join2.port_2) annotation (Line(
      points={{20,-46},{36,-46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(join2.port_1, join1.port_2) annotation (Line(
      points={{36,-34},{36,-28},{50,-28},{50,-20},{46,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_6.port_b, engineRight.ports[1]) annotation (Line(
      points={{20,-66},{20,-69},{20,-69},{20,-72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fuel.y, pressure.u3) annotation (Line(
      points={{74.5,-93},{78,-93},{78,-49},{80,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
</html>
"), experiment(StopTime=2000, Interval=0.0002),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-94,122},{88,60}},
          lineColor={0,0,255},
          textString="Test: Aircraft engine feeding system")}));
end EngineFeedingSystem;
