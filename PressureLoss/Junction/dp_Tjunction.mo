within FluidDissipation.PressureLoss.Junction;
function dp_Tjunction "pressure loss of general T-junction"
  extends Modelica.Icons.Function;

  import FD = FluidDissipation.PressureLoss.Junction;
  import SI = Modelica.SIunits;
  import PI = Modelica.Constants.pi;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //records
  input FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_con IN_con
    "input record for function dp_Tjunction"
    annotation (Placement(transformation(extent={{-100,12},{-80,32}})));

  input FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_var IN_var
    "input record for function dp_Tjunction"
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));

  input SI.MassFlowRate m_flow[3]
    "mass flow rate in passages [left,right,bottom] | (pos == flow into component)"
    annotation (Dialog(group="Input"));
  /*input SI.Pressure p_junction[4] 
    "pressures at ports of junction [left,right,bottom,internal]" 
    annotation (Dialog(group="Input"));*/

  //output variables
  output SI.Pressure DP[3]
    "(thermodynamic) pressure loss [left-internal,internal-right,internal-bottom]"
    annotation (Dialog(group="Output"));

  output SI.MassFlowRate M_FLOW[ 3] "mass flow rate [side,straight,total]"
    annotation (Dialog(group="Output"));

  output TYP.LocalResistanceCoefficient zeta_LOC[2]
    "local resistance coefficient [side,straight]"
    annotation (Dialog(group="Output"));

  output Real cases[6]
    "fluid flow situation at Tjunction according to online documentation"
    annotation (Dialog(group="Output"));

  output Real failureStatus
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

  /*output SI.Velocity velocity[3] 
    "average fluid flow velocity [side,straight,total]";
  annotation (Dialog(group="Output"));*/

protected
  parameter Integer I[3, 3]=identity(3)
    "identity matrix for mass flow rate order operation";

  /*parameter Boolean caseRequest=IN_con.caseRequest 
    "true == case request depending on mass flow rates at ports (exact) | false == driving pressure difference (fast)";*/

  parameter SI.Pressure dp_min=IN_con.dp_min
    "restriction for smoothing while changing of fluid flow situation";

  //estimate fluid flow situation
  /*Real dp_i[3]={p_junction[1] - p_junction[4],p_junction[4] - p_junction[
      2],p_junction[4] - p_junction[3]} 
    "driving pressure difference at junction [left-internal,internal-right,internal-bottom]";*/

  /*Real joint=if caseRequest then if integer(sign(m_flow[1]) + sign(m_flow[
      2]) + sign(m_flow[3])) > 0 then 1 else 0 else if integer(sign(
      dp_i[1]) + sign(-dp_i[2]) + sign(-dp_i[3])) > 0 then 1 else 0 
    "fluid flow situation | 1 == joint";*/

  Real joint=if
    IN_con.flowSituation ==FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left then  1 else if
    IN_con.flowSituation ==FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right then  1 else if
    IN_con.flowSituation ==FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric
                                                                                               then  1 else 0
    "fluid flow situation | 1 == joint";

  /*Real case_1=if caseRequest then if integer(abs(sign(m_flow[1]) -
      sign(m_flow[2]) - sign(m_flow[3]))) > 2 then 1 else 0 else 
      if integer(abs(sign(dp_i[1]) - sign(-dp_i[2]) - sign(-dp_i[3]))) >
      2 then 1 else 0 "fluid flow situation | 1 == case_1";
  Real case_2=if caseRequest then if integer(abs(sign(m_flow[2]) -
      sign(m_flow[1]) - sign(m_flow[3]))) > 2 then 1 else 0 else 
      if integer(abs(sign(-dp_i[2]) - sign(dp_i[1]) - sign(-dp_i[3]))) >
      2 then 1 else 0 "fluid flow situation | 1 == case_2";
  Real case_3=if caseRequest then if integer(abs(sign(m_flow[3]) -
      sign(m_flow[1]) - sign(m_flow[2]))) > 2 then 1 else 0 else 
      if integer(abs(sign(-dp_i[3]) - sign(dp_i[1]) - sign(-dp_i[2]))) >
      2 then 1 else 0 "fluid flow situation | 1 == case_3";
  Real noflow=if caseRequest then if integer(abs(sign(m_flow[3]) +
      sign(m_flow[1]) + sign(m_flow[2]))) > 2 then 1 else 0 else 
      if integer(abs(sign(-dp_i[3]) + sign(dp_i[1]) + sign(-dp_i[2]))) >
      2 then 1 else 0 "fluid flow situation | 1 == noflow";*/

  Real case_1=if
    IN_con.flowSituation ==FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left or
    IN_con.flowSituation ==FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left then  1 else 0
    "fluid flow situation | 1 == case_1";
  Real case_2=if
    IN_con.flowSituation ==FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right or
    IN_con.flowSituation ==FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right then  1 else 0
    "fluid flow situation | 1 == case_2";
  Real case_3=if
    IN_con.flowSituation ==FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric
                                                                                               or
    IN_con.flowSituation ==FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric
                                                                                               then  1 else 0
    "fluid flow situation | 1 == case_3";

  //mass flow rate order operation
  /*Real order[3, 3]=if integer(case_1) == 1 then I else if integer(case_2)
       == 1 then {I[2, :],I[1, :],I[3, :]} else if integer(case_3) == 1 then 
            {I[3, :],I[1, :],I[2, :]} else if sign(m_flow[1]) == 0 then 
            {I[2, :],I[1, :],I[3, :]} else I "mass flow rate order operation";*/

  Real order[3, 3]=if integer(case_1) == 1 then I else if integer(case_2)
       == 1 then {I[2, :],I[1, :],I[3, :]} else if integer(case_3) == 1 then
            {I[3, :],I[2, :],I[1, :]} else if sign(m_flow[1]) == 0 then
            {I[2, :],I[1, :],I[3, :]} else I "mass flow rate order operation";

  //convert mass flow rates from fixed geometry [left,right,bottom] to general fluid flow situation [total,straight,side]
  SI.MassFlowRate mdot[3]=order*{m_flow[1],m_flow[2],m_flow[3]}
    "mass flow rates at T-junction [total,straight,side]";
  //mass flow rates order for functional input
  SI.MassFlowRate mdot_function[3]={mdot[3],mdot[2],mdot[1]}
    "mass flow rates at T-junction [side,straight,total]";

  // SW 09.05.10: convert diameter vector:
  //hydraulic diameter order in function:
  SI.Length d_hyd[3]=order*IN_con.d_hyd
    "hydraulic diameters at T-junction [total,straight,side]";
  SI.Length d_hyd_function[3]={d_hyd[3], d_hyd[2], d_hyd[1]}
    "hydraulic diameters at T-junction [side,straight,total]";

  //internal input record for functions
  FluidDissipation.PressureLoss.Junction.dp_Tjoin_IN_con intern_IN_con(
    final united_converging_crossection=IN_con.united_converging_crossection,
    final alpha=IN_con.alpha,
    final d_hyd=d_hyd_function,
    final m_flow_min=IN_con.m_flow_min,
    final v_max=IN_con.v_max,
    final zeta_TOT_max=IN_con.zeta_TOT_max);

  FluidDissipation.PressureLoss.Junction.dp_Tjoin_IN_var intern_IN_var(final rho=
       IN_var.rho);

  //internal output record for internal input record
  /*SI.Pressure intern_DP[3] 
    "(thermodynamic) pressure loss [left-internal,internal-right,internal-bottom]"
    annotation (Dialog(group="Output"));*/
  SI.Pressure intern_DP[2]
    "(thermodynamic) pressure loss [left-internal,internal-right,internal-bottom]"
    annotation (Dialog(group="Output"));

  SI.MassFlowRate intern_M_FLOW[3] "mass flow rate [side,straight,total]"
    annotation (Dialog(group="Output"));

  TYP.LocalResistanceCoefficient intern_zeta_LOC[2]
    "local resistance coefficient [side,straight]"
    annotation (Dialog(group="Output"));

  SI.ReynoldsNumber intern_Re[3] "Reynolds number"
    annotation (Dialog(group="Output"));
  final SI.PrandtlNumber intern_Pr=0 "Prandtl number"
    annotation (Dialog(group="Output"));

  Real intern_cases[6]
    "fluid flow situation at Tjunction according to online documentation"
    annotation (Dialog(group="Output"));

  Real intern_failureStatus
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

  /*output SI.Velocity intern_velocity[3] 
    "average fluid flow velocity [side,straight,total]";
  annotation (Dialog(group="Output"));*/

  dp_Tjoin_IN_con IN_con_Tjoin(final united_converging_crossection=IN_con.united_converging_crossection,
    final alpha=IN_con.alpha,
    final d_hyd=d_hyd_function,
    final m_flow_min=IN_con.m_flow_min,
    final v_max=IN_con.v_max,
    final zeta_TOT_max=IN_con.zeta_TOT_max);
  dp_Tjoin_symmetric_IN_con IN_con_Tjoin_symmetric(final united_converging_crossection=IN_con.united_converging_crossection,
    final d_hyd=d_hyd_function,
    final m_flow_min=IN_con.m_flow_min,
    final v_max=IN_con.v_max,
    final zeta_TOT_max=IN_con.zeta_TOT_max);
  dp_Tsplit_IN_con IN_con_Tsplit(final united_converging_crossection=IN_con.united_converging_crossection,
    final alpha=IN_con.alpha,
    final d_hyd=d_hyd_function,
    final m_flow_min=IN_con.m_flow_min,
    final v_max=IN_con.v_max,
    final zeta_TOT_max=IN_con.zeta_TOT_max);
  dp_Tsplit_symmetric_IN_con IN_con_Tsplit_symmetric(final united_converging_crossection=IN_con.united_converging_crossection,
    final d_hyd=d_hyd_function,
    final m_flow_min=IN_con.m_flow_min,
    final v_max=IN_con.v_max,
    final zeta_TOT_max=IN_con.zeta_TOT_max);

algorithm
  //fluid flow situations (see online documentation)
  cases[1] := if integer(case_1) == 1 and integer(joint) == 0 then 1 else
          0;
  cases[2] := if integer(case_1) == 1 and integer(joint) == 1 then 1 else
          0;
  cases[3] := if integer(case_2) == 1 and integer(joint) == 0 then 1 else
          0;
  cases[4] := if integer(case_2) == 1 and integer(joint) == 1 then 1 else
          0;
  cases[5] := if integer(case_3) == 1 and integer(joint) == 0 then 1 else
          0;
  cases[6] := if integer(case_3) == 1 and integer(joint) == 1 then 1 else
          0;
  /*cases[7] := if integer(noflow) == 1 and integer(joint) == 0 then 1 else 
          0;
  cases[8] := if integer(noflow) == 1 and integer(joint) == 1 then 1 else 
          0;*/

  //function for Tjunction according to fluid flow situation
  if integer(case_1) == 1 and integer(joint) == 1 then
    (intern_DP,intern_M_FLOW,intern_zeta_LOC,intern_Re,intern_Pr,
      intern_failureStatus) := FluidDissipation.PressureLoss.Junction.dp_Tjoin(
      IN_con_Tjoin,
      intern_IN_var,
      mdot_function);
  elseif integer(case_2) == 1 and integer(joint) == 1 then
    (intern_DP,intern_M_FLOW,intern_zeta_LOC,intern_Re,intern_Pr,
      intern_failureStatus) := FluidDissipation.PressureLoss.Junction.dp_Tjoin(
      IN_con_Tjoin,
      intern_IN_var,
      mdot_function);
  elseif integer(case_1) == 1 and integer(joint) == 0 then
    (intern_DP,intern_M_FLOW,intern_zeta_LOC,intern_Re,intern_Pr,intern_failureStatus) :=
    FD.dp_Tsplit(IN_con_Tsplit,intern_IN_var,mdot_function);
  elseif integer(case_2) == 1 and integer(joint) == 0 then
    (intern_DP,intern_M_FLOW,intern_zeta_LOC,intern_Re,intern_Pr,intern_failureStatus) :=
    FD.dp_Tsplit(IN_con_Tsplit,intern_IN_var,mdot_function);
  elseif integer(case_3) == 1 and integer(joint) == 1 then
    (intern_DP,intern_M_FLOW,intern_zeta_LOC,intern_Re,intern_Pr,
      intern_failureStatus) :=
      FluidDissipation.PressureLoss.Junction.dp_Tjoin_symmetric(
      IN_con_Tjoin_symmetric,
      intern_IN_var,
      mdot_function);
  elseif integer(case_3) == 1 and integer(joint) == 0 then
    (intern_DP,intern_M_FLOW,intern_zeta_LOC,intern_Re,intern_Pr,intern_failureStatus) :=
    FD.dp_Tsplit_symmetric(IN_con_Tsplit_symmetric,intern_IN_var,mdot_function);
  else
    (intern_DP,intern_M_FLOW,intern_zeta_LOC,intern_Re,intern_Pr,intern_failureStatus) :=
    FD.dp_Tzero(IN_con_Tjoin,intern_IN_var,mdot_function);
  end if;

  /*intern_OUT := if OUT.cases[1] == 1 or OUT.cases[3] == 1 then
    FD.dp_Tsplit(intern_IN) else if OUT.cases[2] == 1 or OUT.cases[4] ==
    1 then FD.dp_Tjoint(intern_IN) else if OUT.cases[5] == 1 then
    FD.dp_Ysplit(intern_IN) else if OUT.cases[6] == 1 then FD.dp_Yjoint(
    intern_IN) else FD.dp_Tzero(intern_IN);*/

  failureStatus := intern_failureStatus;

  //assignment of pressure losses to general geometry of Tjunction (design flow configuration >> see online documentation)
  //design flow configuration: DP[1]== [left-internal], DP[2] == [internal-right], DP[3]==[internal-bottom]
  //left
  DP[1] := if cases[3] == 1 then -sign(intern_DP[2])*abs(
    intern_DP[2])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[2])) else if cases[4] == 1 then +sign(
    intern_DP[2])*abs(intern_DP[2])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[2])) else if cases[5] == 1 then -sign(
    intern_DP[1])*abs(intern_DP[1])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[1])) else if cases[6] == 1 then +sign(
    intern_DP[1])*abs(intern_DP[1])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[1])) else 0;

  //right
  DP[2] := if cases[1] == 1 then +sign(intern_DP[2])*abs(
    intern_DP[2])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[2])) else if cases[2] == 1 then -sign(
    intern_DP[2])*abs(intern_DP[2])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[2])) else if cases[5] == 1 then +sign(
    intern_DP[2])*abs(intern_DP[2])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[2])) else if cases[6] == 1 then -sign(
    intern_DP[2])*abs(intern_DP[2])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[2])) else 0;

  //bottom
  DP[3] := if cases[1] == 1 then +sign(intern_DP[1])*abs(
    intern_DP[1])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[1])) else if cases[2] == 1 then -sign(
    intern_DP[1])*abs(intern_DP[1])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[1])) else if cases[3] == 1 then +sign(
    intern_DP[1])*abs(intern_DP[1])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[1])) else if cases[4] == 1 then -sign(
    intern_DP[1])*abs(intern_DP[1])*SMOOTH(
          dp_min,
          0,
          abs(intern_DP[1])) else 0;

  //assignment of pressure losses to general geometry of Tjunction (design flow configuration >> see online documentation)
  //design flow configuration: M_FLOW[1]== [left], M_FLOW[2] == [right], M_FLOW[3]==[bottom]
  M_FLOW[1] := if cases[1] == 1 then +sign(intern_M_FLOW[3])*
    abs(intern_M_FLOW[3])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[3])) else if cases[4] == 1 then +sign(
    +intern_M_FLOW[2])*abs(intern_M_FLOW[2])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[2])) else if cases[6] == 1 then +sign(
    +intern_M_FLOW[1])*abs(intern_M_FLOW[1])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[1])) else if cases[2] == 1 then -sign(
    +intern_M_FLOW[3])*abs(intern_M_FLOW[3])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[3])) else if cases[3] == 1 then -sign(
    +intern_M_FLOW[2])*abs(intern_M_FLOW[2])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[2])) else if cases[5] == 1 then -sign(
    +intern_M_FLOW[1])*abs(intern_M_FLOW[1])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[1])) else 0;

  M_FLOW[2] := if cases[1] == 1 then +sign(+intern_M_FLOW[2])
    *abs(intern_M_FLOW[2])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[2])) else if cases[4] == 1 then +sign(
    +intern_M_FLOW[3])*abs(intern_M_FLOW[3])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[3])) else if cases[5] == 1 then +sign(
    +intern_M_FLOW[2])*abs(intern_M_FLOW[2])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[2])) else if cases[2] == 1 then -sign(
    +intern_M_FLOW[2])*abs(intern_M_FLOW[2])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[2])) else if cases[3] == 1 then -sign(
    +intern_M_FLOW[3])*abs(intern_M_FLOW[3])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[3])) else if cases[6] == 1 then -sign(
    +intern_M_FLOW[2])*abs(intern_M_FLOW[2])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[2])) else 0;

  M_FLOW[3] := if cases[1] == 1 then +sign(+intern_M_FLOW[1])
    *abs(intern_M_FLOW[1])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[1])) else if cases[3] == 1 then +sign(
    +intern_M_FLOW[1])*abs(intern_M_FLOW[1])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[1])) else if cases[6] == 1 then +sign(
    +intern_M_FLOW[3])*abs(intern_M_FLOW[3])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[3])) else if cases[2] == 1 then -sign(
    +intern_M_FLOW[1])*abs(intern_M_FLOW[1])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[1])) else if cases[4] == 1 then -sign(
    +intern_M_FLOW[1])*abs(intern_M_FLOW[1])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[1])) else if cases[5] == 1 then -sign(
    +intern_M_FLOW[3])*abs(intern_M_FLOW[3])*SMOOTH(
          IN_con.m_flow_min,
          0,
          abs(intern_M_FLOW[3])) else 0;

  //OUT.velocity := intern_OUT.velocity;

  zeta_LOC := intern_zeta_LOC;

  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2,Documentation(info="<html>
<p>
Calculation of pressure loss in a T-junction either acting as T-join for merging incompressible fluid flows or acting as split for separating these.
This T-junction can be calculated for standard geometries with a varying branching angle of the side branch and hydraulic diameters at the edges as parameters.
Note that the mass flow rates at the edges of all passages need to be known for the calculation of the pressure loss (incompressible case).
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> circular crossectional area </b>
 </li>
 <li>
      <b> angle of turning 0&deg; &le; alpha &le; 90&deg; </b> <i>[Idelchik 2006, p. 417, sec. 15] </i>
 </li>
</ul>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
<p>
All possible fluid flow situations in a T-junction are defined by cases shown in the following figure:
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/pic_Tjunction_cases.png\", width=1244>
</p>
 
Splitting of fluid flows takes place for case 1, case 3 and case 5. Joining of fluid flow occurs for case 2, case 4 and case 6. A temporary case like case 7 (outflow out of T-junction for all fluid flows) or case 8 (inflow into T-junction) happens during the transition from one case to another.
 
<p>
Note that the following egoistic sign convention of the mass flow rates shall be used for the pressure loss calculation in a T-junction. Mass flow rates flowing out of a T-junction have a negative sign, whereas ingoing mass flow rates have a positive sign for the design flow. The design flow for the different fluid flow situations (case 1 to case 8) is marked by the blue arrows in the figure above. The actual fluid flow situation and the corresponding pressure loss is calculated automatically in dependence of the mass flow rates at a fixed general geometry shown in the following figure:
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/pic_Tjunction_general.png\", width=380>
</p>
 
<p>
Ensure that the egoistic sign convention of the mass flow rates for the fixed geometry corresponds to the intended fluid flow situation.
</p>
 
<p>
The (total) pressure loss between the entrance and the exit of a fluid flow can be either positive or negative at design flow for certain fluid flow situations.
</p>
 
<ul>
   <li> Decreasing <b>(total)</b> pressure in actual fluid flow direction occurs only if the following criteria are fulfilled:
      <ul>
         <li> Design flow </li>
         <li> Positive pressure loss coefficient (p_tot_entrance - p_tot_exit &gt; 0)</li>
         <pre><b> or </b></pre>
         <li> Reverse design flow </li>
         <li> Negative pressure loss coefficient (p_tot_entrance - p_tot_exit &lt; 0) </li>
      </ul>
   </li>
   <li> Increasing (total) pressure in actual fluid flow direction occurs only if the following criteria are fulfilled:
      <ul>
         <li> Design flow </li>
         <li> Negative pressure loss coefficient (p_tot_entrance - p_tot_exit &lt; 0)  </li>
          <pre><b> or </b></pre>
         <li> Reverse design flow </li>
         <li> Positive pressure loss coefficient (p_tot_entrance - p_tot_exit &gt; 0)  </li>
      </ul>
   </li>
</ul>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> p_tot_entrance    </b></td><td> total pressure at entrance of a fluid flow [Pa],</td></tr>
<tr><td><b> p_tot_exit        </b></td><td> total pressure at exit of the corresponding fluid flow[Pa].</td></tr>
</table>
</p>
 
<p>
Therefore the (thermodynamic) pressure loss between the entrance and the exit of a fluid flow can be either positive or negative. For example an increase of (thermodynamic) pressure in the direction of fluid flow leading to a negative pressure loss difference can be a result of the diffuser effect. Increasing the crossectional area from the total passage to the side branch leads to a decrease in fluid flow velocity (continuity equation) and an increase in (thermodynamic) pressure (equation of Bernoulli). If the increase of (thermodynamic) pressure due to the diffuser effect is higher then the irreversible pressure losses due to the splitting of the fluid flows there will be an increasing (thermodynamic) pressure in fluid flow direction.
</p>
 
The local pressure loss in a T-junction can be determined for the fluid flow through a side branch <b>(dp_loc_side)</b> or a straight passage <b>(dp_loc_straight)</b> by:
<p>
<pre>
     dp_loc_branch = zeta_loc_branch*(rho/2)*v_tot^2,
</pre>
</p>
 
<p>
where the local pressure loss is calculated w.r.t. the fluid flow velocity of the total fluid flow in the total passage as reference.
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> dp_loc_branch     </b></td><td> as local pressure loss due to the fluid flow through the side branch or straight passage [Pa],</td></tr>
<tr><td><b> rho               </b></td><td> as density of fluid flow [kg/m3],</td></tr>
<tr><td><b> v_tot             </b></td><td> as velocity of the total fluid flow in the total passage [m/s],</td></tr>
<tr><td><b> zeta_loc_branch   </b></td><td> as local resistance coefficient of the side branch or the straight passage in the T-junction [-].</td></tr>
</table>
</p>
 
The (thermodynamic) pressure loss <b>dp</b> between the entrance and the exit is calculated out of the determined total pressure <b>dp_tot</b> loss (out of the total pressure loss coefficient) reduced by the dynamic pressure loss <b>dp_dyn</b>:
 
<p>
<pre>
     dp = dp_tot - dp_dyn,
</pre>
</p>
 
<p>
where
</p>
 
<p>
<pre>
     dp_tot = p_tot_entrance - p_tot-exit = zeta_loc_branch*(rho/2)*(v_tot)^2 and
     dp_dyn = (rho/2)*(v_entrance - v_exit)^2,
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> dp                          </b></td><td> as thermodynamic pressure difference between entrance and exit section [Pa],</td></tr>
<tr><td><b> dp_dyn                      </b></td><td> as dynamic pressure difference between entrance and exit section [Pa],</td></tr>
<tr><td><b> dp_tot                      </b></td><td> as total pressure difference between entrance and exit section [Pa],</td></tr>
<tr><td><b> rho                         </b></td><td> as density of fluid flow [kg/m3],</td></tr>
<tr><td><b> v_entrance                  </b></td><td> as velocity at the entrance of a side branch or straight passage [m/s],</td></tr>
<tr><td><b> v_exit                      </b></td><td> as velocity at the exit of the total fluid flow [m/s],</td></tr>
<tr><td><b> zeta_loc_branch             </b></td><td> as local resistance coefficient of the side branch or the straight passage in the T-junction [-].</td></tr>
</table>
</p>
 
<p>
The calculation of the local resistance coefficient <b>zeta_loc_branch</b> for the side branch or the straight passage and the corresponding pressure loss is determined in dependence of the fluid flow situation and described in:
</p>
 
<p>
<table>
<tr><td><b> Case 1 and Case 3     </b></td><td> <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tsplit\">dp_Tsplit </a>,</td></tr>
<tr><td><b> Case 2 and Case 4     </b></td><td> <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tjoin\">dp_Tjoin </a>,</td></tr>
<tr><td><b> Case 5                </b></td><td> <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tsplit_symmetric\">dp_Tsplit_symmetric </a>,</td></tr>
<tr><td><b> Case 6                </b></td><td> <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tjoin_symmetric\">dp_Tjoin_symmetric </a>,</td></tr>
<tr><td><b> Case 7 and Case 8     </b></td><td> <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tzero\">dp_Tzero </a>.</td></tr>
</table>
</p>
 
Note that this function delivers a failure status without terminating the simulation. The failure status allows checking if the results are still reasonable even though that some boundary conditions are not fulfilled as expected. The following boundary conditions are checked:
 
<ul>
 <li> check of geometry:
      failure status is true if united_converging_crossection is not used and the crossectional areas of the total passage and the straight passage have not the same hydraulic diameter
 <li> check of mass balance:
      failure status is true the mass balance is temporarily not fulfilled
 <li> check of flow situation:
      failure status is true if the junction is not acting as a split
</ul>
 
An implementation of this general T-junction into Modelica_Fluid as thermo-hydraulic framework is shown in <a href=\"Modelica://FluidDissipation.Examples.Applications.Junction.pressureLoss_Tjunction\">PressureLossModel </a> and <a href=\"Modelica://FluidDissipation.Examples.Applications.Junction.Tjunction\">PressureLossTjunction </a>. Note that the following important convention for a fixed design flow direction shall be followed for the implementation of the pressure loss calculation in a fixed general geometry of the T-junction:
</p>
 
<ul>
 <li> input of mass flow rates:
      m_flow[3] = {left,right,bottom}
 <li> output of pressure loss calculation:
      DP[3]     = {left-internal,internal-right,internal-bottom}
</ul>
 
<h4><font color=\"#EF9B13\">References</font></h4>
<dl>
 <dt>Idelchik,I.E.:</dt>
    <dd><b>Handbook of hydraulic resistance</b>.
    Jaico Publishing House,Mumbai, 3rd edition, 2006.</dd>
 <dt>Miller,D.S.:</dt>
    <dd><b>Internal flow systems</b>.
    volume 5th of BHRA Fluid Engineering Series.BHRA Fluid Engineering, 1984.
 <dt>VDI:</dt>
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>.
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
 
</html>
"));
end dp_Tjunction;
