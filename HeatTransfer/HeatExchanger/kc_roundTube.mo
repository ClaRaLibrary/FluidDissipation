within FluidDissipation.HeatTransfer.HeatExchanger;
function kc_roundTube
  extends Modelica.Icons.Function;
  //SOURCE: A.M. Jacobi, Y. Park, D. Tafti, X. Zhang. AN ASSESSMENT OF THE STATE OF THE ART, AND POTENTIAL DESIGN IMPROVEMENTS, FOR FLAT-TUBE HEAT EXCHANGERS IN AIR CONDITIONING AND REFRIGERATION APPLICATIONS - PHASE I

  //input records
  input FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_con IN_con
    "Input record for function kc_roundTube_KC";
  input FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_var IN_var
    "Input record for function kc_roundTube_KC";

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

  import TYP = FluidDissipation.Utilities.Types.HTXGeometry_roundTubes;

protected
  SI.Area A_c=IN_con.A_fr*((IN_con.F_p*IN_con.P_t - IN_con.F_p*IN_con.D_c - (
      IN_con.P_t - IN_con.D_c)*IN_con.delta_f)/(IN_con.F_p*IN_con.P_t))
    "Minimum flow cross-sectional area";
  SI.Area A_tot=if IN_con.geometry == TYP.LouverFin then IN_con.A_fr*((IN_con.N
      *PI*IN_con.D_c*(IN_con.F_p - IN_con.delta_f) + 2*(IN_con.P_t*IN_con.L -
      IN_con.N*PI*IN_con.D_c^2/4))/(IN_con.P_t*IN_con.F_p)) else 0
    "Total heat transfer area";
  SI.Length D_h=if IN_con.geometry == TYP.LouverFin then 4*A_c*IN_con.L/A_tot else
            0 "Hydraulic diameter";

algorithm
  kc := FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_KC(IN_con,
    IN_var);
  Pr := abs(IN_var.eta*IN_var.cp/IN_var.lambda);

  if IN_con.geometry == TYP.PlainFin or IN_con.geometry == TYP.LouverFin or
      IN_con.geometry == TYP.SlitFin or IN_con.geometry == TYP.WavyFin then
    Re := abs(IN_var.m_flow)*IN_con.D_c/(IN_var.eta*A_c);
    Nu := max(1e-3, kc*IN_con.D_c/IN_var.lambda);
  end if;

  failureStatus := if IN_con.geometry == TYP.PlainFin then if Re < 300 or Re >
    8000 then 1 else 0 else if IN_con.geometry == TYP.LouverFin then if Re <
    300 or Re > 7000 then 1 else 0 else if IN_con.geometry == TYP.SlitFin then
    if Re < 400 or Re > 7000 then 1 else 0 else if IN_con.geometry == TYP.WavyFin then
          if Re < 350 or Re > 7000 then 1 else 0 else 0;

  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(info="<html>
<p>
Calculation of the mean convective heat transfer coefficient <b> kc </b> for the air-side heat transfer of heat exchangers with round tubes and several fin geometries.
</p>

<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> According to the kind of fin geometry the calculation is valid in a range of <b> Re</b> from 300 to 8000. </li>

<p>
<table>
<tr><td><b> Plain fin      </b></td><td> 300 &lt; Re_Dc &lt; 8000,</td></tr>
<tr><td><b> Louver fin     </b></td><td> 300 &lt; Re_Dc &lt; 7000,</td></tr>
<tr><td><b> Slit fin       </b></td><td> 400 &lt; Re_Dc &lt; 7000,</td></tr>
<tr><td><b> Wavy fin       </b></td><td> 350 &lt; Re_Dc &lt; 7000.</td></tr>
</table>
</p>

<br>

<li> medium = air </li>
</ul>

<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/heatExchanger/pic_roundTube.png\", width=850>
</p> 

<h4><font color=\"#EF9B13\">Calculation</font></h4>
<p>
The mean convective heat transfer coefficient <b> kc </b> for heat exchanger is calculated through the corresponding Coulburn factor <b> j </b>:
</p>

<ul>
     <p>
     <pre>
     kc =  j * Re_Dc * Pr^(1/3) * lambda / D_c
     </pre>
     </p>

  <li> <b>Plain fin</b>:
     <p>
     <pre>
      j = f(Re_Dc, D_c, F_p, N, P_l, P_t) 
     </pre>
     </p>
  <li> <b>Louver fin</b>:
     <p>
     <pre>
      j = f(Re_Dc, D_c, D_h, F_p, L_h, L_p, N, P_l, P_t) 
     </pre>
     </p>
  <li> <b>Slit fin</b>:
     <p>
     <pre>
      j = f(Re_Dc, D_c, F_p, N, P_l, P_t, S_h, S_p)
     </pre>
     </p>
  <li> <b>Wavy fin</b>:
     <p>
     <pre>
      j = f(Re_Dc, A_c, A_fr)
     </pre>
     </p>
</ul>

<p>
with
</p>
 
<p>
<table>
<tr><td><b> A_c                           </b></td><td> as minimum flow cross-sectional area [m^2],</td></tr>
<tr><td><b> A_fr                          </b></td><td> as frontal area [m^2],</td></tr>
<tr><td><b> D_c                           </b></td><td> as fin collar diameter [m],</td></tr>
<tr><td><b> D_h                           </b></td><td> as hydraulic diameter [m],</td></tr>
<tr><td><b> F_p                           </b></td><td> as fin pitch [m],</td></tr>
<tr><td><b> kc                            </b></td><td> as mean convective heat transfer coefficient [W/(m2K)],</td></tr>
<tr><td><b> L_h                           </b></td><td> as louver height [m],</td></tr>
<tr><td><b> L_p                           </b></td><td> as louver pitch [m],</td></tr>
<tr><td><b> lambda                        </b></td><td> as heat conductivity of fluid [W/(mK)],</td></tr>
<tr><td><b> N                             </b></td><td> as number of tube rows [-],</td></tr>
<tr><td><b> P_l                           </b></td><td> as longitudinal tube pitch [m],</td></tr>
<tr><td><b> P_t                           </b></td><td> as transverse tube pitch [m],</td></tr>
<tr><td><b> Pr = eta*cp/lambda            </b></td><td> as Prandtl number [-],</td></tr>
<tr><td><b> Re_Dc = rho*velocity_c*D_c/eta</b></td><td> as Reynolds number based on fin collar diameter <b> D_c </b> and average velocity <b> velocity_c </b> at minimum cross-sectional area <b> A_c </b> [-],</td></tr>
<tr><td><b> S_h                           </b></td><td> as slit height [m],</td></tr>
<tr><td><b> S_p                           </b></td><td> as slit pitch [m].</td></tr>
</table>
</p>

<p>
The minimum flow cross-sectional area <b> A_c </b> for heat exchangers is determined by:
</p>

<p>
<pre>
    A_c = A_fr * (F_p * P_t - F_p * D_c - (P_t - D_c) * delta_f) / (F_p * P_t)
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> A_fr          </b></td><td> as frontal area [m^2],</td></tr>
<tr><td><b> D_c           </b></td><td> as fin collar diameter [m],</td></tr>
<tr><td><b> delta_f       </b></td><td> as fin thickness [m],</td></tr>
<tr><td><b> F_p           </b></td><td> as fin pitch [m],</td></tr>
<tr><td><b> P_d           </b></td><td> as pattern depth of wavy fin, wave height [m],</td></tr>
<tr><td><b> P_t           </b></td><td> as transverse tube pitch [m].</td></tr>
</table>
</p>

<h4><font color=\"#EF9B13\">Verification</font></h4>
<p>
The mean Nusselt number <b> Nu </b> representing the mean convective heat transfer coefficient <b> kc </b> is shown below for different fin geometries at similar dimensions. 
</p>

<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/heatExchanger/fig_roundTube_kc.png\">
</p>

<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
 <dt>C.-C. Wang, C.-T. Chang:</dt> 
    <dd><b>Heat and mass transfer for plate fin-and-tube heat exchangers, with and without hydrophilic coating</b>. 
    In International Journal of Heat and Mass Transfer, volume 41, pages 3109-3120, 1998.</dd>
 <dt>C.-C. Wang, C.-J. Lee, C.-T. Chang, S.-P. Lin:</dt> 
    <dd><b>Heat transfer and friction correlation for compact louvered fin-and-tube heat exchangers</b>. 
    In International Journal of Heat and Mass Transfer, volume 42, pages 1945-1956, 1999.</dd>
 <dt>C.-C. Wang, W.-H. Tao, C.-J. Chang:</dt> 
    <dd><b>An investigation of the airside performance of the slit fin-and-tube heat exchangers</b>. 
    In International Journal of Refrigeration, volume 22, pages 595-603, 1999.</dd>
 <dt>C.-C. Wang, W.-L. Fu, C.-T. Chang:</dt> 
    <dd><b>Heat Transfer and Friction Characteristics of Typical Wavy Fin-and-Tube Heat Exchangers</b>. 
    In Experimental Thermal and Fluid Science, volume 14, pages 174-186, 1997.</dd>
</dl>

</html>
", revisions="<html>
</html>"));
end kc_roundTube;
