%INCLUDES

include "data.dzn";
include "alldifferent.mzn";
%-----
% PARAMETROS
%par int: dim; esto es del a)
par int: N; %numero de rectangulos
array [1..N] of par int: alto;  %alto de los rectangulos
array [1..N] of par int: ancho; %ancho de los rectangulos


% VARIABLES
array [1..N] of var 0..100: x;
array [1..N] of var 0..100: y;
%var int: d;
var int: h;
var int: w;
%RESTRICCIONES
constraint forall(i in 1..N, j in 1..N where i!=j)(
                  x[j] >= x[i] + ancho[i] \/
                  x[i] >= x[j] + ancho[j] \/
                  y[i] >= y[j] + alto[j] \/
                  y[j] >= y[i] + alto[i] );
                  
constraint forall(i in 1..N-1) (x[i] + ancho[i] <= w /\ y[i] + alto[i] <= h);
constraint (x[N] + ancho[N] <= w /\ y[N] + alto[N] <= h) \/ (x[N] >= alto[N]); %TODO d)
%RESOLVER
solve minimize w*h;

output["Altura: ", show(h),"\nAnchura:",show(w),"\nSuperfície mínima: ",show(w*h), "\nCoordenadas x: ",show(x),"\nCoordenadas y: ", show(y)];