within FluidDissipation.HeatTransfer.Plate;
function kc_laminar "Mean heat transfer coefficient of plate | laminar regime"
  extends Modelica.Icons.Function;
  //SOURCE: VDI-Waermeatlas, Aufl. 9, Springer-Verlag, 2002, Section Gd 1
  //Notation of equations according to SOURCE

  //input records
  input FluidDissipation.HeatTransfer.Plate.kc_laminar_IN_con IN_con
    "Input record for function kc_laminar"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.Plate.kc_laminar_IN_var IN_var
    "Input record for function kc_laminar"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output SI.CoefficientOfHeatTransfer kc "Convective heat transfer coefficient"
    annotation (Dialog(group="Output"));
  output SI.PrandtlNumber Pr "Prandtl number" annotation (Dialog(group="Output"));
  output SI.ReynoldsNumber Re "Reynolds number"
    annotation (Dialog(group="Output"));
  output SI.NusseltNumber Nu "Nusselt number"
    annotation (Dialog(group="Output"));
  output Real failureStatus
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

protected
  Real MIN=Modelica.Constants.eps "Limiter";

  Real laminar=1e5 "Maximum Reynolds number of laminar flow regime";
  Real prandtlMax=2000 "Maximum Prandtl number";
  Real prandtlMin=0.6 "Minimum Prandtl number";

  //failure status
  Real fstatus[2] "Check of expected boundary conditions";

  //Documentation
algorithm
  Pr := IN_var.eta*IN_var.cp/max(MIN, IN_var.lambda);
  Re := abs(IN_var.rho*IN_var.velocity*IN_con.L/max(MIN, IN_var.eta));
  kc := FluidDissipation.HeatTransfer.Plate.kc_laminar_KC(IN_con, IN_var);
  Nu := kc*IN_con.L/max(MIN, IN_var.lambda);

  //failure status
  fstatus[1] := if Re > laminar then 1 else 0;
  fstatus[2] := if Pr > prandtlMax or Pr < prandtlMin then 1 else 0;

  failureStatus := 0;
  for i in 1:size(fstatus, 1) loop
    if fstatus[i] == 1 then
      failureStatus := 1;
    end if;
  end for;
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of the mean convective heat transfer coefficient <b> kc </b> for a laminar fluid flow over an even surface.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> laminar regime (Reynolds number &le; 1e5) 
<li> Prandtl number 0.6 &le; Pr &le; 2000 
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/plate/pic_plate.png\">
</p>   
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The mean convective heat transfer coefficient <b> kc</b> for flat plate is calculated through the corresponding Nusselt number <b> Nu_lam</b> according to <i>[VDI 2002, p. Gd 1, eq. 1]</i> :
 
<pre>
    Nu_lam = 0.664 * Re^(0.5) * (Pr)^(1/3) 
</pre>
 
<p>
and the corresponding mean convective heat transfer coefficient <b> kc </b> :
</p>
 
<p>
<pre>
    kc =  Nu_lam * lambda / L
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> cp                 </b></td><td> as specific heat capacity at constant pressure [J/(kg.K)],</td></tr>
<tr><td><b> eta                </b></td><td> as dynamic viscosity of fluid [Pa.s],</td></tr>
<tr><td><b> kc                 </b></td><td> as mean convective heat transfer coefficient [W/(m2.K)],</td></tr>
<tr><td><b> lambda         </b></td><td> as heat conductivity of fluid [W/(m.K)],</td></tr>
<tr><td><b> L              </b></td><td> as length of plate [m],</td></tr>
<tr><td><b> Nu_lam                  </b></td><td> as mean Nusselt number for laminar regime [-], </td></tr>
<tr><td><b> Pr = eta*cp/lambda           </b></td><td> as Prandtl number [-],</td></tr>
<tr><td><b> rho          </b></td><td> as fluid density [kg/m3],</td></tr>
<tr><td><b> Re = rho*v*L/eta    </b></td><td> as Reynolds number [-].</td></tr>
</table>
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>
 
The mean Nusselt number <b> Nu </b> in the laminar regime representing the mean convective heat transfer coefficient <b> kc </b> for Prandtl numbers of different fluids is shown in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/plate/fig_plate_kc_laminar.png\" width=\"600\">
</p>
 
Note that this function is best used in the laminar regime up to a Reynolds number <b> Re </b> smaller than 2300. There is a deviation w.r.t. literature due to the neglect of the turbulence influence in the transition regime even though this function is used inside its cited restrictions for a higher Reynolds number. The function <a href=\"Modelica://FluidDissipation.HeatTransfer.Plate.kc_mean_overall\">  kc_mean_overall </a> is recommended for the simulation of a Reynolds number higher than 2300.
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl> 
<dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
 
</html>
", revisions="<html>
<pre>2016-04-12 Stefan Wischhusen: Removed singularity for Re at zero mass flow rate. </pre>
</html>"));
end kc_laminar;
