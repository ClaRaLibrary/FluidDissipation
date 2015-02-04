within FluidDissipation.HeatTransfer.HeatExchanger;
record kc_tubeBundleFilmCondensation_lam_IN_var
  "Input record for function kc_tubeBundleFilmCondensation_lam and kc_tubeBundleFilmCondensation_lam_KC"

  extends Modelica.Icons.Record;

  //fluid properties
  SI.SpecificHeatCapacityAtConstantPressure cp_l
    "Specific heat capacity of liquid"
    annotation (Dialog(group="Fluid properties"));
  SI.ThermalConductivity lambda_l "Thermal conductivity of liquid"
    annotation (Dialog(group="Fluid properties"));
  SI.Density rho_g "Density of gas" annotation (Dialog(group=
          "Fluid properties"));
  SI.Density rho_l "Density of liquid"
    annotation (Dialog(group="Fluid properties"));
  SI.DynamicViscosity eta_g "Dynamic viscosity of gas" annotation (
      Dialog(group="Fluid properties"));
  SI.DynamicViscosity eta_l "Dynamic viscosity of liquid"
    annotation (Dialog(group="Fluid properties"));

  Modelica.SIunits.Temperature T_s "Saturation temperature" annotation(Dialog(group="Fluid properties"));
  SI.SpecificEnthalpy dh_lg "Evaporation enthalpy of fluid"
    annotation (Dialog(group="Fluid properties"));

  //input variables
  SI.MassFlowRate m_flow "Mass flow rate" annotation (Dialog(group="Input"));
  Modelica.SIunits.Temperature T_w "Wall temperature" annotation(Dialog(group="Input"));

    annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam\"> kc_tubeBundleFilmCondensation_lam</a> and <a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_KC\"> kc_tubeBundleFilmCondensation_lam_KC</a>.
</html>"));

end kc_tubeBundleFilmCondensation_lam_IN_var;
