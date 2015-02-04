within FluidDissipation.Examples.TestCases.PressureLoss;
model Join_symmetric

  Applications.PressureLoss.Tjunction tjunction(
                                             redeclare package Medium =
      Modelica.Media.Air.SimpleAir, zeta_TOT_max=100,
    flowSituation=FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(
  redeclare package Medium = Modelica.Media.Air.SimpleAir,
    p=system.p_start,
    nPorts=1)
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary2(
  redeclare package Medium = Modelica.Media.Air.SimpleAir,
    m_flow=0.5,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  inner Modelica.Fluid.System system(momentumDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_out_st(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    diameter=0.1,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b,
    length=5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-20,-60})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=1,
    offset=0.1,
    height=0.3,
    duration=3)
    annotation (Placement(transformation(extent={{-130,14},{-110,34}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_in_left(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    diameter=0.1,
    length=5,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary1(
  redeclare package Medium = Modelica.Media.Air.SimpleAir,
    nPorts=1,
    m_flow=0.1,
    use_m_flow_in=true)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_in_right(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    diameter=0.1,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b,
    length=5)                                                 annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,0})));
equation
  connect(ramp.y, boundary2.m_flow_in) annotation (Line(
      points={{-109,24},{-100,24},{-100,8},{-90,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary2.ports[1], pipe_in_left.port_a)
                                                annotation (Line(
      points={{-70,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary.ports[1], pipe_out_st.port_b) annotation (Line(
      points={{-50,-60},{-30,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tjunction.port_2, pipe_in_right.port_b)
                                              annotation (Line(
      points={{20,0},{28.4,0},{28.4,1.22465e-015},{40,1.22465e-015}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_in_right.port_a, boundary1.ports[1])
                                                annotation (Line(
      points={{60,-1.22465e-015},{62,-1.22465e-015},{62,0},{70,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tjunction.port_3, pipe_out_st.port_a) annotation (Line(
      points={{0,-20},{0,-60},{-10,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_in_left.port_b, tjunction.port_1) annotation (Line(
      points={{-40,0},{-20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ramp.y, boundary1.m_flow_in) annotation (Line(
      points={{-109,24},{102,24},{102,8},{90,8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    experiment(StopTime=15, Tolerance=1e-005));
end Join_symmetric;
