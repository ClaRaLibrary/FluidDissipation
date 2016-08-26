within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function dp_twoPhaseLaminarMSH_MFLOW "Two phase flow frictional pressure loss for laminar regime according to Mueller-Steinhagen and Heck (1986)|Calculate mass flow rate"
  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_con
    IN_con "Input record for constant values";
  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var
    IN_var "Input record for variable values";

  input Modelica.SIunits.PressureDifference dp "Pressure difference";

  output Modelica.SIunits.MassFlowRate M_FLOW "Mass flow rate";

protected
  Real beta;
  Modelica.SIunits.Length d_hyd = 4*IN_con.A_cross/IN_con.perimeter "Hydraulic diameter";
algorithm
  beta := max(IN_con.length*64/(2*d_hyd^2)*((IN_var.eta_l/max(Modelica.Constants.eps, IN_var.rho_l) + 2*IN_var.x_flow*(IN_var.eta_g/max(Modelica.Constants.eps, IN_var.rho_g) - IN_var.eta_l/max(Modelica.Constants.eps, IN_var.rho_l)))*(max(1 - IN_var.x_flow, Modelica.Constants.eps)^(1/3)) + IN_var.eta_g/max(Modelica.Constants.eps, IN_var.rho_g)*IN_var.x_flow^3), Modelica.Constants.eps);

  M_FLOW := dp*IN_con.A_cross/beta;

end dp_twoPhaseLaminarMSH_MFLOW;
