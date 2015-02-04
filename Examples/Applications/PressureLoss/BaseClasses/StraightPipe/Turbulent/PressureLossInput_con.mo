within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Turbulent;
record PressureLossInput_con "Input record for dp_turbulent"

  extends FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_IN_con;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe\"> straight pipe function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_con;
