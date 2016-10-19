within FluidDissipation.PressureLoss.Orifice;
function dp_thickEdgedOverall
  "Pressure loss of thick and sharp edged orifice | overall flow regime | constant influence of friction | arbitrary cross sectional area"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //Notation of equations according to SOURCES

  //input records
  input FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_IN_con IN_con
    "Input record for function dp_thickEdgedOverall"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_IN_var IN_var
    "Input record for function dp_thickEdgedOverall"
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

  SI.Area A_cross=max(MIN, IN_con.A_1)
    "Cross sectional area of large cross sectional area";
  SI.Diameter d_hyd_0=4*IN_con.A_0/max(MIN, IN_con.C_0)
    "Hydraulic diameter of vena contraction";
  SI.Diameter d_hyd_1=4*A_cross/max(MIN, IN_con.C_1)
    "Hydraulic diameter of large cross sectional area";

  SI.ReynoldsNumber Re_0 "Reynolds number in vena contraction";
  SI.Velocity velocity "Mean velocity";

  //failure status
  Real fstatus[2] "Check of expected boundary conditions";

  //Documentation

algorithm
  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW := FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_MFLOW(
      IN_con,
      IN_var,
      chosenTarget.dp);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_DP(
      IN_con,
      IN_var,
      chosenTarget.m_flow);
  end if;

  velocity := abs(M_FLOW)/max(MIN, IN_var.rho*A_cross);
  Re := max(MIN, IN_var.rho*abs(velocity)*d_hyd_1/max(MIN, IN_var.eta));
  Re_0 := max(MIN, IN_var.rho*velocity*d_hyd_0/max(MIN, IN_var.eta));
  zeta_TOT := DP/(0.5*IN_var.rho*max(MIN, velocity^2));

  //failure status
  fstatus[1] := if IN_con.L/d_hyd_0 <= 0.015 then 1 else 0;
  fstatus[2] := if Re_0 <= 1e3 then 1 else 0;

  failureStatus := 0;
  for i in 1:size(fstatus, 1) loop
    if fstatus[i] == 1 then
      failureStatus := 1;
    end if;
  end for;

  //assertion
  assert(IN_con.A_1 > IN_con.A_0,
    "Area A_1 has to be larger than Area A_0 for proper orifice geometry!");
  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    Documentation(info="<html>
<p>
Calculation of pressure loss in thick edged orifices with sharp corners at overall flow regime for incompressible and single-phase fluid flow through an arbitrary shaped cross sectional area (square, circular, etc.) considering constant influence of surface roughness.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used within the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> Reynolds number (for vena contracta) Re &gt; 1e3 </b> <i>[Idelchik 2006, p. 222, diag. 4-15] </i>
 </li>
 <li> 
      <b> Relative length of vena contracta (L/d_hyd_0) &gt; 0.015 </b> <i>[Idelchik 2006, p. 222, diag. 4-15] </i>
 </li>
 <li> 
      <b> Darcy friction factor lambda_FRI = 0.02 </b> <i>[Idelchik 2006, p. 222, sec. 4-15] </i>
 </li> 
</ul>
 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/orifice/pic_thickEdged.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation for thick and sharp edged orifice is further documented for the incompressible case <a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_DP\">dp_thickEdgedOverall_DP</a> and the compressible case <a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_MFLOW\">dp_thickEdgedOverall_MFLOW</a>.
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end dp_thickEdgedOverall;
