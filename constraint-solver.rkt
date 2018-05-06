#lang racket

(provide create-solver
         create-intvar
         all-different
         create-phase
         add-constraint
         solve
         next-solution
         value)

(require (prefix-in ffi: "private/ffi.rkt"))

(struct Solver (solver))
(struct IntVar (var))
(struct Constraint (constraint))
(struct DecisionBuilder (db))

(define (IntVars->pointers vars)
  (define (get-var v) (IntVar-var v))
  (map get-var vars))

(define (create-solver label) 
  (Solver (ffi:solver_new label)))

(define (create-intvar solver n_min n_max label)
  (define solver^ (Solver-solver solver))
  (IntVar (ffi:solver_MakeIntVar solver^ n_min n_max label)))

(define (all-different solver . vars)
  (define solver^ (Solver-solver solver))
  (define vars^ (IntVars->pointers vars))
  (define len (length vars))

  (Constraint 
    (ffi:solver_MakeAllDifferent solver^ vars^ len)))

(define (create-phase solver intvar-str intval-str . vars)
  (define solver^ (Solver-solver solver))
  (define vars^ (IntVars->pointers vars))
  (define len (length vars))

  (DecisionBuilder 
    (ffi:solver_MakePhase solver^ vars^ len intvar-str intval-str)))

(define (add-constraint solver constraint)
  (define solver^ (Solver-solver solver))
  (define constraint^ (Constraint-constraint))

  (ffi:solver_AddConstraint solver^ constraint^))

(define (solve solver db)
  (define solver^ (Solver-solver solver))
  (define db^ (DecisionBuilder-db db))

  (ffi:solver_Solve solver^ db^))

(define (next-solution solver db)
  (define solver^ (Solver-solver solver))
  (define db^ (DecisionBuilder-db db))

  (ffi:solver_NextSolution solver^ db^))

(define (value var)
  (define var^ (IntVar-var var))
  (ffi:value_IntVar var^))

