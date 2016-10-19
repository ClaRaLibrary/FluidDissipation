within FluidDissipation.PressureLoss.Orifice;
record dp_suddenChange_IN_con
  "Input record for function dp_suddenChange, dp_suddenChange_DP and dp_suddenChange_MFLOW"

  //orifice variables
  extends FluidDissipation.Utilities.Records.PressureLoss.Orifice(
    final A_0=0,
    final C_0=0,
    final K=0,
    final L=0);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss functions <a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_suddenChange\"> dp_suddenChange </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_suddenChange_DP\"> dp_suddenChange_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_suddenChange_MFLOW\"> dp_suddenChange_MFLOW </a>. 
</html>"));
end dp_suddenChange_IN_con;
