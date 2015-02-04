within FluidDissipation.Utilities;
package Icons 
extends Icons.Package;


  class Package "Icon for a package"

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}), graphics={
          Rectangle(
            lineColor={128,128,128},
            fillColor={248,248,248},
            fillPattern=FillPattern.Solid,
            extent={{-100.0,-100.0},{100.0,100.0}},
            radius=25),
          Rectangle(
            lineColor={128,128,128},
            fillPattern=FillPattern.None,
            extent={{-100.0,-100.0},{100.0,100.0}},
            radius=25.0)}));
  end Package;

end Icons;
