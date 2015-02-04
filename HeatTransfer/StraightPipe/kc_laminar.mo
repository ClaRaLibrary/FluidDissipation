within FluidDissipation.HeatTransfer.StraightPipe;
function kc_laminar
  "Mean heat transfer coefficient of straight pipe | uniform wall temperature or uniform heat flux | hydrodynamically developed or undeveloped laminar flow regime"
  extends Modelica.Icons.Function;
  //input records
  input FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_con IN_con
    "Input record for function kc_laminar"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_var IN_var
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
  Real MIN=Modelica.Constants.eps;

  Real laminar=2e3 "Maximum Reynolds number of laminar flow regime";
  Real prandtlMax=1000 "Maximum Prandtl number";
  Real prandtlMin=0.6 "Minimum Prandtl number";

  SI.Area A_cross=PI*IN_con.d_hyd^2/4 "Cross sectional area";

  SI.Velocity velocity=abs(IN_var.m_flow)/max(MIN, IN_var.rho*A_cross)
    "Mean velocity";

  //failure status
  Real fstatus[2] "check of expected boundary conditions";

  //Documentation
algorithm
  Pr := abs(IN_var.eta*IN_var.cp/max(MIN, IN_var.lambda));
  Re := max(1e-3, IN_var.rho*velocity*IN_con.d_hyd/max(MIN, IN_var.eta));
  kc := FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_KC(IN_con, IN_var);
  Nu := kc*IN_con.d_hyd/max(MIN, IN_var.lambda);

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
Calculation of mean convective heat transfer coefficient <b> kc </b> of a straight pipe at an uniform wall temperature <b> or </b> uniform heat flux <b>and</b> for a hydrodynamically developed <b>or</b> undeveloped laminar fluid flow.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> circular cross sectional area 
<li> uniform wall temperature (UWT) <b> or </b> uniform heat flux (UHF) 
<li> hydrodynamically developed fluid flow (DFF) <b> or </b> hydrodynamically undeveloped fluid flow (UFF) 
<li> 0.6 &le; Prandtl number &le; 1000 
<li> laminar regime (Reynolds number &le; 2000) 
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/pic_straightPipe.png\">
</p>  
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The mean convective heat transfer coefficient <b> kc </b> of a straight pipe in the laminar regime can be calculated for the following four heat transfer boundary conditions through its corresponding Nusselt number <b> Nu </b>:
 
<p>
<b> Uniform wall temperature in developed fluid flow (heatTransferBoundary == UWTuDFF)</b> according to <i>[VDI 2002, p. Ga 2, eq. 6]</i> :
</p> 
 
<pre>
    Nu_TD = [3.66^3 + 0.7^3 + {1.615*(Re*Pr*d_hyd/L)^1/3 - 0.7}^3]^1/3 
</pre>
 
<p>
<b> Uniform heat flux in developed fluid flow (heatTransferBoundary == UHFuDFF)</b> according to <i>[VDI 2002, p. Ga 4, eq. 19]</i> :
</p> 
 
<pre>
    Nu_qD = [4.364^3 + 0.6^3 + {1.953*(Re*Pr*d_hyd/L)^1/3 - 0.6}^3]^1/3 
</pre>
 
<p>
<b> Uniform wall temperature in undeveloped fluid flow (heatTransferBoundary == UWTuUFF)</b> according to <i>[VDI 2002, p. Ga 2, eq. 12]</i> :
</p> 
 
<pre>
    Nu_TU = [3.66^3 + 0.7^3 + {1.615*(Re*Pr*d_hyd/L)^1/3 - 0.7}^3 + {(2/[1+22*Pr])^1/6*(Re*Pr*d_hyd/L)^0.5}^3]^1/3 
</pre>
 
<p>
<b> Uniform heat flux in developed fluid flow (heatTransferBoundary == UHFuUFF)</b> according to <i>[VDI 2002, p. Ga 5, eq. 25]</i> :
</p> 
 
<pre>
    Nu_qU = [4.364^3 + 0.6^3 + {1.953*(Re*Pr*d_hyd/L)^1/3 - 0.6}^3 + {0.924*Pr^1/3*[Re*d_hyd/L]^0.5}^3]^1/3.  
</pre>
 
<p>
The corresponding mean convective heat transfer coefficient <b> kc </b> is determined w.r.t. the chosen heat transfer boundary by:
</p>
 
<p>
<pre>
    kc =  Nu * lambda / d_hyd
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> d_hyd                    </b></td><td> as hydraulic diameter of straight pipe [m],</td></tr>
<tr><td><b> kc                       </b></td><td> as mean convective heat transfer coefficient [W/(m2K)],</td></tr>
<tr><td><b> lambda                   </b></td><td> as heat conductivity of fluid [W/(mK)],</td></tr>
<tr><td><b> L                        </b></td><td> as length of straight pipe [m],</td></tr>
<tr><td><b> Nu = kc*d_hyd/lambda     </b></td><td> as mean Nusselt number [-], </td></tr>
<tr><td><b> Pr = eta*cp/lambda       </b></td><td> as Prandtl number [-],</td></tr>
<tr><td><b> Re = rho*v*d_hyd/eta     </b></td><td> as Reynolds number [-],</td></tr>
<tr><td><b> v                        </b></td><td> as mean velocity [m/s].</td></tr>
</table>
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>
The mean Nusselt number <b> Nu </b> representing the mean convective heat transfer coefficient <b> kc </b> depending on four different heat transfer boundary conditions is shown in the figures below. 
 
<p>
This verification has been done with the fluid properties of Water (Prandtl number Pr = 7) and a diameter to pipe length fraction of 0.1.
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_straightPipe_kc_laminar.png\">
</p>
 
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
 <dt>Bejan,A.:</dt> 
    <dd><b>Heat transfer handbook</b>. 
    Wiley, 2003.</dd>
 <dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
 
</html>
"));
end kc_laminar;
