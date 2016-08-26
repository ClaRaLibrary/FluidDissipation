within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.FlatTube;
model FlatTubeFlowModel "Flat tube: Application flow model for heat exchanger function in Modelica.Fluid"

  //base flow model
  extends FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.BaseHeatExchangerPL.BaseHeatExchangerModel;

  //pressure loss calculation
  parameter FluidDissipation.Utilities.Types.HTXGeometry_flatTubes geometry=
      FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin "Choice of fin geometry"
                             annotation (Dialog(group="HeatExchanger"));

  parameter SI.Area A_fr=0.1 "Frontal area"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length D_h=0.0025 "Hydraulic diameter" annotation (Dialog(
        group="HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
                true else false));
  parameter SI.Length D_m=0.005 "Major tube diameter for flat tube"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length F_d=0.02 "Fin depth" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Length F_l=0.02 "Fin length" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Length F_p=0.002 "Fin pitch, fin spacing + fin thickness"
    annotation (Dialog(group="HeatExchanger", enable=if geometry ==
          FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Length L=0.1 "Heat exchanger length"
    annotation (Dialog(group="HeatExchanger"));
  parameter SI.Length L_l=0.0015 "Louver length" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Length L_p=0.0015 "Louver pitch" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Length T_p=0.02 "Tube pitch" annotation (Dialog(group=
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
  parameter Real delta=0.3 "Fin thickness (t) / Fin length (l)" annotation (
      Dialog(group="HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
                true else false));
  parameter SI.Length delta_f=0.0001 "Fin thickness" annotation (Dialog(group=
         "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  parameter SI.Angle Phi=10*PI/180 "Louver angle" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.FlatTube.PressureLossInput_con
    IN_con(
    geometry=geometry,
    A_fr=A_fr,
    D_h=D_h,
    D_m=D_m,
    F_d=F_d,
    F_l=F_l,
    F_p=F_p,
    L=L,
    L_l=L_l,
    L_p=L_p,
    T_p=T_p,
    alpha=alpha,
    gamma=gamma,
    delta=delta,
    Phi=Phi,
    delta_f=delta_f)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.FlatTube.PressureLossInput_var
    IN_var(final eta=eta, final rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  dp =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.FlatTube.pressureLoss_mflow(
    IN_con,
    IN_var,
    m_flow);

  annotation (Diagram(graphics));
end FlatTubeFlowModel;
