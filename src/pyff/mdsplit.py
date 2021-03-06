"""
mdsplit creates a separate signed XML file for each EntitiyDescriptor from the input md aggregate.
This is a subset of the MDQ specification to allowing to address an entity using following scheme
<baseurl>/entities/<urlencode(entityID)>

Note: The input file is considered to be trusted, therefore its signature is not verified.
"""

__author__ = 'r2h2'

import logging
import lxml.etree as etree
import os
import re
import shutil
import sys
import urllib

from pyff.samlmd import MDRepository
from pyff.pipes import plumbing
from pyff.store import MemoryStore

XMLDECLARATION = b'<?xml version="1.0" ?>'


class Pipeline:
    def __init__(self, keyfile, certfile, cacheDuration, validUntil):
        self.key = keyfile
        self.certfile = certfile
        self.cacheDuration = cacheDuration
        self.validUntil = validUntil

    def get(self, loaddir, outfile, template_file=None):
        # sign a single entity descriptor

        if template_file:
            with (open(template_file, 'r')) as fd:
                pipeline_template = fd.read()
        else:
            pipeline_template = '''- load:
  - {0}
- select
- finalize:
    cacheDuration: {2}
    validUntil: {3}
- sign:
    key:  {4}
    cert: {5}
- publish:
    {1}
'''
        pipeline = pipeline_template.format(loaddir,
                                            outfile,
                                            self.cacheDuration,
                                            self.validUntil,
                                            self.key,
                                            self.certfile,
                                           )
        return pipeline


def entityid_to_dirname(entityid):
    entityid_safename = entityid.replace('/', '_').replace(':', '.') # prevent httpd url-encoding '%'
    return urllib.parse.quote(entityid_safename, safe='')


def simple_md(pipeline):
    """ just a copy of md:main """
    modules = []
    modules.append('pyff.builtins')
    store = MemoryStore()
    md = MDRepository()
    plumbing(pipeline).process(md, state={'batch': True, 'stats': {}})


def process_entity_descriptor(ed, pipeline, args):
    """
    1. create an unsigned EntityDescriptor XML file
    2. create a pipline file to sign it
    3. execute pyff to create an aggregate with the EntityDescriptor
    4. delete temp files
    Note: for pyff pipeline processing the entityDescriptor xml file must be alone in a directory
    TODO: remove EntitiesDecriptor and make EntityDescriptor the root element.
    """
    dirname_temp = os.path.abspath(os.path.join(args.outdir_unsigned,
                                                entityid_to_dirname(ed.attrib['entityID'])))
    if not os.path.exists(dirname_temp):
        os.makedirs(dirname_temp)
    fn_temp = os.path.join(dirname_temp, 'ed.xml')
    logging.debug('writing unsigned EntitiyDescriptor ' + ed.attrib['entityID'] + ' to ' + fn_temp)
    if args.cacheDuration is not None:
        ed.attrib['cacheDuration'] = args.cacheDuration
    if args.validUntil is not None:
        ed.attrib['validUntil'] = args.validUntil
    if not os.path.exists(os.path.dirname(fn_temp)):
        os.makedirs(os.path.dirname(fn_temp))
    with open(fn_temp, 'wb') as f:
        f.write(XMLDECLARATION + b'\n' + etree.tostring(ed))
    if not args.nosign:
        if not os.path.exists(args.outdir_signed):
            os.makedirs(args.outdir_signed)
        fn_out = os.path.abspath(os.path.join(args.outdir_signed,
                                              entityid_to_dirname(ed.attrib['entityID']) + '.xml'))
        fn_pipeline = os.path.join(dirname_temp, 'ed.fd')
        with open(fn_pipeline, 'w') as f_pipeline:
            f_pipeline.write(pipeline.get(dirname_temp, fn_out))
        simple_md(fn_pipeline)
        if not args.nocleanup:
            shutil.rmtree(dirname_temp)



def process_md_aggregate(args):
    """ process each ed; take validUntil and cacheDuration from root level """
    root = etree.parse(args.input).getroot()
    if root.tag != '{urn:oasis:names:tc:SAML:2.0:metadata}EntitiesDescriptor':
        raise Exception('Root element must be EntitiesDescriptor')
    if 'cacheDuration' in root.attrib and args.cacheDuration is None:
        args.cacheDuration = root.attrib['cacheDuration']
    if 'validUntil' in root.attrib and args.validUntil is None:
        args.validUntil = root.attrib['validUntil']
    alist = ''
    for a in root.attrib:
        alist += ' ' + a + '="' + root.attrib[a] + '"'
    logging.debug('Root element: ' + root.tag + alist)
    pipeline = Pipeline(args.key, args.certfile, args.cacheDuration, args.validUntil)
    for ed in root.findall('{urn:oasis:names:tc:SAML:2.0:metadata}EntityDescriptor'):
        process_entity_descriptor(ed, pipeline, args)
