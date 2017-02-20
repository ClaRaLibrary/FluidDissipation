within ;
package FluidDissipation
import PI = Modelica.Constants.pi;
import REC = FluidDissipation.Utilities.Records;
import SI = Modelica.SIunits;
import TYP = FluidDissipation.Utilities.Types;


extends FluidDissipation.Utilities.Icons.Package;














annotation (
  preferredView="info",
  version="1.1.8",
  uses(Modelica(version="3.2.2")),
  conversion(
 from(version="1.0 Beta 8a", script="./Extras/Scripts/ConvertFluidDissipation_from_Beta8_to_Beta9.mos"),
  from(version="1.0 Beta 8b", script="./Extras/Scripts/ConvertFluidDissipation_from_Beta8_to_Beta9.mos"),
    from(version="1.0 Beta 8c", script="./Extras/Scripts/ConvertFluidDissipation_from_Beta8_to_Beta9.mos"),
    noneFromVersion="1.0",
    from(version="1.1.4", script="./Extras/Scripts/ConvertFluidDissipation_from_1.1.4_to1.1.5.mos"),
    from(version="1.1.7", script="./Extras/Scripts/ConvertFluidDissipation_from_1.1.7_to1.1.8.mos")),
  Documentation(info="<html>
<div align=\"center\">
 
<p> 
<img src=\"modelica://FluidDissipation/Extras/Images/FD_500.png\">
</p>
</div>
 
<h2> <font color=\"#EF9B13\"> Library description </font></h2>
 
This library contains <b>convective heat transfer</b> and  <b>pressure loss</b> functions written in 
Modelica&reg;. Generally the pressure loss calculations are based on incompressible fluids and total pressure difference. For devices with non changing cross sectional area, the calculated total pressure loss is equal to the static pressure difference. Geodetic pressure loss is not considered throughout the library (except two-phase flow pipes). The functions supplied may be used separately.<br>
<br>
For the following applications functions are provided:
<p>
<b>
<ul>
<li>Heat Transfer</li>
        <ul> 
                <li> Channel: even gaps</li>
                <li> General: generic forced convection (e.g., Dittus and Boelter)</li>
                <li> Heat Exchanger: air-side heat transfer for fin and tube heat exchangers, 
                                2-phase heat transfer for tube and shell heat exchangers,
                         1-phase heat transfer for tube bundle heat exchangers</li>
                <li> Helical Pipe: forced convection within helical pipe heat exchangers</li>
                <li> Plate: forced convection for even surfaces</li> 
                <li> Straight Pipe: heat transfer in straight pipes</li>
        </ul>
<li>Pressure Loss</li>
        <ul>
                <li> Bend: pressure drop for curved or edged bends</li>
                <li> Channel: pressure drop for channel flows</li>
                <li> Diffuser: pressure difference in diffusers</li>
                <li> General: generic pressure drop correlations</li>
                <li> Heat Exchanger: air-side pressure drop for fin and tube heat exchangers,
                        pressure drop for corrugated plate heat exchangers</li>
                <li> Junction: pressure difference in junctions</li>
                <li> Nozzle: pressure drop in nozzles</li>
                <li> Orifice: pressure difference for a sudden change of hydraulic diameter</li>
                <li> Straight Pipe: pressure drop in straight pipes</li>
                <li> Valve: pressure drop of multiple valve types</li>
        </ul>
</ul>
</b>
</p>        
<p>
The library is a non-commercial product of XRG Simulation GmbH. It makes use of external, 
non-commercial models supplied by Modelica Standard Library. In order to work correctly, 
ensure that this library is always loaded with <b> Modelica Standard Library version 
3.2.1</b>.<br>
 
<h2> <font color=\"#EF9B13\"> Acknowledgements </font></h2>
The following people contributed to the FluidDissipation library (alphabetical list):
J&ouml;rg Eiden, Ole Engel, Friedrich Gottelt, Timm Hoppe, Nina Peci, Sven Rutkowski, Thorben Vahlenkamp, Stefan 
Wischhusen. 
 
<p>
The development of the FluidDissipation library was founded within the ITEA research 
project EuroSysLib-D by German Federal Ministry of Education and Research (promotional 
reference 01IS07022B). The project ended in June 2010.<br>
<br>
Furthermore, funding was received in the projects DynCap and DynStart from the
German Federal Ministry for Economic Affairs and Energy (promotional references 
03ET2009C and 03ET7060D)
</p>
 
<h2> <font color=\"#EF9B13\"> Licence condition </font></h2>
<p>
<b>Licensed by XRG-Simulation GmbH under the Modelica License 2</b><br>
Copyright &copy; 2007-2016, XRG Simulation GmbH.
</p>
 
<p>
<i>This Modelica package is <u>free</u> software and
the use is completely at <u>your own risk</u>;
it can be redistributed and/or modified under the terms of the
Modelica license 2, see the license conditions (including the
disclaimer of warranty)
<a href=\"Modelica://FluidDissipation.UsersGuide.ModelicaLicense2\">here</a></u>
or at
<a href=\"https://www.Modelica.org/licenses/ModelicaLicense2\">
http://www.Modelica.org/licenses/ModelicaLicense2</a>.</i>
</p><br>
 
<h2> <font color=\"#EF9B13\"> Contact </font></h2>
 
XRG Simulation GmbH<br>
Harburger Schlossstrasse 6-12<br>
21079 Hamburg<br>
Germany<br>
<br>
<a href=mailto:info@xrg-simulation.de>info@xrg-simulation.de</a> </html>
 
"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={                             Bitmap(extent={{-92,-80},{94,82}},
          fileName="Modelica://FluidDissipation/Extras/Images/XRG_logo_3Streifen.png")}));
end FluidDissipation;
