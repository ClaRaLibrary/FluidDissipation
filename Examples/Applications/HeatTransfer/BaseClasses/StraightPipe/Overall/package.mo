within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe;
package Overall "FluidDissipation: Heat transfer for straight pipe in overall fluid flow regime"
extends
  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.BaseStraightPipeHT;
constant String fluidFlowRegime="overall regime";


redeclare function extends coefficientOfHeatTransfer

algorithm
  kc := FluidDissipation.HeatTransfer.StraightPipe.kc_overall_KC(IN_con, IN_var);

end coefficientOfHeatTransfer;


annotation (Documentation(info="<html>
<p>
In this package the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.StraightPipe.kc_overall_KC\"> kc_overall_KC </a> of a straight pipe out of the <b> FluidDissipation </b> library is implemented into an usable form for replaceable calculations of convective heat transfer coefficients. All functions for <a href=\"Modelica://FluidDissipation.Examples.Applications.StraightPipe\"> straight pipes </a> are integrated within the <b>Modelica_Fluid </b> library as thermo-hydraulic framework.
</p>
 
<p>
This function executes the calculation of a straight pipe in the overall regime for an incompressible and single-phase fluid flow. 
</p>
 
<p>
A test case for implemented heat transfer functions of straight pipes is available as <a href=\"Modelica://FluidDissipation.Examples.TestCases.HeatTransfer.StraightPipe\"> volume model</a> for Modelica_Fluid as thermo-hydraulic framework. 
</p>
 
</html>
"));
end Overall;
