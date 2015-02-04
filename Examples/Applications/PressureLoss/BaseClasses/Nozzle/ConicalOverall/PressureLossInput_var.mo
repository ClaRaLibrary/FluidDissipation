within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Nozzle.ConicalOverall;
record PressureLossInput_var "Input record for dp_conicalOverall"

  extends FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_var;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.Diffuser\"> diffuser function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_var;
