within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.VolumeFlowRate;
record PressureLossInput_con "Input record for dp_volumeFlowRate"

  extends FluidDissipation.PressureLoss.General.dp_volumeFlowRate_IN_con;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.General\"> generic volume flow rate function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_con;
