within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.NominalPressureLossLawDensity;
model NominalPressureLossLawDensityFlowModel
  "NominalPressureLossLawDensity: Application flow model for generic function in Modelica.Fluid"

  //base flow model
  extends
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.BaseGeneralPL.BaseGeneralModel;

  //pressure loss calculation
  FluidDissipation.Utilities.Types.MassOrVolumeFlowRate target=FluidDissipation.Utilities.Types.MassOrVolumeFlowRate.MassFlowRate
    "1 == use nominal mass flow rate | 2 == use nominal volume flow rate"
    annotation (Dialog(group="Generic variables"));

  parameter SI.Area A_cross=A_cross_nom "Cross sectional area"
    annotation (Dialog(group="Generic variables"));
  parameter SI.Area A_cross_nom=Modelica.Constants.pi*0.1^2/4
    "Nominal cross sectional area"
    annotation (Dialog(group="Generic variables"));
  parameter SI.Pressure dp_nom=2
    "Nominal pressure loss (at nominal values of mass flow rate and density)"
    annotation (Dialog(group="Generic variables"));
  parameter SI.MassFlowRate m_flow_nom=1
    "Nominal mass flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables"));
  parameter Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));
  parameter SI.VolumeFlowRate V_flow_nom=m_flow_nom/rho_nom
    "Nominal volume flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables",enable=not (
          target==FluidDissipation.Utilities.Types.MassOrVolumeFlowRate.MassFlowRate)));
  parameter SI.Density rho_nom=1e3
    "Nominal density (at nominal values of mass flow rate and pressure loss)"
    annotation (Dialog(group="Generic variables"));
  parameter FluidDissipation.Utilities.Types.PressureLossCoefficient zeta_TOT=
      zeta_TOT_nom "Pressure loss coefficient"
    annotation (Dialog(group="Generic variables"));
  parameter FluidDissipation.Utilities.Types.PressureLossCoefficient zeta_TOT_nom=0.02*1/
      0.1 "Nominal pressure loss coefficient (for nominal values)"
    annotation (Dialog(group="Generic variables"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.NominalPressureLossLawDensity.PressureLossInput_con
    IN_con(
    final exp=exp,
    final m_flow_nom=m_flow_nom,
    final target=target,
    final A_cross=A_cross,
    final A_cross_nom=A_cross_nom,
    final dp_nom=dp_nom,
    final V_flow_nom=V_flow_nom,
    final rho_nom=rho_nom,
    final zeta_TOT_nom=zeta_TOT_nom)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.NominalPressureLossLawDensity.PressureLossInput_var
    IN_var(final zeta_TOT=zeta_TOT, final rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.NominalPressureLossLawDensity.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);

end NominalPressureLossLawDensityFlowModel;
