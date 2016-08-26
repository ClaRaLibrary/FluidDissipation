within FluidDissipation.HeatTransfer.HeatExchanger;
record kc_tubeBundleFilmCondensation_lam_IN_con "Input record for function kc_tubeBundleFilmCondensation_lam and kc_tubeBundleFilmCondensation_lam_KC"
  extends Modelica.Icons.Record;

  Modelica.SIunits.Length d = 0.005 "Diameter of the bundle's tubes" annotation (Dialog(group="Geometry"));
  Modelica.SIunits.Area A_front = 1 "Frontal area" annotation (Dialog(group="Geometry"));
  Real C = 1 "Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8"
                                                                                    annotation (Dialog(group="Geometry"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the heat transfer function <a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam\"> kc_tubeBundleFilmCondensation_lam</a> and <a href=\"Modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_KC\"> kc_tubeBundleFilmCondensation_lam_KC</a>.
</html>"));
end kc_tubeBundleFilmCondensation_lam_IN_con;
