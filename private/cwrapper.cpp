#include <cstdlib>
#include <cstring>

#include "ortools/constraint_solver/constraint_solveri.h"

using namespace operations_research;

std::vector<IntVar*> vectorIntVar(IntVar** vars) {
  int len = sizeof(vars)/sizeof(vars[0]);
  std::vector<IntVar*> vec_vars(vars, vars + len);
  return vec_vars;
}

extern "C" {

Solver *solver_new(const char *c) {
  return new Solver(std::string(c));
}

IntVar *solver_MakeIntVar(Solver *solver, int min, int max, const char *c) {
  return solver->MakeIntVar(min, max, std::string(c));
}
DecisionBuilder *solver_MakePhase(Solver *solver, IntVar **vars, Solver::IntVarStrategy var_str, Solver::IntValueStrategy val_str) {
  return solver->MakePhase(vectorIntVar(vars), var_str, val_str);
}

Constraint *solver_MakeAllDifferent(Solver *solver, IntVar **vars) {
  return solver->MakeAllDifferent(vectorIntVar(vars));
}

void solver_AddConstraint(Solver *solver, Constraint *c) {
  solver->AddConstraint(c);
}

bool solver_Solve(Solver *solver, DecisionBuilder *db) {
  return solver->Solve(db);
}

bool solver_NextSolution(Solver *solver) {
  return solver->NextSolution();
}

int value_IntVar(IntVar *var) {
  return var->Value();
}


} //extern "C"

