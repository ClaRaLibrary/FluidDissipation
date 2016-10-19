within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.VolumeFlowRate;
model VolumeFlowRateFlowModel
  "VolumeFlowRate: Application flow model for generic function in Modelica.Fluid"

  //base flow model
  extends
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.BaseGeneralPL.BaseGeneralModel;

  //pressure loss calculation
  parameter Real a=15 "Coefficient for quadratic term"
    annotation (Dialog(group="Generic variables"));
  parameter Real b=0 "Coefficient for linear term"
    annotation (Dialog(group="Generic variables"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.VolumeFlowRate.PressureLossInput_con
    IN_con(
    a=a,
    b=b,
    dp_min=dp_small)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.VolumeFlowRate.PressureLossInput_var
    IN_var(rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.VolumeFlowRate.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);

end VolumeFlowRateFlowModel;
