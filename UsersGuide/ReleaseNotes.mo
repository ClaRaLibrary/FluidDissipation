within FluidDissipation.UsersGuide;
class ReleaseNotes "Release notes"
extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>

<h4><font color=\"#008000\">Version 1.1.7, 2014-07-12</font></h4>
 
<p>
List of revisions:
<ul>
<li>Corrected <a href=modelica://FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_KC>kc_laminar_KC</a> function.</li>
<li>Corrected <a href=modelica://FluidDissipation.PressureLoss.Bend.dp_curvedOverall_MFLOW>dp_curvedOverall_MFLOW</a>.</li>
</ul>
</p>

<h4><font color=\"#008000\">Version 1.1.6, 2014-07-12</font></h4>
 
<p>
List of revisions:
<ul>
<li>Added new function <a href=modelica://FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph>kc_tubeBundle_1ph</a> for round tube bundle heat exchanger (one phase media).</li>  
<li>Added annotation Inline=true or Inline=false to all functions.</li>
<li>Revised <a href=modelica://FluidDissipation.Utilities.Functions.General.Stepsmoother>Stepsmoother</a>function and derivative.</li>
<li>Revised <a href=modelica://FluidDissipation.Utilities.Functions.General.SmoothPower_der>SmoothPower_der</a>.</li>
<li>Revised function <a href=modelica://FluidDissipation.PressureLoss.Bend.dp_curvedOverall_MFLOW>dp_curvedOverall_MFLOW</a> to improve regularization for close to zero mass flow rates.</li>
<li>Removed a failure in diffuser flow model.</li> 
</ul>

</p>

<h4><font color=\"#008000\">Version 1.1.5, 2014-01-31</font></h4>
 
<p>
List of revisions:
<ul>
<li>Added a <a href=modelica://FluidDissipation.Examples.TestCases.PressureLoss.EdgedBend>test bench model</a> for an edged bend (elbow).</li>
<li>Removed Integer modifications of enumeration parameters from Examples.</li>
<li>Removed non-specified annotations (except Commands).</li>
<li>Revised laminar and transition regime of dp_edgedOverall_MFLOW and dp_edgedOverall_DP. Please note, that the new model will calculate higher pressure drops in laminar and transient region.</li>
<li>Removed a unit failure in verification models for flat and round tube heat exchangers.</li> 
</ul>

</p>

<h4><font color=\"#008000\">Version 1.1.4, 2013-07-18</font></h4>
 
<p>
List of revisions:
<ul>
<li>Enhanced transition for functions dp_edgedOverall_MFLOW and dp_suddenChange_MFLOW.</li>
</ul>

</p>

<h4><font color=\"#008000\">Version 1.1.3, 2013-06-11</font></h4>
 
<p>
List of revisions:
<ul>
<li>Corrected Modelica syntax (w.r.t. annotation, enumerations, etc.).</li>
<li>Corrected an error in the momentum pressure loss calculation of FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseMomentum_DP. Specified a type for A_cross in the same function. Correction of references in function Modelica.Fluid.Dissipation.Utilities.Functions.PressureLoss.TwoPhase.SlipRatio.
</li>
<li> Removed an erroneous limitation of angle phi for geodetic pipe pressure difference in function FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseGeodetic_DP.</li>
<li>Corrected many typos.</li>
</ul>

</p> 

<h4><font color=\"#008000\">Version 1.1.2, 2012-05-21</font></h4>
 
<p>
List of revisions:
<ul>
<li>Introduced a new two-phase heat transfer function for film condensation at a tube bundle  
  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam</li>

<li>Enabled an optional input of a media state record into model
</li>

<li>Removed temperature offset in components of package
  FluidDissipation.Examples.Applications.HeatTransfer</li>
</ul>

</p> 

<h4><font color=\"#008000\">Version 1.1, 2011-03-30</font></h4>
 
<p>
Release for Modelica Standard Library 3.2.

List of revisions:
<ul>
<li>Changed unit of MolarMass as input of two-phase heat transfer function 
  FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC</li>

<li>Corrected an logical error in function
  FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.TwoPhaseDensity</li>

<li>Removed temperature offset in components of package
  FluidDissipation.Examples.Applications.HeatTransfer</li>
</ul>

</p> 

<h4><font color=\"#008000\">Version 1.0, 2010-06-30</font></h4>
 
<p>
Final release within EuroSysLib-D project.
</p> 

<h4><font color=\"#008000\">Version 1.0 Beta 9, 2010-06-22</font></h4>
 
<p>
FluidDissipation was improved for the release as follows:
</p> 
 
<li> New correlations for pressure loss:
<ul>
        <li> Junction</li>
        <li> Nozzle</li>
</ul>
<h4><font color=\"#008000\">Version 1.0 Beta 8, 2010-03-12</font></h4>
 
<p>
FluidDissipation was improved for the release as follows:
</p> 
 
<li> New correlations for pressure loss:
<ul>
        <li> Diffuser</li>
        <li> Heat exchanger</li>
</ul>

<h4><font color=\"#008000\">Version 1.0 Beta 7, 2010-02-26</font></h4>
 
<p>
FluidDissipation was improved for the release as follows:
</p> 
 
<ul>
<li> New correlations for convective heat transfer:
<ul>
        <li> Two phase flow in straight pipes</li>
        <li> Heat exchanger</li>
</ul>
<li> New correlations for pressure loss:
<ul>
        <li> Two phase flow in straight pipes</li>
        <li> Valves </li>
</ul>
</ul>
  
<h4><font color=\"#008000\">Version 1.0 Beta 4-6, 2010-01-12</font></h4>
 
<p>
FluidDissipation was improved for the release as follows:
</p> 
 
<ul>
<li> Changed structure for input records of all heat transfer and pressure loss 
functions:
<ul>
        <li> Reduced amount of input records for compressible and incompressible 
functions as well as for their combinational one to improve usability of library.
        </li>
        <li> Splitting input records of one function into one with parameters (e.g. for 
geometry) and one with variables (e.g. fluid properties) to ease work of IDE-solver. 
        </li>
</ul>
<li>
</li>
<li> Improved Modelica.Fluid application models for available heat transfer and pressure 
loss functions:
<ul>
        <li> Flattened inheritance with one base flow model for all energy devices.
        </li>
        <li> Implemented smooth state of fluid density and dynamic viscosity for reverse 
flow.
        </li>
</ul>
</li>
<li> Adaption of complete library due to structure change.
</ul>

<h4><font color=\"#008000\">Version 1.0 Beta 3, 2009-07-03</font></h4>
 
<p>
FluidDissipation was improved for the release as follows:
</p>
 
<ul>
<li> Changed flow models structure: <br> 
Now that a future feature for the automatic choice of using either a mass flow rate 
(compressible case) or a pressure loss (incompressible case) function for calculation is 
supported if implemented by IDE. Due to that no manual selection of a compressible or 
incompressible calculation in the Modelica.Fluid flow models is possible anymore. 
Therefore nonlinear equations will be created from the Modelica.Fluid flow models, if the 
future feature is not supported and the mass flow rate is known at a fluid port instead 
of the pressure loss.
</li>
<li> Changed structure and amount of records used as input for function calls due to 
changed structure of flow model.
</li>
<li> Changed structure of function calls due to changed structure of flow model. 
</li>
<li> Finished validation of all available heat transfer and pressure loss functions.
</li>
<li> Included scripts for verification of all available heat transfer and pressure loss 
functions.
</li>
</ul>
 
<h4><font color=\"#008000\">Version 1.0 Beta 2, 2009-04-22</font></h4>
 
<p>
FluidDissipation was improved for the release as follows:
</p> 
 
<ul>
<li> Support of analytical Jacobians at inverse calculation of heat transfer and pressure 
loss functions.
</li>
<li> Included Modelica.Fluid application models for available heat transfer and pressure 
loss functions.
</li>
<li> Adaption of complete library to Modelica Standard nomenclature.
</ul>
 
<h4><font color=\"#008000\">Version 1.0 Beta 1, 2008-10-08</font></h4>
 
Initial release of FluidDissipation.
 
</html>"));
end ReleaseNotes;
