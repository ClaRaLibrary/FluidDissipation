within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.BaseChannelPL;
partial model BaseChannelModel "Base flow model for channel functions in Modelica.Fluid"

  extends BaseClasses.BaseFlowModel(final from_dp=true, final allowFlowReversal=
       true);

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.Channel_i;

equation
  dp = dp_tot;

end BaseChannelModel;
