__author__ = 'leifj'
# -*- coding: utf-8 -*-

import os
import gettext

LOCALE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "i18n")

language = gettext.translation('messages', LOCALE_DIR, fallback=True)
