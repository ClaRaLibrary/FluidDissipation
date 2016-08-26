within FluidDissipation.HeatTransfer.General;
record kc_approxForcedConvection_IN_con "Input record for function approxForcedConvection and approxForcedConvection_KC"

  //generic variables
  extends FluidDissipation.Utilities.Records.HeatTransfer.General;
  parameter Real exp_Pr=0.4 "Exponent for Prandtl number w.r.t. Dittus/Boelter | 0.4 for heating | 0.3 for cooling"
    annotation (Dialog(group="Generic variables",enable=if target == FluidDissipation.Utilities.Types.kc_general.Rough then
          true else false));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.General.kc_approxForcedConvection\"> kc_approxForcedConvection </a> and 
<a href=\"Modelica://FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_KC\"> kc_approxForcedConvection_KC </a>.
</html>"));
end kc_approxForcedConvection_IN_con;
