# -*- coding: utf-8 -*-

# Learn more: https://github.com/kennethreitz/setup.py

from setuptools import setup, find_packages, Extension

try:
    from Cython.Build import cythonize
    from Cython.Distutils import build_ext
    USE_CYTHON = True
except ImportError:
    USE_CYTHON = False
    raise ImportError("it requires Cython to install this package.")

with open('README.md') as f:
    readme = f.read()

with open('LICENSE') as f:
    license = f.read()

if USE_CYTHON:
    suffix = ".pyx"
    cmdclass = {"build_ext": build_ext}
else:
    suffix = ".cpp"
    cmdclass = {}

lst_ext = [
    Extension("pydams.DAMS",
                sources=["pydams/DAMS" + suffix],
                libraries=["dams"],
                include_dirs=["./include"],
                extra_compile_args=["-w", "-O2", "-m64", "-fPIC"],
                language="c++"),
    Extension("pydams._distance_function",
                sources=["pydams/_distance_function" + suffix],
                extra_compile_args=["-w", "-O2", "-m64", "-fPIC"],
                language="c++")
    ]

setup(
    name='pydams',
    version='1.0.4',
    description='Python bindings around DAMS: Geocoding Tool for Japanese Address',
    long_description=readme,
    author='Sakae Mizuki',
    author_email='s.mizuki@hottolink.co.jp',
    url='https://github.com/hottolink/pydams',
    license=license,
    packages=find_packages(exclude=('tests', 'docs')),
    test_suite="tests",
    setup_requires=["setuptools>=18.0","cython"],
    ext_modules=cythonize(lst_ext),
    cmdclass=cmdclass
)

