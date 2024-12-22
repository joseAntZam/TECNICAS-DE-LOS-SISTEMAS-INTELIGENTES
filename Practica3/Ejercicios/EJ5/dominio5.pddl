(define (domain Mundo5 )
    (:requirements 
        :strips 
        :typing
    )
    (:types
       
        Edificios Unidades TiposRecursos Investigaciones - varios
        TiposEdificios
        TiposUnidades 
        Localizaciones
        TipoInvestigaciones
    
    )
    (:constants
        Mineral Gas Especia - TiposRecursos
        Operador Androide Soldado - TiposUnidades
        CentroMando CentroReclutamiento Extractor Laboratorio Teletransportador - TiposEdificios
        InvestigarSoldado InvestigarTeletransporte - TipoInvestigaciones
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
        ;;Util para saber si se tiene una investigacion
        (tengoInvestigacion ?x - TipoInvestigaciones)
        ;;Que recursos necesita una investigacion
        (necesita_para_investigar ?x - TipoInvestigaciones ?y - TiposRecursos)
        ;;Al igual que para edificios y unidades 
        (esInvestigacion ?x - Investigaciones ?y - TipoInvestigaciones)
        
        
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
            (not(extrayendo ?unidad Especia))
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
            (not(extrayendo ?unidad Especia))
            ;;posicion de la unidad en la localizacion del recurso
            (posicion ?unidad ?locRecurso)
            ;;recurso en la localizacion
            (or
                (hay Mineral ?locRecurso)
                (hay Especia ?locRecurso)
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
        (when (hay Especia ?locRecurso)
            (and
                (extrayendo ?unidad Especia)
                (tengo Especia)
            )
        )
        
    )
    )



    (:action Construir
        :parameters (?unidad -Unidades ?edificio -Edificios ?loc - Localizaciones)
        :precondition (and 
            ;;El edificio no debe estar construido
            (not (construido ?edificio))

            (esUnidad ?unidad Operador)

            ;;Me encuentro en la localizacion de costruccion del edificio
            (posicion ?unidad ?loc)
            ;;unidad desocupada
            (not(extrayendo ?unidad Mineral))
            (not(extrayendo ?unidad Gas))
            (not(extrayendo ?unidad Especia))
            

            ;; Necesito tener los recursos necesarios para construir el edificio
            (forall (?recurso - TiposRecursos ?tipoEdificio - TiposEdificios)
                (imply(and (esEdificio ?edificio ?tipoEdificio) (necesita_para_construir ?tipoEdificio ?recurso))
                    (tengo ?recurso)
                )
            )
            
            ;; Que no se construya más de un edificio en la misma localización
            (forall ( ?edificio1 - Edificios) 
                (not(posicion ?edificio1 ?loc))
            )


            ;; Si el tipo de edificio es Teletransportador, necesito tener la investigación de teletransporte
            (imply (esEdificio ?edificio Teletransportador)
                (tengoInvestigacion InvestigarTeletransporte)
            )

            
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

             ;; La unidad no debe estar en otra localización , es decir no esta reclutada
             (forall (?posicion - Localizaciones)
                (not(posicion ?unidad ?posicion))
            )
            
            ;; Necesito tener los recursos necesarios para reclutar la unidad
            (forall (?recurso - TiposRecursos ?tipoUnidad - TiposUnidades)
                (imply(and (esUnidad ?unidad ?tipoUnidad) (necesita_para_reclutar ?tipoUnidad ?recurso))
                    (tengo ?recurso)
                )
            )
            ;; El edifico debe ser el tipo de edificio donde se recluta la unidad
            (forall (?tipounidad - TiposUnidades ?tipoedificio - TiposEdificios)
                (imply(and (esUnidad ?unidad ?tipounidad) (esEdificio ?edificio ?tipoedificio))
                    (reclutamiento_en ?tipounidad ?tipoedificio) 
                )
            )
            
            

            ;; Si la unidad es un soldado, necesito tener la investigación de soldado
            (imply(esUnidad ?unidad Soldado)
                (tengoInvestigacion InvestigarSoldado)
            )

            
             
         )
         :effect (and
             ;; La nueva unidad aparece en la localización del edificio
            (posicion ?unidad ?loc)
        )
     )


       (:action Investigar
            :parameters (?edificio - Edificios ?investigacion - Investigaciones)
            :precondition (and
                ;; El edificio debe estar construido
                (construido ?edificio)
                ;; El edificio debe ser un laboratorio
                (esEdificio ?edificio Laboratorio)

                ;;Necesito tener los recursos necesarios para investigar
                (forall(?recurso - TiposRecursos ?tipo - TipoInvestigaciones)
                    (imply(and (esInvestigacion ?investigacion ?tipo) (necesita_para_investigar ?tipo ?recurso))
                        (tengo ?recurso)
                    )
                
                )
            )
            :effect (and
                ;; Marcar la investigación como completada
                (forall (?tipo - TipoInvestigaciones)
                    (when (esInvestigacion ?investigacion ?tipo)
                        (tengoInvestigacion ?tipo)
                    )
                )
                
            )
        )
)