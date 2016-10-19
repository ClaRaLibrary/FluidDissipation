within FluidDissipation.Utilities.Records.HeatTransfer;
record TwoPhaseFlowHT_IN_con
  "Base record for two phase heat transfer coefficient"
  extends Modelica.Icons.Record;

  //choices
  FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget target=
      FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilHor
    "Choice of (horizontal/vertical) boiling or (horizontal) condensation in pipe"
    annotation (Dialog(group="Choices"));

  SI.Area A_cross=Modelica.Constants.pi*0.1^2/4 "Cross sectional area"
    annotation (Dialog(group="Geometry"));
  SI.Length perimeter=Modelica.Constants.pi*0.1 "Wetted perimeter"
    annotation (Dialog(group="Geometry"));

  FluidDissipation.Utilities.Types.MolarMass_gpmol MM=18.02
    "Molar mass of fluid" annotation (Dialog(group="Fluid properties", enable=
          if target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilHor
           or target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilVer
           then true else false));
  SI.Pressure p_crit=220.89e5 "Critical pressure of fluid"
    annotation (Dialog(group="Fluid properties"));

  annotation (Documentation(revisions="<html>
<p>2011-03-28        XRG Simulation GmbH, Stefan Wischhusen: Changed unit for molar mass.</p>
</html>"));
end TwoPhaseFlowHT_IN_con;
