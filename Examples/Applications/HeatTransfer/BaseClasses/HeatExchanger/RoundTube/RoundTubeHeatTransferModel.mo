within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.RoundTube;
model RoundTubeHeatTransferModel
  "Round tube heat exchanger: Application heat transfer model for round tube function in Modelica.Fluid"
  extends
    FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.BaseHeatExchangerHT.BaseHeatExchangerModel;

  FluidDissipation.Utilities.Types.HTXGeometry_roundTubes geometry=
      FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin
    "Choice of fin geometry" annotation (Dialog(group="HeatExchanger"));

  parameter SI.Area A_fr=1 "Frontal Area"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length D_c=0.01 "Fin collar diameter"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length F_p=0.002 "Fin pitch, fin spacing + fin thickness"
    annotation (Dialog(group="HeatExchanger", enable=if geometry ==
          FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin then
                true else false));
  parameter SI.Length L=N*P_l "Heat exchanger length"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length L_h=0.0015 "Louver height" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin then
                true else false));
  parameter SI.Length L_p=0.0025 "Louver pitch" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin then
                true else false));
  parameter Integer N=2 "Number of tube rows" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin then
                true else false));
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
  parameter SI.Length S_h=0.001 "Slit height" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin then
                true else false));
  parameter SI.Length S_p=0.002 "Slit pitch" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin then
                true else false));
  parameter SI.Length X_f=0.005 "Half wave length of wavy fin" annotation (
      Dialog(group="HeatExchanger", enable=if geometry ==
          FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin then
                true else false));

  parameter SI.Length delta_f=0.0001 "Fin thickness" annotation (Dialog(group=
         "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin then
                true else false));

  HeatTransferHeatExchanger_con IN_con(
    geometry=geometry,
    A_fr=A_fr,
    D_c=D_c,
    F_p=F_p,
    L_h=L_h,
    L_p=L_p,
    P_d=P_d,
    P_l=P_l,
    P_t=P_t,
    N=N,
    X_f=X_f,
    delta_f=delta_f,
    L=L,
    S_h=S_h,
    S_p=S_p)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  HeatTransferHeatExchanger_var IN_var(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  SI.Area A_cross=A_fr*((F_p*P_t - F_p*D_c - (P_t - D_c)*delta_f)/(F_p*P_t))
    "Minimum flow cross-sectional area";
  SI.Length D_h=if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin
                                                                                       then
            4*A_cross/(A_fr*(2*(P_t - D_c + F_p)/(F_p*(P_t - D_c)))) else 0
    "Hydraulic diameter";

  SI.Area A_kc=if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin
       or geometry ==FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin
       or geometry ==FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin  then
            A_fr*((N*PI*D_c*(F_p - delta_f) + 2*(P_t*L - N*PI*D_c^2/4))/(P_t*
      F_p)) else if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin
                                                                                       then
            A_fr*((N*PI*D_c*(F_p - delta_f) + 2*(P_t*L - N*PI*D_c^2/4)*(sqrt(
      X_f^2 + P_d^2)/X_f))/(P_t*F_p)) else 0
    "Heat transfer area for convective heat transfer coefficient (kc)";

  SI.Velocity velocity=abs(m_flow)/max(Modelica.Constants.eps, (rho*A_cross))
    "Mean velocity";

  SI.ReynoldsNumber Re=rho*velocity*D_c/eta
    "Reynolds number based on fin collar diameter";
  SI.NusseltNumber Nu=kc*D_c/lambda "Nusselt number";

equation
  kc = coefficientOfHeatTransfer(IN_con, IN_var);

  //heat transfer rate is negative if outgoing out of system
  thermalPort.Q_flow = kc*A_kc*(thermalPort.T - T);

end RoundTubeHeatTransferModel;
