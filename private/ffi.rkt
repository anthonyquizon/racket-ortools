#lang racket

(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/alloc)

(define-ffi-definer define-ortools (ffi-lib "./extern/libcwrapper"))

(define _SOLVER-pointer (_cpointer 'SOLVER))
(define _INTVAR-pointer (_cpointer 'INTVAR))
(define _CONSTRAINT-pointer (_cpointer 'CONSTRAINT))
(define _DECISION_BUILDER-pointer (_cpointer 'DECISION_BUILDER))

(define _IntVarStrategy
  (_enum '(INT_VAR_DEFAULT 
           INT_VAR_SIMPLE
           CHOOSE_FIRST_UNBOUND
           CHOOSE_RANDOM
           CHOOSE_MIN_SIZE_LOWEST_MIN
           CHOOSE_MIN_SIZE_HIGHEST_MIN
           CHOOSE_MIN_SIZE_LOWEST_MAX
           CHOOSE_MIN_SIZE_HIGHEST_MAX
           CHOOSE_LOWEST_MIN
           CHOOSE_HIGHEST_MAX
           CHOOSE_MIN_SIZE
           CHOOSE_MAX_SIZE
           CHOOSE_MAX_REGRET_ON_MIN
           CHOOSE_PATH)))

(define _IntValueStrategy
  (_enum '(INT_VALUE_DEFAULT
           INT_VALUE_SIMPLE
           ASSIGN_MIN_VALUE
           ASSIGN_MAX_VALUE
           ASSIGN_RANDOM_VALUE
           ASSIGN_CENTER_VALUE
           SPLIT_LOWER_HALF
           SPLIT_UPPER_HALF)))

(define-ortools solver_delete (_fun _SOLVER-pointer -> _void)
  #:wrap (deallocator))

(define-ortools solver_new (_fun _string -> _SOLVER-pointer)
  #:wrap (allocator solver_delete))

(define-ortools solver_MakeIntVar (_fun _SOLVER-pointer _int _int _string -> _INTVAR-pointer))
(define-ortools solver_MakeAllDifferent (_fun _SOLVER-pointer (_list i _INTVAR-pointer) _int -> _CONSTRAINT-pointer))
(define-ortools solver_MakePhase (_fun _SOLVER-pointer (_list i _INTVAR-pointer) _int _IntVarStrategy _IntValueStrategy -> _DECISION_BUILDER-pointer))

(define-ortools solver_AddConstraint (_fun _SOLVER-pointer _CONSTRAINT-pointer -> _void))
(define-ortools solver_Solve (_fun _SOLVER-pointer _DECISION_BUILDER-pointer -> _bool))
(define-ortools solver_NextSolution (_fun _SOLVER-pointer _DECISION_BUILDER-pointer -> _bool))
(define-ortools value_IntVar (_fun _INTVAR-pointer -> _int))


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

