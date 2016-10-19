within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.General;
package Turbulent "FluidDissipation: Turbulent fluid flow in generic geometries"
extends
  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.General.BaseGeneralHT;
constant String fluidFlowRegime="turbulent regime";


redeclare function extends coefficientOfHeatTransfer(IN_con, IN_var)

algorithm
  kc := FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_KC(
    IN_con, IN_var);

end coefficientOfHeatTransfer;


annotation (Documentation(info="<html>
<p>
In this package the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.HeatTransfer.General.kc_approxForcedConvection_KC\"> HeatTransfer.General.kc_approxForcedConvection_KC </a> of a generic geometry out of the <b> FluidDissipation </b> library is implemented into an usable form for replaceable calculations of convective heat transfer coefficients. All functions for <a href=\"Modelica://FluidDissipation.Examples.Applications.General\"> generic geometries </a> are integrated within the <b>Modelica_Fluid </b> library as thermo-hydraulic framework.
</p>
 
<p>
This function executes the heat transfer calculation of an even gap at an turbulent flow regime of an incompressible and single-phase fluid flow.
</p>
 
<p>
A test case for implemented heat transfer functions of channels is available as <a href=\"Modelica://FluidDissipation.Examples.TestCases.General\"> volume model</a> for Modelica_Fluid as thermo-hydraulic framework. 
</p>
 
</html>"));
end Turbulent;
