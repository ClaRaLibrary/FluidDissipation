within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.FilmCondensationTubeBundle;
model FilmCondensationTubeBundleHeatTransferModel
  "Application heat transfer model for laminar film condensation in a Tube bundle heat exchanger in Modelica.Fluid"

  extends
    FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.BaseHeatExchangerHT.BaseHeatExchangerModel_TwoPhase(
      final T_w=thermalPort.T);

  parameter SI.Area A_fr = 1 "Frontal Area" annotation (Dialog(group="HeatExchanger"));
  parameter Modelica.SIunits.Length d = 0.005 "Diameter of the bundle's tubes" annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length L=2*P_l "Heat exchanger length" annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length P_l=0.02 "Longitudinal tube pitch" annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length P_t = 0.025 "Transverse tube pitch" annotation (Dialog(group="HeatExchanger"));
  parameter Real C = 1
    "Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8"
                                                                                    annotation (Dialog(group="HeatExchanger"));

  HeatTransferHeatExchanger_con IN_con(
    d=d,
    A_front=A_fr,
    C=C)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  HeatTransferHeatExchanger_var IN_var(
    cp_l=cp_l,
    lambda_l=lambda_l,
    rho_g=rho_g,
    rho_l=rho_l,
    eta_g=eta_g,
    eta_l=eta_l,
    dh_lg=dh_lg,
    m_flow=m_flow,
    T_s=T_s,
    T_w=T_w)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  SI.Area A_kc = 2*Modelica.Constants.pi*IN_con.d*A_fr*L/P_t/P_l
    "Heat transfer area for convective heat transfer coefficient (kc)";

  SI.Velocity velocity = abs(m_flow)/max(Modelica.Constants.eps, (IN_var.rho_g*A_fr))
    "Mean velocity";

equation
  kc = coefficientOfHeatTransfer(IN_con, IN_var);

  //heat transfer rate is negative if outgoing out of system
  thermalPort.Q_flow = kc*A_kc*(T_w - T_s);

end FilmCondensationTubeBundleHeatTransferModel;
