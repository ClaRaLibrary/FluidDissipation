within FluidDissipation.HeatTransfer.HeatExchanger;
record kc_roundTube_IN_var "Input record for function kc_roundTube and kc_roundTube_KC"
  extends Modelica.Icons.Record;

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties;

  //input variable (mass flow rate)
  SI.MassFlowRate m_flow annotation (Dialog(group="Input"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube\"> kc_roundTube </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_KC\"> kc_roundTube_KC </a>.
</html>"));

end kc_roundTube_IN_var;
