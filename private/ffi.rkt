#lang racket

(provide solver_new
         solver_delete
         solver_MakeIntVar
         solver_AddConstraint
         solver_MakePhase
         solver_MakeAllDifferent
         solver_Solve
         solver_NextSolution
         value_IntVar)

(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/alloc
         racket/runtime-path)

(define-runtime-path cwd ".")
         
(define-ffi-definer define-ortools (ffi-lib (build-path cwd 'up "extern" "libcwrapper")))

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

(define-ortools solver_delete (_fun _SOLVER-pointer -> _int)
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

