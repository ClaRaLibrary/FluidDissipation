within FluidDissipation.Utilities.Icons.PressureLoss;
model FlowModel "icon for flow model in Modelica_Fluid applications"

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Polygon(
          points={{-60,50},{-60,-50},{60,-50},{60,50},{-60,50}},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-60,0},{-100,0}}, color={0,127,255}),
        Line(
          points={{-60,50},{-60,-50},{60,50},{60,-50},{-60,50}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(points={{60,0},{100,0}}, color={0,127,255})}));
end FlowModel;
