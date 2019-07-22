within FluidDissipation.PressureLoss.General;
function dp_pressureLossCoefficient "Generic pressure loss | pressure loss coefficient (zeta_TOT)"
  extends Modelica.Icons.Function;
  //input records
  input FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_con IN_con "Input record for dp_pressureLossCoefficient" annotation (
    Dialog(group = "Constant inputs"));
  input FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_var IN_var "Input record for dp_pressureLossCoefficient" annotation (
    Dialog(group = "Variable inputs"));
  input FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget "Target variable of calculation" annotation (
    Dialog(group = "Input"));
  //output variables
  output SI.Pressure DP "pressure loss" annotation (
    Dialog(group = "Output"));
  output SI.MassFlowRate M_FLOW "mass flow rate" annotation (
    Dialog(group = "Output"));
  // zeta_TOT has no meaning for this function
  output Utilities.Types.PressureLossCoefficient zeta_TOT "Pressure loss coefficient" annotation (
    Dialog(group = "Output"));
  // Re has no meaning for this function
  final output SI.ReynoldsNumber Re = 0 "Reynolds number" annotation (
    Dialog(group = "Output"));
  final output SI.PrandtlNumber Pr = 0 "Prandtl number" annotation (
    Dialog(group = "Output"));
  // function has no restrictions
  final output Real failureStatus = 0 "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results" annotation (
    Dialog(group = "Output"));

protected
  Real MIN=Modelica.Constants.eps;
  Modelica.SIunits.Velocity velocity "Mean velocity of flow";

algorithm

  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW := FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_MFLOW(IN_con, IN_var, chosenTarget.dp);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_DP(IN_con, IN_var, chosenTarget.m_flow);
  end if;

  velocity := abs(M_FLOW)/max(MIN, IN_var.rho*IN_con.A_cross);
  // Resulting zeta_TOT can be different from input due to
  // regularization function (at low pressure loss)
  zeta_TOT := DP/(0.5*IN_var.rho*max(MIN, velocity^2));

  annotation (
    Inline = false,
    smoothOrder(normallyConstant = IN_con) = 2,
    Documentation(info = "<html>
<p>
Calculation of a generic pressure loss in dependence of the pressure loss coefficient.
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation for this generic function is further documented for the incompressible case <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_DP\">dp_pressureLossCoefficient_DP</a> and the compressible case <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_MFLOW\">dp_pressureLossCoefficient_MFLOW</a>.
</html>", revisions = "<html>
2017-03-24 Stefan Wischhusen: Provided reasonable outputs for all outputs of the function.
</html>"));
end dp_pressureLossCoefficient;
