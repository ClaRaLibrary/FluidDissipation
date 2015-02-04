within FluidDissipation.Utilities.Records.General;
record IdealGas
  "Base record for generic pressure loss function | ideal gas | mean density"
  extends Modelica.Icons.Record;

  parameter Real exp(min=Modelica.Constants.eps) = 2
    "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));
  parameter SI.SpecificHeatCapacity R_s(min=1) = 287
    "Specific gas constant of ideal gas"
    annotation (Dialog(group="Fluid properties"));

  Real Km(min=Modelica.Constants.eps) = R_s*(2e3)/((10)^exp/rho_m)
    "Coefficient for pressure loss law [(Pa)^2/{(kg/s)^exp*K}]"
    annotation (Dialog(group="Generic variables"));
  SI.Density rho_m=p_m/(R_s*T_m) "Mean density of ideal gas"
    annotation (Dialog(group="Fluid properties", enable=useMeanDensity));
  SI.Temp_K T_m=(293 + 293)/2 "Mean temperature of ideal gas"
    annotation (Dialog(group="Fluid properties", enable=not (useMeanDensity)));
  SI.Pressure p_m=(1e5 + 1e5)/2 "Mean pressure of ideal gas"
    annotation (Dialog(group="Fluid properties", enable=not (useMeanDensity)));

end IdealGas;
