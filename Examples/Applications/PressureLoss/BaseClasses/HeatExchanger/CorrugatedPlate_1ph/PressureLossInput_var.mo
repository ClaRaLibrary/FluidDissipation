within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.CorrugatedPlate_1ph;
record PressureLossInput_var "Input record for dp_corrugatedPlate_1ph_DP"

  extends
    FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_var;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.HeatExchanger\"> corrugated plate heat exchanger function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_var;
