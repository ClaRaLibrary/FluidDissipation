within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.NominalDensityViscosity;
model NominalDensityViscosityFlowModel
  "NominalDensityViscosity: Application flow model for generic function in Modelica.Fluid"

  //base flow model
  extends
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.BaseGeneralPL.BaseGeneralModel;

  //pressure loss calculation
  parameter SI.Pressure dp_nom=2
    "Nominal pressure loss (at nominal values of mass flow rate and density)"
    annotation (Dialog(group="Generic variables"));
  parameter Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));
  parameter SI.MassFlowRate m_flow_nom=1
    "Nominal mass flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables"));
  parameter SI.Density rho_nom=1e3
    "Nominal density (at nominal values of mass flow rate and pressure loss)"
    annotation (Dialog(group="Generic variables"));
  parameter Real exp_eta=1 "Exponent for dynamic viscosity dependence"
    annotation (Dialog(group="Generic variables"));
  parameter SI.DynamicViscosity eta_nom=1e-3
    "Dynamic viscosity at nominal pressure loss"
    annotation (Dialog(group="Generic variables"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.NominalDensityViscosity.PressureLossInput_con
    IN_con(
    dp_nom=dp_nom,
    exp=exp,
    m_flow_nom=m_flow_nom,
    rho_nom=rho_nom,
    exp_eta=exp_eta,
    eta_nom=eta_nom)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.NominalDensityViscosity.PressureLossInput_var
    IN_var(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.NominalDensityViscosity.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);

end NominalDensityViscosityFlowModel;
