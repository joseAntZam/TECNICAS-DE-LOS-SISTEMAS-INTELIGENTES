(define (domain Mundo3 )
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
        CentroMando CentroReclutamiento Extractor - TiposEdificios
    )

    (:predicates
        ;;Posicion de una unidad , edifico o recurso en una localizacion
        (posicion ?x - varios ?y - Localizaciones)
        ;; Comunicacion entre dos localizaciones
        (camino ?x ?y - Localizaciones)
        ;;Un edificio esta construido
        (construido ?x - Edificios)
        ;;Unidad (operador) extrayendo un recurso
        (extrayendo ?x - Unidades ?y - TiposRecursos)
        ;;Un recurso esta en una localizacion
        (hay ?x - TiposRecursos ?y - Localizaciones)
        ;; Una unidad es de un tipo de unidad
        (esUnidad ?x - Unidades ?y - TiposUnidades) 
        ;;Un determinado edificio es de un tipo de edificio
        (esEdificio ?x - Edificios ?y - TiposEdificios)
        ;;Recuerso necesario para construir un edificio
        (necesita_para_construir ?x - TiposEdificios ?y - TiposRecursos)
        ;;Tengo un recurso , necesario para construir un edificio
        (tengo ?x - TiposRecursos)
        ;;Al tener diferentes
        

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
        :parameters (?unidad -Unidades ?locRecurso - Localizaciones )
        :precondition (and 
            (esUnidad ?unidad Operador)
            ;;unidad desocupada
            (not(extrayendo ?unidad Mineral))
            (not(extrayendo ?unidad Gas))
            ;;posicion de la unidad en la localizacion del recurso
            (posicion ?unidad ?locRecurso)
            ;;recurso en la localizacion
            (or
                (hay Mineral ?locRecurso)
                (and
                    (hay Gas ?locRecurso)
                    (exists (?edificio - Edificios)
                        (and
                            (construido ?edificio)
                            (esEdificio ?edificio Extractor)
                            (posicion ?edificio ?locRecurso)
                        )
                    )
                )
            )
        )
        :effect (and
        ;; Se marca el recurso que se esta extrayendo por la unidad y lo ponemos como que ya lo tenemos
        (forall (?recurso - TiposRecursos)
                (when (hay ?recurso ?locRecurso)
                    (and
                        (extrayendo ?unidad ?recurso)
                        (tengo ?recurso)
                    )
                )
            )
        
    )
    )



    (:action Construir
        :parameters (?unidad -Unidades ?edificio -Edificios ?loc - Localizaciones)
        :precondition (and 
            ;;Edificio no construido
            (not (construido ?edificio))
            (esUnidad ?unidad Operador)
            ;;unidad desocupada
            (not(extrayendo ?unidad Mineral))
            (not(extrayendo ?unidad Gas))
            ;; evitar que se construya más de un edificio en la misma localización
            (not (exists (?otroEdificio - Edificios)
                (and
                    (construido ?otroEdificio)
                    (posicion ?otroEdificio ?loc)
                )
            ))
            ;; iterar sobre los recursos necesarios para construir el edificio
            (exists (?tipoEdificio - TiposEdificios)
            (and
                (esEdificio ?edificio ?tipoEdificio)
                (forall (?recurso - TiposRecursos)
                    (imply
                        (necesita_para_construir ?tipoEdificio ?recurso)
                        (tengo ?recurso)
                    )
                )
            )
        )
            ;;Me encuentro en la localizacion de costruccion del edificio
            (posicion ?unidad ?loc)
        )
        :effect (and
            ;;Edificio construido
            (construido ?edificio)
            ;;Localizo el edificio en la localizacion
            (posicion ?edificio ?loc)
        )
    )

)



    


