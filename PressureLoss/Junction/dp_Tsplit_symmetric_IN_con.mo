within FluidDissipation.PressureLoss.Junction;
record dp_Tsplit_symmetric_IN_con "input record for pressure loss function | dp_Tsplit_symmetric"

  //T-junction variables
  extends FluidDissipation.Utilities.Records.PressureLoss.Tjunction(final
      velocity_reference_branches=false, final alpha=90);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tsplit_symmetric\"> dp_Tsplit_symmetric </a>.
</html>"));
end dp_Tsplit_symmetric_IN_con;
