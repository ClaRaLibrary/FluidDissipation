within FluidDissipation.PressureLoss.Orifice;
function dp_suddenChange
  "Pressure loss of orifice with sudden change in cross sectional area | turbulent flow regime | smooth surface | arbitrary cross sectional area | without buffles | sharp edge"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //Notation of equations according to SOURCES

  //input records
  input FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_con IN_con
    "Input record for function dp_suddenChange"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_var IN_var
    "Input record for function dp_suddenChange"
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

  //Documentation
protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_1=max(MIN, min(IN_con.A_1, IN_con.A_2))
    "Small cross sectional area of orifice";
  SI.Area A_2=max(MIN, max(IN_con.A_1, IN_con.A_2))
    "Large cross sectional area of orifice";
  SI.Length C_1=max(MIN, min(IN_con.C_1, IN_con.C_2))
    "Perimeter of small cross sectional area of orifice";
  SI.Length C_2=max(MIN, max(IN_con.C_1, IN_con.C_2))
    "perimeter of large cross sectional area of orifice";
  SI.Diameter d_hyd_1=4*A_1/C_1
    "Hydraulic diameter of small cross sectional area of orifice";

  SI.Velocity velocity "Mean velocity";

  //failure status
  Real fstatus[2] "Check of expected boundary conditions";

algorithm
  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW := FluidDissipation.PressureLoss.Orifice.dp_suddenChange_MFLOW(
      IN_con,
      IN_var,
      DP);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.Orifice.dp_suddenChange_DP(
      IN_con,
      IN_var,
      M_FLOW);
  end if;

  velocity := abs(M_FLOW)/max(MIN, IN_var.rho*A_1);
  Re := max(MIN, IN_var.rho*abs(velocity)*d_hyd_1/IN_var.eta);
  zeta_TOT := abs(DP)/(0.5*IN_var.rho*max(MIN, velocity^2));

  //failure status
  fstatus[1] := if (chosenTarget.m_flow > 0 and Re < 3.3e3) then 1 else 0;
  fstatus[2] := if (chosenTarget.m_flow < 0 and Re < 10e4) then 1 else 0;

  failureStatus := 0;
  for i in 1:size(fstatus, 1) loop
    if fstatus[i] == 1 then
      failureStatus := 1;
    end if;
  end for;

  //assertion
  assert(IN_con.A_1 <= IN_con.A_2,
    "Area A_1 has to be smaller or equal than Area A_2 for proper orifice geometry!");
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of the local pressure loss at a sudden change of the cross sectional areas (sudden expansion or sudden contraction) with sharp corners at turbulent flow regime for incompressible and single-phase fluid flow through arbitrary shaped cross sectional area (square, circular, etc.) considering a smooth surface. The flow direction determines the type of the transition. In case of the design flow a sudden expansion will be considered. At flow reversal a sudden contraction will be considered.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used within the restricted limits according to the referenced literature.
<ul>
 <li>
      <b>Smooth surface</b>
 <li>
      <b>Turbulent flow regime</b>
 <li>
      <b>Reynolds number for sudden expansion Re &gt; 3.3e3 </b> <i>[Idelchik 2006, p. 208, diag. 4-1] </i>
 <li> 
      <b>Reynolds number for sudden contraction Re &gt; 1e4 </b> <i>[Idelchik 2006, p. 216-217, diag. 4-9] </i>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/orifice/pic_suddenChangeSection.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation for orifice with a sudden change of the cross sectional areas is further documented for the incompressible case <a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_suddenChange_DP\">dp_suddenChange_DP</a> and the compressible case <a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_suddenChange_MFLOW\">dp_suddenChange_MFLOW</a>.
</html>"));
end dp_suddenChange;
