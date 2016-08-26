within FluidDissipation.PressureLoss.HeatExchanger;
record dp_flatTube_IN_var "Input record for function dp_flatTube, dp_flatTube_DP"
  extends Modelica.Icons.Record;

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties(final cp=0,
      final lambda=0);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.HeatExchanger.dp_flatTube_DP\"> dp_flatTube_DP </a>.
</html>"));
end dp_flatTube_IN_var;
