within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.SuddenChangeSectionBidirectionalTurbulentSmooth;
model SuddenChangeSectionBidirectionalTurbulentSmoothFlowModel
  "Orifice (sudden section change): Application flow model for orifice function in Modelica.Fluid"

  //base flow model
  extends
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.BaseOrificePL.BaseOrificeModel;

  //pressure loss parameter
  parameter SI.Area A_1=PI*0.01^2/4 "Small cross sectional area of orifice";
  parameter SI.Area A_2=A_1 "Large cross sectional area of orifice";
  parameter SI.Length C_1=PI*0.01 "Small perimeter of orifice";
  parameter SI.Length C_2=C_1 "Large perimeter of orifice";

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.SuddenChangeSectionBidirectionalTurbulentSmooth.PressureLossInput_con
    IN_con(
    A_1=A_1,
    A_2=A_2,
    C_1=C_1,
    C_2=C_2) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.SuddenChangeSectionBidirectionalTurbulentSmooth.PressureLossInput_var
    IN_var(
    eta=eta,
    rho=rho) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.SuddenChangeSectionBidirectionalTurbulentSmooth.massFlowRate_dp(
    IN_con, IN_var, dp);
end SuddenChangeSectionBidirectionalTurbulentSmoothFlowModel;
