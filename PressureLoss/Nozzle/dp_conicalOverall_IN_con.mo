within FluidDissipation.PressureLoss.Nozzle;
record dp_conicalOverall_IN_con
  "Input record for function dp_conicalOverall_DP"

  //diffuser variables
  extends FluidDissipation.Utilities.Records.PressureLoss.Transition;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the  pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Diffuser.dp_conicalOverall_DP\"> dp_conicalOverall_DP </a>.
</html>"));
end dp_conicalOverall_IN_con;
