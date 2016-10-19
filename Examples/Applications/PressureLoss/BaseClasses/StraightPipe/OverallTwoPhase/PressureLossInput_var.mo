within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.OverallTwoPhase;
record PressureLossInput_var "Input record for dp_overall"

  extends FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe\"> straight pipe function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_var;
