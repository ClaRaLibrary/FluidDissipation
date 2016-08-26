within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.RoundTube;
model RoundTubeFlowModel "Round tube: Application flow model for heat exchanger function in Modelica.Fluid"

  //base flow model
  extends FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.BaseHeatExchangerPL.BaseHeatExchangerModel;

  //pressure loss calculation
  parameter FluidDissipation.Utilities.Types.HTXGeometry_roundTubes geometry=
      FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin "Choice of fin geometry"
                             annotation (Dialog(group="HeatExchanger"));

  parameter SI.Area A_fr=0.1 "Frontal area"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length D_c=0.01 "Fin collar diameter"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length F_p=0.002 "Fin pitch, fin spacing + fin thickness"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length L=N*P_l "Heat exchanger length"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length L_h=0.0015 "Louver height" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin then
                true else false));
  parameter SI.Length L_p=0.0025 "Louver pitch" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin then
                true else false));
  parameter Integer N=2 "Number of tube rows"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length P_d=0.0015 "Pattern depth of wavy fin, wave height"
    annotation (Dialog(group="HeatExchanger", enable=if geometry ==
          FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin then
                true else false));
  parameter SI.Length P_l=0.02 "Longitudinal tube pitch" annotation (Dialog(
        group="HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin then
                true else false));
  parameter SI.Length P_t=0.025 "Transverse tube pitch"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length X_f=0.005 "Half wave length of wavy fin" annotation (
      Dialog(group="HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin then
                true else false));

  parameter SI.Length delta_f=0.0001 "Fin thickness"
    annotation (Dialog(group="HeatExchanger"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.RoundTube.PressureLossInput_con
    IN_con(
    geometry=geometry,
    A_fr=A_fr,
    D_c=D_c,
    F_p=F_p,
    L=L,
    L_h=L_h,
    L_p=L_p,
    N=N,
    P_d=P_d,
    P_l=P_l,
    P_t=P_t,
    X_f=X_f,
    delta_f=delta_f)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.RoundTube.PressureLossInput_var
    IN_var(final eta=eta, final rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  dp =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.RoundTube.pressureLoss_mflow(
    IN_con,
    IN_var,
    m_flow);

  annotation (Diagram(graphics));
end RoundTubeFlowModel;
