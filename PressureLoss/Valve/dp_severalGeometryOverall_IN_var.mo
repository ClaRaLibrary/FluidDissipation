within FluidDissipation.PressureLoss.Valve;
record dp_severalGeometryOverall_IN_var
  "Input record for function dp_severalGeometryOverall, dp_severalGeometryOverall_DP and dp_severalGeometryOverall_MFLOW"

  extends Modelica.Icons.Record;

  //valve variables
  Real opening=1 "Opening of valve | 0==closed and 1== fully opened"
    annotation (Dialog(group="Valve"));

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid"
    annotation (Dialog(group="Fluid properties"));
  SI.Density rho=1e3 "Density of fluid"
    annotation (Dialog(group="Fluid properties"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall\"> dp_severalGeometryOverall </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_DP\"> dp_severalGeometryOverall_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_MFLOW\"> dp_severalGeometryOverall_MFLOW </a>.
</html>"));
end dp_severalGeometryOverall_IN_var;
