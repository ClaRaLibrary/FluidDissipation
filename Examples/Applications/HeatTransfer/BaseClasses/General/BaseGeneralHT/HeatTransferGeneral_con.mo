within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.General.BaseGeneralHT;
record HeatTransferGeneral_con "Input record for generic functions"

  extends FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_con;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer functions of <a href=\"Modelica://FluidDissipation.HeatTransfer.General\"> generic geometries </a> implemented in Modelica_Fluid as thermo-hydraulic framework.
</html>"));
end HeatTransferGeneral_con;
