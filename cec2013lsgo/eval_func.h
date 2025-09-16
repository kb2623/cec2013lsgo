#ifndef _EVAL_FUNC_H
#define _EVAL_FUNC_H

#include "F1.h"
#include "F2.h"
#include "F3.h"
#include "F4.h"
#include "F5.h"
#include "F6.h"
#include "F7.h"
#include "F8.h"
#include "F9.h"
#include "F10.h"
#include "F11.h"
#include "F12.h"
#include "F13.h"
#include "F14.h"
#include "F15.h"

Benchmarks * generateFuncObj(int funcID);
void set_func(int);
void set_data_dir(char *);
double eval_sol(double *);
void free_func(void);
void free_func(Benchmarks *);
void next_run(void);

#endif