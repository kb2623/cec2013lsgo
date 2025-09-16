#!python
#cython: language_level=2, boundscheck=False
import os
import pkgutil

from libc.stdlib cimport malloc, free
from libcpp.string cimport string

from cec2013decl cimport (
    Benchmarks,
    generateFuncObj,
    free_func
)


def file_load(data_dir: str, file_name: str):
    """Load cdata file into temporary directory.

    Args:
        data_dir (str): Path to storage of data files
        file_name (str): File name to load.
    """
    if os.path.exists('%s/%s' % (data_dir, file_name)): return
    data = pkgutil.get_data('cec2013lsgo', 'cdatafiles/%s' % file_name)
    with open('%s/%s' % (data_dir, file_name), 'wb') as f: f.write(data)


cdef class Benchmark:
    cdef Benchmarks * bench

    def __init__(self, no_fun: int = 1, input_data_dir: str = 'inputdata'):
        # Create benchmark
        self.bench = generateFuncObj(no_fun)
        # Set input data dir
        cdef bytes b = input_data_dir.encode('utf-8')
        cdef string cpp_path = b
        self.bench.set_data_dir(cpp_path)
        # Create input data dir
        os.makedirs(input_data_dir, exist_ok=True)
        # Load xopt
        for i in range(1, 16): file_load(input_data_dir, 'F%d-xopt.txt' % i)
        # Load p
        for i in range(4, 12): file_load(input_data_dir, 'F%d-p.txt' % i)
        for i in range(13, 15): file_load(input_data_dir, 'F%d-p.txt' % i)
        # Load w
        for i in range(4, 12): file_load(input_data_dir, 'F%d-w.txt' % i)
        for i in range(13, 15): file_load(input_data_dir, 'F%d-w.txt' % i)
        # Load s
        for i in range(4, 12): file_load(input_data_dir, 'F%d-s.txt' % i)
        for i in range(13, 15): file_load(input_data_dir, 'F%d-s.txt' % i)
        # Load R25
        for i in range(4, 12): file_load(input_data_dir, 'F%d-R25.txt' % i)
        for i in range(13, 15): file_load(input_data_dir, 'F%d-R25.txt' % i)
        # Load R50
        for i in range(4, 12): file_load(input_data_dir, 'F%d-R50.txt' % i)
        for i in range(13, 15): file_load(input_data_dir, 'F%d-R50.txt' % i)
        # Load R100
        for i in range(4, 12): file_load(input_data_dir, 'F%d-R100.txt' % i)
        for i in range(13, 15): file_load(input_data_dir, 'F%d-R100.txt' % i)
        
    cpdef get_info(self, int fun):
        r"""Return the lower bound of the function.

        Args:
            fun (int): Optimization function number.
        """
        cdef double optimum
        cdef double range_fun
        optimum = 0
        if (fun in [2, 5, 9]):
            range_fun = 5
        elif (fun in [3, 6, 10]):
            range_fun = 32
        else:
            range_fun = 100
        return {
            'lower': -range_fun,
            'upper': range_fun,
            'threshold': 0,
            'best': optimum,
            'dimension': 1000
        }

    def get_num_functions(self):
        return 15

    cpdef next_run(self):
        self.bench.nextRun()

    cpdef eval(self, double[::1] x):
        # Reserve the array to pass to C
        cdef double * y = <double *> malloc(1000 * sizeof(double))
        if y == NULL: raise MemoryError()
        # Copy the original values
        for i in range(1000): y[i] = x[i]
        # Calculate the fitness value
        cdef double fx = self.bench.compute(y)
        # Free the memeory
        free(y)
        # Convert and return the value (python cannot work with long double)
        return float(fx)    

    def __dealloc(self):
        free_func(self.bench)


