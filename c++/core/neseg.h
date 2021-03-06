#ifndef NESEG_H_
#define NESEG_H_


//Drawing libraries
#ifdef WITH_GLEW
  #include <GL/glew.h>
#endif
#include <GL/glut.h>
#ifdef _APPLE
#include <OpenGL/gl.h>
#define ulong unsigned long
#else
#include <GL/gl.h>
#endif

// This is a computer vision program, isn't it?
#include "cv.h"
#include "highgui.h"

//C libraries
#include <math.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdarg.h>
#include <sys/types.h>
#include <sys/stat.h>

#ifdef _WIN32
#else
#include <sys/syscall.h>
#include <sys/mman.h>
#endif

//C++ libraries (sometimes used)
#include <string>
#include <iostream>
#include <sstream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <map>
#include <set>
#include <algorithm>
#include <cctype>
#include <typeinfo>
//For some math stuff
#ifdef WITH_GSL
#include <gsl/gsl_math.h>
#include <gsl/gsl_eigen.h>
#include <gsl/gsl_linalg.h>
#include <gsl/gsl_blas.h>
#include <gsl/gsl_matrix.h>
#endif

//Error checking
#include <assert.h>

//Multiple cores?
#ifdef _OPENMP
#include <omp.h>
#endif

//Keep it standard
using namespace std;

#endif
