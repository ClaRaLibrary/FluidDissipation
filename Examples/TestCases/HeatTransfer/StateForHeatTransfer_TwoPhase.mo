within FluidDissipation.Examples.TestCases.HeatTransfer;
model StateForHeatTransfer_TwoPhase "Substitute volume model"

  parameter Boolean use_MediaState=false
    "true: Use state record, false: Use p_state and h_state input"                                      annotation(Dialog(group="State"), choices(__Dymola_checkBox=true));

  replaceable package Medium = Modelica.Media.Water.WaterIF97_pT constrainedby
    Modelica.Media.Interfaces.PartialTwoPhaseMedium "Medium in the component"
    annotation (Dialog(group="Fluid properties"), choicesAllMatching=true);
  Medium.BaseProperties medium;
  input Medium.ThermodynamicState state_user=medium.state
    "input for state record according to Modelica.Media"                                                       annotation (Dialog(group="State",
        enable=if use_MediaState then true else false));

  //definition of (missing) thermodynamic state for heat transfer calculation
  Medium.ThermodynamicState state;

  SI.Pressure p_state=1e5 "Pressure of state" annotation (Dialog(group="State",
        enable=if use_MediaState then false else true));
  SI.SpecificEnthalpy h_state=20 "Specific enthalpy of state" annotation (Dialog(group="State",
        enable=if use_MediaState then false else true));

equation
  medium.p = p_state;
  medium.h = h_state;

  if use_MediaState then
   state =state_user;
  else
  state=medium.state;
  end if;

  annotation (
    defaultComponentName="stateForHeatTransfer",
    defaultComponentPrefixes="inner",
    missingInnerMessage="
Your model is using an outer \"stateForHeatTransfer\" component but
an inner \"stateForHeatTransfer\" component is not defined.
For simulation drag FluidDissipation.Examples.TestCases.HeatTransfer.StateForHeatTransfer into your model
to specify system properties. The default StateForHeatTransfer setting
is used for the current simulation.
",  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-40,-46},{52,-128}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-46,46},{46,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="p,T")}),
    Documentation(revisions="<html>
2012-03-30 Introduced optional state record input. Stefan Wischhusen, XRG.
</html>"));
end StateForHeatTransfer_TwoPhase;
