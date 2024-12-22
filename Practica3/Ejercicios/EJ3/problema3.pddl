;;Lo unico que he tocado es generalizar el predicado necesita_para_cosntruir

(define (problem problemaMundo) (:domain Mundo3)
(:objects 
   LOC11 LOC12 LOC13 LOC14 LOC15 - Localizaciones
   LOC21 LOC22 LOC23 LOC24  - Localizaciones
   LOC31 LOC32 LOC34 LOC35 - Localizaciones
   LOC42 LOC44  - Localizaciones
   CentroMando1 - Edificios
   Extractor1 - Edificios
   CentroReclutamiento1 - Edificios
   Operador1 - Unidades
   Operador2 - Unidades
   Operador3 - Unidades
   
)

(:init
    ;;CentroMando1 construido
    (construido CentroMando1)

    ;;POSICONES
    (posicion CentroMando1 LOC11)
    (posicion Operador1 LOC11)
    (posicion Operador2 LOC11)
    (posicion Operador3 LOC11)

    ;;IDENTIFICACIONES
    (esEdificio CentroMando1 CentroMando)
    (esUnidad Operador1 Operador)
    (esUnidad Operador2 Operador)
    (esUnidad Operador3 Operador)
    (esEdificio Extractor1 Extractor)
    (esEdificio CentroReclutamiento1 CentroReclutamiento)

    ;; La cosntruccion de Extractor requiere Mineral
    (necesita_para_construir Extractor Mineral)
    ;; La construcción de CentroReclutamiento requiere Mineral y Gas
    (necesita_para_construir CentroReclutamiento Mineral)
    (necesita_para_construir CentroReclutamiento Gas)

    ;; Localizaciones de los minerales
    (hay Mineral LOC15)
    (hay Mineral LOC23)
    (hay Gas LOC14)

    ;; Los operadores están desocupados
    (not (extrayendo Operador1 Mineral))
    (not (extrayendo Operador1 Gas))
    (not (extrayendo Operador2 Mineral))
    (not (extrayendo Operador2 Gas))
    (not (extrayendo Operador3 Mineral))
    (not (extrayendo Operador3 Gas))

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
    ;; Construcción de un centro de reclutamiento en LOC44
    (construido CentroReclutamiento1)
    (posicion CentroReclutamiento1 LOC44)
))

)
