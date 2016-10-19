within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function SlipRatio "Calculation of (analytical/empirical) slip ratio"
  extends Modelica.Icons.Function;
  //SOURCE_1: VDI-Waermeatlas, 10th edition, Springer-Verlag, 2006.
  //SOURCE_2: Thome, J.R., Engineering Data Book 3, Swiss Federal Institute of Technology Lausanne (EPFL), 2009.
  //SOURCE 3: J.M. Jensen and H. Tummescheit. Moving boundary models for dynamic simulations of two-phase flows. In Proceedings of the 2nd International Modelica Conference, pp. 235-244, Oberpfaffenhofen, Germany, 2002. The Modelica Association.

  input FluidDissipation.Utilities.Types.VoidFractionApproach voidFractionApproach=
      FluidDissipation.Utilities.Types.VoidFractionApproach.Homogeneous
    "Choice of void fraction approach" annotation (Dialog(group="Choices"));

  input SI.Density rho_g(min=Modelica.Constants.eps) = 1.1220
    "Density of gaseous phase" annotation (Dialog);
  input SI.Density rho_l(min=Modelica.Constants.eps) = 943.11
    "Density of liquid phase" annotation (Dialog);
  input Real x_flow=0 "Mass flow rate quality" annotation (Dialog);

  output Real SR "Slip ratio";

protected
  Real MIN=Modelica.Constants.eps;

  //SOURCE_1: p.Lba 3, sec. 3.2
  Real SR_hom=1 "Slip ratio w.r.t. homogeneous approach";
  //SOURCE_2: p.17-6, eq. 17.3.4
  Real SR_mom=abs(rho_l/max(MIN, rho_g))^0.5
    "Slip ratio w.r.t. momentum flux approach (heterogeneous)";
  //SOURCE_2: p.17-7, eq. 17.3.13
  Real SR_kin=abs(rho_l/max(MIN, rho_g))^(1/3)
    "Slip ratio w.r.t. kinetic energy flow approach from Zivi (heterogeneous)";
  //SOURCE_2: p.17-10, eq. 17.4.3
  Real SR_chi=(1 - x_flow*(1 - abs(rho_l)/max(MIN, abs(rho_g))))^0.5
    "Empirical slip ratio w.r.t. momentum flux approach from Chisholm (heterogeneous)";

algorithm
  SR := if voidFractionApproach == FluidDissipation.Utilities.Types.VoidFractionApproach.Homogeneous
     then SR_hom else if voidFractionApproach == FluidDissipation.Utilities.Types.VoidFractionApproach.Momentum
     then SR_mom else if voidFractionApproach == FluidDissipation.Utilities.Types.VoidFractionApproach.Energy
     then SR_kin else if voidFractionApproach == FluidDissipation.Utilities.Types.VoidFractionApproach.Chisholm
     then SR_chi else 1;

     annotation (Inline=false);
end SlipRatio;
