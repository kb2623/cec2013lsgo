import os
import sys

from setuptools import (
    find_packages,
    Extension,
    setup
)


sourcefiles = [
    'cec2013lsgo/cec2013.pyx', 
    'cec2013lsgo/eval_func.cpp',
    'cec2013lsgo/Benchmarks.cpp',
]

for i in range(1, 16): 
    sourcefiles.append('cec2013lsgo/F%d.cpp' % i)

libs = []
if sys.platform != 'win32':
    libs.append('m')

compiler_args = []
if os.environ.get('DEBUG', '0') == '1':
    if sys.platform == 'win32': compiler_args.extend(['/Zi', '/Od'])
    else: compiler_args.extend(['-g', '-O0'])
else:
    compiler_args.extend(['-std=c++11', '-O3', '-march=native'])

link_args = []
if os.environ.get('DEBUG', '0') == '1' and sys.platform == 'win32':
    link_args.append('/DEBUG')


cec2013lsgo = Extension(
    "cec2013lsgo.cec2013",
    sources=sourcefiles,
    include_dirs=['cec2013lsgo'],
    language="c++",
    extra_compile_args = compiler_args,
    extra_link_args= link_args,
    libraries = libs
)


setup(
    ext_modules=[cec2013lsgo],
    packages=find_packages(),
    package_data={'cec2013lsgo': ['cdatafiles/*.txt', '*.h', 'cec2013decl.pxd']},
)
