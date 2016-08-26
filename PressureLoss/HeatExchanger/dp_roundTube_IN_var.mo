within FluidDissipation.PressureLoss.HeatExchanger;
record dp_roundTube_IN_var "Input record for function dp_roundTube, dp_roundTube_DP"
  extends Modelica.Icons.Record;

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties(final cp=0,
      final lambda=0);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_DP\"> dp_roundTube_DP </a>.
</html>"));
end dp_roundTube_IN_var;
