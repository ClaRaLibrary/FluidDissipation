within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.IdealGas;
model IdealGasFlowModel "IdealGas: Application flow model for generic function in Modelica.Fluid"

  //base flow model
  extends FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.BaseGeneralPL.BaseGeneralModel;

  //pressure loss calculation
  parameter Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));
  parameter Real Km=R_s*(2e3)/((10)^exp/rho_m) "Coefficient for pressure loss law [(Pa)^2/{(kg/s)^exp*K}]"
    annotation (Dialog(group="Generic variables"));
  parameter SI.SpecificHeatCapacity R_s=287 "Specific gas constant of ideal gas"
    annotation (Dialog(group="Generic variables"));
  parameter SI.Density rho_m=p_m/(R_s*T_m) "Mean density of ideal gas"
    annotation (Dialog(group="Generic variables"));
  parameter SI.Temp_K T_m=(293 + 293)/2 "Mean temperature of ideal gas"
    annotation (Dialog(group="Generic variables"));
  parameter SI.Pressure p_m=(1e5 + 1e5)/2 "Mean pressure of ideal gas"
    annotation (Dialog(group="Generic variables"));

  //linearisation
  parameter SI.Pressure dp_smooth=1e-3 "Start linearisation for decreasing pressure loss"
    annotation (Dialog(group="Linearisation"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.IdealGas.PressureLossInput_con
    IN_con(
    exp=exp,
    R_s=R_s,
    Km=Km,
    dp_smooth=dp_smooth)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.IdealGas.PressureLossInput_var
    IN_var(
    rho_m=rho_m,
    T_m=T_m,
    p_m=p_m) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.IdealGas.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);

end IdealGasFlowModel;
