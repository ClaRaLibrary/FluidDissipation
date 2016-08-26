within FluidDissipation.Utilities.Records.PressureLoss;
record Tjunction "Input for T-junction"
  extends Modelica.Icons.Record;

  //T-junction variables
  Boolean united_converging_crossection=true "true == A_cross_total = 2*A_cross_branch | false == A_cross_total > 2*A_cross_branch"
    annotation (Dialog(group="T-junction"));
  Boolean velocity_reference_branches=true "true == pressure loss coefficents w.r.t. velocity in each passage | false == w.r.t velocity in total passage"
    annotation (Dialog(group="T-junction"));

  /*Integer alpha=90 "Angle of branching" annotation (Dialog(group="T-junction"));*/
  Real alpha=90 "Angle of branching" annotation (Dialog(group="T-junction"));

  SI.Diameter d_hyd[3]=ones(3)*0.1 "Hydraulic diameter of passages [side,straight,total]"
    annotation (Dialog(group="T-junction"));

  //restrictions
  SI.MassFlowRate m_flow_min=1e-3 "Restriction for smoothing at reverse fluid flow"
    annotation (Dialog(group="Restrictions"));
  SI.Velocity v_max=2e2 "Restriction for maximum fluid flow velocity"
    annotation (Dialog(group="Restrictions"));
  Real zeta_TOT_max=1e3 "Restriction for maximum value of pressure loss coefficient"
    annotation (Dialog(group="Restrictions"));
end Tjunction;
