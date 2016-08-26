within FluidDissipation.HeatTransfer.StraightPipe;
record kc_laminar_IN_con "Input record for function kc_laminar and kc_laminar_KC"

  extends FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con(final
      roughness=FluidDissipation.Utilities.Types.Roughness.Neglected);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.StraightPipe.kc_laminar\"> kc_laminar </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_KC\"> kc_laminar_KC </a>.
</html>"));
end kc_laminar_IN_con;
