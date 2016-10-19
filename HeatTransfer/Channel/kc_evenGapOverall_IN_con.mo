within FluidDissipation.HeatTransfer.Channel;
record kc_evenGapOverall_IN_con
  "Input record for function kc_evenGapOverall and kc_evenGapOverall_KC"

  //even gap variables
  extends FluidDissipation.Utilities.Records.HeatTransfer.EvenGap;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall\"> kc_evenGapOverall </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_KC\"> kc_evenGapOverall_KC </a>.
</html>"));
end kc_evenGapOverall_IN_con;
