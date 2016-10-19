within FluidDissipation.PressureLoss.Valve;
function dp_severalGeometryOverall_DP
  "Pressure loss of valve | calculate pressure loss | several geometries | overall flow regime"
  extends Modelica.Icons.Function;
  import FD = FluidDissipation.PressureLoss.Valve;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;
  import TYP = FluidDissipation.Utilities.Types;

  //input records
  input FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_con IN_con
    "Input record for function dp_severalGeometryOverall_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_var IN_var
    "Input record for function dp_severalGeometryOverall_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "Pressure loss";

  import TYP1 = FluidDissipation.Utilities.Types.ValveCoefficient;
  import TYP2 = FluidDissipation.Utilities.Types.ValveGeometry;

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area Av=if IN_con.valveCoefficient == TYP1.AV then IN_con.Av else if
      IN_con.valveCoefficient == TYP1.KV then IN_con.Kv*27.7e-6 else if IN_con.valveCoefficient
       == TYP1.CV then IN_con.Cv*24e-6 else if IN_con.valveCoefficient == TYP1.OP then
            IN_con.m_flow_nominal*(IN_var.opening/max(MIN, IN_con.opening_nominal)
      *(IN_con.rho_nominal*IN_con.dp_nominal)^0.5) else MIN
    "Av (metric) flow coefficient [Av]=m^2";

  TYP.PressureLossCoefficient zeta_bal=SMOOTH(
      0.05,
      0,
      IN_var.opening)*10^(-3.8397*IN_var.opening + 2.9449) + SMOOTH(
      0,
      0.05,
      IN_var.opening)*IN_con.zeta_tot_max "Ball valves";
  TYP.PressureLossCoefficient zeta_dia=SMOOTH(
      0.05,
      0,
      IN_var.opening)*10^(2.2596*exp(-1.8816*IN_var.opening)) + SMOOTH(
      0,
      0.05,
      IN_var.opening)*IN_con.zeta_tot_max "Diaphragm valves";
  TYP.PressureLossCoefficient zeta_but=SMOOTH(
      0.05,
      0,
      IN_var.opening)*619.81*exp(-7.3211*IN_var.opening) + SMOOTH(
      0,
      0.05,
      IN_var.opening)*IN_con.zeta_tot_max "Butterfly valves";
  TYP.PressureLossCoefficient zeta_gat=SMOOTH(
      0.05,
      0,
      IN_var.opening)*51.45*exp(-6.046*IN_var.opening) + SMOOTH(
      0,
      0.05,
      IN_var.opening)*IN_con.zeta_tot_max "Gate valves";
  TYP.PressureLossCoefficient zeta_slu=SMOOTH(
      0.05,
      0,
      IN_var.opening)*248.89*exp(-7.8265*IN_var.opening) + SMOOTH(
      0,
      0.05,
      IN_var.opening)*IN_con.zeta_tot_max "Sluice valves";

  TYP.PressureLossCoefficient zeta_tot=if IN_con.valveCoefficient == TYP1.OP then
            2 else if IN_con.geometry == TYP2.Ball then zeta_bal else if IN_con.geometry
       == TYP2.Diaphragm then zeta_dia else if IN_con.geometry == TYP2.Butterfly then
            zeta_but else if IN_con.geometry == TYP2.Gate then zeta_gat else
      if IN_con.geometry == TYP2.Sluice then zeta_slu else 0
    "Pressure loss coefficient of chosen valve";

  Real valveCharacteristic=(2/min(IN_con.zeta_tot_max, max(MIN, max(IN_con.zeta_tot_min,
      abs(zeta_tot)))))^0.5
    "Valve characteristic considering opening of chosen valve";

  SI.MassFlowRate m_flow_small=valveCharacteristic*Av*(IN_var.rho)^0.5*(IN_con.dp_small)
      ^0.5 "Mass flow rate at linearisation";

  //Documentation

algorithm
  DP := 1/((valveCharacteristic*Av)^2*IN_var.rho)*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    m_flow,
    m_flow_small,
    2);

  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(m_flow=FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_MFLOW(
          IN_con,
          IN_var,
          DP)),
    Documentation(info="<html>
<p>
Calculation of pressure loss for a valve with different geometries at overall flow regime for incompressible and single-phase fluid flow in dependence of its opening.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this function is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. On the other hand the function <a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_MFLOW\">dp_severalGeometryOverall_MFLOW</a> is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> developed fluid flow </b>
 </li>
 <li>
      <b> ball valve </b>
 </li>
 <li>
      <b> diaphragm valve </b>
 </li>
 <li>
      <b> butterfly valve </b>
 </li>
 <li>
      <b> gate valve </b>
 </li>
 <li>
      <b> sluice valve </b>
 </li>
</ul>
 
<p> 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
</p>
Wide variations in valve geometry are possible and a manufacturer will not necessarily maintain geometric similarity between valves of the same type but of different size. Here pressure loss can be estimated for the following types of a valve:
<ul>
 <li>
      <b> ball valve </b>
 </li>
 <li>
      <b> diaphragm valve </b>
 </li>
 <li>
      <b> butterfly valve </b>
 </li>
 <li>
      <b> gate valve </b>
 </li>
 <li>
      <b> sluice valve </b>
 </li>
</ul> 
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss <b> dp </b> for valves is determined by:
<p>
<pre>
    dp = (zeta_tot/2) * rho * velocity^2
    dp = 1/(valveCharacteristic^2)* rho * velocity^2
    dp = 1/(valveCharacteristic^2 * Av^2 * rho) *(m_flow)^2 
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> rho                        </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> Av                         </b></td><td> as (metric) flow coefficient (cross sectional area) [m^2],</td></tr>
<tr><td><b> m_flow                     </b></td><td> as mass flow rate [kg/s],</td></tr>
<tr><td><b> valveCharacteristic        </b></td><td> as coefficient of a valve in dependence of its opening [-],</td></tr>
<tr><td><b> velocity                   </b></td><td> as mean velocity [m/s],</td></tr>
<tr><td><b> zeta_tot                   </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>
 
<p>
The <b>valveCharacteristic</b> is determined out of a correlation for the pressure loss coefficient (<b>zeta_tot</b>) in dependence of its opening. The reason for introducing an additional variable 
<b>valveCharacteristic</b> is a different definition of the following pressure loss correlations of valves.
</p>
 
<ul>
  <li> Using coefficient Av with [Av]=m^2 and [V_flow]=m^3/s, [dp]=Pa:
     <br>
     <pre>
      V_flow = Av * (dp/rho)^0.5
     </pre>
  <li> Using coefficient Kv with [Kv]=m^3/(h*bar^0.5) and [V_flow]=m^3/h, [dp]=bar :
     <br>
     <pre>
      V_flow = Kv * [dp/(rho/rho0)]^0.5
     </pre>
  <li> Using coefficient Cv with [Cv]=USG/(min*psi^0.5) and [V_flow]=USG/min, [dp]=psi :
     <br>
     <pre>
      V_flow = Cv * [dp/(rho/rho0)]^0.5
     </pre>
</ul>
The different flow coefficients <b>Kv and Cv</b> are often given in manufacturer data instead of <b>Av</b> to describe pressure loss of valves. Here a geometry of a valve can be chosen and the specific manufacturer data for the flow coefficients can be used. Then values for given <b>Kv and Cv</b> are converted into <b>Av</b> used in pressure loss calculation 
(see <a href=\"Modelica://Modelica_Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">Users Guide</a> for detailed discussion).
 
The pressure loss coefficient (<b>zeta_tot</b>) for several geometries of valves is calculated according to <i>[Miller 1978, sec. 14.6, p. 270ff]</i> : 
<ul>
  <li> <b>Ball valve</b>:
     <br>
     <pre>
      zeta_tot = 10^(-3.8397 * opening + 2.9449) 
     </pre>
  <li> <b>Diaphragm valve</b>
      <br>
     <pre>
      zeta_tot = 10^[2.2596*exp(-1.8816 * opening)]  
     </pre>
 <li> <b>Butterfly valve</b>
      <br>
     <pre>
     zeta_tot = 619.81*exp(-7.3211*opening) 
     </pre>
 <li> <b>Gate valve</b>
      <br>
     <pre>
     zeta_tot = 51.45*exp(-6.046*opening) 
     </pre>
 <li> <b>Sluice valve</b>
      <br>
     <pre>
     zeta_tot = 248.89*exp(-7.8265*opening)
     </pre>
</ul>
<p>
with
</p>
<p>
<table>
<tr><td><b> opening       </b></td><td> as amount of opening of a valve from 0% to 100% [-],</td></tr>
<tr><td><b> zeta_tot      </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>
 
<p>
Note that the pressure loss coefficients for an overall fluid flow are obtained out of the turbulent regime.
</p> 
 
<h4><font color=\"#EF9B13\">Verification</font></h4>      
<p>
The pressure loss coefficient (<b>zeta_tot</b>) of a valve with different geometries are shown in dependence of the <b>opening</b> in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/valve/fig_valve_dp_severalGeometryOverall_zetaVsOpening.png\">
</p>
<p> 
Note that the pressure loss coefficients (<b>zeta_tot</b>) are numerically optimised for very small openings (opening &le; 5%). At openings smaller than 5% the pressure loss coefficient is smoothly set 
to a maximum value (<b>zeta_tot_max</b>) to be adjusted as parameter. Therefore a very small leakage mass flow rate can be adjusted for a given pressure difference at almost closed valves. A very small
leakage mass flow rate can often be neglected in system simulation with valves, whereas the numerical behaviour of the simulation is improved.
</p>
<p>
The pressure loss of different valves at a constant opening of 50% in dependence of mass flow rate is shown in the figure below.
<p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/valve/fig_valve_dp_severalGeometryOverall_DPvsMFLOW.png\">
</p> 
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dt>Miller,D.S.:</dt>
    <dd><b>Internal flow systems</b>.
    Volume 5th of BHRA Fluid Engineering Series.BHRA Fluid Engineering, 1978.
</dl>
</html>
"));
end dp_severalGeometryOverall_DP;
