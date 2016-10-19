within FluidDissipation.Utilities.Functions.General;
function SearchVectorMax
  "Returns maximum value and corresponding index of vector"
  extends Modelica.Icons.Function;
  input Real vector[:];

  output Real maximum;
  output Integer index;

algorithm
  maximum := vector[1];
  index := 1;
  for i in 2:size(vector, 1) loop
    if maximum < vector[i] then
      maximum := vector[i];
      index := i;
    end if;
  end for;
  annotation (Inline=false, smoothOrder=5);
end SearchVectorMax;
