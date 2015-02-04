within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.PressureLossCoefficient;
model PressureLossCoefficientFlowModel
  "PressureLossCoefficient: Application flow model for generic function in Modelica.Fluid"

  //base flow model
  extends
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.BaseGeneralPL.BaseGeneralModel;

  //pressure loss calculation
  parameter SI.Area A_cross=Modelica.Constants.pi*0.1^2/4
    "cross sectional area" annotation (Dialog(group="Generic variables"));
  parameter FluidDissipation.Utilities.Types.PressureLossCoefficient zeta_TOT=0.5
    "pressure loss coefficient" annotation (Dialog(group="Generic variables"));

  //linearisation
  parameter SI.Pressure dp_smooth=1e-3
    "Start linearisation for decreasing pressure loss"
    annotation (Dialog(group="Linearisation"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.PressureLossCoefficient.PressureLossInput_con
    IN_con(final A_cross=A_cross, final dp_smooth=dp_smooth)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.PressureLossCoefficient.PressureLossInput_var
    IN_var(final zeta_TOT=zeta_TOT, final rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.PressureLossCoefficient.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);

end PressureLossCoefficientFlowModel;
