within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel;
package Laminar "FluidDissipation: Laminar fluid flow in an even gap"
extends FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel.BaseChannelHT;
constant String fluidFlowRegime="laminar regime";


redeclare function extends coefficientOfHeatTransfer

algorithm
  kc := FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_KC(IN_con,
    IN_var);

end coefficientOfHeatTransfer;


annotation (Documentation(info="<html>
<p>
In this package the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_KC\"> kc_evenGapLaminar_KC </a> of an even gap out of the <b> FluidDissipation </b> library is implemented into an usable form for replaceable calculations of convective heat transfer coefficients. All functions for <a href=\"Modelica://FluidDissipation.Examples.Applications.Channel\"> channels </a> are integrated within the <b>Modelica_Fluid </b> library as thermo-hydraulic framework.
</p>
 
<p>
This function executes the heat transfer calculation of an even gap at a laminar flow regime of an incompressible and single-phase fluid flow.
</p>
 
<p>
A test case for implemented heat transfer functions of channels is available as <a href=\"Modelica://FluidDissipation.Examples.TestCases.HeatTransfer.Channel\"> volume model</a> for Modelica_Fluid as thermo-hydraulic framework. 
</p>
 
</html>"));
end Laminar;
