within FluidDissipation.HeatTransfer.StraightPipe;
record kc_overall_IN_var "Input record for function kc_overall and kc_overall_KC"

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties;

  //input variable (mass flow rate)
  SI.MassFlowRate m_flow annotation (Dialog(group="Input"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.StraightPipe.kc_overall\"> kc_overall </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.StraightPipe.kc_overall_KC\"> kc_overall_KC </a>.
</html>"));
end kc_overall_IN_var;
