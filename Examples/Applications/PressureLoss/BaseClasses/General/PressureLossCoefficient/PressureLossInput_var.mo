within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.PressureLossCoefficient;
record PressureLossInput_var
  "Input record for generic function with pressure loss coefficient dependence"

  extends
    FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_var;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.General\"> generic pressure loss coefficient function </a> implemented in  
Modelica.Fluid as thermo-hydraulic framework.
</html>"));

end PressureLossInput_var;
