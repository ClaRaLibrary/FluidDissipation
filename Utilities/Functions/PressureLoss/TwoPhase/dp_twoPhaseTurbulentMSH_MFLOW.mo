within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function dp_twoPhaseTurbulentMSH_MFLOW "Two phase flow friction loss for turbulent flow regime according to Mueller-Steinhagen and Heck (1986)|Calculate mass flow rate"
  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_con
    IN_con "Input record for constant values";
  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var
    IN_var "Input record for variable values";

  input Modelica.SIunits.PressureDifference dp "Pressure difference";
  input Modelica.SIunits.PressureDifference dp_smooth=0.1 "Pressure difference for linearisation around zero flow"   annotation (Dialog(group="Expert Settings"));

  output Modelica.SIunits.MassFlowRate M_FLOW "Mass flow rate";

protected
  Real beta;
  Modelica.SIunits.Length d_hyd = 4*IN_con.A_cross/IN_con.perimeter "Hydraulic diameter";
algorithm
  beta := max(0.3164*IN_con.length/(2*d_hyd^(1.25))*((max(Modelica.Constants.eps, IN_var.eta_l)^(0.25)/max(Modelica.Constants.eps, IN_var.rho_l) + 2*IN_var.x_flow*(max(Modelica.Constants.eps, IN_var.eta_g)^(0.25)/max(Modelica.Constants.eps, IN_var.rho_g) - max(Modelica.Constants.eps, IN_var.eta_l)^(0.25)/max(Modelica.Constants.eps, IN_var.rho_l)))*(max(1 - IN_var.x_flow, Modelica.Constants.eps)^(1/3)) + max(Modelica.Constants.eps, IN_var.eta_g)^(0.25)/max(Modelica.Constants.eps, IN_var.rho_g)*IN_var.x_flow^3), Modelica.Constants.eps);

  M_FLOW := IN_con.A_cross*FluidDissipation.Utilities.Functions.General.SmoothPower(
    dp,
    dp_smooth,
    (4/7))/(beta)^(4/7);

end dp_twoPhaseTurbulentMSH_MFLOW;
