within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.FlatTube;
model FlatTubeHeatTransferModel
  "Flat tube heat exchanger: Application heat transfer model for flat tube function in Modelica.Fluid"
  extends
    FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.BaseHeatExchangerHT.BaseHeatExchangerModel;

  parameter FluidDissipation.Utilities.Types.HTXGeometry_flatTubes geometry=
      FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin
    "Choice of fin geometry" annotation (Dialog(group="HeatExchanger"));

  parameter SI.Area A_fr=1 "Frontal Area"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length D_h=0.0025 "Hydraulic diameter" annotation (Dialog(
        group="HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
                true else false));
  parameter SI.Length D_m=0.002 "Major tube diameter for flat tube"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length F_l=0.01 "Fin length" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Length F_p=0.0015 "Fin pitch, fin spacing + fin thickness"
    annotation (Dialog(group="HeatExchanger", enable=if geometry ==
          FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Length L=0.1 "Heat exchanger length"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length L_l=0.001 "Louver length" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Length L_p=0.0025 "Louver pitch" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Length T_d=0.02 "Tube depth" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Length T_p=0.01 "Tube pitch" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));

  parameter Real alpha=0.25 "Lateral fin spacing (s) / free flow height (h)"
    annotation (Dialog(group="HeatExchanger", enable=if geometry ==
          FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
                true else false));
  parameter Real gamma=0.07 "Fin thickness (t) / lateral fin spacing (s)"
    annotation (Dialog(group="HeatExchanger", enable=if geometry ==
          FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
                true else false));
  parameter Real delta=0.03 "Fin thickness (t) / Fin length (l)" annotation (
      Dialog(group="HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
                true else false));
  parameter SI.Length delta_f=0.0001 "Fin thickness" annotation (Dialog(group=
         "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Angle Phi=10*PI/180 "Louver angle" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then true else false));

  HeatTransferHeatExchanger_con IN_con(
    geometry=geometry,
    A_fr=A_fr,
    D_h=D_h,
    D_m=D_m,
    F_l=F_l,
    F_p=F_p,
    L_l=L_l,
    L_p=L_p,
    T_d=T_d,
    T_p=T_p,
    alpha=alpha,
    gamma=gamma,
    delta=delta,
    delta_f=delta_f,
    Phi=Phi)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  HeatTransferHeatExchanger_var IN_var(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  SI.Area A_cross=if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin
                                                                                       then
            A_fr*((F_l - delta_f)*(F_p - delta_f)/((F_l + D_m)*F_p)) else if
      geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
            A_fr*(h*s/((h + t + D_m)*(s + t))) else 0
    "Minimum flow cross-sectional area";
  SI.Length h=if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin
                                                                                       then
            D_h*(1 + alpha)/(2*alpha) else 0 "Free flow height";
  SI.Length l=if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin
                                                                                       then
            t/delta else 0 "Fin length";
  SI.Length s=if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin
                                                                                       then
            h*alpha else 0 "Lateral fin spacing (free flow width)";
  SI.Length t=if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin
                                                                                       then
            s*gamma else 0 "Fin thickness";

  SI.Area A_kc=if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin
                                                                                       then
            L*A_fr*(2*(F_l + F_p - delta_f)/(F_p*(F_l + D_m))) else if
      geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
            L*A_fr*(2*(h + s)/((s + t)*(h + t + D_m))) else 0
    "Heat transfer area for convective heat transfer coefficient (kc)";

  SI.Velocity velocity=abs(m_flow)/max(Modelica.Constants.eps, (rho*A_cross))
    "Mean velocity";

  SI.ReynoldsNumber Re=if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin
                                                                                       then
            rho*velocity*L_p/eta else if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin  then
            rho*velocity*D_h/eta else 0
    "Reynolds number based on characteristic length";
  SI.NusseltNumber Nu=if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin
                                                                                       then
            kc*L_p/lambda else if geometry ==FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin  then
            kc*D_h/lambda else 0 "Nusselt number";

equation
  kc = coefficientOfHeatTransfer(IN_con, IN_var);

  //heat transfer rate is negative if outgoing out of system
  thermalPort.Q_flow = kc*A_kc*(thermalPort.T - T);

end FlatTubeHeatTransferModel;
