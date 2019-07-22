within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend;
package EdgedBend "FluidDissipation: Edged bend considering surface roughness"
extends
  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.BaseBendPL;


redeclare function extends massFlowRate_dp

  //input records for bend function
  input
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.EdgedBend.PressureLossInput_con
    IN_con annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  input
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.EdgedBend.PressureLossInput_var
    IN_var annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(tab="Input"));

algorithm
  M_FLOW := FluidDissipation.PressureLoss.Bend.dp_edgedOverall_MFLOW(
    IN_con,
    IN_var,
    dp);

  annotation (Documentation(info="<html>
<p>
In this package the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_edgedOverall\"> dp_edgedOverall </a> of a edged bend function with surface roughness dependence out of the <b> FluidDissipation </b> library is  
implemented into an usable form for the replaceable pressure loss calculations of a <a  
href=\"Modelica://FluidDissipation.Examples.Applications.PressureLoss.Bend\"> bend function </a> with the <b>Modelica.Fluid </b>  
library as thermo-hydraulic framework. 
</p>
 
<p>
This function executes the calculation of a edged bend function at the overall flow regime for an incompressible and single-phase  
fluid flow considering surface roughness dependence. Here the mass flow rate (M_FLOW) is calculated in dependence of a known  
pressure loss (dp).
</p>
 
<p>
A test case ready for the simulation of a Modelica.Fluid bend function can be found in <a  
href=\"Modelica://FluidDissipation.Examples.TestCases.PressureLoss.Bend\"> Test: Bend functions </a>.
</p>
 
</html>
"));
end massFlowRate_dp;
end EdgedBend;
