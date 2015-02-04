within FluidDissipation.Utilities.Icons;
class BaseLibrary "Icon for a base library"

  extends Package;
  annotation (Diagram(graphics), Icon(graphics={
        Ellipse(
          extent={{-30,-30},{30,30}},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end BaseLibrary;
