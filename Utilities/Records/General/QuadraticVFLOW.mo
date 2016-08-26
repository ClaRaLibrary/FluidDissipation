within FluidDissipation.Utilities.Records.General;
record QuadraticVFLOW "Base record for generic pressure loss function | quadratic function (dp=a*Vdot^2 + b*Vdot)"

  extends Modelica.Icons.Record;

  Real a(unit="(Pa.s2)/m6") = 15 "Coefficient for quadratic term"
    annotation (Dialog(group="Generic variables"));
  Real b(unit="(Pa.s)/m3") = 0 "Coefficient for linear term"
    annotation (Dialog(group="Generic variables"));

end QuadraticVFLOW;
