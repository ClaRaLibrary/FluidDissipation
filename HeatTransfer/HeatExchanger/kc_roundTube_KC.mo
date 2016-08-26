within FluidDissipation.HeatTransfer.HeatExchanger;
function kc_roundTube_KC
  extends Modelica.Icons.Function;
  //SOURCE: A.M. Jacobi, Y. Park, D. Tafti, X. Zhang. AN ASSESSMENT OF THE STATE OF THE ART, AND POTENTIAL DESIGN IMPROVEMENTS, FOR FLAT-TUBE HEAT EXCHANGERS IN AIR CONDITIONING AND REFRIGERATION APPLICATIONS - PHASE I

  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_con IN_con "Input record for function kc_roundTube_KC";
  input FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_var IN_var "Input record for function kc_roundTube_KC";

  //output variables
  output SI.CoefficientOfHeatTransfer kc "Output for function kc_roundTube_KC";

protected
  type TYP =
      Modelica.Fluid.Dissipation.Utilities.Types.HTXGeometry_roundTubes;

  Real MIN=Modelica.Constants.eps "Limiter";

  SI.ReynoldsNumber Re_Dc=max(MIN, (abs(IN_var.m_flow)*IN_con.D_c/(IN_var.eta*
      A_c))) "Reynolds number based on fin collar diameter";

  SI.ReynoldsNumber Re_i "Reynolds number at transition to linerized calculation for wavy fins";

  SI.PrandtlNumber Pr=IN_var.eta*IN_var.cp/IN_var.lambda "Prandtl number";
  Real j "Colburn j faktor";

  SI.Area A_c=IN_con.A_fr*((IN_con.F_p*IN_con.P_t - IN_con.F_p*IN_con.D_c - (
      IN_con.P_t - IN_con.D_c)*IN_con.delta_f)/(IN_con.F_p*IN_con.P_t)) "Minimum flow cross-sectional area";
  SI.Area A_tot=if IN_con.geometry == TYP.LouverFin then IN_con.A_fr*((IN_con.N
      *PI*IN_con.D_c*(IN_con.F_p - IN_con.delta_f) + 2*(IN_con.P_t*IN_con.L -
      IN_con.N*PI*IN_con.D_c^2/4))/(IN_con.P_t*IN_con.F_p)) else 0 "Total heat transfer area";
  SI.Length D_h=if IN_con.geometry == TYP.LouverFin then 4*A_c*IN_con.L/A_tot else
            0 "Hydraulic diameter";

  Real J1=0 "Exponent for computation of Colburn j faktor";
  Real J2=0 "Exponent for computation of Colburn j faktor";
  Real J3=0 "Exponent for computation of Colburn j faktor";
  Real J4=0 "Exponent for computation of Colburn j faktor";
  Real J5=0 "Exponent for computation of Colburn j faktor";
  Real J6=0 "Exponent for computation of Colburn j faktor";
  Real J7=0 "Exponent for computation of Colburn j faktor";
  Real J8=0 "Exponent for computation of Colburn j faktor";

algorithm
  if IN_con.geometry == TYP.PlainFin then
    j := 0.991*(2.24*Re_Dc^(-0.092)*(IN_con.N/4)^(-0.031))^(0.607*(4 - IN_con.N))
      *(0.14*Re_Dc^(-0.328)*(IN_con.P_t/IN_con.P_l)^(-0.502)*(IN_con.F_p/IN_con.D_c)
      ^(0.0312))*(2.55*(IN_con.P_l/IN_con.D_c)^(-1.28));
    kc := j*(Re_Dc*Pr^(1/3)*IN_var.lambda/IN_con.D_c);

  elseif IN_con.geometry == TYP.LouverFin then
    if Re_Dc < 900 then
      J1 := -0.991 - 0.1055*(IN_con.P_l/IN_con.P_t)^3.1*Modelica.Math.log(IN_con.L_h/IN_con.L_p);
      J2 := -0.7344 + 2.1059*IN_con.N^0.55/(Modelica.Math.log(Re_Dc) - 3.2);
      J3 := 0.08485*(IN_con.P_l/IN_con.P_t)^(-4.4)*IN_con.N^(-0.68);
      J4 := -0.1741*Modelica.Math.log(IN_con.N);
      j := 14.3117*Re_Dc^J1*(IN_con.F_p/IN_con.D_c)^J2*(IN_con.L_h/IN_con.L_p)^
        J3*(IN_con.F_p/IN_con.P_l)^J4*(IN_con.P_l/IN_con.P_t)^(-1.724);
    elseif Re_Dc > 1100 then
      J5 := -0.6027 + 0.02593*(IN_con.P_l/D_h)^0.52*IN_con.N^(-0.5)*Modelica.Math.log(IN_con.L_h
        /IN_con.L_p);
      J6 := -0.4776 + 0.40774*IN_con.N^0.7/(Modelica.Math.log(Re_Dc) - 4.4);
      J7 := -0.58655*(IN_con.F_p/D_h)^2.3*(IN_con.P_l/IN_con.P_t)^(-1.6)*IN_con.N
        ^(-0.65);
      J8 := 0.0814*(Modelica.Math.log(Re_Dc) - 3);
      j := 1.1373*Re_Dc^J5*(IN_con.F_p/IN_con.P_l)^J6*(IN_con.L_h/IN_con.L_p)^
        J7*(IN_con.P_l/IN_con.P_t)^J8*IN_con.N^0.3545;
    else
      J1 := -0.991 - 0.1055*(IN_con.P_l/IN_con.P_t)^3.1*Modelica.Math.log(IN_con.L_h/IN_con.L_p);
      J2 := -0.7344 + 2.1059*IN_con.N^0.55/(Modelica.Math.log(Re_Dc) - 3.2);
      J3 := 0.08485*(IN_con.P_l/IN_con.P_t)^(-4.4)*IN_con.N^(-0.68);
      J4 := -0.1741*Modelica.Math.log(IN_con.N);
      J5 := -0.6027 + 0.02593*(IN_con.P_l/D_h)^0.52*IN_con.N^(-0.5)*Modelica.Math.log(IN_con.L_h
        /IN_con.L_p);
      J6 := -0.4776 + 0.40774*IN_con.N^0.7/(Modelica.Math.log(Re_Dc) - 4.4);
      J7 := -0.58655*(IN_con.F_p/D_h)^2.3*(IN_con.P_l/IN_con.P_t)^(-1.6)*IN_con.N
        ^(-0.65);
      J8 := 0.0814*(Modelica.Math.log(Re_Dc) - 3);
      j := SMOOTH(
        900,
        1100,
        Re_Dc)*(14.3117*Re_Dc^J1*(IN_con.F_p/IN_con.D_c)^J2*(IN_con.L_h/IN_con.L_p)
        ^J3*(IN_con.F_p/IN_con.P_l)^J4*(IN_con.P_l/IN_con.P_t)^(-1.724)) +
        SMOOTH(
        1100,
        900,
        Re_Dc)*(1.1373*Re_Dc^J5*(IN_con.F_p/IN_con.P_l)^J6*(IN_con.L_h/IN_con.L_p)
        ^J7*(IN_con.P_l/IN_con.P_t)^J8*IN_con.N^0.3545);
    end if;
    kc := SMOOTH(
      100,
      0,
      Re_Dc)*j*(Re_Dc*Pr^(1/3)*IN_var.lambda/IN_con.D_c);

  elseif IN_con.geometry == TYP.SlitFin then
    J1 := -0.674 + 0.1316*IN_con.N/Modelica.Math.log(Re_Dc) - 0.3769*IN_con.F_p/IN_con.D_c -
      1.8857*IN_con.N/Re_Dc;
    J2 := -0.0178 + 0.996*IN_con.N/Modelica.Math.log(Re_Dc) + 26.7*IN_con.N/Re_Dc;
    J3 := 1.865 + 1244.03*IN_con.F_p/(Re_Dc*IN_con.D_c) - 14.37/Modelica.Math.log(Re_Dc);
    j := 1.6409*Re_Dc^J1*(IN_con.S_p/IN_con.S_h)^1.16*(IN_con.P_t/IN_con.P_l)^
      1.37*(IN_con.F_p/IN_con.D_c)^J2*IN_con.N^J3;
    kc := j*(Re_Dc*Pr^(1/3)*IN_var.lambda/IN_con.D_c);

  elseif IN_con.geometry == TYP.WavyFin then
    Re_i := 2*exp(2.921)^(1/(A_c/IN_con.A_fr)); // 2 * turning point of the not linearized kc calculation
    if Re_Dc > Re_i then
      // original calculation
      j := 1.201/((Modelica.Math.log(Re_Dc^(A_c/IN_con.A_fr)))^2.921);
    else
      // linearized calculation to avoid increasing of kc for low Reynolds numbers and division by zero for Re = 1
      j := (Re_Dc-Re_i)*(-1.201*2.921*(A_c/IN_con.A_fr)/((Modelica.Math.log(Re_i^(A_c/IN_con.A_fr)))^3.921*Re_i)) + 1.201/((Modelica.Math.log(Re_i^(A_c/IN_con.A_fr)))^2.921);
    end if;
    kc := j*(Re_Dc*Pr^(1/3)*IN_var.lambda/IN_con.D_c);

  else

  end if;

  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
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
The mean Nusselt number <b> Nu </b> representing the mean convective heat transfer coefficient <b> kc </b> for the plain and wavy fin heat exchanger is shown in the figure below. Here the figures are calculated for an (unintended) inverse calculation, where an unknown mass flow rate is calculated out of a given mean convective heat transfer coefficient <b> kc </b>. The calculation for the louver and slit fin are too complex for inverting.  
</p>

<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/heatExchanger/fig_roundTube_kc_KC.png\">
</p>

<p>
Note that the verification for <a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube\"> kc_roundTube </a> is also valid for this inverse calculation due to using the same functions. 
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
<p>2016-04-12 Sven Rutkowski: Removed singularity for Re at zero mass flow rate thorugh linerized function in wavy fin correlation.</p>
</html>"));
end kc_roundTube_KC;
