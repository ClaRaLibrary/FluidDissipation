within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.CorrugatedPlate_1ph;
model FlatTubeFlowModel "Flat tube: Application flow model for heat exchanger function in Modelica.Fluid"

  //base flow model
  extends FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.BaseHeatExchangerPL.BaseHeatExchangerModel;

  //pressure loss calculation
  Integer channels(min = 1) = 10 "number of paralell flown channels per fluid" annotation (Dialog(group="HeatExchanger"));
  SI.Length Length(min=1e-2)=0.3 "length of the heat exchanger plates in flow direction (header center to header center)"
                                                                                             annotation (Dialog(group="HeatExchanger"));
  SI.Length Width(min=1e-2)=0.1 "width of the heat exchanger plates in flow direction"
                                                           annotation (Dialog(group="HeatExchanger"));
  SI.Length amp(min=1e-10) = 2e-3 "amplitude of corrugated plate" annotation (Dialog(group="HeatExchanger"));
  SI.Length Lambda(min=1e-10) = 2*Modelica.Constants.pi*amp "wave length of corrugated plate";
  SI.Angle phi = 45/180*Modelica.Constants.pi "Corrugation angle" annotation (Dialog(group="HeatExchanger"));

  Real a = 3.8 "Friction loss parameter (default value from literature)" annotation (Dialog(group="Adaption to measurement data"));
  Real b = 0.18 "Friction loss parameter (default value from literature)" annotation (Dialog(group="Adaption to measurement data"));
  Real c = 0.36 "Friction loss parameter (default value from literature)" annotation (Dialog(group="Adaption to measurement data"));

  //numerical aspects
  SI.Velocity velocity_small=1e-8 "Regularisation for a velocity smaller then velocity_small"
    annotation (Dialog(group="Numerical aspects"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.CorrugatedPlate_1ph.PressureLossInput_con
    IN_con(
    channels=channels,
    Length=channels,
    Width=Width,
    amp=amp,
    phi=phi,
    a=a,
    b=b,
    c=c,
    velocity_small=velocity_small)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.CorrugatedPlate_1ph.PressureLossInput_var
    IN_var(final eta=eta, final rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  dp =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.CorrugatedPlate_1ph.pressureLoss_mflow(
    IN_con,
    IN_var,
    m_flow);

  annotation (Diagram(graphics));
end FlatTubeFlowModel;
