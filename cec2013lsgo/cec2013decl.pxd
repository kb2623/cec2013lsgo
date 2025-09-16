cdef extern from "Benchmarks.h" namespace "":
    cdef cppclass Benchmarks:
        Benchmarks()
        void set_data_dir(str data_dir)
        void nextRun()
        int getMinx()
        int getMaxx()
        double compute(double * x)

cdef extern from "eval_func.h":
    Benchmarks * generateFuncObj(int no_fun)
    void free_func(Benchmarks * bench)

