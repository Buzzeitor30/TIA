﻿;Dominio mercancias

;Breve descripción del dominio: se dispone de furgonetas, camiones, zona ZLE, zona intercambiador
;neutra y pedidos. Los pedidos se transportan con las furgonetas entre las distintas zonas. Un camión
;no puede circular por ua zona ZLE, una furgoneta por donde quiera. Los camiones solo pueden recorrer 70km diarios
;(entre todos), pero se puede ampliar 20km pagando 20€ (solo incrementos de 20). 

(define (domain mercancias) ;nombre del dominio
(:requirements :durative-actions :typing :fluents :negative-preconditions)
(:types pedido zona vehiculo - object) ; existen camiones, furgonetas, pedidos, ZLE, intercambiador
(:predicates (at ?v - vehiculo ?z - zona)
             ;Predicados para distinguir el tipo de zona
             (es_zle ?z - zona)
             (es_intercambiador ?z - zona)
             ;Predicados para el tipo de vehiculo
             (es_furgo ?v - vehiculo)
             (es_camion ?v - vehiculo)
             ;Predicados, el primero para saber donde se encuentra el pedido y el segundo para saber que vehiculo lo transporta
             (at_pedido ?p - pedido ?z - zona)
             (en ?p - pedido ?v - vehiculo)
)

(:functions 
            (distance ?z1 - zona ?z2 - zona)
	    (kilometraje)
	    (dinero-extra)
            (presupuesto)
)

(:durative-action transportar-furgo
;Parametros => vehiculo v y zonas z1 z2
:parameters (?v - vehiculo ?z1 ?z2 - zona)
;Para la furgo el tiempo es la distancia
:duration (= ?duration (distance ?z1 ?z2))
;La furgo tiene que estar al principio en z1
:condition (and (at start(at ?v ?z1))
                (over all (es_furgo ?v))
        )
;Al acabar la furgoneta deja de estar en z1 y se va a z2
:effect (and (at start (not (at ?v ?z1)))
             (at end (at ?v ?z2))    
)
)

(:durative-action transportar-camion
;Parametros => vehiculo v y zonas z1 z2
:parameters (?v - vehiculo ?z1 ?z2 - zona)
;Para el camion el tiempo es dist/4
:duration (= ?duration (/ (distance ?z1 ?z2) 4))
;El camion tiene que estar al principio en z1 y z2 no puede ser ZLE
:condition (and (at start(at ?v ?z1))
                (over all (es_camion ?v))
                (over all (not (es_zle ?z2)))
		(at start (>= (kilometraje) (distance ?z1 ?z2)))
        )
;Al acabar el camion deja de estar en z1 y se va a z2
:effect (and (at start (not (at ?v ?z1)))
             (at end (at ?v ?z2))
	     (at end (decrease (kilometraje) (distance ?z1 ?z2)))  
)
)

(:durative-action intercambiar
:parameters (?v1 ?v2 - vehiculo ?z - zona ?p - pedido)
:duration (= ?duration 3)
:condition (and (over all (at ?v1 ?z))
		(over all (at ?v2 ?z))
		(at start (en ?p ?v1))
		(over all (es_intercambiador ?z))
)
:effect (and   (at end (en ?p ?v2))
		(at end (not (en ?p ?v1)))
)
)

(:durative-action incrementar
:parameters ()
:duration (= ?duration 1)
:condition (and (at start (>= (presupuesto) 20)))
:effect (and (at end (decrease (presupuesto) 20))
	     (at end (increase (dinero-extra) 20))
	     (at end (increase (kilometraje) 20))
)
)
(:durative-action recoger
;Parametros => vehiculo v y zona z1
:parameters (?v - vehiculo ?z1 - zona ?p - pedido)
:duration (= ?duration 1)
;El camion tiene que estar overall en z1 y el pedido debe estar al principio
:condition (and (over all (at ?v ?z1))
                (at start (at_pedido ?p ?z1))
        )
;El pedido se va de z1 y se sube al camion
:effect (and (at start (not (at_pedido ?p ?z1)))
             (at end (en ?p ?v))    
)
)

(:durative-action entregar
:parameters (?v - vehiculo ?z1 - zona ?p - pedido)
:duration (= ?duration 2)
;El camion tiene que estar al principio en z1  y el pedido en el camion
;destino correcto
:condition (and (over all (at ?v ?z1))
                (at start (en ?p ?v))
        )
;El pedido deja de estar en el camion y llega a su destino
:effect (and (at start (not (en ?p ?v)))
             (at end (at_pedido ?p ?z1))    
)
)

)
