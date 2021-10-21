;Global variable
(defglobal ?*node-gen* = 0)

(defrule right 
    ;initial facts 
    ?f <- (robotIA posRobot ?xr ?yr posCain $?Cains level ?lvl)
    
    (max-depth ?prof)
    (grid-dimension ?width ?heigh)
    (hole-location ?holes)
    
    (test (< ?lvl ?prof))   ;Check level
    (test (neq ?xr ?width)) ;Check not in border
                            ;neq (not equal operator)

    ;TEST NEXT POSITION 
    (test (and (not (member$ ?holes (create$ nextPosHole (+ ?xr 1) ?yr) )) ;next position == hole??
                (not (member$ ?Cains (create$ nextPosCain (+ ?xr 1) ?yr) )))) ;next position == cain??
    => 
    (assert (robotIA posRobot (+ ?xr 1) ?yr posCain $?Cains level (+ ?lvl 1))) ;change robot's position 
    (bind ?*node-gen* (+ ?*node-gen* 1))
)

(defrule right-cain
    ;initial facts 
    ?f <- (robotIA posRobot ?xr ?yr posCain $?cn1 cn = (+ ?xr 1) ?yr $?cn2 level ?lvl) ;cn = (+ ?xr 1)  mira si en la siguiente posición hay lata
    (max-depth ?prof)
    (grid-dimension ?width ?heigh)
    (hole-location ?holes)
    => 
    (if (and (neq (+ ?xr 1) ?width) (and (< ?lvl ?prof) (member$ ?holes (create$ nextPosHole (+ ?xr 2) ?yr)))) ;Siguiente lata a lata es hueco)
        then 
        (assert (robotIA posRobot (+ ?xr 1) ?yr posCain $?cn1 $?cn2 level (+ ?lvl 1))) ;change robot's position 
        else
        (assert (robotIA posRobot (+ ?xr 1) ?yr posCain $?cn1 cn=(+ ?xr 2) ?yr $?cn2 level (+ ?lvl 1))))
    
    (bind ?*node-gen* (+ ?*node-gen* 1))
)

(defrule left 
    ;initial facts 
    ?f <-(robotIA posRobot ?xr ?yr posCain $?Cains level ?lvl)
    (max-depth ?prof)
    (grid-dimension ?width ?heigh)
    (hole-location ?holes)
    
    (test (< ?lvl ?prof))  ;Check level
    (test (neq ?xr -1))    ;Check not in border
                           ;neq (not equal operator)

    ;TEST NEXT POSITION 
    (test (and (not (member$ ?holes (create$ previousPosHole (- ?xr 1) ?yr) )) ;next position == hole??
                (not (member$ ?Cains (create$ previousPosCain (- ?xr 1) ?yr) )))) ;next position == cain??
    => 
    (assert (robotIA posRobot (- ?xr 1) ?yr posCain $?Cains level (+ ?lvl 1))) ;change robot's position 
    (bind ?*node-gen* (+ ?*node-gen* 1))
)

(defrule left-cain
    ;initial facts 
    ?f <- (robotIA posRobot ?xr ?yr posCain $?cn1 cn = (- ?xr 1) ?yr $?cn2 level ?lvl) ;cn = (- ?xr 1)  mira si en la siguiente posición hay lata
    (max-depth ?prof)
    (grid-dimension ?width ?heigh)
    (hole-location ?holes)
    => 
    (if (and (neq (- ?xr 1) -1) (and (< ?lvl ?prof) (member$ ?holes (create$ previousPosHole (- ?xr 2) ?yr)))) ;Siguiente lata a lata es hueco)
        then 
        (assert (robotIA posRobot (- ?xr 1) ?yr posCain $?cn1 $?cn2 level (- ?lvl 1))) ;change robot's position 
        else
        (assert (robotIA posRobot (- ?xr 1) ?yr posCain $?cn1 cn=(- ?xr 2) ?yr $?cn2 level (- ?lvl 1))))
    
    (bind ?*node-gen* (+ ?*node-gen* 1))
)

(defrule up 
    ;initial facts 
    ?f <-(robotIA posRobot ?xr ?yr posCain $?Cains level ?lvl)
    (max-depth ?prof)
    (grid-dimension ?width ?heigh)
    (hole-location ?holes)
    
    (test (< ?lvl ?prof))  ;Check level
    (test (neq ?xr (+ ?heigh 1)))    ;Check not in border
                           ;neq (not equal operator)

    ;TEST UPPER POSITION 
    (test (and (not (member$ ?holes (create$ upperPosHole ?xr (+ ?yr 1) ) )) ;next position == hole??
                (not (member$ ?Cains (create$ upperPosCain ?xr (+ ?yr 1) ))))) ;next position == cain??
    => 
    (assert (robotIA posRobot ?xr (+ ?yr 1) posCain $?Cains level (+ ?lvl 1))) ;change robot's position 
    (bind ?*node-gen* (+ ?*node-gen* 1))
)

(defrule up-cain
    ;initial facts 
    ?f <-(robotIA posRobot ?xr ?yr posCain $?cn1  ?xr cn =(+ ?yr 1) $?cn2 level ?lvl) 
    (max-depth ?prof)
    (grid-dimension ?width ?heigh)
    (hole-location ?holes)
    => 
    (if (and (neq ?xr (+ ?heigh 1)) (and (< ?lvl ?prof) (member$ ?holes (create$ upperPosHole ?xr (+ ?yr 2))))) ;Siguiente lata a lata es hueco)
        then 
        (assert (robotIA posRobot ?xr (+ ?yr 1) posCain $?cn1 $?cn2 level (+ ?lvl 1))) ;change robot's position 
        else
        (assert (robotIA posRobot ?xr (+ ?yr 1) posCain $?cn1 cn=?xr (+ ?yr 1) $?cn2 level (+ ?lvl 1))))
    
    (bind ?*node-gen* (+ ?*node-gen* 1))
)

(defrule down 
    ;initial facts 
    ?f <-(robotIA posRobot ?xr ?yr posCain $?Cains level ?lvl)
    (max-depth ?prof)
    (grid-dimension ?width ?heigh)
    (hole-location ?holes)
    
    (test (< ?lvl ?prof))  ;Check level
    (test (neq ?xr ?heigh))    ;Check not in border
                           ;neq (not equal operator)

    ;TEST LOWER POSITION 
    (test (and (not (member$ ?holes (create$ lowerPosHole ?xr (- ?yr 1) ) )) (not (member$ ?Cains (create$ lowerPosCain ?xr (- ?yr 1) )))))
    => 
    (assert (robotIA posRobot ?xr (- ?yr 1) posCain $?Cains level (+ ?lvl 1))) ;change robot's position 
    (bind ?*node-gen* (+ ?*node-gen* 1))
)

(defrule down-cain
    ;initial facts 
    ?f <-(robotIA posRobot ?xr ?yr posCain $?cn1 ?xr cn = (- ?yr 1) $?cn2 level ?lvl) 
    (max-depth ?prof)
    (grid-dimension ?width ?heigh)
    (hole-location ?holes)
    => 
    (if (and (neq ?xr ?heigh) 
        (and (< ?lvl ?prof) (member$ ?holes (create$ lowerPosHole ?xr (- ?yr 2)))
        )) ;Siguiente lata a lata es hueco)
        then 
        (assert (robotIA posRobot ?xr (- ?yr 1) posCain $?cn1 $?cn2 level (+ ?lvl 1))) ;change robot's position 
        else
        (assert (robotIA posRobot ?xr (- ?yr 1) posCain $?cn1 ?xr (- ?yr 1) $?cn2 level (+ ?lvl 1))))
    
    (bind ?*node-gen* (+ ?*node-gen* 1))
)



;; ============================================================
;; =========      ESTRATEGIA DE CONTROL DE BUSQUEDA    ========
;; ============================================================
;; La regla 'objetivo' se utiliza para detectar cuando se ha alcanzado el estado objetivo

(defrule objetivo
    (declare (salience 100))
    ?f<-(robotIA posRobot ?xr ?yr posCain level ?lvl)
    
   =>
    (printout t "SOLUCION ENCONTRADA EN EL NIVEL " ?lvl crlf)
    (printout t "NUMERO DE NODOS EXPANDIDOS O REGLAS DISPARADAS " ?*node-gen* crlf)
    (printout t "HECHO OBJETIVO " ?f crlf)
    
    (halt)
)

(defrule no_solucion
    (declare (salience -99))
    (robotIA $? level ?lvl)
    ;(grid-dimension ?width ?height)

    ;(test (and (neq ?cx 0) (neq ?cy 0))) ;(0, 0)
    ;(test (and (neq ?cx 0) (neq ?cy ?width))) ;(0, width)
    ;(test (and (neq ?cx ?height) (neq ?cy 0))) ;(height, 0)
    ;(test (and (neq ?cx ?height) (neq ?cy ?width))) ;(height, width)
    =>
    (printout t "SOLUCION NO ENCONTRADA" crlf)
    (printout t "NUMERO DE NODOS EXPANDIDOS O REGLAS DISPARADAS " ?*node-gen* crlf)
    
    (halt)
)		


(deffunction inicio()
    (reset)
    ;Depth
    (printout t "Profundidad Maxima:= " )
    (bind ?prof (read))

    ;TYPE OF RESEARCH
    (printout t "Tipo de Busqueda " crlf "    1.- Anchura" crlf "    2.- Profundidad" crlf )
    (bind ?a (read))
    (if (= ?a 1)
            then    (set-strategy breadth)
            else   (set-strategy depth))
    
    (printout t " Ejecuta run para poner en marcha el programa " crlf)
    
    ;DINAMIC OBJECTS
    (assert (robotIA posRobot 0 0 posCain cain 0 1 cain 1 1 cain 2 1 cain 3 1 level 0))
    ;STATIC OBJECTS 
    (assert (max-depth ?prof))
    (assert (hole-location hl 0 2 vd 2 2 vd 3 5 vd 1 4))
    (assert (grid-dimension 4 6))
)