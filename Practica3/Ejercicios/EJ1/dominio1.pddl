(define (domain Mundo1 )
    (:requirements 
        :strips 
        :typing
    )
    (:types
       
        Edificios Unidades TiposRecursos -varios
        TiposEdificios
        TiposUnidades 
        Localizaciones
    
    )
    (:constants
        Mineral Gas  - TiposRecursos
        Operador - TiposUnidades
        CentroMando CentroReclutamiento - TiposEdificios
    )

    (:predicates
        ;;Posicion de unidades recursos y edificios
        (posicion ?x - varios ?y - Localizaciones)
        ;;Camino entre localizaciones
        (camino ?x ?y - Localizaciones)
        ;;Indica si esta un edifico cosntruido
        (constrido ?x - Edificios)
        ;;Indica si una unidad esta extrayendo un recurso
        (extrayendo ?x - Unidades ?y - TiposRecursos)
        ;;Indica si un recurso esta en una localizacion
        (en ?x - TiposRecursos ?y - Localizaciones)
        ;;Indica si una unidad es de un tipo determinado
        (esUnidad ?x - Unidades ?y - TiposUnidades) 
        ;;Indica si un edificio es de un tipo determinado
        (esEdificio ?x - Edificios ?y - TiposEdificios)

    )
    (:action Navegar
        :parameters (?unidad -Unidades ?origen - Localizaciones ?destino - Localizaciones)
        :precondition (and
            ;;posicion de la unidad en el origen
            (posicion ?unidad ?origen)
            ;;camino entre origen y destino
            (camino ?origen ?destino)
            ;;unidad desocupada
            (not(extrayendo ?unidad Mineral))
            (not(extrayendo ?unidad Gas))
         )
        :effect (and
            ;;posicion de la unidad no en el origen
            (not (posicion ?unidad ?origen))
            ;;posicion de la unidad en el destino
            (posicion ?unidad ?destino)
         )
    )
    
    (:action Asignar
        :parameters (?unidad -Unidades ?locRecurso - Localizaciones ?recurso - TiposRecursos)
        :precondition (and 
            (esUnidad ?unidad Operador)
            ;;unidad desocupada
            (not(extrayendo ?unidad Mineral))
            (not(extrayendo ?unidad Gas))
            ;;posicion de la unidad en la localizacion del recurso
            (posicion ?unidad ?locRecurso)
            ;;recurso en la localizacion
            (en ?recurso ?locRecurso)
        )
        :effect (and 
            ;; Unidad esta extrayendo recurso
            (extrayendo ?unidad ?recurso)
        )
    )
    

)