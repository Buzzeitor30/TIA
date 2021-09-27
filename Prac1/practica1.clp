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
))

(deftemplate pres_fre
0 100 por
((baja (0 1)(5 1)(20 0))
 (media (10 0)(40 1)(60 1)(70 0))
 (alta (60 0)(100 1))
))

(deftemplate velocidad_rel
-30 30 kmh
((alejando (-30 1)(0 0))
(constante (-10 0)(0 1)(15 0))
(frenando (0 0)(30 1)))
)

;REGLAS


