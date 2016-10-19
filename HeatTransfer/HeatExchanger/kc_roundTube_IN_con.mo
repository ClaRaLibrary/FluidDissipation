within FluidDissipation.HeatTransfer.HeatExchanger;
record kc_roundTube_IN_con
  "Input record for function kc_roundTube and kc_roundTube_KC"
  extends Modelica.Icons.Record;

  FluidDissipation.Utilities.Types.HTXGeometry_roundTubes geometry=
      FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin
    "Choice of fin geometry" annotation (Dialog(group="HeatExchanger"));

  SI.Area A_fr=0 "Frontal area" annotation (Dialog(group="HeatExchanger"));
  SI.Length D_c=0 "Fin collar diameter"
    annotation (Dialog(group="HeatExchanger"));
  SI.Length F_p=0 "Fin pitch, fin spacing + fin thickness"
    annotation (Dialog(group="HeatExchanger"));
  SI.Length L=0 "Heat exchanger length" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin then
                true else false));
  SI.Length L_h=0 "Louver height" annotation (Dialog(group="HeatExchanger",
        enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin then
                true else false));
  SI.Length L_p=0 "Louver pitch" annotation (Dialog(group="HeatExchanger",
        enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin then
                true else false));
  Integer N=0 "Number of tube rows" annotation (Dialog(group="HeatExchanger",
        enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin then
                true else false));
  SI.Length P_d=0 "Pattern depth of wavy fin, wave height" annotation (Dialog(
        group="HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin then
                true else false));
  SI.Length P_l=0 "Longitudinal tube pitch" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin
           or geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin then
                true else false));
  SI.Length P_t=0 "Transverse tube pitch"
    annotation (Dialog(group="HeatExchanger"));
  SI.Length S_h=0 "Slit height" annotation (Dialog(group="HeatExchanger",
        enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin then
                true else false));
  SI.Length S_p=0 "Slit pitch" annotation (Dialog(group="HeatExchanger", enable=
         if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin then
                true else false));
  SI.Length X_f=0 "Half wave length of wavy fin" annotation (Dialog(group=
          "HeatExchanger", enable=if geometry == FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin then
                true else false));

  SI.Length delta_f=0 "Fin thickness" annotation (Dialog(group="HeatExchanger"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube\"> kc_roundTube </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_KC\"> kc_roundTube_KC </a>.
</html>"));

end kc_roundTube_IN_con;
