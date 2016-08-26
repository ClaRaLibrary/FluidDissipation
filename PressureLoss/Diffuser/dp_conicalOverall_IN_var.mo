within FluidDissipation.PressureLoss.Diffuser;
record dp_conicalOverall_IN_var "Input record for function dp_conicalOverall, dp_conicalOverall_DP"

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties(final cp=0,
      final lambda=0);
  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the  pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Diffuser.dp_conicalOverall_DP\"> dp_conicalOverall_DP </a>.
</html>"));
end dp_conicalOverall_IN_var;
