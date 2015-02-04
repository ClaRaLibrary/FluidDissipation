within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel.BaseChannelHT;
record HeatTransferChannel_con "Input record for channel functions"

  extends FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_con;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer functions of <a href=\"Modelica://FluidDissipation.HeatTransfer.Channel\"> channels </a> implemented in Modelica_Fluid as thermo-hydraulic framework.
</html>"));
end HeatTransferChannel_con;
