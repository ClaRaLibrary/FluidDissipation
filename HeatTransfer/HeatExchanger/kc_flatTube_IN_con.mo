within FluidDissipation.HeatTransfer.HeatExchanger;
record kc_flatTube_IN_con "Input record for function kc_heatExchanger and kc_heatExchanger_KC"
  extends Modelica.Icons.Record;

  FluidDissipation.Utilities.Types.HTXGeometry_flatTubes geometry=
      FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin "Choice of fin geometry"
                             annotation (Dialog(group="HeatExchanger"));

  SI.Area A_fr=0 "Frontal area" annotation (Dialog(group="HeatExchanger"));
  SI.Length D_h=0 "Hydraulic diameter" annotation (Dialog(group="HeatExchanger",
        enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
                true else false));
  SI.Length D_m=0 "Major tube diameter for flat tube"
    annotation (Dialog(group="HeatExchanger"));
  SI.Length F_l=0 "Fin length" annotation (Dialog(group="HeatExchanger", enable=
         if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  SI.Length F_p=0 "Fin pitch, fin spacing + fin thickness" annotation (Dialog(
        group="HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  SI.Length L_l=0 "Louver length" annotation (Dialog(group="HeatExchanger",
        enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  SI.Length L_p=0 "Louver pitch" annotation (Dialog(group="HeatExchanger",
        enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  SI.Length T_d=0 "Tube depth" annotation (Dialog(group="HeatExchanger", enable=
         if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));
  SI.Length T_p=0 "Tube pitch" annotation (Dialog(group="HeatExchanger", enable=
         if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));

  Real alpha=0 "Lateral fin spacing (s) / free flow height (h)" annotation (
      Dialog(group="HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
                true else false));
  Real gamma=0 "Fin thickness (t) / lateral fin spacing (s)" annotation (Dialog(
        group="HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
                true else false));
  Real delta=0 "Fin thickness (t) / Fin length (l)" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFinn then
                true else false));
  SI.Length delta_f=0 "Fin thickness" annotation (Dialog(group="HeatExchanger",
        enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin then
                true else false));
  SI.Angle Phi=0 "Louver angle" annotation (Dialog(group="HeatExchanger",
        enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin then
                true else false));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube\"> kc_flatTube </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_KC\"> kc_flatTube_KC </a>.
</html>"));

end kc_flatTube_IN_con;
