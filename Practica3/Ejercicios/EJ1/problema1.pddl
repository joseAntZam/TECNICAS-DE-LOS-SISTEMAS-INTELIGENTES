(define (problem problemaMundo) (:domain Mundo1)
(:objects 
   LOC11 LOC12 LOC13 LOC14 LOC15 - Localizaciones
   LOC21 LOC22 LOC23 LOC24  - Localizaciones
   LOC31 LOC32 LOC34 LOC35 - Localizaciones
   LOC42 LOC44  - Localizaciones
   CentroMando1 - Edificios
   Operador1 - Unidades
   
)

(:init
    ;;CentroMando1 construido
    (constrido CentroMando1)
    ;; Operador1 y CentroMando1 en LOC11
    (posicion CentroMando1 LOC11)
    (posicion Operador1 LOC11)
    ;; Operador1 es de tipo Operador y CentroMando1 es de tipo CentroMando
    (esEdificio CentroMando1 CentroMando)
    (esUnidad Operador1 Operador)
    ;; Localizaciones de los minerales
    (en Mineral LOC15)
    (en Mineral LOC23)

    ;; El operador1 esta desocupado
    (not(extrayendo Operador1 Mineral))
    (not(extrayendo Operador1 Gas))

    ;; Conexiones observadas en el grafo de localizaciones
    (camino LOC11 LOC12) (camino LOC12 LOC11)
    (camino LOC14 LOC15) (camino LOC15 LOC14)
    (camino LOC21 LOC11) (camino LOC11 LOC21)
    (camino LOC22 LOC12) (camino LOC12 LOC22)
    (camino LOC22 LOC23) (camino LOC23 LOC22)
    (camino LOC23 LOC13) (camino LOC13 LOC23)
    (camino LOC23 LOC24) (camino LOC24 LOC23)
    (camino LOC24 LOC14) (camino LOC14 LOC24)
    (camino LOC31 LOC21) (camino LOC21 LOC31)
    (camino LOC31 LOC32) (camino LOC32 LOC31)
    (camino LOC32 LOC22) (camino LOC22 LOC32)
    (camino LOC34 LOC24) (camino LOC24 LOC34)
    (camino LOC35 LOC15) (camino LOC15 LOC35)
    (camino LOC42 LOC32) (camino LOC32 LOC42)
    (camino LOC42 LOC44) (camino LOC44 LOC42)
    (camino LOC44 LOC34) (camino LOC34 LOC44)
    (camino LOC44 LOC35) (camino LOC35 LOC44)
    

)

(:goal (and
    ;; Operador1 asiganado a nodo recurso
    (extrayendo Operador1 Mineral)
))

)
