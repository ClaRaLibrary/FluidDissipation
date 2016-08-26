within FluidDissipation.HeatTransfer.HeatExchanger;
record kc_flatTube_IN_var "Input record for function kc_heatExchanger and kc_heatExchanger_KC"
  extends Modelica.Icons.Record;

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties;

  //input variable (mass flow rate)
  SI.MassFlowRate m_flow annotation (Dialog(group="Input"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube\"> kc_flatTube </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_KC\"> kc_flatTube_KC </a>.
</html>"));

end kc_flatTube_IN_var;
