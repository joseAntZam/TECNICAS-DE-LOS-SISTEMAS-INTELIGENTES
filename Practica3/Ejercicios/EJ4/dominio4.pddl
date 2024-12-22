(define (domain Mundo4 )
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
        Operador Androide Soldado - TiposUnidades
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
        ;;Recuerso necesario para reclutar una unidad
        (necesita_para_reclutar ?x - TiposUnidades ?y - TiposRecursos)
        ;;Donde reclutan una unidad
        (reclutamiento_en ?x - TiposUnidades ?y - TiposEdificios)

        
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
        (when (hay Mineral ?locRecurso)
            (and
                (extrayendo ?unidad Mineral)
                (tengo Mineral)
            )
        )
        (when (hay Gas ?locRecurso)
            (and
                (extrayendo ?unidad Gas)
                (tengo Gas)
            )
        )
        
    )
    )



    (:action Construir
        :parameters (?unidad -Unidades ?edificio -Edificios ?loc - Localizaciones)
        :precondition (and 
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



   (:action Reclutar
         :parameters (?edificio - Edificios ?unidad - Unidades ?loc - Localizaciones)
         :precondition (and

            ;; El edificio debe estar construido
             (construido ?edificio)
             ;; La localización del edificio es la misma donde aparecerá la unidad
             (posicion ?edificio ?loc)
             ;; La unidad no debe estar en otra localización
             ;; es decir no esta reclutada
             (not (exists (?localizacion - Localizaciones)
                        (posicion ?unidad ?localizacion)
                )
             ) 
            
            ;; Verificar que el tipo de unidad se corresponde con el tipo de edificio
            (exists (?tipoUnidad - TiposUnidades ?tipoEdificio - TiposEdificios)
            (and
                (esUnidad ?unidad ?tipoUnidad)
                (reclutamiento_en ?tipoUnidad ?tipoEdificio)
                (esEdificio ?edificio ?tipoEdificio)
            )
            )
            ;; Verificar que se tienen los recursos necesarios para reclutar la unidad
             (exists (?tipoUnidad - TiposUnidades)
            (and
                (esUnidad ?unidad ?tipoUnidad)
                (forall (?recurso - TiposRecursos)
                    (imply
                        (necesita_para_reclutar ?tipoUnidad ?recurso)
                        (tengo ?recurso)
                    )
                )
            )
            )
             
         )
         :effect (and
             ;; La nueva unidad aparece en la localización del edificio
            (posicion ?unidad ?loc)
        )
     )

)