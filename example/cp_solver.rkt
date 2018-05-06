#lang racket

(require "../constraint-solver.rkt")

(define numVals 3)
(define solver (create-solver "CPSimple"))
(define x (create-intvar solver 0 (- numVals 1) "x"))
(define y (create-intvar solver 0 (- numVals 1) "y"))
(define z (create-intvar solver 0 (- numVals 1) "z"))

(define allvars `(,x ,y ,z))

(define constraint (all-different solver x y))
(define db (create-phase solver 'CHOOSE_FIRST_UNBOUND 'ASSIGN_MIN_VALUE x y z))

(solve solver db)

(for ([n (in-naturals)]
      #:break (not (next-solution solver db)))
  (displayln 
    (format 
      "Solution ~a:\n x=~a\n y=~a\n z=~a\n" 
      n 
      (value x)
      (value y)
      (value z))))

