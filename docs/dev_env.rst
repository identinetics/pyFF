Setup for Development Environment
=================================

Pycharm
-------

Use pycharm >= 2017.x (older versions do not start modules including relative imports properly)

src/pyff/__init__.py: instead of getting the version from the package replace it (ofr dev only) with a constant:

  __version__ = pkg_resources.require("pyFF")[0].version
  __version__ = 'debug'

Sample Run Configuration for pyffd:

Script: pyff.mdx
Script parameters: -f -H 127.0.0.1 -P 8085 -p ../log/pyffd.pid --loglevel=DEBUG --log=../log/pyffd.log --error-log=../log/pyffd.err ../testdata/etc/pyff/mdx_disco_dev.fd
Interpreter options: -m
Working directory: <abspath of project home>/src
Add source root to PYTHONPATH: true

To configure an HSM set theenv depening on the driver, e.g.:
Environment variables: PYKCS11LIB=/usr/lib64/libetvTokenEngine.so;PYKCS11PIN=secret1
