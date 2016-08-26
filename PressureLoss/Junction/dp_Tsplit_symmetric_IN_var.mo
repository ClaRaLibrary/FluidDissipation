within FluidDissipation.PressureLoss.Junction;
record dp_Tsplit_symmetric_IN_var "input record for pressure loss function | dp_Tsplit_symmetric"
  extends Modelica.Icons.Record;

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties(
    final cp=0,
    final eta=0,
    final lambda=0);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tsplit_symmetric\"> dp_Tsplit_symmetric </a>.
</html>"));
end dp_Tsplit_symmetric_IN_var;
