;Global variable
(defglobal ?*node-gen* = 0)



(defrule right 
    ;initial facts 
    ?f<-(robotIA posRobot ?xr ?yr posCain $?Cains level ?lvl)
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
    
    (test (< ?lvl ?prof))   ;Check level
    (test (neq ?xr ?width)) ;Check not in border
                            ;neq (not equal operator)

    ;TEST NEXT POSITION 
    (test (member$( $?cn1 ?Cains)) ;next position == cain??
    => 
    (assert (robotIA posRobot (+ ?xr 1) ?yr posCain $?Cains level (+ ?lvl 1))) ;change robot's position 
    (bind ?*node-gen* (+ ?*node-gen* 1))
)

(defrule left

)

(defrule left-cain

)
 
(defrule down

)

(defrule down-cain

)

(defrule up

)

(defrule up-cain

)

;Funcion de inicio
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