within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Valve.BaseValvePL;
partial model BaseValveModel
  "Base flow model for valve functions in Modelica.Fluid"

  extends BaseClasses.BaseFlowModel(final from_dp=true, final allowFlowReversal=
       true);

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.Valve_i;
equation
  dp = dp_tot;

end BaseValveModel;
