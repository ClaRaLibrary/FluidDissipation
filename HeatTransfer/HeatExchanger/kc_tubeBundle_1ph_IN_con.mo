within FluidDissipation.HeatTransfer.HeatExchanger;
record kc_tubeBundle_1ph_IN_con "Input record for function kc_tubeBundle_1ph and kc_tubeBundle_1ph_KC"
 extends Modelica.Icons.Record;
  Modelica.SIunits.Area A_front(min=1e-6)=1 "Cross sectional area in front of the tube row or bundle"
    annotation (Dialog(group="Geometry"));
  Modelica.SIunits.Length d(min=1e-6) = 0.02 "Outer diameter of tubes"
    annotation (Dialog(group="Geometry"));
  Modelica.SIunits.Length s_1(min=2*1e-6) = 0.03 "Distance between tubes (center to center) orthogonal to flow direction"
    annotation (Dialog(group="Geometry"));
  Modelica.SIunits.Length s_2(min=0) = 0.026 "Distance between tubes (center to center) parallel to flow direction"
    annotation (Dialog(group="Geometry"));
  Boolean staggeredAlignment "True, if the tubes are aligned staggeredly, false otherwise | don't care for single row"
    annotation (Dialog(group="Geometry"));
  Integer n(min=1) = 1 "Number of pipe rows in flow direction"
    annotation (Dialog(group="Geometry"));
end kc_tubeBundle_1ph_IN_con;
