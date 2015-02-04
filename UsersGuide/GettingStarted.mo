within FluidDissipation.UsersGuide;
class GettingStarted "GettingStarted"
extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>
The <b> FluidDissipation </b> library provides convective heat transfer and pressure loss 
(HTPL) correlations for a broad range of energy devices to build up thermohydraulic 
energy systems.
</p>
<p>
This section introduces an implementation method for the integration of the provided HTPL 
functions by FluidDissipation into own application models. Additionally you can find 
ready-to-use application models integrated into Modelica.Fluid as thermohydraulic 
framework <a href=\"Modelica://FluidDissipation.Examples.Applications.PressureLoss\"> (see 
application examples)</a>.<br /> 
In the following the implementation method is described in 5 steps for a straight pipe as 
example. Generally the implementation method can be used for all HTPL correlations 
throughout the library in the same manner.
</p>
 
<h4><font color=\"#EF9B13\">Step 1: Use/Create model with missing pressure loss correlation 
</font></h4>
<p>
All thermohydraulic systems using pressure loss calculations can be modelled for an <b> 
incompressible case </b>, where the pressure loss (DP) is calculated in dependence of a 
known mass flow rate (m_flow)
 
<pre>
   DP = f(m_flow,...)
</pre>
 
or a <b> compressible case </b> , where the mass flow rate (M_FLOW) is calculated in 
dependence of a known pressure loss (dp)
 
<pre>
   M_FLOW = f(dp,...).
</pre>
<p> 
In both cases one target variable (DP for the compressible or M_FLOW for the 
incompressible case) is calculated as a function of the corresponding input variable 
(m_flow or dp respectively). Both functions for these cases can be found in the library 
for the pressure loss device of interest enlarged with a corresponding underscore 
describing its intended use (functionname_MFLOW for compressible or functionname_DP for 
incompressible calculation).
</p>
To create a simplified thermohydraulic model, the pressure loss (dp) and the mass flow 
rate (M_FLOW) have to be defined as unknown variables and only a functional correlation 
between them is still missing. Here the implementation for the compressible case of a 
flow model will be explained as example.
<pre>
   model straightPipe
    //compressible case M_FLOW = f(dp)     
     Modelica.SIunits.Pressure dp \"Input pressure loss\";
     Modelica.SIunits.MassFlowRate M_FLOW \"Output mass flow rate\";    
   end straightPipe
 
   equation
  end straightPipe
</pre>
</p>
 
<h4><font color=\"#EF9B13\">Step 2: Choose pressure loss <b> function </b> of interest 
</font></h4>
<p>
The HTPL correlations are modelled with functions for several devices. The pressure loss 
of a straight pipe to be modelled can be found by browsing through the <b> 
FluidDissipation </b> library and looking up the function of interest, here:
<pre>
   FluidDissipation.PressureLoss.StraightPipe.dp_overall_MFLOW
</pre>
This HTPL correlation for the compressible case of a straight pipe have to be dragged and 
dropped in the equation section of the <b> equation layer </b> of the model in Step 1.
<pre>
   model straightPipe
    //compressible case M_FLOW = f(dp)     
     Modelica.SIunits.Pressure dp \"Input pressure loss\";
     Modelica.SIunits.MassFlowRate M_FLOW \"Output mass flow rate\";    
 
    equation
    FluidDissipation.PressureLoss.StraightPipe.dp_overall_<b>MFLOW</b>
   end straightPipe
</pre>
 
<h4><font color=\"#EF9B13\">Step 3: Choose corresponding pressure loss <b> records </b> 
</font></h4>
The chosen function in Step 2 still needs its corresponding input values provided by 
records. These input records are spitted into one for input parameters (e.g. for 
geometry) and one for input variables (e.g. for fluid properties). The name of these 
input records are identical with the corresponding function but with the extension <b> 
_IN_con </b> for parameters and <b> _IN_var </b> for variables as input. These 
corresponding input record for the chosen function have to be dragged and dropped on the 
<b> diagram layer </b> of the model in Step 1.
<pre>
  Input parameter record: 
FluidDissipation.PressureLoss.StraightPipe.dp_overall<b>_IN_con</b> IN_con
  Input variable record: 
FluidDissipation.PressureLoss.StraightPipe.dp_overall<b>_IN_var</b> IN_var        
</pre>
 
Now the equation layer of the model in Step 1 should look similar to the following 
(without comments and annotation):
<pre>
  model straightPipe 
   ...  
   //records
   FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_con <b>IN_con</b>;
   FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_var <b>IN_var</b>;
  
   equation
   FluidDissipation.PressureLoss.StraightPipe.dp_overall_MFLOW
  end straightPipe
</pre>
 
<h4><font color=\"#EF9B13\">Step 4: Build function-record construction</font> </h4>
Now the input record have to be assigned to the chosen function in the equation layer. 
The resulting function-record implementation for the compressible case looks like the 
following:
<pre>
model straightPipe 
   ... 
  equation
  //compressible case
  M_FLOW = FluidDissipation.PressureLoss.StraightPipe.dp_overall_MFLOW(IN_con,IN_var,dp); 
end straightPipe
</pre>

Here the compressible case for the unknown mass flow rate (M_FLOW) is calculated by the 
known pressure difference (dp) out of the interfaces of the thermohydraulic framework and 
the input records (IN_con,IN_var) provide data like geometry and fluid properties for 
example.
 
<h4><font color=\"#EF9B13\">Step 5: Assign record variables </font></h4>
In the last step the variables of the input records for the function have to be assigned. 
The assignment of the record variables can either be done directly in the record on the 
diagram layer or in the equation layer. 
The assignment of the input record in the equation layer results into the following 
model:
<pre>
model straightPipe
 ... 
//compressible fluid flow
  //input record
  
FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Overall.Pres
sureLossInput_con
    IN_con(
    d_hyd=d_hyd,
    L=L,
    roughness=roughness,
    K=K);

 
FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Overall.Pres
sureLossInput_var
    IN_var(
    eta=eta,
    rho=rho);
 ...
end straight Pipe;
</pre> 
<p>
If the implementation of a HTPL correlation is done in an existing application model, the 
unknown variables out of Step 1 (M_FLOW and dp for compressible or DP and m_flow for 
incompressible case) have to be adjusted to the model variables (typically the interface 
variables). The implementation of HTPL correlation into <b> Modelica.Fluid </b> can be 
found for <a href=\"Modelica://FluidDissipation.Examples.TestCases.PressureLoss\"> flow 
models of several devices</a>.
</p>
 </html>"));
end GettingStarted;
