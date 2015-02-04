within FluidDissipation.PressureLoss.Junction;
record dp_Tjoin_symmetric_IN_con
  "input record for pressure loss function | dp_Tjoin_symmetric"

  //T-junction variables
  extends FluidDissipation.Utilities.Records.PressureLoss.Tjunction(final
      velocity_reference_branches=false, final alpha=90);

 annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tjoint_symmetric\"> dp_Tjoint_symmetric </a>.
</html>"));
end dp_Tjoin_symmetric_IN_con;
