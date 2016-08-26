within FluidDissipation.Utilities.Functions.General;
function ReynoldsNumber "calculation of Reynolds number"
  extends Modelica.Icons.Function;
  import SI = Modelica.SIunits;
  import MIN = Modelica.Constants.eps;

  //geometry
  input SI.Area A_cross "Cross sectional area";
  input SI.Length perimeter "Wetted perimeter";

  //fluid properties
  input SI.Density rho "Density of fluid";
  input SI.DynamicViscosity eta "Dynamic viscosity of fluid";

  input SI.MassFlowRate m_flow "Mass flow rate";

  output SI.ReynoldsNumber Re "Reynolds number";
  output SI.Velocity velocity "Mean velocity";

// protected
//   SI.Diameter d_hyd=4*A_cross/max(MIN, perimeter) "Hydraulic diameter";

algorithm
  Re := 4*abs(m_flow)/max(MIN, (perimeter*eta));
  velocity := m_flow/max(MIN, (rho*A_cross));
  annotation (Inline=true, smoothOrder=1,
    Documentation(revisions="<html>
<pre>2016-04-12 Stefan Wischhusen: Removed obsolete d_hyd from function ReynoldsNumber.</pre>
</html>"));
end ReynoldsNumber;
