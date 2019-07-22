within FluidDissipation.Examples.TestCases.PressureLoss;
model Diffuser "Test cases of pressure loss functions for diffusers"

  inner Modelica.Fluid.System system(p_ambient(displayUnit="Pa") = 5.013e5)
    annotation (Placement(transformation(extent={{80, -100}, {100, -80}})));

public
  Modelica.Blocks.Sources.Sine input_mflow(
    freqHz=1,
    offset=0,
    amplitude=1)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Modelica.Fluid.Sources.FixedBoundary OUT_mflow(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.SimpleAir)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,0})));

  Modelica.Fluid.Sources.MassFlowSource_T IN_mflow(
    T=system.T_ambient,
    nPorts=1,
    use_m_flow_in=true,
    redeclare package Medium = Modelica.Media.Air.SimpleAir)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,0})));

  Applications.PressureLoss.DiffuserFlowModel from_mflow(
                                      redeclare package Medium =
        Modelica.Media.Air.SimpleAir, redeclare model FlowModel =
        FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Diffuser.ConicalOverall.ConicalOverallFlowModel
        (
        A_1=PI*0.1^2/4,
        C_1=PI*0.1,
        A_2=4*PI*0.1^2/4)) "Calculate pressure loss from mass flow rate"
    annotation (Placement(transformation(extent={{-24,-24},{24,24}})));

equation
  connect(from_mflow.port_b, OUT_mflow.ports[1]) annotation (Line(
      points={{24,0},{52,0},{52,1.33227e-015},{80,1.33227e-015}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(from_mflow.port_a, IN_mflow.ports[1]) annotation (Line(
      points={{-24,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(input_mflow.y, IN_mflow.m_flow_in) annotation (Line(
      points={{-79,0},{-70,0},{-70,8},{-60,8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
Switch to the diagram or equation layer to see the model of a <b> Modelica.Fluid diffuser </b> using <b> FluidDissipation pressure loss calculations </b>.
</p>
</html>
"), experiment(Interval=0.0002),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-92,100},{90,38}},
          lineColor={0,0,255},
          textString="Test: Diffuser functions"), Text(
          extent={{-56,40},{60,24}},
          lineColor={255,0,0},
          textString=
              "set record parameters for chosen pressure loss function (inside flow model)")}));
end Diffuser;
