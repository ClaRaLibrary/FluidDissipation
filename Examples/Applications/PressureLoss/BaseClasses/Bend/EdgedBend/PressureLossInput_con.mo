within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.EdgedBend;
record PressureLossInput_con "Input record for dp_edgedOverall"

  extends FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_con;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.Bend\"> edged bend function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_con;
