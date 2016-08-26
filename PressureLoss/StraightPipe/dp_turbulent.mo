within FluidDissipation.PressureLoss.StraightPipe;
function dp_turbulent "Pressure loss of straight pipe | turbulent flow regime"
  extends Modelica.Icons.Function;
  //input records
  input FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_IN_con IN_con "Input record for function dp_turbulent"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_IN_var IN_var "Input record for function dp_turbulent"
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
  SI.Area A_cross=PI*IN_con.d_hyd^2/4 "Circular cross sectional area";

  SI.Velocity velocity=chosenTarget.m_flow/(IN_var.rho*A_cross) "Mean velocity";

  //failure status
  Real fstatus[1] "Check of expected boundary conditions";

  //Documentation
algorithm
  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW := FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_MFLOW(
      IN_con,
      IN_var,
      chosenTarget.dp);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_DP(
      IN_con,
      IN_var,
      chosenTarget.m_flow);

  end if;

  velocity := abs(M_FLOW)/max(MIN, IN_var.rho*A_cross);
  Re := max(MIN, IN_var.rho*abs(velocity)*IN_con.d_hyd/IN_var.eta);
  zeta_TOT := DP/(0.5*IN_var.rho*max(MIN, velocity^2));

  //failure status
  fstatus[1] := if Re < 4e3 then 1 else 0;

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
Calculation of pressure loss in a straight pipe for <b> turbulent </b> flow regime of an incompressible and single-phase fluid flow only considering surface roughness.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used within the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> circular cross sectional area </b>
 <li>
      <b> turbulent flow regime (Reynolds number Re &ge; 4e3) <i>[VDI-W&auml;rmeatlas 2002, p. Lab 3, fig. 1] </i> </b>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/pic_straightPipe.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation for straight pipe with turbulent flow regim is further documented for the incompressible case <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_DP\">dp_turbulent_DP</a> and the compressible case <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_MFLOW\">dp_turbulent_MFLOW</a>.
</html>"));
end dp_turbulent;
