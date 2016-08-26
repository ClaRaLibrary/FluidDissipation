within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Valve.Overall;
model OverallFlowModel "Valve (overall): Application flow model for valve function in Modelica.Fluid"

  //base flow model
  extends FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Valve.BaseValvePL.BaseValveModel;

  //pressure loss calculation
  FluidDissipation.Utilities.Types.ValveGeometry geometry=FluidDissipation.Utilities.Types.ValveGeometry.Ball "Choice of geometry for valve"
                                   annotation (Dialog(group="Valve"));
  FluidDissipation.Utilities.Types.ValveCoefficient valveCoefficient=
      FluidDissipation.Utilities.Types.ValveCoefficient.AV "Choice of valve coefficient"
                                  annotation (Dialog(group="Valve"));

  parameter Real opening=1 "Opening of valve | 0==closed and 1== fully opened"
    annotation (Dialog(group="Valve"));
  parameter Real Av=PI*0.1^2/4 "Av (metric) flow coefficient [Av]=m^2"
    annotation (Dialog(group="Valve"));
  parameter Real Kv=Av/27.7e-6 "Kv (metric) flow coefficient [Kv]=m^3/h"
    annotation (Dialog(group="Valve"));
  parameter Real Cv=Av/24.6e-6 "Cv (US) flow coefficient [Cv]=USG/min"
    annotation (Dialog(group="Valve"));
  parameter SI.Pressure dp_nominal=1e3 "Nominal pressure loss"
    annotation (Dialog(group="Valve"));
  parameter SI.MassFlowRate m_flow_nominal=opening_nominal*Av*(rho_nominal*
      dp_nominal)^0.5 "Nominal mass flow rate"
    annotation (Dialog(group="Valve"));
  parameter Real opening_nominal=0.5 "Nominal opening"
    annotation (Dialog(group="Valve"));
  parameter Real zeta_tot_min=1e-3 "Minimal pressure loss coefficient at full opening"
    annotation (Dialog(group="Valve"));
  parameter Real zeta_tot_max=1e2 "Maximum pressure loss coefficient at closed opening"
    annotation (Dialog(group="Valve"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Valve.Overall.PressureLossInput_con
    IN_con(
    geometry=geometry,
    valveCoefficient=valveCoefficient,
    Av=Av,
    Kv=Kv,
    Cv=Cv,
    dp_nominal=dp_nominal,
    m_flow_nominal=m_flow_nominal,
    rho_nominal=rho_nominal,
    opening_nominal=opening_nominal,
    dp_small=dp_small,
    zeta_tot_min=zeta_tot_min,
    zeta_tot_max=zeta_tot_max)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Valve.Overall.PressureLossInput_var
    IN_var(
    opening=opening,
    rho=rho,
    eta=eta) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Valve.Overall.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);

  annotation (Diagram(graphics));
end OverallFlowModel;
