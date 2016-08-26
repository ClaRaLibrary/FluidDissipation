within FluidDissipation.PressureLoss.HeatExchanger;
function dp_flatTube_DP "Air-side pressure loss of heat exchanger with flat tubes and several fin geometries | calculate DP (incompressible)"
  extends Modelica.Icons.Function;
  //SOURCE: A.M. Jacobi, Y. Park, D. Tafti, X. Zhang. AN ASSESSMENT OF THE STATE OF THE ART, AND POTENTIAL DESIGN IMPROVEMENTS, FOR FLAT-TUBE HEAT EXCHANGERS IN AIR CONDITIONING AND REFRIGERATION APPLICATIONS - PHASE I
  //Notation of equations according to SOURCE

  import FD = FluidDissipation.PressureLoss.HeatExchanger;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.HeatExchanger.dp_flatTube_IN_con IN_con "Input record for function dp_flatTube_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.HeatExchanger.dp_flatTube_IN_var IN_var "Input record for function dp_flatTube_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "pressure loss" annotation (Dialog(group="Output"));

protected
  Real MIN=Modelica.Constants.eps;

  SI.Conversions.NonSIunits.Angle_deg Phi=IN_con.Phi*180/PI;

  SI.ReynoldsNumber Re_Dh=max(1e-3, abs(m_flow)*IN_con.D_h/(IN_var.eta*A_c)) "Reynolds number based on hydraulic diameter";
  SI.ReynoldsNumber Re_Lp=max(1e-3, abs(m_flow)*IN_con.L_p/(IN_var.eta*A_c)) "Reynolds number based on louver pitch";
  Real f "Fanning friction factor";
  /*SI.Velocity v_fr=m_flow/(IN_var.rho*IN_con.A_fr) "Frontal velocity";*/
  SI.Velocity v_c=m_flow/(IN_var.rho*A_c) "Velocity at minimum flow cross-sectional area";

  SI.Area A_c=if IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin
                                                                                               then
            IN_con.A_fr*((IN_con.F_l - IN_con.delta_f)*(IN_con.F_p - IN_con.delta_f)
      /((IN_con.F_l + IN_con.D_m)*IN_con.F_p)) else if IN_con.geometry ==
      FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
            IN_con.A_fr*(h*s/((h + t + IN_con.D_m)*(s + t))) else 0 "Minimum flow cross-sectional area";
  SI.Length D_h=if IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin
                                                                                               then
            4*A_c/(IN_con.A_fr*(2*(IN_con.F_p - IN_con.delta_f + IN_con.F_l -
      IN_con.delta_f)/(IN_con.F_p*(IN_con.F_l + IN_con.D_m)))) else 0 "Hydraulic diameter";
  SI.Length h=if IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin
                                                                                               then
            IN_con.D_h*(1 + IN_con.alpha)/(2*IN_con.alpha) else 0 "Free flow height";
  SI.Length l=if IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin
                                                                                               then
            t/IN_con.delta else 0 "Fin length";
  SI.Length s=if IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin
                                                                                               then
            h*IN_con.alpha else 0 "Lateral fin spacing (free flow width)";
  SI.Length t=if IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin
                                                                                               then
            s*IN_con.gamma else 0 "Fin thickness";
  SI.Length T_h=if IN_con.geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin
                                                                                               then
            IN_con.T_p - IN_con.D_m else 0;

  Real f1a=0;
  Real f1b=0;
  Real f2a=0;
  Real f2b=0;
  Real f3a=0;
  Real f3b=0;

  //Documentation

algorithm
  if IN_con.geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then

    if Re_Lp < 140 then
      f1a := 14.39*Re_Lp^(-0.805*IN_con.F_p/IN_con.F_l)*(Modelica.Math.log(1 + (IN_con.F_p/
        IN_con.L_p)))^3.04;
      f2a := (Modelica.Math.log((IN_con.delta_f/IN_con.F_p)^0.48 + 0.9))^(-1.435)*(D_h/IN_con.L_p)
        ^(-3.01)*(Modelica.Math.log(0.5*max(10, Re_Lp)))^(-3.01);
      f3a := (IN_con.F_p/IN_con.L_l)^(-0.308)*(IN_con.F_d/IN_con.L_l)^(-0.308)*
        (exp(-0.1167*IN_con.T_p/IN_con.D_m))*Phi^0.35;
      f := f1a*f2a*f3a;

    elseif Re_Lp > 160 then
      f1b := 4.97*Re_Lp^(0.6049 - 1.064/Phi^0.2)*(Modelica.Math.log((IN_con.delta_f/IN_con.F_p)
        ^0.5 + 0.9))^(-0.527);
      f2b := ((D_h/IN_con.L_p)*Modelica.Math.log(0.3*Re_Lp))^(-2.966)*(IN_con.F_p/IN_con.L_l)^
        (-0.7931*IN_con.T_p/T_h);
      f3b := (IN_con.T_p/IN_con.D_m)^(-0.0446)*Modelica.Math.log(1.2 + (IN_con.L_p/IN_con.F_p)
        ^1.4)^(-3.553)*Phi^(-0.477);
      f := f1b*f2b*f3b;

    else
      f1a := 14.39*Re_Lp^(-0.805*IN_con.F_p/IN_con.F_l)*(Modelica.Math.log(1 + (IN_con.F_p/
        IN_con.L_p)))^3.04;
      f2a := (Modelica.Math.log((IN_con.delta_f/IN_con.F_p)^0.48 + 0.9))^(-1.435)*(D_h/IN_con.L_p)
        ^(-3.01)*(Modelica.Math.log(0.5*Re_Lp))^(-3.01);
      f3a := (IN_con.F_p/IN_con.L_l)^(-0.308)*(IN_con.F_d/IN_con.L_l)^(-0.308)*
        (exp(-0.1167*IN_con.T_p/IN_con.D_m))*Phi^0.35;
      f1b := 4.97*Re_Lp^(0.6049 - 1.064/Phi^0.2)*(Modelica.Math.log((IN_con.delta_f/IN_con.F_p)
        ^0.5 + 0.9))^(-0.527);
      f2b := ((D_h/IN_con.L_p)*Modelica.Math.log(0.3*Re_Lp))^(-2.966)*(IN_con.F_p/IN_con.L_l)^
        (-0.7931*IN_con.T_p/T_h);
      f3b := (IN_con.T_p/IN_con.D_m)^(-0.0446)*Modelica.Math.log(1.2 + (IN_con.L_p/IN_con.F_p)
        ^1.4)^(-3.553)*Phi^(-0.477);
      f := SMOOTH(
        140,
        160,
        Re_Lp)*f1a*f2a*f3a + SMOOTH(
        160,
        140,
        Re_Lp)*f1b*f2b*f3b;

    end if;

    DP := 4*f*IN_con.L/D_h*IN_var.rho/2*
      FluidDissipation.Utilities.Functions.General.SmoothPower(
      v_c,
      IN_con.velocity_small,
      2);

  elseif IN_con.geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then

    f := 9.6243*Re_Dh^(-0.7422)*IN_con.alpha^(-0.1856)*IN_con.delta^0.3053*
      IN_con.gamma^(-0.2659)*(1 + 7.669E-8*Re_Dh^4.429*IN_con.alpha^0.920*
      IN_con.delta^3.767*IN_con.gamma^0.236)^0.1;
    DP := 4*f*IN_con.L/IN_con.D_h*IN_var.rho/2*
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
Calculation of pressure loss in flat tube heat exchangers with several fin geometries for incompressible and single-phase fluid flow.
</p>
 
<p>
This function can be used to calculate the pressure loss at known mass flow rate (m_flow).
</p>

<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> According to the kind of fin geometry the calculation is valid in a range of <b> Re</b> from 100 to 5000. </li>

<p>
<table>
<tr><td><b> Louver fin     </b></td><td> 100 &lt; Re_Lp &lt; 3000,</td></tr>
<tr><td><b> Rectangular offset strip fin </b></td><td> 300 &lt; Re_Dh &lt; 5000.</td></tr>
</table>
</p>

<br>

<li> medium = air </li>
</ul>

<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/heatExchanger/pic_flatTube.png\", width=850>
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
  <li> <b>Louver fin</b>:
     <p>
     <pre>
      f = f(Re_Lp, D_m, delta_f, F_d, F_l, F_p, L_l, L_p, Phi, T_p)
     </pre>
     </p>
  <li> <b>Rectangular offset strip fin</b>:
     <p>
     <pre>
      f = f(Re_Dh, alpha, delta, gamma)
     </pre>
     </p>
</ul>

<p>
with
</p>
 
<p>
<table>
<tr><td><b> alpha                         </b></td><td> as fraction of lateral fin spacing <b> s </b> and free flow height <b> h </b> [-],</td></tr>
<tr><td><b> D_h                           </b></td><td> as hydraulic diameter [m],</td></tr>
<tr><td><b> D_m                           </b></td><td> as major tube diameter of flat tube [m],</td></tr>
<tr><td><b> delta                         </b></td><td> as fraction of fin thickness <b> t </b> and fin length <b> l </b> [-],</td></tr>
<tr><td><b> delta_f                       </b></td><td> as fin thickness [m],</td></tr>
<tr><td><b> F_d                           </b></td><td> as flow depth [m],</td></tr>
<tr><td><b> F_l                           </b></td><td> as fin length [m],</td></tr>
<tr><td><b> F_p                           </b></td><td> as fin pitch [m],</td></tr>
<tr><td><b> gamma                         </b></td><td> as fraction of fin thickness <b> t </b> and lateral fin spacing <b> s </b> [-],</td></tr>
<tr><td><b> L                             </b></td><td> as length of heat exchanger [m],</td></tr>
<tr><td><b> L_l                           </b></td><td> as louver length [m],</td></tr>
<tr><td><b> L_p                           </b></td><td> as louver pitch [m],</td></tr>
<tr><td><b> Phi                           </b></td><td> as louver angle [grad],</td></tr>
<tr><td><b> T_p                           </b></td><td> as tube pitch [m],</td></tr>
<tr><td><b> Re_Dh = rho*velocity_c*D_h/eta</b></td><td> as Reynolds number based on hydraulic diameter <b> D_h </b> and average velocity <b> velocity_c </b> at minimum cross-sectional area <b> A_c </b> [-],</td></tr>
<tr><td><b> Re_Lp = rho*velocity_c*L_p/eta</b></td><td> as Reynolds number based on louver pitch <b> L_p </b> and average velocity <b> velocity_c </b> at minimum cross-sectional area <b> A_c </b> [-].</td></tr>
</table>
</p>

<p>
The minimum flow cross-sectional area <b> A_c </b> and total heat transfer surface area <b> A_tot </b> for heat exchangers are determined by:
</p>
<ul>
  <li> <b>Louver fin</b>:
     <p>
     <pre>
      A_c = A_fr * (F_l - delta_f ) * (F_p - delta_f) / ((F_l + D_m) * F_p)
     </pre>
     </p>
     <p>
     <pre>
      A_tot = A_fr * 2 * (F_l + F_p - delta_f) / (F_p * (F_l + D_m)) * L
     </pre>
     </p>
  <li> <b>Rectangular offset strip fin</b>:
     <p>
     <pre>
      A_c = A_fr * h * s / ((h + t + D_m) * (s +t ))
     </pre>
     </p>
     <p>
     <pre>
      A_tot = A_fr * 2 * (h + s) / ((s + t) * (h + t + D_m)) * L
     </pre>
     </p>
</ul>

<p>
with
</p>

<p>
<table>
<tr><td><b> A_fr          </b></td><td> as frontal area [m^2],</td></tr>
<tr><td><b> D_m           </b></td><td> as major tube diameter of flat tube [m],</td></tr>
<tr><td><b> delta_f       </b></td><td> as fin thickness [m],</td></tr>
<tr><td><b> F_l           </b></td><td> as fin length [m],</td></tr>
<tr><td><b> F_p           </b></td><td> as fin pitch [m],</td></tr>
<tr><td><b> L             </b></td><td> as length of heat exchanger [m],</td></tr>
<tr><td><b> l             </b></td><td> as fin length of rectangular offset strip fin [m],</td></tr>
<tr><td><b> s             </b></td><td> as lateral fin spacing of rectangular offset strip fin [m],</td></tr>
<tr><td><b> t             </b></td><td> as fin thickness of rectangular offset strip fin [m].</td></tr>
</table>
</p>

<h4><font color=\"#EF9B13\">Verification</font></h4>
<p>
The pressure loss coefficient (<b>zeta_TOT</b>) of flat tube heat exchangers with several fin geometriess are shown in dependence of the Reynolds number (<b>Re</b>) in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/heatExchanger/fig_heatExchanger_dp_flatTube_DP.png\">
</p>

<p>
The pressure loss of flat tube heat exchangers with several fin geometriess in dependence of mass flow rate is shown in the figure below.
<p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/heatExchanger/fig_heatExchanger_dp_flatTube_DPvsRe.png\">
</p> 

<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
 <dt>Y.-J. CHANG, Kuei-Chang Hsu, Yur-Tsai Lin, C.-C. WANG:</dt> 
    <dd><b>A generalized friction correlation for louver fin geometry</b>. 
    In International Journal of Heat and Mass Transfer, volume 43, pages 2237-2243, 2000.</dd>
 <dt>Y.-J. CHANG and C.-C. WANG:</dt> 
    <dd><b>Air Side Performance of Brazed Aluminium Heat Exchangers</b>. 
    In Journal of Enhanced Heat Transfer, volume 3, No. 1,  pages 15-28, 1996.</dd>
 <dt>R.-M. Manglik, A.-E. Bergles:</dt> 
    <dd><b>Heat Transfer and Pressure Drop Correlations for the Rectangular Offset Strip Fin Compact Heat Exchanger</b>. 
    In Experimental Thermal and Fluid Science, volume 10, pages 171-180, 1995.</dd>
</dl>

</html>"));
end dp_flatTube_DP;
