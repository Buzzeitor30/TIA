(define (problem problem_name) (:domain mercancias)
(:objects
c1 - vehiculo
c2 - vehiculo
f1 - vehiculo
f2 - vehiculo
A - zona
B - zona
C - zona
D - zona
E - zona
F - zona
p1 - pedido
p2 - pedido
p3 - pedido
p4 - pedido
p5 - pedido
)

(:init
    ;Vehiculos
    (at c1 C)
    (at c2 C)
    (at f1 B)
    (at f2 B)
    ;Zonas
    (es_zle A)
    (es_zle B)
    (es_intercambiador C)
    (es_intercambiador D)
    (es_intercambiador E)
    ;Tipos
    (es_camion c1)
    (es_camion c2)
    (es_furgo f1)
    (es_furgo f2)
    ;Paquetes
    (at_pedido p1 A)
    (at_pedido p2 B)
    (at_pedido p3 F)
    (at_pedido p4 D)
    (at_pedido p5 E)
    ;Funciones
    (= (distance A A) 0)
    (= (distance A B) 4)
    (= (distance A C) 6)
    (= (distance A D) 10)
    (= (distance A E) 52)
    (= (distance A F) 100)

    (= (distance B B) 0)
    (= (distance B C) 4)
    (= (distance B D) 16)
    (= (distance B E) 20)
    (= (distance B F) 40)

    (= (distance C C) 0)
    (= (distance C D) 28)
    (= (distance C E) 55)
    (= (distance C F) 30)

    (= (distance D D) 0)
    (= (distance D E) 30)
    (= (distance D F) 10)

    (= (distance E E) 0)
    (= (distance E F) 160)

    (= (distance F F) 0)
    
    (= (kilometraje) 70)
    (= (presupuesto) 40)
    (= (dinero-extra) 0)

)
(:goal (and
	(at_pedido p1 F)
	(at_pedido p2 E)
	(at_pedido p3 D)
    (at_pedido p4 E)
    (at_pedido p5 A)
	))

(:metric minimize (+ (* 0.8 (total-time)) (* 0.2 (dinero-extra))))
)
