within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Diffuser.ConicalOverall;
model ConicalOverallFlowModel "Diffuser (conical): Application flow model for diffuser function in Modelica.Fluid"

  //base flow model
  extends FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Diffuser.BaseDiffuserPL.BaseDiffuserModel;

  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //pressure loss parameter
  parameter SI.Length L_d=L_1 "Length of diffuser section (parallel to bulk fluid flow)"
    annotation (Dialog(group="Diffuser"));
  parameter SI.Area A_1=PI*0.01^2/4 "Small constant cross sectional area at inlet of diffuser"
    annotation (Dialog(group="Diffuser"));
  parameter SI.Area A_2=2*A_1 "Large constant cross sectional area at outlet of diffuser"
    annotation (Dialog(group="Diffuser"));
  parameter SI.Length C_1=PI*0.01 "Small perimeter at inlet of diffuser"
    annotation (Dialog(group="Diffuser"));
  parameter SI.Length C_2=2*C_1 "Large perimeter at outlet of diffuser"
    annotation (Dialog(group="Diffuser"));
  parameter SI.Length L_1=0.1 "Length of straight pipe before diffuser section"
    annotation (Dialog(group="Straight pipe"));
  parameter SI.Length L_2=L_1 "Length of straight pipe after diffuser section"
    annotation (Dialog(group="Straight pipe"));
  parameter SI.Length K=2.5e-5 "Roughness (average height of surface asperities)"
    annotation (Dialog(group="Straight pipe"));
  parameter SI.Velocity velocity_small=1e-3 "Regularisation for a velocity smaller then velocity_small"
    annotation (Dialog(group="Numerical aspects"));
  parameter Utilities.Types.PressureLossCoefficient zeta_tot_min=1e-3 "Minimal pressure loss coefficient"
    annotation (Dialog(group="Numerical aspects"));
  parameter Utilities.Types.PressureLossCoefficient zeta_tot_max=1e2 "Maximum pressure loss coefficient"
    annotation (Dialog(group="Numerical aspects"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Diffuser.ConicalOverall.PressureLossInput_con
    IN_con(
    A_1=A_1,
    A_2=A_2,
    C_1=C_1,
    C_2=C_2,
    L_1=L_1,
    L_2=L_2,
    K=K,
    velocity_small=velocity_small,
    zeta_tot_min=zeta_tot_min,
    zeta_tot_max=zeta_tot_max,
    L_d=L_d) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Nozzle.ConicalOverall.PressureLossInput_con
    IN_con_rev(
    L_trans=L_d,
    A_1=A_2,
    A_2=A_1,
    C_1=C_2,
    C_2=C_1,
    L_1=L_2,
    L_2=L_1,
    K=K,
    velocity_small=velocity_small,
    zeta_tot_min=zeta_tot_min,
    zeta_tot_max=zeta_tot_max)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Diffuser.ConicalOverall.PressureLossInput_var
    IN_var(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  SI.Velocity velocity_a=abs(m_flow)/(rho_a*A_1) "Velocity at inlet of diffuser section w.r.t. design flow direction";
  SI.Velocity velocity_b=abs(m_flow)/(rho_b*A_2) "Velocity at outlet of diffuser section w.r.t. design flow direction";
  SI.Pressure dp_dyn=(rho_a/2)*SMOOTH(
      m_flow_small,
      0,
      abs(m_flow))*velocity_a^2 - (rho_b/2)*SMOOTH(
      m_flow_small,
      0,
      abs(m_flow))*velocity_b^2 "Dynamic pressure difference between inlet and outlet of diffuser section";

  TYP.PressureLossCoefficient zeta_tot "Total pressure loss coefficient";

  constant Real MIN = 1e-6;

equation
  //Please note that for design flow direction there is an increase in static pressure due to a decrease in velocity because of a larger cross sectional area at the outlet compared to the inlet
  dp + dp_dyn = if noEvent(m_flow > 0) then
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    m_flow,
    m_flow_small,
    0)*(
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Diffuser.ConicalOverall.pressureLoss_mflow(
    IN_con,
    IN_var,
    m_flow)) else (
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    m_flow,
    m_flow_small,
    0)*(
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Nozzle.ConicalOverall.pressureLoss_mflow(
    IN_con_rev,
    IN_var,
    m_flow)));

    dp = dp_tot - dp_dyn "Static pressure difference";

    zeta_tot = if noEvent(m_flow > 0) then dp_tot/rho_a*2/max(MIN, velocity_a^2) else -dp_tot/rho_b*2/max(MIN, velocity_b^2);

  annotation (Documentation(revisions="<html>
2014-07-14 Stefan Wischhusen: Corrected sign convention for dynamic pressure drop and used m_flow instead of dp_tot for switching between Diffusor and Nozzle mode.
</html>"));
end ConicalOverallFlowModel;
