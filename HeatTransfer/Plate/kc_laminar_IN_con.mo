within FluidDissipation.HeatTransfer.Plate;
record kc_laminar_IN_con
  "Input record for function kc_laminar and kc_laminar_KC"

  extends FluidDissipation.HeatTransfer.Plate.kc_overall_IN_con;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.Plate.kc_laminar\">  kc_laminar </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.Plate.kc_laminar_KC\">  kc_laminar_KC </a>.
</html>"));
end kc_laminar_IN_con;
