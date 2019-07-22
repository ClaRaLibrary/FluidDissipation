within FluidDissipation.Utilities.Records.HeatTransfer;
record TwoPhaseFlowConvectiveBoiling_IN_var
  extends Modelica.Icons.Record;
  Modelica.SIunits.CoefficientOfHeatTransfer kc_l=1000 "Local liquid phase heat transfer coefficient";
  Modelica.SIunits.CoefficientOfHeatTransfer kc_g=1000 "Local gas phase heat transfer coefficient";
  Modelica.SIunits.Density rho_l=943.11 "Liquid density" annotation (Dialog(group="Fluid properties"));
  Modelica.SIunits.Density rho_g=1.1220 "Gas density" annotation (Dialog(group="Fluid properties"));
  Modelica.SIunits.Pressure p=100e5 "Pressure" annotation (Dialog(group="Input"));
  Real x_flow=0.5 "Mass flow rate steam quality" annotation (Dialog(group="Input"));
  Real phi=1 "Wetted radius" annotation (Dialog(group="Flow"));

  Modelica.SIunits.ThermalConductivity lambda_wall=2 "Thermal conductivity of wall" annotation (Dialog(group="Properties of wall"));
  Real flowPattern=5 "Flow pattern in horizontal boiling flow: 1=one phase | 2=stratified | 3=wavy | 4=plug/slug | 5=annular | 6=mist | 7=bubble | 8=one phase | 9=not defined" annotation (Dialog(group="Flow"));

end TwoPhaseFlowConvectiveBoiling_IN_var;
