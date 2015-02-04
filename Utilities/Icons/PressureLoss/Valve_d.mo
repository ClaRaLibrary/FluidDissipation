within FluidDissipation.Utilities.Icons.PressureLoss;
partial model Valve_d "Icon for valve"

  annotation ( Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
          extent={{-6,-74},{10,-86}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Line(points={{-60,0},{-100,0}}, color={0,
          127,255}),Polygon(
          points={{-60,50},{-60,-50},{60,-50},{60,50},{-60,50}},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Line(points={{60,0},{100,0}}, color={0,127,
          255}),Line(
          points={{-60,50},{-60,-50},{60,50},{60,-50},{-60,50}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5)}));

end Valve_d;
