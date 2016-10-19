within FluidDissipation.Examples.TestCases.HeatTransfer;
model StateForHeatTransfer
  "Substitute volume model as fluid property interface to heat transfer models"

  parameter Boolean use_MediaState=false
    "true: Use state record input, false: fluid property inputs (p_state, t_state, h_state, d_state or X_state)"
                                                                                                        annotation(Dialog(group="State"), choices(__Dymola_checkBox=true));

  replaceable package Medium = Modelica.Media.Air.DryAirNasa constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (Dialog(group="Fluid properties"), choicesAllMatching=true);
  Medium.BaseProperties medium;
  input Medium.ThermodynamicState state_user=medium.state
    "input for state record according to Modelica.Media"                                                       annotation (Dialog(group="State",
        enable=if use_MediaState then true else false));

  //definition of (missing) thermodynamic state for heat transfer calculation
  Medium.ThermodynamicState state "Thermodynamic state";

  Medium.AbsolutePressure p_state=1e5 "Pressure of state" annotation (Dialog(group="State",
        enable=if use_MediaState or Medium.ThermoStates == Modelica.Media.Interfaces.Choices.IndependentVariables.T
        or Modelica.Media.Interfaces.Choices.IndependentVariables.dTX then false else true));
  SI.Temp_C t_state=20 "Temperature of state" annotation (Dialog(group="State",
        enable=if use_MediaState or Medium.ThermoStates == Choices.IndependentVariables.ph
        or Choices.IndependentVariables.phX then false else true));
  Medium.SpecificEnthalpy h_state=Medium.h_default "Specific enthalpy of state"  annotation (Dialog(group="State",
        enable=if not use_MediaState and (Medium.ThermoStates==Modelica.Media.Interfaces.Choices.IndependentVariables.ph or
        Medium.ThermoStates==Modelica.Media.Interfaces.Choices.IndependentVariables.phX) then true else false));
  Medium.Density d_state=1.18 "Density of state"  annotation (Dialog(group="State",
        enable=if not use_MediaState and Medium.ThermoStates==Modelica.Media.Interfaces.Choices.IndependentVariables.dTX then true else false));
  Medium.MassFraction[Medium.nX] X_state=Medium.X_default
    "Mass fractions of state"                                                        annotation (Dialog(group="State",
        enable=if not use_MediaState and (Medium.ThermoStates==Modelica.Media.Interfaces.Choices.IndependentVariables.dTX or
        Medium.ThermoStates==Modelica.Media.Interfaces.Choices.IndependentVariables.pTX or
        Medium.ThermoStates==Modelica.Media.Interfaces.Choices.IndependentVariables.phX) then true else false));

equation
  if Medium.ThermoStates == Modelica.Media.Interfaces.Choices.IndependentVariables.pT then
    medium.p = p_state;
    medium.T = t_state + 273.15;
  elseif Medium.ThermoStates == Modelica.Media.Interfaces.Choices.IndependentVariables.T then
    medium.p = p_state;
    medium.T = t_state + 273.15;
  elseif Medium.ThermoStates == Modelica.Media.Interfaces.Choices.IndependentVariables.ph then
    medium.p = p_state;
    medium.h = h_state;
  elseif Medium.ThermoStates == Modelica.Media.Interfaces.Choices.IndependentVariables.pTX then
    medium.p = p_state;
    medium.T = t_state + 273.15;
    if Medium.reducedX then
    medium.X[1:Medium.nXi]=X_state[1:Medium.nXi];
    else
    medium.X = X_state;
    end if;
  elseif Medium.ThermoStates == Modelica.Media.Interfaces.Choices.IndependentVariables.dTX then
    medium.d = d_state;
    medium.T = t_state + 273.15;
    if Medium.reducedX then
    medium.X[1:Medium.nXi]=X_state[1:Medium.nXi];
    else
    medium.X = X_state;
    end if;
  elseif Medium.ThermoStates == Modelica.Media.Interfaces.Choices.IndependentVariables.phX then
    medium.p = p_state;
    medium.h = h_state + 273.15;
    if Medium.reducedX then
    medium.X[1:Medium.nXi]=X_state[1:Medium.nXi];
    else
    medium.X = X_state;
    end if;
  end if;

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
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="state")}),
    Documentation(revisions="<html>
2012-03-30 Revised parameter naming and description. Stefan Wischhusen, XRG.<br>
2016-01-19 The model is now suitable for multiple medium models with different states. Stefan Wischhusen, XRG.


</html>", info="<html>
This model fills the state record of various Modelica.Media medium models. The state record is required as an input of the heat transfer application models from package <a href=\"Modelica://FluidDissipation.Examples.Applications.HeatTransfer\">FluidDissipation.Examples.Applications.HeatTransfer</a>. The state record is transferred without connections to the application model.

</html>"));
end StateForHeatTransfer;
