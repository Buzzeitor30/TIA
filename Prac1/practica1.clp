;-------TEMPLATES----------

(deftemplate vehiculo
(slot  id (type SYMBOL))
(slot distancia-crisp (type INTEGER))
(slot velocidad-crisp (type INTEGER)) ;km/h)
(slot fuerza-de-aceleracion-crisp-momentum (type FLOAT)) ;porcentaje)
(slot fuerza-de-aceleracion-crisp-maximum (type FLOAT)) ;porcentaje)
(slot presion-freno-crisp-momentum (type FLOAT))
(slot presion-freno-crisp-maximum (type FLOAT)))

(deftemplate dis_rel
0 50 m
((cerca (0 1)(5 1)(15 0))
(medio (10 0)(20 1)(30 1)(35 0))
(lejos (30 0)(35 1))
))

(deftemplate vel_rel
-30 30 kmh
((alejando (-30 1)(0 0))
(constante (-10 0)(0 1)(15 0))
(acercando (0 0)(30 1))
))

(deftemplate fuerza_acel
0 100 porc
((nula (0 0)(0 1)(0 0))
(baja (0 1)(5 1)(20 0))
(media (10 0)(40 1)(60 1)(70 0))
(alta (60 0)(100 1))
))

(deftemplate pre_fre
0 100 porce
((nula (0 0)(0 1)(0 0))
(baja (0 1)(5 1)(20 0))
(media (10 0)(40 1)(60 1)(70 0))
(alta (60 0)(100 1))
))


;--------REGLAS------------

;Sacada del boletín
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
            
(defrule leerconsola
	(initial-fact)
	=>
	(printout t"Introduzca la distancia relativa: "crlf)
	(bind ?Rdist (read))
	(printout t"Introduzca la velocidad relativa: "crlf)
	(bind ?Rvel (read))
	(printout t"Introduzca un identificador para el vehículo: "crlf)
	(bind ?identificador (read))
	;Creamos los hechos
	(assert (vehiculo (id ?identificador) (distancia-crisp ?Rdist) (velocidad-crisp ?Rvel) (fuerza-de-aceleracion-crisp-momentum 0.0) (fuerza-de-aceleracion-crisp-maximum 0.0) (presion-freno-crisp-momentum 0.0) (presion-freno-crisp-maximum 0.0)))
	(fuzzify dis_rel ?Rdist 0)
	(fuzzify vel_rel ?Rvel 0)
)

(defrule alejando_cerca
	(dis_rel cerca)
	(vel_rel alejando)
	=>
	(assert (fuerza_acel media))
	(assert (pre_fre nula))
)

(defrule alejando_medio
	(dis_rel medio)
	(vel_rel alejando)
	=>
	(assert (fuerza_acel more-or-less alta))
	(assert (pre_fre nula))
)

(defrule alejando_lejos
	(dis_rel lejos)
	(vel_rel alejando)
	=>
	(assert (fuerza_acel very alta))
	(assert (pre_fre nula))
)

(defrule constante_cerca
	(dis_rel cerca)
	(vel_rel constante)
	=>
	(assert (fuerza_acel nula))
	(assert (pre_fre very baja))
)

(defrule constante_medio
	(dis_rel medio)
	(vel_rel constante)
	=>
	(assert (fuerza_acel media))
	(assert (pre_fre nula))
)

(defrule constante_lejos
	(dis_rel lejos)
	(vel_rel constante)
	=>
	(assert (fuerza_acel alta))
	(assert (pre_fre nula))
)


(defrule acercando_cerca
	(dis_rel cerca)
	(vel_rel acercando)
	=>
	(assert (fuerza_acel nula))
	(assert (pre_fre alta))
)

(defrule acercando_medio
	(dis_rel medio)
	(vel_rel acercando)
	=>
	(assert (fuerza_acel nula))
	(assert (pre_fre more-or-less media))
)

(defrule acercando_lejos
	(dis_rel lejos)
	(vel_rel acercando)
	=>
	(assert (fuerza_acel very baja))
	(assert (pre_fre very baja))
)
;------------PRESENTAR RESULTADOS--------
(defrule res
	?c <- (vehiculo (id ?identificador) (distancia-crisp ?Rdist) (velocidad-crisp ?Rvel) (fuerza-de-aceleracion-crisp-momentum ?famo) (fuerza-de-aceleracion-crisp-maximum ?famax) (presion-freno-crisp-momentum ?pfmom) (presion-freno-crisp-maximum ?pfmax))
	(fuerza_acel ?f)
	(pre_fre ?p)
	=>
	(bind ?fmax (maximum-defuzzify ?f))
	(bind ?fmom (moment-defuzzify ?f))
	(bind ?pmax (maximum-defuzzify ?p))
	(bind ?pmom (moment-defuzzify ?p))
	(printout t"Aceleracion maximum: "?fmax crlf)
	(printout t"Freno maximum: "?pmax crlf)
	(printout t"Aceleracion moment: "?fmom crlf)
	(printout t"Freno moment: "?pmom crlf)
	(modify ?c (fuerza-de-aceleracion-crisp-momentum ?fmom) (fuerza-de-aceleracion-crisp-maximum ?fmax) (presion-freno-crisp-momentum ?pmom) (presion-freno-crisp-maximum ?pmax))
)
