% Definición de variables:
int :color1_verde = 100; 
int :color2_rojo = 250;
int :color3_naranja = 350;
int :color4_azul = 450;
% String con el nombre de los colores
enum nombres_colores = {Verde, Rojo, Naranja, Azul};
% String con el coste de los colores
array[1..4] of int: costos_colores = [color1_verde, color2_rojo, color3_naranja, color4_azul];
%variable costo_total
var int: costo_total;
%Variables de cada uno de los paises , comprenden entre 1..4 , que son los colores
var 1..4 : Argentina;
var 1..4: Bolivia;
var 1..4: Brasil;
var 1..4: Chile;
var 1..4: Colombia;
var 1..4: Ecuador;
var 1..4: Guayana_Francesa;
var 1..4: Guayana;
var 1..4: Paraguay;
var 1..4: Peru;
var 1..4: Surinam;
var 1..4: Uruguay;
var 1..4: Venezuela;
% Definición de restricciones , para que paises vecinos no tengan el mismo color
constraint Argentina != Bolivia /\ Argentina != Brasil /\ Argentina != Chile /\ Argentina != Paraguay /\ Argentina != Uruguay;
constraint Bolivia != Argentina /\ Bolivia != Brasil /\ Bolivia != Chile /\ Bolivia != Paraguay /\ Bolivia != Peru;
constraint Brasil != Argentina /\ Brasil != Bolivia /\ Brasil != Colombia /\ Brasil != Guayana_Francesa /\ Brasil != Guayana /\ Brasil != Paraguay /\ Brasil != Peru /\ Brasil != Surinam /\ Brasil != Uruguay /\ Brasil != Venezuela;
constraint Chile != Argentina /\ Chile != Bolivia /\ Chile != Peru;
constraint Colombia != Brasil /\ Colombia != Ecuador /\ Colombia != Peru /\ Colombia != Venezuela;
constraint Ecuador != Colombia /\ Ecuador != Peru;
constraint Guayana_Francesa != Brasil /\ Guayana_Francesa != Surinam;
constraint Guayana != Brasil /\ Guayana != Surinam /\ Guayana != Venezuela;
constraint Paraguay != Argentina /\ Paraguay != Bolivia /\ Paraguay != Brasil /\ Paraguay != Uruguay;
constraint Peru != Bolivia /\ Peru != Brasil /\ Peru != Chile /\ Peru != Colombia /\ Peru != Ecuador;
constraint Surinam != Brasil /\ Surinam != Guayana_Francesa /\ Surinam != Guayana;
constraint Uruguay != Argentina /\ Uruguay != Brasil /\ Uruguay != Paraguay;
constraint Venezuela != Brasil /\ Venezuela != Colombia /\ Venezuela != Guayana;
%Restricion para saber cual es el coste total ,dependiendo del color de cada pais
%Se multiplica cada uno de los costes de cada color por el numero de paises que
%tienen ese color
%Ejemplo : paises de color verde : Argentina , chile , venezuela 
         % OPERACION: 100*(1+0+0+1+0+0+0+0+0+0+0+0+1)
constraint costo_total = sum(i in 1..4) (costos_colores[i] * ((Argentina = i) + (Bolivia = i) + (Brasil = i) + (Chile = i) + (Colombia = i) + (Ecuador = i) + (Guayana_Francesa = i) + (Guayana = i) + (Paraguay = i) + (Peru = i) + (Surinam = i) + (Uruguay = i) + (Venezuela = i)));

%constraint costo_total = 2900;
solve minimize costo_total;
%solve satisfy;
% Definición de salida:
output ["COSTE TOTAL : ",show(costo_total), "\n",
        "Argentina : ", "\(nombres_colores[Argentina])" , " ", show(costos_colores[Argentina]), "\n",
        "Bolivia : ", "\(nombres_colores[Bolivia])", " ", show(costos_colores[Bolivia]), "\n",
        "Brasil : ", "\(nombres_colores[Brasil])", " ", show(costos_colores[Brasil]), "\n",
        "Chile : ", "\(nombres_colores[Chile])", " ", show(costos_colores[Chile]), "\n",
        "Colombia : ", "\(nombres_colores[Colombia])", " ", show(costos_colores[Colombia]), "\n",
        "Ecuador : ", "\(nombres_colores[Ecuador])", " ", show(costos_colores[Ecuador]), "\n",
        "Guayana_Francesa : ", "\(nombres_colores[Guayana_Francesa])", " ", show(costos_colores[Guayana_Francesa]), "\n",
        "Guayana : ", "\(nombres_colores[Guayana])", " ", show(costos_colores[Guayana]), "\n",
        "Paraguay : ", "\(nombres_colores[Paraguay])", " ", show(costos_colores[Paraguay]), "\n",
        "Peru : ", "\(nombres_colores[Peru])", " ", show(costos_colores[Peru]), "\n",
        "Surinam : ","\(nombres_colores[Surinam])", " ", show(costos_colores[Surinam]), "\n",
        "Uruguay : ", "\(nombres_colores[Uruguay])", " ", show(costos_colores[Uruguay]), "\n",
        "Venezuela : ", "\(nombres_colores[Venezuela])", " ", show(costos_colores[Venezuela])];

