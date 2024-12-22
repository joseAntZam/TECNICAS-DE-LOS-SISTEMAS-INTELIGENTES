(define (problem problemaMundo) (:domain Mundo6)
(:objects 
   LOC11 LOC12 LOC13 LOC14 LOC15 - Localizaciones
   LOC21 LOC22 LOC23 LOC24  - Localizaciones
   LOC31 LOC32 LOC34 LOC35 - Localizaciones
   LOC42 LOC44  - Localizaciones
   Extractor1 CentroMando1 CentroReclutamiento1 Laboratorio1 Teletransportador1 Teletransportador2 - Edificios
   Operador1 Operador2 Operador3 Operador4 Androide1 Androide2 Soldado1 - Unidades
   InvestigarSoldado1  InvestigarTeletrasporte1 - Investigaciones
   

   
)

(:init
    ;;CentroMando1 construido
    (construido CentroMando1)

    ;;POSICONES
    (posicion CentroMando1 LOC11)
    (posicion Operador1 LOC11)

    ;;IDENTIFICACIONES
    
    (esUnidad Operador1 Operador)
    (esUnidad Operador2 Operador)
    (esUnidad Operador3 Operador)
    (esUnidad Operador4 Operador)
    (esUnidad Androide1 Androide)
    (esUnidad Androide2 Androide)
    (esUnidad Soldado1 Soldado)
    (esEdificio CentroMando1 CentroMando)
    (esEdificio Extractor1 Extractor)
    (esEdificio CentroReclutamiento1 CentroReclutamiento)
    (esEdificio Laboratorio1 Laboratorio)
    (esEdificio Teletransportador1 Teletransportador)
    (esEdificio Teletransportador2 Teletransportador)
    (esInvestigacion InvestigarSoldado1 InvestigarSoldado)
    (esInvestigacion InvestigarTeletrasporte1 InvestigarTeletransporte)

    ;; La cosntruccion de Extractor requiere Mineral
    (necesita_para_construir Extractor Mineral)
    ;; La construcción de CentroReclutamiento requiere Mineral y Gas
    (necesita_para_construir CentroReclutamiento Mineral)
    (necesita_para_construir CentroReclutamiento Gas)
    ;; La construcción de Laboratorio requiere Mineral y Gas
    (necesita_para_construir Laboratorio Mineral)
    (necesita_para_construir Laboratorio Gas)



    ;; El reclutamiento de Androides y operadores requiere minerales
    (necesita_para_reclutar Androide Mineral)
    (necesita_para_reclutar Operador Mineral)
    ;; El reclutamiento de Soldados requiere minerales y gas
    (necesita_para_reclutar Soldado Mineral)
    (necesita_para_reclutar Soldado Gas)


    ;; Requerimientos investigaciones
    (necesita_para_investigar InvestigarSoldado Mineral)
    (necesita_para_investigar InvestigarSoldado Gas)
    (necesita_para_investigar InvestigarTeletransporte Mineral)
    (necesita_para_investigar InvestigarTeletransporte Especia )

    ;; Localizaciones de los minerales
    (hay Mineral LOC15)
    (hay Mineral LOC23)
    (hay Gas LOC14)
    (hay Especia LOC13)

    ;; Los operadores están desocupados
    (not (extrayendo Operador1 Mineral))
    (not (extrayendo Operador1 Gas))
    (not (extrayendo Operador1 Especia)
    )

    ;; Donde se reclutan las unidades
    (reclutamiento_en Androide CentroReclutamiento)
    (reclutamiento_en Soldado CentroReclutamiento)
    (reclutamiento_en Operador CentroMando)

    ;;Inicicilaizar el coste
    (= (coste) 0)
    
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
    (posicion CentroReclutamiento1 LOC21)
    ;; Construcción de un laboratorio en LOC12
    (construido Laboratorio1)
    (posicion Laboratorio1 LOC12)
    ;; Construcción de un teletransportador en LOC35
    (construido Teletransportador1)
    (posicion Teletransportador1 LOC35)
    ;; Construcción de un teletransportador en LOC31
    (construido Teletransportador2)
    (posicion Teletransportador2 LOC31)
    ;; Posicion objetivo de las unidades
    (posicion Androide1 LOC15)
    (posicion Androide2 LOC15)
    (posicion Soldado1 LOC15)
    ;; Coste optimo
    (< (coste) 52)
)
)

)