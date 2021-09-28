;---------------------------------DEFINIMOS LAS TEMPLATES--------------------------------

;TODO: Hacer el coche

(deftemplate vehiculo
(slot  id (type SYMBOL))
(slot distancia-crisp (type INTEGER))
(slot velocidad-crisp (type INTEGER)) ;km/h)
(slot fuerza-de-aceleracion-crisp-momentum (type FLOAT)) ;porcentaje)
(slot fuerza-de-aceleracion-crisp-maximum (type FLOAT)) ;porcentaje)
(slot presion-freno-crisp-momentum (type FLOAT))
(slot presion-freno-crisp-maximum (type FLOAT)))

(deftemplate distancia_rel
0 50 metros
((cerca (0 1)(5 1)(15 0))
(medio (10 0)(20 1)(30 1)(35 0))
(lejos (30 0)(35 1))
))

(deftemplate fuerza_acel
0 100 por
((baja (0 1)(5 1)(20 0))
 (media (10 0)(40 1)(70 0))
 (alta (60 0)(100 1))
 (nula (0 0)(0 1)(0 0))	
))

(deftemplate pres_fre
0 100 por
((baja (0 1)(5 1)(20 0))
 (media (10 0)(40 1)(60 1)(70 0))
 (alta (60 0)(100 1))
 (nula (0 0)(0 1)(0 0))
))

(deftemplate velocidad_rel
-30 30 kmh
((alejando (-30 1)(0 0))
(constante (-10 0)(0 1)(15 0))
(acercando (0 0)(30 1))
))

;-------------------------------REGLAS-------------------------------------------------
;Función fuzzify, copiada directamente del boletín

(deffunction fuzzify (?fztemplate ?value ?delta) 
 
        (bind ?low (get-u-from ?fztemplate)) 
        (bind ?hi  (get-u-to   ?fztemplate)) 
 
        (if (<= ?value ?low) 
          then 
            (assert-string 
              (format nil "(%s (%g 1.0) (%g 0.0))" ?fztemplate ?low ?delta)) 
          else 
            (if (>= ?value ?hi) 
              then 
                (assert-string 
                   (format nil "(%s (%g 0.0) (%g 1.0))" 
                               ?fztemplate (- ?hi ?delta) ?hi)) 
              else 
                (assert-string 
                   (format nil "(%s (%g 0.0) (%g 1.0) (%g 0.0))" 
                               ?fztemplate (max ?low (- ?value ?delta)) 
                               ?value (min ?hi (+ ?value ?delta)) )) 
            )))

(defrule leerconsola ;Leemos valores crisp y fusificamos la velocidad y distancia
	(initial-fact)
=>	
	(printout t"Introduce el identificador de tu coche"crlf)
	(bind ?id (read))
	(printout t"Introduce la distancia en metros"crlf)
	(bind ?Rdist (read))
	(printout t"Introduce la velocidad en km/h"crlf)
	(bind ?Rvel (read))
	(assert (vehiculo (id ?id) (distancia-crisp ?Rdist) (velocidad-crisp ?Rvel) (fuerza-de-aceleracion-crisp-momentum 0.0) (fuerza-de-aceleracion-crisp-maximum 0.0) (presion-freno-crisp-momentum 0.0) (presion-freno-crisp-maximum 0.0)))
	(fuzzify velocidad_rel ?Rvel 0.0)
	(fuzzify distancia_rel ?Rdist 0.0)
)

;TABLAS
(defrule alejando_cerca
	(velocidad_rel alejando)
	(distancia_rel cerca)
	=>
	(assert (fuerza_acel media))
	(assert (pres_fre nula))
)

(defrule alejando_medio
	(velocidad_rel alejando)
	(distancia_rel medio)
	=>
	(assert (fuerza_acel more-or-less alta))
	(assert (pres_fre nula))
)

(defrule alejando_lejos
	(velocidad_rel alejando)
	(distancia_rel lejos)
	=>
	(assert (fuerza_acel very alta))
	(assert (pres_fre nula))
)  

(defrule constante_cerca
	(velocidad_rel constante)
	(distancia_rel cerca)
	=>
	(assert (fuerza_acel nula))
	(assert (pres_fre very baja))
)

(defrule constante_medio
	(velocidad_rel constante)
	(distancia_rel medio)
	=>
	(assert (fuerza_acel media))
	(assert (pres_fre very nula))
)

(defrule constante_lejos
	(velocidad_rel constante)
	(distancia_rel lejos)
	=>
	(assert (fuerza_acel alta))
	(assert (pres_fre very nula))
)    

(defrule acercando_cerca
	(velocidad_rel acercando)
	(distancia_rel cerca)
	=>
	(assert (fuerza_acel nula))
	(assert (pres_fre very alta))
)

(defrule acercando_medio
	(velocidad_rel acercando)
	(distancia_rel medio)
	=>
	(assert (fuerza_acel nula))
	(assert (pres_fre very more-or-less media))
)

(defrule acercando_lejos
	(velocidad_rel acercando)
	(distancia_rel lejos)
	=>
	(assert (fuerza_acel very baja))
	(assert (pres_fre very baja))
)


;-----------------------------------------------PRESENTACIÓN DE RESULTADOS-------------------------------------

