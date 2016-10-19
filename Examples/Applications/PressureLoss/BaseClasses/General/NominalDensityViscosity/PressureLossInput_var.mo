within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.NominalDensityViscosity;
record PressureLossInput_var "Input record for dp_nominalDensityViscosity"

  extends
    FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_IN_var;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.General\"> generic ideal gas function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_var;
