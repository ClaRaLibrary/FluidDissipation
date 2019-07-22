within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice;
package BaseOrificePL "Base package for all pressure loss functions of an orifice"
extends FluidDissipation.Utilities.Icons.BaseLibrary;


replaceable partial function massFlowRate_dp
  extends Modelica.Icons.Function;

  //mass flow rate as output
  output SI.MassFlowRate M_FLOW;

end massFlowRate_dp;
end BaseOrificePL;
