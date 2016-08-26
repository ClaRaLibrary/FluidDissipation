within FluidDissipation.Examples.Applications.PressureLoss;
model StraightPipeFlowModel "Application flow model for straight pipe functions in Modelica.Fluid"

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.StraightPipe_i;

  //choice for straight pipe pressure loss model
  replaceable model FlowModel =
      FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Overall.OverallFlowModel
    constrainedby FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.BaseStraightPipePL.BaseStraightPipeModel
    annotation (choicesAllMatching=true);

  replaceable package Medium =
      Modelica.Media.CompressibleLiquids.LinearColdWater                                                   constrainedby Modelica.Media.Interfaces.PartialMedium "Medium in the component"
                              annotation (choicesAllMatching=true);

  //interfaces
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=
           0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=0),
        iconTransformation(extent={{110,-10},{90,10}})));

  //instance of flow model for chosen generic pressure loss
  //see definition in PartialFlowModel
  FlowModel flowModel(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(port_a, flowModel.port_a) annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(flowModel.port_b, port_b) annotation (Line(
      points={{10,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-40,-70},{40,-110}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          fillColor={232,0,0},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=
            true, extent={{-100,-100},{100,100}}), graphics));
end StraightPipeFlowModel;
