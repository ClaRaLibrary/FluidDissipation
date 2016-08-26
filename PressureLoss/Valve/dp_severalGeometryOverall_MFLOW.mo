within FluidDissipation.PressureLoss.Valve;
function dp_severalGeometryOverall_MFLOW "Pressure loss of valve | calculate mass flow rate | several geometries | overall flow regime"
  extends Modelica.Icons.Function;
  import FD = FluidDissipation.PressureLoss.Valve;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;
  import TYP = FluidDissipation.Utilities.Types;

  //input records
  input FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_con IN_con "Input record for function dp_severalGeometryOverall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_var IN_var "Input record for function dp_severalGeometryOverall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(group="Input"));

  //output variables
  output SI.MassFlowRate M_FLOW "Mass flow rate";

  import TYP1 = FluidDissipation.Utilities.Types.ValveCoefficient;
  import TYP2 = FluidDissipation.Utilities.Types.ValveGeometry;

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area Av=if IN_con.valveCoefficient == TYP1.AV then IN_con.Av else if
      IN_con.valveCoefficient == TYP1.KV then IN_con.Kv*27.7e-6 else if IN_con.valveCoefficient
       == TYP1.CV then IN_con.Cv*24e-6 else if IN_con.valveCoefficient == TYP1.OP then
            IN_con.m_flow_nominal*(IN_var.opening/max(MIN, IN_con.opening_nominal)
      *(IN_con.rho_nominal*IN_con.dp_nominal)^0.5) else MIN "Av (metric) flow coefficient [Av]=m^2";

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
      if IN_con.geometry == TYP2.Sluice then zeta_slu else 0 "Pressure loss coefficient of chosen valve";

  Real valveCharacteristic=(2/min(IN_con.zeta_tot_max, max(MIN, max(IN_con.zeta_tot_min,
      abs(zeta_tot)))))^0.5 "Valve characteristic considering opening of chosen valve";

  //Documentation

algorithm
  M_FLOW := valveCharacteristic*Av*(IN_var.rho)^0.5*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    dp,
    IN_con.dp_small,
    0.5);
  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(dp=FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_DP(
          IN_con,
          IN_var,
          M_FLOW)),
    Documentation(info="<html>
<p>
Calculation of pressure loss for a valve with different geometries at overall flow regime for incompressible and single-phase fluid flow in dependence of its opening.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this  function is numerically best used for the <b> compressible case </b>, where the pressure loss (dp) is known (out of pressures as state variable) in the used model and the corresponding mass flow rate (M_FLOW) has to be calculated. On the other hand the  function <a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_DP\">dp_severalGeometryOverall_DP</a> is numerically best used for the <b> incompressible case </b> if the mass flow rate (m_flow) is known (as state variable) and the pressure loss (DP) has to be calculated.
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
The mass flow rate <b> m_flow </b> for valves out of pressure loss is determined by:
<p>
<pre>
    m_flow = [rho * dp * Av^2 / (zeta_tot/2]^0.5
    m_flow = (2/zeta_tot)^0.5 * Av * (rho * dp)^0.5
    m_flow = valveCharacteristic * Av * (rho * dp)^0.5
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
 
The pressure loss calculation for valves of several geometries is further documented <a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_DP\">dp_severalGeometryOverall_DP</a>.
 
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
The mass flow rate of different valves at a constant opening of 50% in dependence of pressure loss is shown in the figure below.
<p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/valve/fig_valve_dp_severalGeometryOverall_MFLOWvsDP.png\">
</p> 
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dt>Miller,D.S.:</dt>
    <dd><b>Internal flow systems</b>.
    Volume 5th of BHRA Fluid Engineering Series.BHRA Fluid Engineering, 1978.
</dl>
</html>
"));
end dp_severalGeometryOverall_MFLOW;
