within FluidDissipation.PressureLoss.HeatExchanger;
function dp_roundTube_DP "Air-side pressure loss of heat exchanger with round tubes and several fin geometries | calculate DP (incompressible)"
  extends Modelica.Icons.Function;
  //SOURCE: A.M. Jacobi, Y. Park, D. Tafti, X. Zhang. AN ASSESSMENT OF THE STATE OF THE ART, AND POTENTIAL DESIGN IMPROVEMENTS, FOR FLAT-TUBE HEAT EXCHANGERS IN AIR CONDITIONING AND REFRIGERATION APPLICATIONS - PHASE I
  //Notation of equations according to SOURCE

  import FD = FluidDissipation.PressureLoss.HeatExchanger;

  //input records
  input FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_IN_con IN_con "Input record for function dp_roundTube_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_IN_var IN_var "Input record for function dp_roundTube_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "pressure loss" annotation (Dialog(group="Output"));

protected
  Real MIN=Modelica.Constants.eps;

  SI.ReynoldsNumber Re_Dc=max(1e-3, abs(m_flow)*IN_con.D_c/(IN_var.eta*A_c)) "Reynolds number based on fin collar diameter";
  Real f "Fanning friction faktor";
  /*SI.Velocity v_fr=m_flow/(IN_var.rho*IN_con.A_fr) "Frontal velocity";*/
  SI.Velocity v_c=m_flow/(IN_var.rho*A_c) "Velocity at minimum flow cross-sectional area";

  SI.Area A_c=IN_con.A_fr*((IN_con.F_p*IN_con.P_t - IN_con.F_p*IN_con.D_c - (
      IN_con.P_t - IN_con.D_c)*IN_con.delta_f)/(IN_con.F_p*IN_con.P_t)) "Minimum flow cross-sectional area";
  SI.Area A_tot=if IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin
       or IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin
       or IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin  then
            IN_con.A_fr*((IN_con.N*PI*IN_con.D_c*(IN_con.F_p - IN_con.delta_f)
       + 2*(IN_con.P_t*IN_con.L - IN_con.N*PI*IN_con.D_c^2/4))/(IN_con.P_t*
      IN_con.F_p)) else if IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin
                                                                                               then IN_con.A_fr*((IN_con.N*PI*
      IN_con.D_c*(IN_con.F_p - IN_con.delta_f) + 2*(IN_con.P_t*IN_con.L -
      IN_con.N*PI*IN_con.D_c^2/4)*(sqrt(IN_con.X_f^2 + IN_con.P_d^2)/IN_con.X_f))
      /(IN_con.P_t*IN_con.F_p)) else 0 "Total heat transfer area";
  SI.Area A_tube=IN_con.A_fr*IN_con.N*PI*(IN_con.D_c - 2*IN_con.delta_f)*IN_con.F_p
      /(IN_con.P_t*IN_con.F_p) "Tube surface area";
  SI.Length D_h=4*A_c*IN_con.L/A_tot "Hydraulic diameter";

  Real F1=0;
  Real F2=0;
  Real F3=0;
  Real F4=0;
  Real F5=0;
  Real F6=0;
  Real F7=0;
  Real F8=0;
  Real F9=0;

  //Documentation

algorithm
  if IN_con.geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin then
    f := 1.039*Re_Dc^(-0.418)*(IN_con.delta_f/IN_con.D_c)^(-0.104)*IN_con.N^(-0.0935)
      *(IN_con.F_p/IN_con.D_c)^(-0.197);
    DP := 4*f*IN_con.L/D_h*IN_var.rho/2*
      FluidDissipation.Utilities.Functions.General.SmoothPower(
      v_c,
      IN_con.velocity_small,
      2);

  elseif IN_con.geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin then

    if IN_con.N == 1 then
      F1 := 0.1691 + 4.4118*(IN_con.F_p/IN_con.P_l)^(-0.3)*(IN_con.L_h/IN_con.L_p)
        ^(-2)*Modelica.Math.log(IN_con.P_l/IN_con.P_t)*(IN_con.F_p/IN_con.P_t)^3;
      F2 := -2.6642 - 14.3809*(1/Modelica.Math.log(Re_Dc));
      F3 := -0.6816*Modelica.Math.log(IN_con.F_p/IN_con.P_l);
      F4 := 6.4668*(IN_con.F_p/IN_con.P_t)^1.7*Modelica.Math.log(A_tot/A_tube);
      f := 0.00317*Re_Dc^F1*(IN_con.F_p/IN_con.P_l)^F2*(D_h/IN_con.D_c)^F3*(
        IN_con.L_h/IN_con.L_p)^F4*(Modelica.Math.log(A_tot/A_tube))^(-6.0483);

    else
      F5 := 0.1395 - 0.0101*(IN_con.F_p/IN_con.P_l)^0.58*(IN_con.L_h/IN_con.L_p)
        ^(-2)*Modelica.Math.log(A_tot/A_tube)*(IN_con.P_l/IN_con.P_t)^1.9;
      F6 := -6.4367/Modelica.Math.log(max(10, Re_Dc));
      F7 := 0.07191*Modelica.Math.log(Re_Dc);
      F8 := -2.0585*(IN_con.F_p/IN_con.P_t)^1.67*Modelica.Math.log(Re_Dc);
      F9 := 0.1036*Modelica.Math.log(IN_con.P_l/IN_con.P_t);
      f := 0.06393*Re_Dc^F5*(IN_con.F_p/IN_con.D_c)^F6*(D_h/IN_con.D_c)^F7*(
        IN_con.L_h/IN_con.L_p)^F8*IN_con.N^F9*(Modelica.Math.log(max(100, Re_Dc)) - 4)^(-1.093);
    end if;

    DP := 4*f*IN_con.L/D_h*IN_var.rho/2*
      FluidDissipation.Utilities.Functions.General.SmoothPower(
      v_c,
      IN_con.velocity_small,
      2);

  elseif IN_con.geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin then

    f := 3.826*Re_Dc^(-0.5959)*(IN_con.F_p/IN_con.D_c)^(-0.2392)*(IN_con.P_l*
      IN_con.N/IN_con.D_c)^0.04879;
    DP := 4*f*IN_con.L/D_h*IN_var.rho/2*
      FluidDissipation.Utilities.Functions.General.SmoothPower(
      v_c,
      IN_con.velocity_small,
      2);

  elseif IN_con.geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin then

    f := 16.67/max(1, Modelica.Math.log(Re_Dc))^2.64*(A_tot/A_tube)^(-0.096)*IN_con.N^0.098;
    DP := 4*f*IN_con.L/D_h*IN_var.rho/2*
      FluidDissipation.Utilities.Functions.General.SmoothPower(
      v_c,
      IN_con.velocity_small,
      2);

  else

  end if;

  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    Documentation(info="<html>
<p>
Calculation of pressure loss in round tube heat exchangers with several fin geometries for incompressible and single-phase fluid flow.
</p>
 
<p>
This function can be used to calculate the pressure loss at known mass flow rate (m_flow).
</p>

<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> According to the kind of fin geometry the calculation is valid in a range of <b> Re</b> from 300 to 7500: </li>

<p>
<table>
<tr><td><b> Plain fin      </b></td><td> 800 &lt; Re_Dc &lt; 7500,</td></tr>
<tr><td><b> Louver fin     </b></td><td> 300 &lt; Re_Dc &lt; 7000,</td></tr>
<tr><td><b> Slit fin       </b></td><td> 550 &lt; Re_Dc &lt; 2000,</td></tr>
<tr><td><b> Wavy fin       </b></td><td> 350 &lt; Re_Dc &lt; 7000.</td></tr>
</table>
</p>

<br>

<li> medium = air </li>
</ul>

<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/heatExchanger/pic_roundTube.png\", width=850>
</p> 

<h4><font color=\"#EF9B13\">Calculation</font></h4>

<p>
The pressure loss <b> dp </b> for heat exchangers is determined by:
</p>

<p>
<pre>
    dp = zeta_TOT * (rho/2) * velocity_c^2 
</pre>
</p>

<p>
with
</p>
 
<p>
<table>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> velocity_c     </b></td><td> as average velocity at minimum cross-sectional area [m/s],</td></tr>
<tr><td><b> zeta_TOT       </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>

<p>
The pressure loss coefficient <b> zeta_TOT </b> for heat exchangers is determined by:
</p>

<p>
<pre>
    zeta_TOT = 4 * f * L / D_h
</pre>
</p>

<p>
<pre>
         D_h = 4 * A_c * L / A_tot 
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> A_c            </b></td><td> as minimum flow cross-sectional area [m^2],</td></tr>
<tr><td><b> A_tot          </b></td><td> as total heat transfer surface area [m^2],</td></tr>
<tr><td><b> D_h            </b></td><td> as hydraulic diameter [m],</td></tr>
<tr><td><b> f              </b></td><td> as fanning friction factor [-],</td></tr>
<tr><td><b> L              </b></td><td> as length of heat exchanger [m].</td></tr>
</table>
</p>

<p>
The calculation of the fanning friction factor <b> f </b> depends on different geometrical parameters and the Reynolds number:
</p>
<ul>
  <li> <b>Plain fin</b>:
     <p>
     <pre>
      f = f(Re_Dc, D_c, delta_f, F_p, N)
     </pre>
     </p>
  <li> <b>Louver fin</b>:
     <p>
     <pre>
      f = f(Re_Dc, A_tot, A_tube, D_c, D_h, F_p, L_h, L_p, N, P_l, P_t)
     </pre>
     </p>
  <li> <b>Slit fin</b>:
     <p>
     <pre>
      f = f(Re_Dc, D_c, F_p, N, P_l)
     </pre>
     </p>
  <li> <b>Wavy fin</b>:
     <p>
     <pre>
      f = f(Re_Dc, A_tot, A_tube, N)
     </pre>
     </p>
</ul>

<p>
with
</p>
 
<p>
<table>
<tr><td><b> A_tot                         </b></td><td> as total heat transfer surface area [m^2],</td></tr>
<tr><td><b> A_tube                        </b></td><td> as tube surface area [m^2],</td></tr>
<tr><td><b> D_c                           </b></td><td> as fin collar diameter [m],</td></tr>
<tr><td><b> D_h                           </b></td><td> as hydraulic diameter [m],</td></tr>
<tr><td><b> delta_f                       </b></td><td> as fin thickness [m],</td></tr>
<tr><td><b> F_p                           </b></td><td> as fin pitch [m],</td></tr>
<tr><td><b> L_h                           </b></td><td> as louver height [m],</td></tr>
<tr><td><b> L_p                           </b></td><td> as louver pitch [m],</td></tr>
<tr><td><b> N                             </b></td><td> as number of tube rows [-],</td></tr>
<tr><td><b> P_l                           </b></td><td> as longitudinal tube pitch [m],</td></tr>
<tr><td><b> P_t                           </b></td><td> as transverse tube pitch [m],</td></tr>
<tr><td><b> Re_Dc = rho*velocity_c*D_c/eta</b></td><td> as Reynolds number based on fin collar diameter <b> D_c </b> and average velocity <b> velocity_c </b> at minimum cross-sectional area <b> A_c </b> [-],</td></tr>
<tr><td><b> S_h                           </b></td><td> as slit height [m],</td></tr>
<tr><td><b> S_p                           </b></td><td> as slit pitch [m].</td></tr>
</table>
</p>

<p>
The minimum flow cross-sectional area <b> A_c </b> and total heat transfer surface area <b> A_tot </b> for heat exchangers are determined by:
</p>

<ul>
     <p>
     <pre>
        A_c = A_fr * (F_p * P_t - F_p * D_c - (P_t - D_c) * delta_f) / (F_p * P_t)
     </pre>
     </p>
  <li> <b>Plain fin, Louver fin and Slit fin</b>:
     <p>
     <pre>
      A_tot = A_fr * (N * PI * D_c * (F_p - delta_f) + 2 * (P_t * L - N * PI * D_c^2 / 4)) / (P_t * F_p)
     </pre>
     </p>
  <li> <b>Wavy fin</b>:
     <p>
     <pre>
      A_tot = A_fr * (N * PI * D_c * (F_p - delta_f) + 2 * (P_t * L - N * PI * D_c^2 / 4) * ((X_f^2 + P_d^2) / X_f)) / (P_t * F_p)
     </pre>
     </p>
</ul>

<p>
with
</p>

<p>
<table>
<tr><td><b> A_fr          </b></td><td> as frontal area [m^2],</td></tr>
<tr><td><b> D_c           </b></td><td> as fin collar diameter [m],</td></tr>
<tr><td><b> delta_f       </b></td><td> as fin thickness [m],</td></tr>
<tr><td><b> F_p           </b></td><td> as fin pitch [m],</td></tr>
<tr><td><b> L             </b></td><td> as length of heat exchanger [m],</td></tr>
<tr><td><b> N             </b></td><td> as number of tube rows [-],</td></tr>
<tr><td><b> P_d           </b></td><td> as pattern depth of wavy fin, wave height [m],</td></tr>
<tr><td><b> P_t           </b></td><td> as transverse tube pitch [m],</td></tr>
<tr><td><b> X_f           </b></td><td> as half wave length of wavy fin [m].</td></tr>
</table>
</p>

<h4><font color=\"#EF9B13\">Verification</font></h4>
<p>
The pressure loss coefficient (<b>zeta_TOT</b>) of round tube heat exchangers with several fin geometriess are shown in dependence of the Reynolds number (<b>Re</b>) in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/heatExchanger/fig_heatExchanger_dp_roundTube_DP.png\">
</p>

<p>
The pressure loss of round tube heat exchangers with several fin geometriess in dependence of mass flow rate is shown in the figure below.
<p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/heatExchanger/fig_heatExchanger_dp_roundTube_DPvsRe.png\">
</p> 

<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
 <dt>C.-C. Wang, Y.-J. Chang, Y.-C. Hsieh, Y.-T. Lin:</dt> 
    <dd><b>Sensible heat and friction characteristics of plate fin-and-tube heat exchangers having plane fins</b>. 
    In International Journal of Refrigeration, volume 19, No. 4, pages 223-230, 1996.</dd>
 <dt>C.-C. Wang, C.-J. Lee, C.-T. Chang, S.-P. Lin:</dt> 
    <dd><b>Heat transfer and friction correlation for compact louvered fin-and-tube heat exchangers</b>. 
    In International Journal of Heat and Mass Transfer, volume 42, pages 1945-1956, 1999.</dd>
 <dt>G.-J. Kim, A.-M. Jacobi:</dt> 
    <dd><b>Effect of Inclination on the Air-side Performance of a Brazed Aluminium Heat Exchanger Under Dry and Wet Conditions</b>. 
    In International Journal of Heat and Mass Transfer, volume 44, pages 4613-4623, 1999.</dd>
 <dt>C.-C. Wang, W.-H. Tao, C.-J. Chang:</dt> 
    <dd><b>An investigation of the airside performance of the slit fin-and-tube heat exchangers</b>. 
    In International Journal of Refrigeration, volume 22, pages 595-603, 1999.</dd>
 <dt>C.-C. Wang, W.-L. Fu, C.-T. Chang:</dt> 
    <dd><b>Heat Transfer and Friction Characteristics of Typical Wavy Fin-and-Tube Heat Exchangers</b>. 
    In Experimental Thermal and Fluid Science, volume 14, pages 174-186, 1997.</dd>
</dl>
</html>"));
end dp_roundTube_DP;
