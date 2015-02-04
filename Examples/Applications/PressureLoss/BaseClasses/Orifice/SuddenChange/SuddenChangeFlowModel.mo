within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.SuddenChange;
model SuddenChangeFlowModel
  "Orifice (sudden section change): Application flow model for orifice function in Modelica.Fluid"

  //base flow model
  extends
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.BaseOrificePL.BaseOrificeModel;

  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //pressure loss parameter
  parameter SI.Area A_1=PI*0.01^2/4 "Small cross sectional area of orifice";
  parameter SI.Area A_2=A_1 "Large cross sectional area of orifice";
  parameter SI.Length C_1=PI*0.01 "Small perimeter of orifice";
  parameter SI.Length C_2=C_1 "Large perimeter of orifice";

  SI.Velocity velocity_a=abs(m_flow)/(rho_a*A_1)
    "Velocity at inlet of diffuser section w.r.t. design flow direction";
  SI.Velocity velocity_b=abs(m_flow)/(rho_b*A_2)
    "Velocity at outlet of diffuser section w.r.t. design flow direction";
  SI.Pressure dp_dyn=(rho_a/2)*SMOOTH(
      m_flow_small,
      0,
      abs(m_flow))*velocity_a^2 - (rho_b/2)*SMOOTH(
      m_flow_small,
      0,
      abs(m_flow))*velocity_b^2
    "Dynamic pressure difference between inlet and outlet of diffuser section";

  TYP.PressureLossCoefficient zeta_tot "Total pressure loss coefficient";

  constant Real MIN = 1e-6;

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.SuddenChange.PressureLossInput_con
    IN_con(
    A_1=A_1,
    A_2=A_2,
    C_1=C_1,
    C_2=C_2) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.SuddenChange.PressureLossInput_var
    IN_var(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.SuddenChange.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);
    dp = dp_tot - dp_dyn "Static pressure difference";

    zeta_tot = if m_flow > 0 then dp/rho_a*2/max(MIN, velocity_a^2) else -dp/rho_b*2/max(MIN, velocity_b^2);
end SuddenChangeFlowModel;
