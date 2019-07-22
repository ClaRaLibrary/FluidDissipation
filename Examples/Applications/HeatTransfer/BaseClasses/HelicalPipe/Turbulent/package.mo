within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HelicalPipe;
package Turbulent "FluidDissipation: Heat transfer for helical pipe in turbulent fluid flow regime"
extends
  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HelicalPipe.BaseHelicalPipeHT;
constant String fluidFlowRegime="turbulent regime";


redeclare function extends coefficientOfHeatTransfer

algorithm
  kc := FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_KC(IN_con,
    IN_var);

end coefficientOfHeatTransfer;

annotation (Documentation(info="<html>
<p>
In this package the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_KC\"> kc_turbulent_KC </a> of a helical pipe out of the <b> FluidDissipation </b> library is implemented into an usable form for replaceable calculations of convective heat transfer coefficients. All functions for <a href=\"Modelica://FluidDissipation.Examples.Applications.HelicalPipe\"> helical pipes </a> are integrated within the <b>Modelica_Fluid </b> library as thermo-hydraulic framework.
</p>
 
<p>
This function executes the calculation of a helical pipe in the turbulent regime for an incompressible and single-phase fluid flow. 
</p>
 
<p>
A test case for implemented heat transfer functions of helical pipes is available as <a href=\"Modelica://FluidDissipation.Examples.TestCases.HelicalPipe\"> volume model</a> for Modelica_Fluid as thermo-hydraulic framework. 
</p>
 
</html>
"));
end Turbulent;
