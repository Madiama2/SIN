

;Variable global
(defglobal ?*node-gen* = 0)

(deffacts map
	(hole 1 1)
	(hole 5 1)
	(hole 4 4)
	(hole 1 4)
)

(deffunction inicio()
	(reset)
	(printout T"Profundidad maxima= ")
    (bind ?prof (read))
    (printout T"Tipo de busqueda " crlf "1.-Anchura" crlf "2.-Profundidad" crlf)
    (bind ?busq (read))
    (if (= ?busq 1)
        then (set-strategy breadth)
        else (set-strategy depth)
    )

	;Dinamic objects
	(assert (robotIA posRobot 3 3 posCain cain 4 1 cain 2 1 cain 1 3 level 0))

	;Static objects
	(assert (max-depth ?prof))
	;(assert (hole-location hl 1 1 hl 5 1 hl 1 4 hl 4 4))
	(assert (grid-dimension 5 4))
)

(defrule mov_right
	?f <- (robotIA posRobot ?x ?y posCain $?z level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes hl)
	(test (<> ?x ?width))
	(test (not (member$ (create$ hl (+ ?x 1) ?y) $?holes)))
	(test (not (member$ (create$ cain (+ ?x 1) ?y) $?z)))
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot (+ ?x 1) ?y posCain $?z level (+ ?lvl 1)))
)

(defrule mov_left
	?f <- (robotIA posRobot ?x ?y posCain $?z level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes)
	(test (<> ?x 1))
	(test (not (member$ (create$ hl(- ?x 1) ?y) $?holes)))
	(test (not (member$ (create$ cain(- ?x 1) ?y) $?z)))
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot (- ?x 1) ?y posCain $?z level (+ ?lvl 1)))
)

(defrule mov_down
		?f <- (robotIA posRobot ?x ?y posCain $?z level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes)
	(test (<> ?y 1))
	(test (not (member$ (create$ hl ?x (- ?y 1)) $?holes)))
	(test (not (member$ (create$ cain ?x (- ?y 1)) $?z)))
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot ?x (- ?y 1) posCain $?z level (+ ?lvl 1)))
)

(defrule mov_up
		?f <- (robotIA posRobot ?x ?y posCain $?z level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes)
	(test (<> ?y ?height))
	(test (not (member$ (create$ hl ?x (+ ?y 1)) $?holes)))
	(test (not (member$ (create$ cain ?x (+ ?y 1)) $?z)))
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot ?x (+ ?y 1) posCain $?z level (+ ?lvl 1)))
)

(defrule mov_cain_right
		?f <- (robotIA posRobot ?x ?y posCain $?z cain ?c_x ?c_y $?w level ?lvl)
		;cogemos las latas de antes guardadas en el "array" $?z y todas las de después $?w. 
		;Y la que estamos mirando actualmente es la de las coordenadas.

	(max-depth ?prof)
	(grid-dimension ?width ?height)

	(hole-location $?holes)
	(test (<> ?c_x ?width))
	(test (not (member$ (create$ hl(+ ?x 2) ?y) $?holes)))
	(test (not (member$ (create$ cain(+ ?x 2) ?y) $?z)))
	(test (not (member$ (create$ cain(+ ?x 2) ?y) $?w)))
	(test (and (= (- ?c_x 1) ?x) (= ?c_y ?y)))
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot (+ ?x 1) ?y posCain $?z cain (+ ?c_x 1) ?c_y $?w level (+ ?lvl 1)))
)

(defrule mov_cain_left
		?f <- (robotIA posRobot ?x ?y posCain $?z cain ?c_x ?c_y $?w level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes)
	(test (<> ?c_x 1))
	(test (not (member$ (create$ hl(- ?x 2) ?y) $?holes)))
	(test (not (member$ (create$ cain(- ?x 2) ?y) $?z)))
	(test (not (member$ (create$ cain(- ?x 2) ?y) $?w)))
	(test (and (= (- ?c_x 1) ?x) (= ?c_y ?y)))
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot (- ?x 1) ?y posCain $?z cain (- ?c_x 1) ?c_y $?w level (+ ?lvl 1)))
)

(defrule mov_cain_down
		?f <- (robotIA posRobot ?x ?y posCain $?z cain ?c_x ?c_y $?w level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes)
	(test (<> ?c_y 1)) ;Lata esta en el limite
	(test (not (member$ (create$ hl ?x (- ?y 2)) $?holes))) ;¿Hay un hueco al lado de la lata?
	(test (not (member$ (create$ cain ?x (- ?y 2)) $?z)))
	(test (not (member$ (create$ cain ?x (- ?y 2)) $?w)))
	(test (and (= ?c_x ?x) (= ?c_y (- ?y 1)))) ;¿Lata abajo?
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot ?x (- ?y 1) posCain $?z cain ?c_x (- ?c_y 1) $?w level (+ ?lvl 1)))
)

(defrule mov_cain_up
		?f <- (robotIA posRobot ?x ?y posCain $?z cain ?c_x ?c_y $?w level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes)
	(test (<> ?c_y ?height)) ;Lata esta en el limite
	(test (not (member$ (create$ hl ?x (+ ?y 2)) $?holes))) ;¿Hay un hueco al lado de la lata?
	(test (not (member$ (create$ cain ?x (+ ?y 2)) $?z)))
	(test (not (member$ (create$ cain ?x (+ ?y 2)) $?w)))
	(test (and (= ?c_x ?x) (= ?c_y (+ ?y 1)))) ;¿Lata arriba?
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot ?x (+ ?y 1) posCain $?z cain ?c_x (+ ?c_y 1) $?w level (+ ?lvl 1)))
)

(defrule delete_cain_right
	(declare(salience 20)) ;tiene preferencia 20 por lo que va delante de moverse o de mover lata
	
	;declaración de hechos
	?f <- (robotIA PosRobot ?x ?y posCan $?z cain ?c_x ?c_y $?w level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes)

	;reglas
	(test (<> ?c_x ?width)) ;Lata esta dentro de la tabla
	(test  (member$ (create$ hl (+ ?x 2) ?y) $?holes)) ;¿Hay un hueco al lado de la lata?
	(test (and (= (- ?c_x 1) ?x) (= ?c_y ?y))) ;¿hay una lata a la derecha del robot?
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot (+ ?x 1) ?y posCain $?z $?w level (+ ?lvl 1)))
)

(defrule delete_cain_left
	(declare(salience 20)) ;tiene preferencia 20 por lo que va delante de moverse o de mover lata
	
	;declaración de hechos
	?f <- (robotIA PosRobot ?x ?y posCan $?z cain ?c_x ?c_y $?w level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes)

	;reglas
	(test (<> ?c_x 1)) ;Lata esta dentro de la tabla
	(test (member$ (create$ hl (- ?x 2) ?y ) $?holes)) ;¿Hay un hueco al lado de la lata?
	(test (and (= (+ ?c_x 1) ?x) (= ?c_y ?y))) ;¿lata izquierda?
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot ?x (- ?y 1) posCain $?z $?w level (+ ?lvl 1)))
)

(defrule delete_cain_down
	(declare(salience 20)) ;tiene preferencia 20 por lo que va delante de moverse o de mover lata
	
	;declaración de hechos
	?f <- (robotIA PosRobot ?x ?y posCan $?z cain ?c_x ?c_y $?w level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes)

	;reglas
	(test (<> ?c_y 1)) ;Lata esta dentro de la tabla
	(test (member$ (create$ hl ?x (- ?y 2)) $?holes)) ;¿Hay un hueco al abajo de la lata?
	(test (and (= ?c_x ?x) (= (+ ?c_y 1) ?y))) ;¿hay una lata a la abajo del robot?
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot ?x (- ?y 1) posCain $?z $?w level (+ ?lvl 1)))
)

(defrule delete_cain_up
	(declare(salience 20)) ;tiene preferencia 20 por lo que va delante de moverse o de mover lata
	
	;declaración de hechos
	?f <- (robotIA PosRobot ?x ?y posCan $?z cain ?c_x ?c_y $?w level ?lvl)
	(max-depth ?prof)
	(grid-dimension ?width ?height)
	(hole-location $?holes)

	;reglas
	(test (<> ?c_y ?height)) ;Lata esta dentro de la tabla
	(test (member$ (create$ hl ?x (+ ?y 2)) $?holes)) ;¿Hay un hueco al arriba de la lata?
	(test (and (= ?c_x ?x) (= (- ?c_y 1) ?y))) ;¿hay una lata a la arriba del robot?
	(test (< ?lvl ?prof))
=>
	(bind ?*node-gen* (+ ?*node-gen* 1))
	(assert (robotIA posRobot ?x (+ ?y 1) posCain $?z $?w level (+ ?lvl 1)))
)

(defrule fin
    (declare (salience 100))
    ?f <- (robotIA posRobot $?a posCain prof ?lvl)
=>
    (printout T"Fin" crlf)
    (printout T"Solución encontrada en el nivel: " ?lvl crlf)
    (printout T"Nodos: " ?*node-gen* crlf)
    (printout T"Hecho objetivo: " ?f crlf)
    (halt)
)

(defrule no_solucion
    (declare (salience -100))
    ?f <- (robotIA $?a prof ?lvl)
=>
    (printout T"Solucion no encontrada" crlf)
    (printout T"Nodos expandidos: " ?*node-gen* crlf)
    (halt)
)