within FluidDissipation.PressureLoss.StraightPipe;
function dp_laminar "Pressure loss of straight pipe | laminar flow regime (Hagen-Poiseuille)"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.

  //input records
  input FluidDissipation.PressureLoss.StraightPipe.dp_laminar_IN_con IN_con "Input record for function dp_laminar"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.StraightPipe.dp_laminar_IN_var IN_var "Input record for function dp_laminar"
    annotation (Dialog(group="Variable inputs"));
  input FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget "Target variable of calculation"
                                     annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "pressure loss" annotation (Dialog(group="Output"));
  output SI.MassFlowRate M_FLOW "mass flow rate"
    annotation (Dialog(group="Output"));
  output Utilities.Types.PressureLossCoefficient zeta_TOT "Pressure loss coefficient"
                                annotation (Dialog(group="Output"));
  output SI.ReynoldsNumber Re "Reynolds number"
    annotation (Dialog(group="Output"));
  final output SI.PrandtlNumber Pr=0 "Prandtl number"
    annotation (Dialog(group="Output"));
  output Real failureStatus "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

protected
  Real MIN=Modelica.Constants.eps;

  SI.Diameter d_hyd=max(MIN, IN_con.d_hyd) "Hydraulic diameter";
  SI.Area A_cross=max(MIN, PI*IN_con.d_hyd^2/4) "Circular cross sectional area";

  SI.Velocity velocity=chosenTarget.m_flow/max(MIN, IN_var.rho*A_cross) "Mean velocity";

  //failure status
  Real fstatus[1] "Check of expected boundary conditions";

  //Documentation

algorithm
  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW := FluidDissipation.PressureLoss.StraightPipe.dp_laminar_MFLOW(
      IN_con,
      IN_var,
      chosenTarget.dp);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.StraightPipe.dp_laminar_DP(
      IN_con,
      IN_var,
      chosenTarget.m_flow);
  end if;

  velocity := abs(M_FLOW)/max(MIN, IN_var.rho*A_cross);
  Re := max(MIN, IN_var.rho*abs(velocity)*IN_con.d_hyd/max(MIN, IN_var.eta));
  zeta_TOT := DP/(0.5*IN_var.rho*max(MIN, velocity^2));

  //failure status
  fstatus[1] := if Re > 2e3 then 1 else 0;

  failureStatus := 0;
  for i in 1:size(fstatus, 1) loop
    if fstatus[i] == 1 then
      failureStatus := 1;
    end if;
  end for;
  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    Documentation(info="<html>
<p>
Calculation of pressure loss in a straight pipe for <b> laminar </b> flow regime of an incompressible and single-phase fluid flow only.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> circular cross sectional area </b>
 <li>
      <b> laminar flow regime (Reynolds number Re &le; 2000) <i>[VDI-W&auml;rmeatlas 2002, p. Lab, eq. 3] </i> </b>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/pic_straightPipe.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation for straight pipe with laminar flow regim is further documented for the incompressible case <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_laminar_DP\">dp_laminar_DP</a> and the compressible case <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_laminar_MFLOW\">dp_laminar_MFLOW</a>.
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end dp_laminar;
