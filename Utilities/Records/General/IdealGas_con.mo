within FluidDissipation.Utilities.Records.General;
record IdealGas_con "Base record for generic pressure loss function | ideal gas | mean density"
  extends Modelica.Icons.Record;

  Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));
  SI.SpecificHeatCapacity R_s=287 "Specific gas constant of ideal gas"
    annotation (Dialog(group="Fluid properties"));
  Real Km=6824.86 "Coefficient for pressure loss law [(Pa)^2/{(kg/s)^exp*K}]"
    annotation (Dialog(group="Generic variables"));

end IdealGas_con;
