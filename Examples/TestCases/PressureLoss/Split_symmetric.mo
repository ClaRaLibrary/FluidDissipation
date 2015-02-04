within FluidDissipation.Examples.TestCases.PressureLoss;
model Split_symmetric

  Applications.PressureLoss.Tjunction tjunction(
                                             redeclare package Medium =
      Modelica.Media.Air.SimpleAir,
    flowSituation=FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric,
    zeta_TOT_max=3)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(
  redeclare package Medium = Modelica.Media.Air.SimpleAir,
    nPorts=1,
    p=system.p_start)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary2(
  redeclare package Medium = Modelica.Media.Air.SimpleAir,
    m_flow=0.5,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));

  inner Modelica.Fluid.System system(momentumDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_out_right(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    diameter=0.1,
    length=5,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b)
              annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    startTime=1,
    offset=0,
    height=0.5)
    annotation (Placement(transformation(extent={{-100,-56},{-80,-36}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_out_left(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    diameter=0.1,
    length=5,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b)
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,0})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_in(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    diameter=0.1,
    length=5,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b)
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Modelica.Fluid.Sources.Boundary_pT boundary1(
  redeclare package Medium = Modelica.Media.Air.SimpleAir,
    nPorts=1,
    p=system.p_start)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
equation
  connect(pipe_out_right.port_a, tjunction.port_2)
                                                annotation (Line(
      points={{40,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_out_right.port_b, boundary.ports[1])
                                                 annotation (Line(
      points={{60,0},{70,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ramp.y, boundary2.m_flow_in) annotation (Line(
      points={{-79,-46},{-74,-46},{-74,-52},{-70,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary2.ports[1], pipe_in.port_a)   annotation (Line(
      points={{-50,-60},{-30,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary1.ports[1], pipe_out_left.port_b)
                                                annotation (Line(
      points={{-70,0},{-66,0},{-66,1.22465e-015},{-60,1.22465e-015}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_in.port_b, tjunction.port_3) annotation (Line(
      points={{-10,-60},{0,-60},{0,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tjunction.port_1, pipe_out_left.port_a) annotation (Line(
      points={{-20,0},{-28.4,0},{-28.4,-1.22465e-015},{-40,-1.22465e-015}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    experiment(StopTime=15, Tolerance=1e-005));
end Split_symmetric;
