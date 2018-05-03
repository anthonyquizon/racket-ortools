#ifndef CWRAPPER_H
#define CWRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

typedef struct Solver Solver;
typedef struct IntVar IntVar;
typedef struct Constraint Constraint;
typedef struct DecisionBuilder DecisionBuilder;
typedef struct IntVarStrategy IntVarStrategy;
typedef struct IntValueStrategy IntValueStrategy;

Solver *solver_new(const char *c); 
IntVar *make_IntVar(Solver solver, int min, int max, const char *c);
Constraint *make_AllDifferent(Solver solver, IntVar **vars);
DecisionBuilder *make_Phase(Solver solver, IntVar **vars, IntVarStrategy var_str, IntValueStrategy val_str);
void solver_addConstraint(Solver solver, Constraint *c);
bool solver_solve(Solver solver, DecisionBuilder *db);

#ifdef __cplusplus
}
#endif
#endif
