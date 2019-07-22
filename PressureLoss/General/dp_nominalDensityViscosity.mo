within FluidDissipation.PressureLoss.General;
function dp_nominalDensityViscosity "Generic pressure loss | nominal operation point | pressure loss law (exponent) | density and dynamic viscosity dependence"
  extends Modelica.Icons.Function;
  //input records
  input FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_IN_con IN_con "Input record for function dp_nominalDensityViscosity" annotation (
    Dialog(group = "Constant inputs"));
  input FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_IN_var IN_var "Input record for function dp_nominalDensityViscosity" annotation (
    Dialog(group = "Variable inputs"));
  input FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget "Target variable of calculation" annotation (
    Dialog(group = "Input"));
  //output variables
  output SI.Pressure DP "pressure loss" annotation (
    Dialog(group = "Output"));
  output SI.MassFlowRate M_FLOW "mass flow rate" annotation (
    Dialog(group = "Output"));
  // zeta_TOT has no meaning for this function
  final output Utilities.Types.PressureLossCoefficient zeta_TOT = 0 "Pressure loss coefficient" annotation (
    Dialog(group = "Output"));
  // Re has no meaning for this function
  final output SI.ReynoldsNumber Re = 0 "Reynolds number" annotation (
    Dialog(group = "Output"));
  final output SI.PrandtlNumber Pr = 0 "Prandtl number" annotation (
    Dialog(group = "Output"));
  // function has no restrictions
  final output Real failureStatus = 0 "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results" annotation (
    Dialog(group = "Output"));
  //Documentation
algorithm

  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW := FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_MFLOW(IN_con, IN_var, chosenTarget.dp);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_DP(IN_con, IN_var, chosenTarget.m_flow);
  end if;
  annotation (
    Inline = false,
    smoothOrder(normallyConstant = IN_con) = 2,
    Documentation(info = "<html>
<p>
Calculation of a generic pressure loss in dependence of nominal fluid variables (e.g. nominal density, nominal dynamic viscosity) at an operation point via interpolation.
This generic function considers the pressure loss law via a pressure loss exponent and the influence of density and dynamic viscosity on pressure loss.
The function can be used to calculate pressure loss at known mass flow rate <b> or </b>  mass flow rate at known pressure loss.
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation for this generic function is further documented for the incompressible case <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_DP\">dp_nominalDensityViscosity_DP</a> and the compressible case <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_MFLOW\">dp_nominalDensityViscosity_MFLOW</a>.
</html>", revisions = "<html>
2017-03-24 Stefan Wischhusen: Provided reasonable outputs for all outputs of the function.
</html>"));
end dp_nominalDensityViscosity;
