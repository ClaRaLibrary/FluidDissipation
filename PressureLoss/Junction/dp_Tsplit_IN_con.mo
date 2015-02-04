within FluidDissipation.PressureLoss.Junction;
record dp_Tsplit_IN_con "input record for pressure loss function | dp_Tsplit"

  //T-junction variables
  extends FluidDissipation.Utilities.Records.PressureLoss.Tjunction(final
      velocity_reference_branches=false);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tsplit\"> dp_Tsplit </a>.
</html>"));
end dp_Tsplit_IN_con;
