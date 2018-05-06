#lang racket

(require "../private/ffi.rkt")

(define numVals 3)
(define solver (solver_new "CPSimple"))
(define x (solver_MakeIntVar solver 0 (- numVals 1) "x"))
(define y (solver_MakeIntVar solver 0 (- numVals 1) "y"))
(define z (solver_MakeIntVar solver 0 (- numVals 1) "z"))

(define xyvars `(,x ,y))
(define allvars `(,x ,y ,z))

(solver_AddConstraint solver (solver_MakeAllDifferent solver xyvars (length xyvars)))

(define db (solver_MakePhase solver allvars (length allvars) 'CHOOSE_FIRST_UNBOUND 'ASSIGN_MIN_VALUE))

(solver_Solve solver db)

(for ([n (in-naturals)]
      #:break (not (solver_NextSolution solver db)))
  (displayln 
    (format 
      "Solution ~a:\n x=~a\n y=~a\n z=~a\n" 
      n 
      (value_IntVar x)
      (value_IntVar y)
      (value_IntVar z))))




