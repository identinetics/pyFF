#!/usr/bin/env python
"""
usage: pyff_mdsplit.py [-h] [-c CERTFILE] [-k KEY] [-n] [-S] [-v]
                       [-l LOGFILE] [-L {INFO,DEBUG,CRITICAL,WARNING,ERROR}]
                       [-o OUTDIR_SIGNED] [-C CACHEDURATION] [-u VALIDUNTIL]
                       input outdir_unsigned

Metadata Splitter

positional arguments:
  input                 Metadata aggregate (input)
  outdir_unsigned       Directory for files containing one unsigned
                        EntityDescriptor each.

optional arguments:
  -h, --help            show this help message and exit
  -c --certfile CERTFILE Certificate as PEM file
  -k --keyfile KEYFILE | PKCS11-URL Key n PEM file or PKCS#11-device
  -n, --nocleanup       do not delete temporary files after signing
  -S, --nosign          do not sign output
  -v, --verbose         output to console with DEBUG level
  -l --logfile LOGFILE
  -L --loglevel {INFO,DEBUG,CRITICAL,WARNING,ERROR}
                        default is INFO if env[LOGLEVEL] is not set
  -o --outdir_signed OUTDIR_SIGNED
                        Directory for files containing one signed
                        EntityDescriptor each.
  -C --cacheduration CACHEDURATION
                        override value from input EntitiesDescriptor, if any
  -u --validuntil VALIDUNTIL
                        override iso date value from input EntitiesDescriptor,
                        if any
"""

import argparse
import logging
import os
import re
import sys

import pyff.mdsplit

LOGLEVELS = {'CRITICAL': 50, 'ERROR': 40, 'WARNING': 30, 'INFO': 20, 'DEBUG': 10}


class Invocation:
    """ Get arguments from command line and enviroment """
    def __init__(self, testargs=None):
        self.parser = argparse.ArgumentParser(description='Metadata Splitter')
        self.parser.add_argument('-c', '--certfile', dest='certfile', help='Certificate (PEM)')
        self.parser.add_argument('-k', '--key', dest='key', help='keyfile or pkcs11 url')
        self.parser.add_argument('-n', '--nocleanup', action='store_true',
            help='do not delete temporary files after signing')
        self.parser.add_argument('-S', '--nosign', action='store_true', help='do not sign output')
        self.parser.add_argument('-v', '--verbose', action='store_true', help='output to console with DEBUG level')
        logbasename = re.sub(r'\.py$', '.log', os.path.basename(__file__))
        self.parser.add_argument('-l', '--logfile', dest='logfile', default=logbasename)
        loglevel_env = os.environ['LOGLEVEL'] if 'LOGLEVEL' in os.environ else 'INFO'
        self.parser.add_argument('-L', '--loglevel', dest='loglevel', default=loglevel_env,
            choices=LOGLEVELS.keys(), help='default is INFO if env[LOGLEVEL] is not set')
        self.parser.add_argument('-o', '--outdir_signed', default='entities',
            help='Directory for files containing one signed EntityDescriptor each.')
        self.parser.add_argument('-C', '--cacheduration', dest='cacheDuration', default='PT5H',
            help='override value from input EntitiesDescriptor, if any')
        self.parser.add_argument('-u', '--validuntil', dest='validUntil',
            help='override iso date value from input EntitiesDescriptor, if any')
        self.parser.add_argument('input', type=argparse.FileType('r'), default=None,
            help='Metadata aggregate (input)')
        self.parser.add_argument('outdir_unsigned', default=None,
            help='Directory for files containing one unsigned EntityDescriptor each.')
        self.args = self.parser.parse_args()
        # merge argv with env
        if not self.args.nosign:
            self.args.certfile = self._merge_arg('MDSIGN_CERT', self.args.certfile, 'certfile')
            self.args.keyfile = self._merge_arg('MDSIGN_KEY', self.args.key, 'key')
            self.args.outdir_signed = self._merge_arg('MDSPLIT_SIGNED', self.args.outdir_signed, 'outdir_signed')
        self.args.input = self._merge_arg('MD_AGGREGATE', self.args.input, 'input')
        self.args.outdir_unsigned = self._merge_arg('MDSPLIT_UNSIGNED', self.args.outdir_unsigned, 'outdir_unsigned')


    def _merge_arg(self, env, arg, argname):
        """ merge argv with env """
        if env not in os.environ and arg is None:
            print("Either %s or --%s must be set and point to an existing file" % (env, argname))
            exit(1)
        if arg is None:
            return env
        else:
            return arg


def main():
    invocation = Invocation()

    log_args = {'level': LOGLEVELS[invocation.args.loglevel],
                'format': '%(asctime)s - %(levelname)s  [%(filename)s:%(lineno)s] %(message)s',
                'filename': invocation.args.logfile,
    }
    logging.basicConfig(**log_args)
    if invocation.args.verbose:
        console_handler = logging.StreamHandler()
        console_handler.setLevel(logging.DEBUG)
        logging.getLogger('').addHandler(console_handler)

    logging.debug('')
    logging.debug('Input file is ' + invocation.args.input.name)
    logging.debug('Output directory for unsigned files is ' + os.path.abspath(invocation.args.outdir_unsigned))
    if not invocation.args.nosign:
        logging.debug('Output directory for signed files is ' + os.path.abspath(invocation.args.outdir_signed))

    pyff.mdsplit.process_md_aggregate(invocation.args)

if __name__ == "__main__":  # pragma: no cover
    main()