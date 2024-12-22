% Declaración de variables
include "globals.mzn";

%Definimos varibles a , b , c ,d teniendo en cuenta que estas pueden obtener el valor
% 0 , 1 , 2 , 3 , haciendo referencia 0 a W , 1 a X , 2 a Y y 3 a Z
set of int: POS = 0..3;
var POS: a;
var POS: b;
var POS: c;
var POS: d;
%Definimos los valores w,x,y,z para clarificar las restricciones
int : w = 0;
int : x = 1;
int : y = 2;
int : z = 3;

%w=0 , x= 1, y=2, z=3
%Este enum es util para el output
enum Letras = {W,X,Y,Z};

% Restricciones que debe cumplir la solucion
% el simbolo "->" significa "implica a"
constraint not(a = x) -> not(c = y);
constraint (b = y \/ b = z) -> (a = x);
constraint not(c = w) -> (b = z);
constraint (d = y) -> not(b = x);
constraint not(d = x) -> (b = x);
constraint all_different([a, b, c, d]);

% Búsqueda de soluciones
solve satisfy;

% Salida de soluciones
output ["a =  \(Letras[a+1]) , b = \(Letras[b+1]), c = \(Letras[c+1]), d = \(Letras[d+1]) \n"];