within FluidDissipation.PressureLoss.General;
function dp_idealGas "Generic pressure loss | ideal gas | mean density"
  extends Modelica.Icons.Function;

  //input records
  input FluidDissipation.PressureLoss.General.dp_idealGas_IN_con IN_con "Input record for function dp_idealGas"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.General.dp_idealGas_IN_var IN_var "Input record for function dp_idealGas"
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

  //Documentation
algorithm
  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW := FluidDissipation.PressureLoss.General.dp_idealGas_MFLOW(
      IN_con,
      IN_var,
      chosenTarget.dp);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.General.dp_idealGas_DP(
      IN_con,
      IN_var,
      chosenTarget.m_flow);
  end if;
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of a generic pressure loss for an <b> ideal gas </b> using mean density.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
    <b> ideal gas </b> 
 <li>
    mean density of ideal gas
</ul>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation for ideal gas is further documented for the incompressible case <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_idealGas_DP\">dp_idealGas_DP</a> and the compressible case <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_idealGas_MFLOW\">dp_idealGas_MFLOW</a>.
</html>"));
end dp_idealGas;
