within FluidDissipation.Utilities.Records.General;
record NominalPressureLossLawDensity_var
  "Base record for generic pressure loss function"

  extends Modelica.Icons.Record;

  TYP.PressureLossCoefficient zeta_TOT=0.2 "Pressure loss coefficient"
    annotation (Dialog(group="Generic variables"));

end NominalPressureLossLawDensity_var;
