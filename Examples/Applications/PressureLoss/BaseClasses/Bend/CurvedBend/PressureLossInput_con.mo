within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.CurvedBend;
record PressureLossInput_con "Input record for dp_curvedOverall"

  extends FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_con;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.Bend\"> curved bend function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_con;
