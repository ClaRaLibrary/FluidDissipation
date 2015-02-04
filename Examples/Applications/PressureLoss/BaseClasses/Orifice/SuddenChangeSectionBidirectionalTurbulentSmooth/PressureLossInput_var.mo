within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.SuddenChangeSectionBidirectionalTurbulentSmooth;
record PressureLossInput_var
  "Input record for dp_suddenChangeSectionBidirectionalTurbulentSmooth"

  extends
    FluidDissipation.PressureLoss.Orifice.dp_suddenChangeSectionBidirectionalTurbulentSmooth_IN_var;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss of the <a  
href=\"Modelica://FluidDissipation.PressureLoss.Orifice\"> orifice function </a> implemented in Modelica.Fluid  
as thermo-hydraulic framework.
</html>"));

end PressureLossInput_var;
