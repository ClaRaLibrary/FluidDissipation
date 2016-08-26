within FluidDissipation.HeatTransfer.Channel;
record kc_evenGapTurbulent_IN_con "Input record for function kc_evenGapTurbulentRoughness and kc_evenGapTurbulentRoughness_KC"

  extends FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_con(final
      target=FluidDissipation.Utilities.Types.kc_evenGap.DevBoth);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent\"> kc_evenGapTurbulent </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent_KC\"> kc_evenGapTurbulent_KC </a>.
</html>"));
end kc_evenGapTurbulent_IN_con;
