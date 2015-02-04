within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.FlatTube;
record PressureLossInput_con "Input record for dp_flatTube_DP"

  extends FluidDissipation.PressureLoss.HeatExchanger.dp_flatTube_IN_con;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.HeatExchanger\"> flat tube heat exchanger function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_con;
