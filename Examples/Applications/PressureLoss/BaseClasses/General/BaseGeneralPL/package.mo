within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General;
package BaseGeneralPL "Base package for all generic pressure loss functions"
extends FluidDissipation.Utilities.Icons.BaseLibrary;


replaceable partial function massFlowRate_dp
  extends Modelica.Icons.Function;

  //mass flow rate as output
  output SI.MassFlowRate M_FLOW;

end massFlowRate_dp;

end BaseGeneralPL;
