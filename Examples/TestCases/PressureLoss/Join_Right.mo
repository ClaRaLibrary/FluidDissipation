within FluidDissipation.Examples.TestCases.PressureLoss;
model Join_Right

  Applications.PressureLoss.Tjunction tjunction(
                                             redeclare package Medium =
      Modelica.Media.Air.SimpleAir,
    zeta_TOT_max=100,
    flowSituation=FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(
  redeclare package Medium = Modelica.Media.Air.SimpleAir,
    nPorts=1,
    p=system.p_start)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary2(
  redeclare package Medium = Modelica.Media.Air.SimpleAir,
    m_flow=0.5,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));

  inner Modelica.Fluid.System system(momentumDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_out_st(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    diameter=0.1,
    length=5,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b)
              annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    startTime=1,
    height=1,
    offset=0)
    annotation (Placement(transformation(extent={{-130,14},{-110,34}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_in(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    diameter=0.1,
    length=5,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary1(
  redeclare package Medium = Modelica.Media.Air.SimpleAir,
    nPorts=1,
    m_flow=0.01,
    use_m_flow_in=true)
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_in_s(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    diameter=0.1,
    length=5,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b)
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
equation
  connect(pipe_out_st.port_b, boundary.ports[1]) annotation (Line(
      points={{-60,0},{-70,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ramp.y, boundary2.m_flow_in) annotation (Line(
      points={{-109,24},{96,24},{96,8},{90,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary2.ports[1], pipe_in.port_a)   annotation (Line(
      points={{70,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_in_s.port_a, boundary1.ports[1]) annotation (Line(
      points={{-30,-60},{-50,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_in_s.port_b, tjunction.port_3) annotation (Line(
      points={{-10,-60},{0,-60},{0,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ramp.y, boundary1.m_flow_in) annotation (Line(
      points={{-109,24},{-109,-52},{-70,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe_in.port_b, tjunction.port_2) annotation (Line(
      points={{40,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_out_st.port_a, tjunction.port_1) annotation (Line(
      points={{-40,0},{-20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    experiment(StopTime=15, Tolerance=1e-005));
end Join_Right;
