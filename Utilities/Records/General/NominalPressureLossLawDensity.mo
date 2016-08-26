within FluidDissipation.Utilities.Records.General;
record NominalPressureLossLawDensity "Base record for generic pressure loss function"

  extends Modelica.Icons.Record;

  //NominalMassFlowRate
  FluidDissipation.Utilities.Types.MassOrVolumeFlowRate target=FluidDissipation.Utilities.Types.MassOrVolumeFlowRate.MassFlowRate "1 == use nominal mass flow rate | 2 == use nominal volume flow rate"
    annotation (Dialog(group="Generic variables"));

  parameter SI.Area A_cross=A_cross_nom "Cross sectional area"
    annotation (Dialog(group="Generic variables"));
  parameter SI.Area A_cross_nom=Modelica.Constants.pi*0.1^2/4 "Nominal cross sectional area"
    annotation (Dialog(group="Generic variables"));

  parameter SI.Pressure dp_nom(min=Modelica.Constants.eps) = 2 "Nominal pressure loss (at nominal values of mass flow rate and density)"
    annotation (Dialog(group="Generic variables"));
  parameter SI.MassFlowRate m_flow_nom(min=Modelica.Constants.eps) = 1 "Nominal mass flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables",enable=target ==
          FluidDissipation.Utilities.Types.MassOrVolumeFlowRate.MassFlowRate));
  parameter Real exp(min=Modelica.Constants.eps) = 2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));

  SI.VolumeFlowRate V_flow_nom(min=Modelica.Constants.eps) = m_flow_nom/rho_nom "Nominal volume flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables",enable=not (target ==
          FluidDissipation.Utilities.Types.MassOrVolumeFlowRate.MassFlowRate)));
  SI.Density rho_nom(min=Modelica.Constants.eps) = 1e3 "Nominal density (at nominal values of mass flow rate and pressure loss)"
    annotation (Dialog(group="Generic variables"));

  Types.PressureLossCoefficient zeta_TOT=zeta_TOT_nom "Pressure loss coefficient"
                                annotation (Dialog(group="Generic variables"));
  parameter Types.PressureLossCoefficient zeta_TOT_nom=0.02*1/0.1 "Nominal pressure loss coefficient (for nominal values)"
    annotation (Dialog(group="Generic variables"));

end NominalPressureLossLawDensity;
