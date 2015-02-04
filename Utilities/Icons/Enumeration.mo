within FluidDissipation.Utilities.Icons;
class Enumeration "package icon for enumerations workaround"

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-140,162},{136,102}},
          textString="%name",
          lineColor={0,0,255}),Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Text(
          extent={{-100,112},{100,-88}},
          lineColor={255,127,0},
          textString="e")}));
end Enumeration;
