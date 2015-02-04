within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.Overall;
record PressureLossInput_var "Input record for dp_severalGeometryOverall"

  extends FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_var;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.Channel\"> channel function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_var;
