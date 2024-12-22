include "globals.mzn";
set of int: HORAS = 1..7;
set of int: DIAS = 1..5;
set of int: ASIGNATURAS = 0..10; %La asigantura 0 es la tutoria 
set of int: ASIGNATURAS_1HORA = {9};
set of int: ASIGNATURAS_2HORA = {2,6,7,8};
set of int: ASIGNATURAS_4HORA = {1,3,4,5};
set of int: ASIGNATURAS_5HORA = {10};
set of int: ASIGNATURAS_2HORAS_CONSECUTIVAS = {1,3,4,5,8};
set of int: ASIGNATURAS_1HORAS_CONSECUTIVAS = {2,6,7,9,10};
%horario
array[HORAS,DIAS] of var ASIGNATURAS : horario; %horas--> filas , dias-->columnas

% Inicializar el contador en cero para cada asignatura
array[ASIGNATURAS] of var int: Contador;


%numero de veces que tiene quer aparcer las asignaturas en el horario

      %Creamos un contador con el recuento de veces que aparece cada asignatura en el horario
      constraint forall (asignatura in ASIGNATURAS) (
          Contador[asignatura] = count(hora in HORAS, dia in DIAS) (
              horario[hora, dia] == asignatura
          )
      );
      
      %Restricciones de que el valor del contador de cada asignatura sea igual al numero de horas de cada asignatura
      constraint forall (i in ASIGNATURAS_1HORA)(
          Contador[i] = 1
      );
      
      constraint forall (i in ASIGNATURAS_2HORA)(
          Contador[i] = 2
      );
      constraint forall (i in ASIGNATURAS_4HORA)(
          Contador[i] = 4
      );
      
      constraint forall (i in ASIGNATURAS_5HORA)(
          Contador[i] = 5
      );

%comprobamos los bloques de dos horas 
      %Comprobamos que las asignaturas 1,3,4,5,8 , se impartan en bloques de dos horas 
      %Ejemplo : (Primer if)--> Si a ultima hora vemos que se imparte la asignatura 3 , si o si en la penultima hora se tiene que impartir la asignatura 3
      %          (elseif)--> Si a primera hora vemos que se imparte la asignatura 3 , si o si en la segunda hora se tiene que impartir la asignatura 3
      %          (esle)--> Si a quinta hora se imparte la asignatura 3 , o a cuarta o a sexta hora , tambien debera impartirse la asigantura 3
      constraint forall(hora in HORAS , dia in DIAS)(
          if horario[hora,dia] in ASIGNATURAS_2HORAS_CONSECUTIVAS then
          
             if hora == 7 then
                horario[hora,dia] = horario[hora-1,dia]
                
             elseif hora == 1 then
                horario[hora,dia] = horario[hora+1,dia]
                
             else
                (horario[hora,dia] = horario[hora+1,dia] /\ horario[hora,dia] !=  horario[hora-1,dia]) 
                \/
                (horario[hora,dia] = horario[hora-1,dia] /\ horario[hora,dia] !=  horario[hora+1,dia]) 
                
             endif
             
          endif
      );


%comprobamos los bloques de una horas 
      %Comprobamos que las asignaturas 2,6,7,9,10 , se impartan en bloques de una horas 
      %Ejemplo : (Primer if)--> Si a ultima hora vemos que se imparte la asignatura 6 ,  en la penultima hora no se puede impartir la asignatura 6
      %          (elseif)--> Si a primera hora vemos que se imparte la asignatura 6 , en la segunda hora no se puede que impartir la asignatura 6
      %          (esle)--> Si a quinta hora se imparte la asignatura 6 , ni a cuarta ni a sexta hora puede impartirse la asignatura 6
      constraint forall(hora in HORAS , dia in DIAS)(
          if horario[hora,dia] in ASIGNATURAS_1HORAS_CONSECUTIVAS then
          
             if hora == 7 then
                horario[hora,dia] != horario[hora-1,dia]
                
             elseif hora == 1 then
                horario[hora,dia] != horario[hora+1,dia]
                
             else
                (horario[hora,dia] != horario[hora+1,dia] /\ horario[hora,dia] !=  horario[hora-1,dia]) 
                
             endif
             
          endif
      );
      
%Un unico bloque de cada asignatura al dia
      array[ASIGNATURAS,DIAS] of var int: ContadorBloques;
      
      %Creamos un contador con el recuento de veces que aparece cada asignatura cada dia
      constraint forall (asignatura in ASIGNATURAS , dia in DIAS) (
                ContadorBloques[asignatura,dia] = count(hora in HORAS) (
                    horario[hora, dia] == asignatura
                )
            );
      %Restriccion de que el valor del contador de cada ASIGNATURAS_2HORAS_CONSECUTIVAS sea menor o igual a 2 para cualquier dia   
      constraint forall (i in ASIGNATURAS_2HORAS_CONSECUTIVAS , dia in DIAS)(
                ContadorBloques[i,dia] <= 2
            );
      %Restriccion de que el valor del contador de cada ASIGNATURAS_1HORAS_CONSECUTIVAS sea menor o igual a 1 para cualquier dia      
      constraint forall (i in ASIGNATURAS_1HORAS_CONSECUTIVAS, dia in DIAS)(
                ContadorBloques[i,dia] <= 1
            );
       


%restricciones de los profesores
      
      %profesor1
      constraint forall(hora in HORAS , dia in DIAS where hora != 5 /\ hora != 6)(
            horario[hora,dia] != 1 /\ horario[hora,dia] !=3
      );
      %profesor2
      constraint forall(hora in HORAS , dia in DIAS where hora != 1 /\ hora != 2)(
            horario[hora,dia] != 4 /\ horario[hora,dia] !=5
      );
      %profesor5
      constraint forall(hora in HORAS , dia in DIAS where hora != 4)(
            horario[hora,dia] != 10
      );

%cuarta hora --> tutoria
      constraint forall(dia in DIAS)(
            horario[3,dia] = 0
      );

%restricciones de los asignaturas
      
      %Asigantura 1 y 4 :lunes o martes
      constraint forall(hora in HORAS , dia in DIAS where dia != 1 /\ dia != 2)(
            horario[hora,dia] != 1 /\ horario[hora,dia] !=4
      );
      %Asignatura 3: miércoles o jueves
      constraint forall(hora in HORAS , dia in DIAS where dia != 3 /\ dia != 4)(
            horario[hora,dia] != 3 
      );
      %Asignatura 5: jueves o viernes
      constraint forall(hora in HORAS , dia in DIAS where dia != 4 /\ dia != 5)(
            horario[hora,dia] != 5 
      );
      %Asignatura 6: miércoles o viernes
      constraint forall(hora in HORAS , dia in DIAS where dia != 3 /\ dia != 5)(
            horario[hora,dia] != 6
      );
      %Asignatura 7: martes o viernes
      constraint forall(hora in HORAS , dia in DIAS where dia != 2 /\ dia != 5)(
            horario[hora,dia] != 7
      );
      %Asignatura 8: miércoles
      constraint forall(hora in HORAS , dia in DIAS where dia != 3)(
            horario[hora,dia] != 8
      );
      %Asignatura 9: lunes
      constraint forall(hora in HORAS , dia in DIAS where dia != 1)(
            horario[hora,dia] != 9
      );
      %En caso de impartirse el mismo día, las asignaturas 6 y 7 deben ir: primero, la
      %asignatura 6 y, en la franja horaria inmediatamente posterior, la asignatura 7.
      constraint forall(dia in DIAS)(
            %Este if comprueba que esten las asiganturas 6 y 7 en un mismo dia
            if((horario[1,dia] == 6 \/ 
               horario[2,dia] == 6 \/ 
               horario[3,dia] == 6 \/ 
               horario[4,dia] == 6 \/ 
               horario[5,dia] == 6 \/ 
               horario[6,dia] == 6 \/ 
               horario[7,dia] == 6)
               /\
               (horario[1,dia] == 7 \/ 
               horario[2,dia] == 7 \/ 
               horario[3,dia] == 7 \/ 
               horario[4,dia] == 7 \/ 
               horario[5,dia] == 7 \/ 
               horario[6,dia] == 7 \/ 
               horario[7,dia] == 7)) then
               
               %Ponemos todos los posibles caso que pueden cumplir la condición, recordando que la hora 3
               %es para tutoria , por lo cual no podrá estar en esa posicion de la matriz ni la asigantura 6 ni la 7
               (horario[1,dia] = 6 /\ horario[2,dia] = 7)
               \/
               (horario[4,dia] = 6 /\ horario[5,dia] = 7)
               \/
               (horario[5,dia] = 6 /\ horario[6,dia] = 7)
               \/
               (horario[6,dia] = 6 /\ horario[7,dia] = 7)
               
               
               endif      
      );
   



solve satisfy;

output
[
  "LUNES     \(horario[1,1]) | \(horario[2,1]) | \(horario[3,1]) | \(horario[4,1]) | \(horario[5,1]) | \(horario[6,1]) | \(horario[7,1]) | \n" ++
  "MARTES    \(horario[1,2]) | \(horario[2,2]) | \(horario[3,2]) | \(horario[4,2]) | \(horario[5,2]) | \(horario[6,2]) | \(horario[7,2]) | \n" ++
  "MIERCOLES \(horario[1,3]) | \(horario[2,3]) | \(horario[3,3]) | \(horario[4,3]) | \(horario[5,3]) | \(horario[6,3]) | \(horario[7,3]) | \n" ++
  "JUEVES    \(horario[1,4]) | \(horario[2,4]) | \(horario[3,4]) | \(horario[4,4]) | \(horario[5,4]) | \(horario[6,4]) | \(horario[7,4]) | \n" ++
  "VIERNES   \(horario[1,5]) | \(horario[2,5]) | \(horario[3,5]) | \(horario[4,5]) | \(horario[5,5]) | \(horario[6,5]) | \(horario[7,5]) | \n"

];