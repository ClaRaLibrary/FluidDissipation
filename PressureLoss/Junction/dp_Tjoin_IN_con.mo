within FluidDissipation.PressureLoss.Junction;
record dp_Tjoin_IN_con "input record for pressure loss function | dp_Tjoin"

  //T-junction variables
  extends FluidDissipation.Utilities.Records.PressureLoss.Tjunction(final
      velocity_reference_branches=false);

annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tjoint\"> dp_Tjoint </a>.
</html>"), Icon(graphics));
end dp_Tjoin_IN_con;
