within FluidDissipation.HeatTransfer.General;
record kc_approxForcedConvection_IN_var
  "Input record for function approxForcedConvection and approxForcedConvection_KC"

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties;
  SI.DynamicViscosity eta_wall=1e-3
    "Dynamic viscosity of fluid at wall temperature" annotation (Dialog(group=
          "Fluid properties"));

  //input variable (mass flow rate)
  SI.MassFlowRate m_flow annotation (Dialog(group="Input"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.General.kc_approxForcedConvection\"> kc_approxForcedConvection </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_KC\"> kc_approxForcedConvection_KC </a>.
</html>"));
end kc_approxForcedConvection_IN_var;
