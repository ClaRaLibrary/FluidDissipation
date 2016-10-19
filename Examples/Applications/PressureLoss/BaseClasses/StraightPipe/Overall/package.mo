within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe;
package Overall "FluidDissipation: Overall regime of straight pipe"
extends
  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.BaseStraightPipePL;


redeclare function extends massFlowRate_dp

  //input records for straight pipe function
  input
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Overall.PressureLossInput_con
    IN_con annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  input
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Overall.PressureLossInput_var
    IN_var annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(tab="Input"));

algorithm
  M_FLOW := FluidDissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(
    IN_con,
    IN_var,
    dp);

  annotation (Documentation(info="<html>
<p>
In this package the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_overall\"> dp_overall </a> of a straight pipe function with surface roughness dependence out of the <b> FluidDissipation </b> library is  
implemented into an usable form for the replaceable pressure loss calculations of a <a  
href=\"Modelica://FluidDissipation.Examples.Applications.PressureLoss.StraightPipe\"> straight pipe function </a> with the <b>Modelica.Fluid </b>  
library as thermo-hydraulic framework. 
</p>
 
<p>
This function executes the calculation of a straight pipe function at the overall flow regime for an incompressible and single-phase  
fluid flow considering surface roughness dependence. Here the mass flow rate (M_FLOW) is calculated in dependence of a known  
pressure loss (dp).
</p>
 
<p>
A test case ready for the simulation of a Modelica.Fluid straight pipe function can be found in <a  
href=\"Modelica://FluidDissipation.Examples.TestCases.PressureLoss.StraightPipe\"> Test: Straight pipe functions </a>.
</p>
 
</html>
"));
end massFlowRate_dp;

end Overall;
