within FluidDissipation.Utilities.Records.HeatTransfer;
record TwoPhaseFlowConvectiveBoiling_IN_con
  extends Modelica.Icons.Record;
  Modelica.SIunits.Pressure p_crit=220.64e5 "Pressure at critical point" annotation (Dialog(group="Fluid properties"));
  String orientation="Vertical" "Geometric orientation" annotation (choices(choice="Vertical" "Vertical, i.e. tilt angle > 30", choice="Horizontal" "Horizontal, i.e. tilt angle < 30"), Dialog(group="Geometry"));
  String boundary="Fixed heating" "Boundary condition" annotation (choices(choice="Fixed heating" "Fixed Heating", choice="Fixed temperature" "Fixed temperature"), Dialog(group="Boundary"));
  Modelica.SIunits.Length s=0.005 "Wall thickness"
                                                  annotation (Dialog(group="Geometry"));
  Modelica.SIunits.Length d_hyd=0.01 "Hydraulic Diameter" annotation (Dialog(group="Geometry"));
end TwoPhaseFlowConvectiveBoiling_IN_con;
