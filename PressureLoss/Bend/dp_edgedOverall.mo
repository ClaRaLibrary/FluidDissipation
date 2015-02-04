within FluidDissipation.PressureLoss.Bend;
function dp_edgedOverall
  "Pressure loss of edged bend | overall flow regime | surface roughness"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //SOURCE_2: Miller, D.S.: INTERNAL FLOW SYSTEMS, 2nd edition, 1984.
  //SOURCE_3: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002, Section Lac 6 (Verification)
  //Notation of equations according to SOURCES

  //input records
  input FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_con IN_con
    "Input record for function dp_edgedOverall"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_var IN_var
    "Input record for function dp_edgedOverall"
    annotation (Dialog(group="Variable inputs"));
  input FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget
    "Target variable of calculation" annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "pressure loss" annotation (Dialog(group="Output"));
  output SI.MassFlowRate M_FLOW "mass flow rate"
    annotation (Dialog(group="Output"));
  output Utilities.Types.PressureLossCoefficient zeta_TOT
    "Pressure loss coefficient" annotation (Dialog(group="Output"));
  output SI.ReynoldsNumber Re "Reynolds number"
    annotation (Dialog(group="Output"));
  final output SI.PrandtlNumber Pr=0 "Prandtl number"
    annotation (Dialog(group="Output"));
  output Real failureStatus
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

protected
  Real MIN=Modelica.Constants.eps;

  SI.Diameter d_hyd=max(MIN, IN_con.d_hyd) "Hydraulic diameter";
  SI.Area A_cross=PI*d_hyd^2/4 "Cross sectional area";
  Real delta=IN_con.delta*180/PI "Angle of turning";

  SI.Velocity velocity "Mean velocity";

  Real fstatus[2] "Check of expected boundary conditions";

  //Documentation
algorithm
  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW := FluidDissipation.PressureLoss.Bend.dp_edgedOverall_MFLOW(
      IN_con,
      IN_var,
      chosenTarget.dp);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.Bend.dp_edgedOverall_DP(
      IN_con,
      IN_var,
      chosenTarget.m_flow);
  end if;

  velocity := abs(M_FLOW)/max(MIN, IN_var.rho*A_cross);
  Re := max(MIN, IN_var.rho*abs(velocity)*IN_con.d_hyd/IN_var.eta);
  zeta_TOT := DP/(0.5*IN_var.rho*max(MIN, velocity^2));

  //failure status
  fstatus[1] := if IN_con.L/max(MIN, IN_con.d_hyd) < 10 then 1 else 0;
  fstatus[2] := if delta > 180 then 1 else 0;

  failureStatus := 0;
  for i in 1:size(fstatus, 1) loop
    if fstatus[i] == 1 then
      failureStatus := 1;
    end if;
  end for;

  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of pressure loss in edged bends with sharp corners at overall flow regime for incompressible and single-phase fluid flow through circular cross sectional area considering surface roughness.
</p>
 
There are larger pressure losses in an edged bend compared to a curved bend under the same conditions. The effect of a sharp corner in an edged bend on the pressure loss is much larger than the influence of surface roughness.
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> circular cross sectional area </b> <i>[Idelchik 2006, p. 366, diag. 6-7] </i>
 </li>
 <li> 
      <b> edged bend with sharp corners at turning </b> <i>[Idelchik 2006, p. 366, diag. 6-7] </i>
 </li>
 <li> 
      <b> 0&deg; &le; angle of turning &le; 180&deg; </b> <i>[Idelchik 2006, p. 338, sec. 19] </i>
 </li> 
 <li> 
      <b> length of bend straight starting section / diameter &ge; 10 </b> <i>[Idelchik 2006, p. 366, diag. 6-7] </i>
 </li> 
</ul>
 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/pic_edgedBend.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation for edged bend is further documented for the incompressible case <a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_edgedOverall_DP\">dp_edgedOverall_DP</a> and the compressible case <a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_edgedOverall_MFLOW\">dp_edgedOverall_MFLOW</a>.
</html>
"));
end dp_edgedOverall;
