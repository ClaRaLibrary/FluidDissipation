within FluidDissipation.HeatTransfer.HelicalPipe;
record kc_overall_IN_con
  "Input record for function kc_overall and kc_overall_KC"

  //helical pipe variables
  extends FluidDissipation.Utilities.Records.HeatTransfer.HelicalPipe;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.HelicalPipe.kc_overall\"> kc_overall </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.HelicalPipe.kc_overall_KC\"> kc_overall_KC </a>.
</html>"));
end kc_overall_IN_con;
