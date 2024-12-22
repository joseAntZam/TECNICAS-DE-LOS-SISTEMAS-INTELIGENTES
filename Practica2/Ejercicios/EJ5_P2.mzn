include "tsiutils.mzn";
% Set de valores
int: size;
int: capacidad_mochila = 5000;

% Pesos
array[1..size] of var int : Pesos;
constraint pesosN(Pesos);

% Prioridad
array[1..size] of var int : Prioridad;
constraint prioridadN(Prioridad);

% Variables de decisión
array[1..size] of var bool: Mochila; % 1 si el objeto i está en la mochila, 0 en caso contrario

% Beneficio y peso total
var int: beneficio = sum(i in 1..size) (Prioridad[i] * Mochila[i]);
var int: pesoTotal = sum(i in 1..size) (Pesos[i] * Mochila[i]);

constraint pesoTotal <= capacidad_mochila;

solve maximize beneficio;

% Formatear la salida
output [
%Utilizo fix para obtener el valor de Mochila una vez encontrada la solucion
%Utilizo floor para garantizar que la parte decimal sea un entero ,
%ejemplo de ello sería el siguinete--> floor(3.5) = 3 
  "Objetos = " ++ concat([ "O" ++ show(i) ++ " " | i in 1..size where fix(Mochila[i]) == 1]), " | ",
  "Número de objetos = ", show(sum(i in 1..size)(fix(Mochila[i]))), " | ",
  "Prioridades = ", show(beneficio), " | ",
  "PesoFinal = ", show(pesoTotal div 1000), ".", show(floor(pesoTotal mod 1000 / 100)), " kgs"
];