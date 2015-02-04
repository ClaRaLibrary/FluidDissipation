within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Plate.BasePlateHT;
record HeatTransferPlate_var "input record for plate functions"

  extends FluidDissipation.HeatTransfer.Plate.kc_overall_IN_var;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer functions of <a href=\"Modelica://FluidDissipation.HeatTransfer.Plate\"> plates </a> implemented in Modelica_Fluid as thermo-hydraulic framework.
</html>"));
end HeatTransferPlate_var;
