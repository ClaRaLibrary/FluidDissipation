**************************************************************************************
*                                                                                    *
*          README for installation of FluidDissipation library 1.1.8                 *
*                                                                                    *
**************************************************************************************

*****Installation******
_______________________


 	1. Unzip the file FluidDissipation 1.1.8.zip. If you have a Dymola licence you
	   should install the library in the subfolder $Dymola\Modelica\Library. It will
	   be listed in the libraries menue of Dymola.
	    
	2. Load the library package.mo into Dymola (File/Open...).

	3. Go to Users guide for more information.


******Library description******
_______________________________
 
This library contains convective heat transfer and pressure loss functions written in 
Modelica. It was developed with Dymola and should be used with this software for
obtaining optimal performance and coverage of Modelica.Fluid examples. 

For the following applications functions are provided:

Heat Transfer

- Channel: even gaps
- General: generic forced convection (e.g., Dittus and Boelter)
- Heat Exchanger: heat transfer for heat exchangers
- Helical Pipe: forced convection within helical pipe heat exchangers
- Plate: forced convection for even surfaces 
- Straight Pipe: heat transfer in straight pipes

Pressure Loss

- Bend: pressure drop for curved or edged bends
- Channel: pressure drop for channel flows
- Diffuser: pressure difference in diffusers
- General: generic pressure drop correlations
- Heat Exchanger: air-side pressure drop for fin and tube heat exchangers, pressure drop 
  for corrugated heat exchangers
- Junction: pressure difference in junctions
- Nozzle: pressure drop in nozzles
- Orifice: pressure difference for a sudden change of hydraulic diameter
- Straight Pipe: pressure drop in straight pipes
- Valve: pressure drop of multiple valve types

The library is a non-commercial product of XRG Simulation GmbH. It makes use of external, 
non-commercial models supplied by Modelica Standard Library. In order to work correctly, 
ensure that this library is always loaded with Modelica Standard Library version 3.2.1.
 
******Acknowledgements******
____________________________

The following people contributed to the FluidDissipation library (alphabetical list):
Joerg Eiden, Ole Engel, Friedrich Gottelt, Timm Hoppe, Nina Peci, Sven Rutkowski, Thorben Vahlenkamp, Stefan 
Wischhusen. 
 
The development of the FluidDissipation library was founded within the ITEA research 
project EuroSysLib-D by German Federal Ministry of Education and Research (promotional 
reference 01IS07022B). The project ended in June 2010. 

 
******Licence condition******
_____________________________

Licensed by XRG Simulation GmbH under the Modelica License 2

Copyright 2007-2016, XRG Simulation GmbH.

This Modelica package is free software and the use is completely at your own risk
it can be redistributed and/or modified under the terms of the Modelica license 2, 
see the license conditions (including the disclaimer of warranty)

Hamburg, Sept. 5th, 2016

XRG Simulation GmbH
Stefan Wischhusen
info@xrg-simulation.de


******Revision history******
____________________________
Version 1.1.8, 2016-09-05

New features:
- Added new function for  dp_twoPhaseOverall_DP 

- Added application for dp_twoPhaseOverall_DP: FluidDissipation.Examples.TestCases.PressureLoss.StraightTwoPhasePipe

Corrected bugs:
- Removed failure in kc_twoPhaseOverall_KC

- Corrected failure status for StraightPipe.kc_overall

- Removed superfluous calculations in StraightPipe.dp_twoPhaseOverall_DP

- Removed obsolete annotations and corrected many typos

- Removed many singularities in heat transfer functions for Reynolds Number at zero velocity.

- Corrected failure in SmoothPower_der

- Corrected factor K_st1 in dp_TJoin

- Corrected functions kc_twoPhase_boilingHorizontal and kc_twoPhase_boilingVertical

Changes with conversion:

- Deleted model StateForHeatTransfer_TwoPhase which is now replaced by StateForHeatTransfer.

Not backwards compatible changes: 
- Removed superfluous parameter "target" in TwoPhaseFlowHT_IN_var record. The following error will be raised by Dymola: "Modelica Unknown named argument 'target' for function FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_var in MODELNAME. Please remove potential inputs for argument "target" in function calls manually.

- Removed superfluous input "d_hyd" from function ReynoldsNumber.


Version 1.1.7, 2015-01-13
- Corrected kc_laminar_KC function.

- Corrected dp_curvedOverall_MFLOW.


Version 1.1.6, 2014-07-12
- Added new function kc_tubeBundle_1ph for round tube bundle heat exchanger (one phase media).

- Added annotation Inline=true or Inline=false to all functions.

- Revised Stepsmoother function and derivative.

- Revised SmoothPower_der.

- Revised function dp_curvedOverall_MFLOW to improve regularization for close to zero mass flow rates.

- Removed a failure in diffuser flow model.


Version 1.1.5, 2014-01-31

- Added a test bench model for an edged bend (elbow)

- Removed Integer modifications of enumeration parameters from Examples.

- Removed non-specified annotations (except Commands).

- Revised laminar and transition regime of dp_edgedOverall_MFLOW and dp_edgedOverall_DP. Please note, that the new model will calculate higher pressure drops in laminar and transient region.

- Removed a unit failure in verification models for flat and round tube heat exchangers.


Version 1.1.4, 2013-07-18

- Enhanced transition for functions dp_edgedOverall_MFLOW and dp_suddenChange_MFLOW.


Version 1.1.3, 2013-06-11

- Corrected Modelica syntax (w.r.t. annotation, enumerations, etc.).

- Corrected an error in the momentum pressure loss calculation of   FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseMomentum_DP. 
Specified a type for A_cross in the same function. Correction of references in function Modelica.Fluid.Dissipation.Utilities.Functions.PressureLoss.TwoPhase.SlipRatio.

- Removed an erroneous limitation of angle phi for geodetic pipe pressure difference in function FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseGeodetic_DP.

- Corrected many typos.


Version 1.1.2, 2012-05-21
 
- Introduced a new two-phase heat transfer function for film condensation at a tube bundle  
  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam

- Enabled an optional input of a media state record into model

- Removed temperature offset in components of package
  FluidDissipation.Examples.Applications.HeatTransfer


Version 1.1, 2011-03-30

- Changed unit of MolarMass as input of two-phase heat transfer function 
  FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC

- Corrected an logical error in function
  FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.TwoPhaseDensity

- Removed temperature offset in components of package
  FluidDissipation.Examples.Applications.HeatTransfer

