within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Valve.Overall;
record PressureLossInput_con "Input record for dp_severalGeometryOverall"

  extends FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_con;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.Valve\"> valve function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_con;
