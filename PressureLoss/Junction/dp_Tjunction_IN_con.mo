within FluidDissipation.PressureLoss.Junction;
record dp_Tjunction_IN_con "input record for pressure loss function | dp_Tjunction"

  //T-junction variables
  extends FluidDissipation.Utilities.Records.PressureLoss.Tjunction(final
      velocity_reference_branches=false);

  //restrictions
  parameter SI.Pressure dp_min = 1 "restriction for smoothing while changing of fluid flow situation"
    annotation (Dialog(group="Restrictions"));
  /*parameter Boolean caseRequest=true 
    "true == case request depending on mass flow rates at ports (exact) | false == driving pressure difference (fast)"
    annotation (Dialog(group="Restrictions"));*/

  FluidDissipation.Utilities.Types.JunctionFlowSituation flowSituation=
      FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left "fluid flow situation"
                           annotation (Dialog(group="FlowSituation"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Junction.dp_Tjunction\"> dp_Tjunction </a>.
</html>"));
end dp_Tjunction_IN_con;
