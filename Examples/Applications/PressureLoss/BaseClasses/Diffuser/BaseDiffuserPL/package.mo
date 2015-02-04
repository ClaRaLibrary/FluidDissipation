within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Diffuser;
package BaseDiffuserPL "Base package for all pressure loss functions of a diffuser"
extends FluidDissipation.Utilities.Icons.BaseLibrary;


replaceable partial function pressureLoss_mflow
  extends Modelica.Icons.Function;

  //mass flow rate as output
  output SI.Pressure DP_tot "Total pressure loss";

end pressureLoss_mflow;

end BaseDiffuserPL;
