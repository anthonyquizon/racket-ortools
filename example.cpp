#include "ortools/constraint_solver/constraint_solveri.h"

namespace operations_research {

void CPSimple() {
  // Instantiate the solver.
  Solver solver("CPSimple");
  const int64 numVals = 3;

  // Define decision variables.
  IntVar* const x = solver.MakeIntVar(0, numVals - 1, "x");
  IntVar* const y = solver.MakeIntVar(0, numVals - 1, "y");
  IntVar* const z = solver.MakeIntVar(0, numVals - 1, "z");

  // Group variables into vectors.
  std::vector<IntVar*> allvars;
  std::vector<IntVar*> xyvars;

  allvars.push_back(x);
  xyvars.push_back(x);

  allvars.push_back(y);
  xyvars.push_back(y);

  allvars.push_back(z);

  // Define constraints.
  solver.AddConstraint(solver.MakeAllDifferent(xyvars));
  // Create decision builder to search for solutions.
  DecisionBuilder* const db = solver.MakePhase(allvars,
                                               Solver::CHOOSE_FIRST_UNBOUND,
                                               Solver::ASSIGN_MIN_VALUE);
  // Search.
  solver.Solve(db);
  int count = 0;

  while (solver.NextSolution()) {
    count++;
    LOG(INFO) << "Solution " << count << ":  x=" << x->Value() << " "
              << "y=" << y->Value() << " "
              << "z=" << z->Value() << " ";
  }

  LOG(INFO) << "Number of solutions: " << count;
}

}   // namespace operations_research

// ----- MAIN -----
int main(int argc, char **argv) {
  operations_research::CPSimple();
  return 0;
}
