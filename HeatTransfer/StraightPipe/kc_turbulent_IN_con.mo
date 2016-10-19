within FluidDissipation.HeatTransfer.StraightPipe;
record kc_turbulent_IN_con
  "Input record for function kc_turbulent and kc_turbulent_KC"

  extends FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con(final
      target=FluidDissipation.Utilities.Types.HeatTransferBoundary.UWTuDFF);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.StraightPipe.kc_turbulent\">kc_turbulent </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.StraightPipe.kc_turbulent_KC\">kc_turbulent_KC </a>.
</html>"));
end kc_turbulent_IN_con;
