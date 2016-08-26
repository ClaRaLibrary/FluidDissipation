within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function VoidFraction "Calculation of (cross sectional) void fraction for two phase flow"
  extends Modelica.Icons.Function;
  //SOURCE_1: VDI-Waermeatlas, 10th edition, Springer-Verlag, 2006.
  //SOURCE_2: Thome, J.R., Engineering Data Book 3, Swiss Federal Institute of Technology Lausanne (EPFL), 2009.

  input FluidDissipation.Utilities.Types.VoidFractionApproach voidFractionApproach=
      FluidDissipation.Utilities.Types.VoidFractionApproach.Homogeneous "Choice of void fraction approach"
                                       annotation (Dialog(group="Choices"));

  input Boolean crossSectionalAveraged=true "true == cross sectional averaged void fraction | false == volumetric"
    annotation (Dialog);

  input SI.Density rho_g(min=Modelica.Constants.eps) = 1.1220 "Density of gaseous phase"
                               annotation (Dialog);
  input SI.Density rho_l(min=Modelica.Constants.eps) = 943.11 "Density of liquid phase"
                              annotation (Dialog);
  input Real x_flow(
    min=0,
    max=1) = 0 "Mass flow rate quality" annotation (Dialog);

  output Real epsilon "Void fraction";
  output Real slipRatio "Slip ratio";

protected
  Real MIN=Modelica.Constants.eps;

  Real xflow=min(1, max(0, abs(x_flow))) "Mass flow rate quality";

  Real SR=FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.SlipRatio(
      voidFractionApproach,
      rho_g,
      rho_l,
      xflow) "Slip ratio for void fraction approach";

  //SOURCE_2: p.17-5, eq. 17.2.5: (Heterogeneous) cross sectional void fraction [epsilon_A=A_g/(A_g+A_l)]
  Real epsilon_A=rho_l*x_flow/max(MIN, rho_l*x_flow + rho_g*(1 - x_flow)*SR);

algorithm
  epsilon := if crossSectionalAveraged then epsilon_A else epsilon_A/((1/max(
    MIN, SR))*(1 - epsilon_A) + epsilon_A);
  slipRatio := SR;

    annotation (Inline=false);
end VoidFraction;
