within FluidDissipation.PressureLoss.General;
function dp_volumeFlowRate
  "Generic pressure loss | quadratic function (dp=a*V_flow^2 + b*V_flow)"
  extends Modelica.Icons.Function;

//input records
  input FluidDissipation.PressureLoss.General.dp_volumeFlowRate_IN_con IN_con
    "Input record for function dp_volumeFlowRate"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.General.dp_volumeFlowRate_IN_var IN_var
    "Input record for function dp_volumeFlowRate"
    annotation (Dialog(group="Variable inputs"));
  input FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget
    "Target variable of calculation" annotation (Dialog(group="Input"));

//output variables
  output SI.Pressure DP "pressure loss" annotation (Dialog(group="Output"));
  output SI.MassFlowRate M_FLOW "mass flow rate"
    annotation (Dialog(group="Output"));
  // zeta_TOT has no meaning for this function
  final output Utilities.Types.PressureLossCoefficient zeta_TOT = 0
    "Pressure loss coefficient" annotation (Dialog(group="Output"));
  // Re has no meaning for this function
  final output SI.ReynoldsNumber Re = 0 "Reynolds number"
    annotation (Dialog(group="Output"));
  final output SI.PrandtlNumber Pr = 0 "Prandtl number"
    annotation (Dialog(group="Output"));
  // function has no restrictions
  final output Real failureStatus = 0
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

//Documentation
algorithm
  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW := FluidDissipation.PressureLoss.General.dp_volumeFlowRate_MFLOW(
      IN_con,
      IN_var,
      chosenTarget.dp);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.General.dp_volumeFlowRate_DP(
      IN_con,
      IN_var,
      chosenTarget.m_flow);

  end if;
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info = "<html>
<p>
Calculation of a generic pressure loss with linear or quadratic dependence on volume flow rate.
The function can be used to calculate pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss.
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation for this generic function is further documented for the incompressible case <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate_DP\">dp_volumeFlowRate_DP</a> and the compressible case <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate_MFLOW\">dp_volumeFlowRate_MFLOW</a>.
</html>", revisions="<html>
2017-03-24 Stefan Wischhusen: Provided reasonable outputs for all outputs of the function.
2018-11-21 Stefan Wischhusen: Fixed problem for linear case (a=0 and b>0).
</html>"));
end dp_volumeFlowRate;
