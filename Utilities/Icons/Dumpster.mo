within FluidDissipation.Utilities.Icons;
class Dumpster

  annotation (Icon(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
          extent={{-60,-38},{60,-78}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,80},{60,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,60},{-60,-60}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,60},{60,-60}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-110,20},{118,-22}},
          lineColor={0,0,255},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="Dump")}));
end Dumpster;
