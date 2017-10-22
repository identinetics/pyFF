from __future__ import print_function
__author__ = 'leifj'
# -*- coding: utf-8 -*-

import os
import gettext
import logging

LOCALE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "i18n")

language = gettext.translation('messages', LOCALE_DIR, fallback=True)

logging.debug('Locale: ' + language._info['language'], ', rev: ' + language._info['po-revision-date'])
