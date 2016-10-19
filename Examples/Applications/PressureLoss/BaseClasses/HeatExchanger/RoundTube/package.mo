within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger;
package RoundTube "FluidDissipation: Round tube heat exchanger with several fin geometries"
  extends
  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.BaseHeatExchangerPL;


  redeclare function extends pressureLoss_mflow

    //input records for heat exchanger function
    input
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.RoundTube.PressureLossInput_con
    IN_con annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    input
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.RoundTube.PressureLossInput_var
    IN_var annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    input SI.MassFlowRate m_flow "Mass flow rate"
      annotation (Dialog(tab="Input"));

  algorithm
  DP := FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_DP(
      IN_con,
      IN_var,
      m_flow);

    annotation (Documentation(info="<html>
<p>
In this package the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_DP\"> dp_roundTube_DP </a> of a round tube heat exchanger function out of the <b> FluidDissipation </b> library is  
implemented into an usable form for the replaceable pressure loss calculations of a <a  
href=\"Modelica://FluidDissipation.Examples.Applications.PressureLoss.HeatExchanger\"> heat exchanger function </a> with the <b>Modelica.Fluid </b>  
library as thermo-hydraulic framework. 
</p>
 
<p>
This function executes the calculation of a round tube heat exchanger function for an incompressible and single-phase  
fluid flow. Here the pressure loss (DP) is calculated in dependence of a known  
mass flow rate (m_flow).
</p>
 
<p>
A test case ready for the simulation of a Modelica.Fluid heat exchanger function can be found in <a  
href=\"Modelica://FluidDissipation.Examples.TestCases.PressureLoss.HeatExchanger\"> Test: Heat exchanger functions </a>.
</p>
 
</html>
"));
  end pressureLoss_mflow;

end RoundTube;
