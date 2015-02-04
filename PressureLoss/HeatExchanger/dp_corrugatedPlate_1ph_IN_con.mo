within FluidDissipation.PressureLoss.HeatExchanger;
record dp_corrugatedPlate_1ph_IN_con
  "Input record for function dp_corrugatedPlate_1ph, dp_corrugatedPlate_1ph_DP"
  extends Modelica.Icons.Record;

  Integer channels(min = 1) = 0 "number of paralell flown channels per fluid" annotation (Dialog(group="HeatExchanger"));
  SI.Length Length(min=1e-2)=0
    "length of the heat exchanger plates in flow direction (header center to header center)"
    annotation (Dialog(group="HeatExchanger"));
  SI.Length Width(min=1e-2)=0
    "width of the heat exchanger plates in flow direction" annotation (Dialog(group="HeatExchanger"));
  SI.Length amp(min=1e-10) = 0 "amplitude of corrugated plate" annotation (Dialog(group="HeatExchanger"));
  SI.Length Lambda(min=1e-10) = 2*Modelica.Constants.pi*amp
    "wave length of corrugated plate" annotation (Dialog(group="HeatExchanger"));
  SI.Angle phi = 0 "Corrugation angle" annotation (Dialog(group="HeatExchanger"));

  Real a = 3.8 "Friction loss parameter (default value from literature)" annotation (Dialog(group="Adaption to measurement data"));
  Real b = 0.18 "Friction loss parameter (default value from literature)" annotation (Dialog(group="Adaption to measurement data"));
  Real c = 0.36 "Friction loss parameter (default value from literature)" annotation (Dialog(group="Adaption to measurement data"));

  //numerical aspects
  SI.Velocity velocity_small=1e-8
    "Regularisation for a velocity smaller then velocity_small"
    annotation (Dialog(group="Numerical aspects"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_DP\"> dp_corrugatedPlate_1ph_DP </a>.
</html>"));
end dp_corrugatedPlate_1ph_IN_con;
