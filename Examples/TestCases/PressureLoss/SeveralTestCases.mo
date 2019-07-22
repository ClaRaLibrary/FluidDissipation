within FluidDissipation.Examples.TestCases.PressureLoss;
model SeveralTestCases
  "Test cases of pressure loss functions for several devices"

  SI.Diameter d_hyd=0.1 "Hydraulic diameter";
  SI.Area A_cross=PI*d_hyd^2/4 "Cross sectional area";
  Real eta=1e-3 "Dynamic viscosity of Water";
  Real rho=1e3 "Density of Water";
  Real Re_cir=input_mflow.y*d_hyd/(eta*A_cross) "Circular geometry";
  Real Re_rec=input_mflow.y*d_hyd/(eta*d_hyd^2) "Rectangular geometry";
  Real vel_cir=input_mflow.y/(rho*A_cross) "Circular geometry";
  Real vel_rec=input_mflow.y/(rho*d_hyd^2) "Rectangular geometry";

  inner Modelica.Fluid.System system(p_ambient(displayUnit="Pa") = 100000,
      m_flow_small=0.01) annotation (Placement(
        transformation(extent={{-200,-200},{-180,-180}})));

public
  Modelica.Blocks.Sources.Sine input_mflow(
    offset=0,
    freqHz=1,
    amplitude=10)
    annotation (Placement(transformation(extent={{-200,-12},{-180,8}})));

public
  Modelica.Blocks.Sources.RealExpression input_p(y=from_mflow.port_a.p)
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  Modelica.Fluid.Sources.Boundary_pT IN_p(
    nPorts=1,
    T(displayUnit="K") = system.T_ambient,
    p(displayUnit="Pa") = system.p_ambient,
    use_p_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{40,154},{60,174}})));

  Modelica.Fluid.Sources.FixedBoundary OUT_dp(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={190,164})));

  Modelica.Fluid.Sources.FixedBoundary OUT_mflow(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={190,136})));

  Modelica.Fluid.Sources.MassFlowSource_T IN_mflow(
    T=system.T_ambient,
    nPorts=1,
    use_m_flow_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,136})));

  Applications.PressureLoss.BendFlowModel from_dp(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare model
      FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.CurvedBend.CurvedBendFlowModel)
    "Calculate mass flow rate from pressure loss"
    annotation (Placement(transformation(extent={{76,150},{124,198}})));

  Applications.PressureLoss.BendFlowModel from_mflow(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare model
      FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.CurvedBend.CurvedBendFlowModel)
    "Calculate pressure loss from mass flow rate"
    annotation (Placement(transformation(extent={{76,102},{124,150}})));

public
  Modelica.Blocks.Sources.RealExpression input_p1(y=from_mflow1.port_a.p)
    annotation (Placement(transformation(extent={{-200,78},{-180,98}})));
  Modelica.Fluid.Sources.Boundary_pT IN_p1(
    nPorts=1,
    T(displayUnit="K") = system.T_ambient,
    p(displayUnit="Pa") = system.p_ambient,
    use_p_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-160,74},{-140,94}})));
  Modelica.Fluid.Sources.FixedBoundary OUT_dp1(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,84})));
  Modelica.Fluid.Sources.FixedBoundary OUT_mflow1(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,56})));
  Modelica.Fluid.Sources.MassFlowSource_T IN_mflow1(
    T=system.T_ambient,
    nPorts=1,
    use_m_flow_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,56})));
  Applications.PressureLoss.BendFlowModel from_dp1(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare model
      FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.EdgedBend.EdgedBendFlowModel)
    "Calculate mass flow rate from pressure loss"
    annotation (Placement(transformation(extent={{-124,70},{-76,118}})));

  Applications.PressureLoss.BendFlowModel from_mflow1(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare model
      FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.EdgedBend.EdgedBendFlowModel)
    "Calculate pressure loss from mass flow rate"
    annotation (Placement(transformation(extent={{-124,22},{-76,70}})));

public
  Modelica.Blocks.Sources.RealExpression input_p2(y=from_mflow2.port_a.p)
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Modelica.Fluid.Sources.Boundary_pT IN_p2(
    nPorts=1,
    T(displayUnit="K") = system.T_ambient,
    p(displayUnit="Pa") = system.p_ambient,
    use_p_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{40,4},{60,24}})));
  Modelica.Fluid.Sources.FixedBoundary OUT_dp2(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={190,14})));
  Modelica.Fluid.Sources.FixedBoundary OUT_mflow2(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={190,-14})));
  Modelica.Fluid.Sources.MassFlowSource_T IN_mflow2(
    T=system.T_ambient,
    nPorts=1,
    use_m_flow_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-14})));
  Applications.PressureLoss.ChannelFlowModel from_dp2(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare model
      FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.Overall.OverallFlowModel)
    "Calculate mass flow rate from pressure loss"
    annotation (Placement(transformation(extent={{76,0},{124,48}})));

  Applications.PressureLoss.ChannelFlowModel from_mflow2(redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare
      model FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.Overall.OverallFlowModel)
    "Calculate pressure loss from mass flow rate"
    annotation (Placement(transformation(extent={{76,-48},{124,0}})));

public
  Modelica.Blocks.Sources.RealExpression input_p3(y=from_mflow3.port_a.p)
    annotation (Placement(transformation(extent={{-200,-62},{-180,-42}})));
  Modelica.Fluid.Sources.Boundary_pT IN_p3(
    nPorts=1,
    T(displayUnit="K") = system.T_ambient,
    p(displayUnit="Pa") = system.p_ambient,
    use_p_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-160,-66},{-140,-46}})));
  Modelica.Fluid.Sources.FixedBoundary OUT_dp3(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,-56})));
  Modelica.Fluid.Sources.FixedBoundary OUT_mflow3(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,-84})));
  Modelica.Fluid.Sources.MassFlowSource_T IN_mflow3(
    T=system.T_ambient,
    nPorts=1,
    use_m_flow_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-84})));
  Applications.PressureLoss.StraightPipeFlowModel from_dp3(redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare
      model FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Overall.OverallFlowModel)
    "Calculate mass flow rate from pressure loss"
    annotation (Placement(transformation(extent={{-124,-70},{-76,-22}})));

  Applications.PressureLoss.StraightPipeFlowModel from_mflow3(redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare
      model FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Overall.OverallFlowModel)
    "Calculate pressure loss from mass flow rate"
    annotation (Placement(transformation(extent={{-124,-118},{-76,-70}})));

public
  Modelica.Blocks.Sources.RealExpression input_p4(y=from_mflow4.port_a.p)
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Modelica.Fluid.Sources.Boundary_pT IN_p4(
    nPorts=1,
    T(displayUnit="K") = system.T_ambient,
    p(displayUnit="Pa") = system.p_ambient,
    use_p_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{40,-146},{60,-126}})));
  Modelica.Fluid.Sources.FixedBoundary OUT_dp4(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={190,-136})));
  Modelica.Fluid.Sources.FixedBoundary OUT_mflow4(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={190,-164})));
  Modelica.Fluid.Sources.MassFlowSource_T IN_mflow4(
    T=system.T_ambient,
    nPorts=1,
    use_m_flow_in=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-164})));
  Applications.PressureLoss.ValveFlowModel from_dp4(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare model
      FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Valve.Overall.OverallFlowModel)
    "Calculate mass flow rate from pressure loss"
    annotation (Placement(transformation(extent={{76,-150},{124,-102}})));

  Applications.PressureLoss.ValveFlowModel from_mflow4(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare model
      FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Valve.Overall.OverallFlowModel)
    "Calculate pressure loss from mass flow rate"
    annotation (Placement(transformation(extent={{76,-198},{124,-150}})));

equation
  connect(IN_p.ports[1], from_dp.port_a) annotation (Line(
      points={{60,164},{68,164},{68,174},{76,174}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_dp.port_b, OUT_dp.ports[1]) annotation (Line(
      points={{124,174},{152,174},{152,164},{180,164}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow.port_b, OUT_mflow.ports[1]) annotation (Line(
      points={{124,126},{152,126},{152,136},{180,136}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow.port_a, IN_mflow.ports[1]) annotation (Line(
      points={{76,126},{68,126},{68,136},{60,136}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(input_p.y, IN_p.p_in) annotation (Line(
      points={{21,170},{30,170},{30,172},{38,172}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(IN_p1.ports[1], from_dp1.port_a) annotation (Line(
      points={{-140,84},{-132,84},{-132,94},{-124,94}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_dp1.port_b, OUT_dp1.ports[1]) annotation (Line(
      points={{-76,94},{-48,94},{-48,84},{-20,84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow1.port_b, OUT_mflow1.ports[1]) annotation (Line(
      points={{-76,46},{-48,46},{-48,56},{-20,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow1.port_a, IN_mflow1.ports[1]) annotation (Line(
      points={{-124,46},{-132,46},{-132,56},{-140,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(input_p1.y, IN_p1.p_in) annotation (Line(
      points={{-179,88},{-170,88},{-170,92},{-162,92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(IN_p2.ports[1], from_dp2.port_a) annotation (Line(
      points={{60,14},{68,14},{68,24},{76,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_dp2.port_b, OUT_dp2.ports[1]) annotation (Line(
      points={{124,24},{152,24},{152,14},{180,14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow2.port_b, OUT_mflow2.ports[1]) annotation (Line(
      points={{124,-24},{152,-24},{152,-14},{180,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow2.port_a, IN_mflow2.ports[1]) annotation (Line(
      points={{76,-24},{68,-24},{68,-14},{60,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(input_p2.y, IN_p2.p_in) annotation (Line(
      points={{21,20},{28,20},{28,22},{38,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(IN_p3.ports[1], from_dp3.port_a) annotation (Line(
      points={{-140,-56},{-132,-56},{-132,-46},{-124,-46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_dp3.port_b, OUT_dp3.ports[1]) annotation (Line(
      points={{-76,-46},{-48,-46},{-48,-56},{-20,-56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow3.port_b, OUT_mflow3.ports[1]) annotation (Line(
      points={{-76,-94},{-48,-94},{-48,-84},{-20,-84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow3.port_a, IN_mflow3.ports[1]) annotation (Line(
      points={{-124,-94},{-132,-94},{-132,-84},{-140,-84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(input_p3.y, IN_p3.p_in) annotation (Line(
      points={{-179,-52},{-170,-52},{-170,-48},{-162,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(IN_p4.ports[1], from_dp4.port_a) annotation (Line(
      points={{60,-136},{68,-136},{68,-126},{76,-126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_dp4.port_b, OUT_dp4.ports[1]) annotation (Line(
      points={{124,-126},{152,-126},{152,-136},{180,-136}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow4.port_b, OUT_mflow4.ports[1]) annotation (Line(
      points={{124,-174},{152,-174},{152,-164},{180,-164}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow4.port_a, IN_mflow4.ports[1]) annotation (Line(
      points={{76,-174},{68,-174},{68,-164},{60,-164}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(input_p4.y, IN_p4.p_in) annotation (Line(
      points={{21,-140},{28,-140},{28,-128},{38,-128}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(input_mflow.y, IN_mflow.m_flow_in) annotation (Line(
      points={{-179,-2},{-174,-2},{-174,144},{40,144}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(input_mflow.y, IN_mflow1.m_flow_in) annotation (Line(
      points={{-179,-2},{-174,-2},{-174,64},{-160,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(input_mflow.y, IN_mflow2.m_flow_in) annotation (Line(
      points={{-179,-2},{-174,-2},{-174,-6},{40,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(input_mflow.y, IN_mflow3.m_flow_in) annotation (Line(
      points={{-179,-2},{-174,-2},{-174,-76},{-160,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(input_mflow.y, IN_mflow4.m_flow_in) annotation (Line(
      points={{-179,-2},{-174,-2},{-174,-156},{40,-156}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
</html>
"), experiment(Interval=0.0002),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},{200,
            200}}), graphics={
        Text(
          extent={{-50,200},{32,186}},
          lineColor={0,0,255},
          textString="SeveralTestCases"),
        Text(
          extent={{-92,158},{-10,144}},
          lineColor={0,0,255},
          textString="CurvedBend"),
        Text(
          extent={{8,76},{90,62}},
          lineColor={0,0,255},
          textString="MitreBend"),
        Text(
          extent={{-92,8},{-10,-6}},
          lineColor={0,0,255},
          textString="RectangularChannel"),
        Text(
          extent={{8,-63},{90,-77}},
          lineColor={0,0,255},
          textString="StraightPipe"),
        Text(
          extent={{-92,-141},{-10,-155}},
          lineColor={0,0,255},
          textString="BallValve")}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},{200,
            200}})));
end SeveralTestCases;
