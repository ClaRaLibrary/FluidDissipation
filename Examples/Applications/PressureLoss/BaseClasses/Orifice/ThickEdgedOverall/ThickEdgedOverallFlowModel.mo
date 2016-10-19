within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.ThickEdgedOverall;
model ThickEdgedOverallFlowModel
  "Orifice (thick edged): Application flow model for orifice function in Modelica.Fluid"

  //base flow model
  extends
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.BaseOrificePL.BaseOrificeModel;

  //pressure loss parameter
  SI.Area A_0=0.1*A_1 "Cross sectional area of vena contraction"
    annotation (Dialog(group="Orifice"));
  parameter SI.Area A_1=PI*0.01^2/4 "Small cross sectional area of orifice"
    annotation (Dialog(group="Orifice"));
  parameter SI.Length C_0=0.1*C_1 "Perimeter of vena contraction"
    annotation (Dialog(group="Orifice"));
  parameter SI.Length C_1=PI*0.01 "Small perimeter of orifice"
    annotation (Dialog(group="Orifice"));
  parameter SI.Length L=1e-3 "Length of vena contraction"
    annotation (Dialog(group="Orifice"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.ThickEdgedOverall.PressureLossInput_con
    IN_con(
    A_0=A_0,
    A_1=A_1,
    C_0=C_0,
    C_1=C_1,
    L=L,
    dp_smooth=dp_smooth)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.ThickEdgedOverall.PressureLossInput_var
    IN_var(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  parameter SI.Pressure dp_smooth=1
    "Start linearisation for decreasing pressure loss"
    annotation (Dialog(group="Numerical aspects"));
equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.ThickEdgedOverall.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);

  dp = dp_tot;
end ThickEdgedOverallFlowModel;
