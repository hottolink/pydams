#!/usr/bin/env python
# -*- coding:utf-8 -*-
from __future__ import absolute_import
from __future__ import unicode_literals
from __future__ import division
from __future__ import print_function

import math
from ._distance_function import hubeny as distance_hubeny

def __pretty_print_level(dict_addr):
    print("\t\taddress:{name}, lat:{y}, long:{x}".format(**dict_addr))

def pretty_print(dict_geocoded):
    """
    pretty prints the geocoded addresses
    :param dict_geocoded: geocoded object returned by DAMS.geocode() or DAMS.geocode_simplify()
    """
    print("score: %d" % dict_geocoded["score"])
    print("candidates: %d" % len(dict_geocoded["candidates"]))

    for idx, obj_candidate in enumerate(dict_geocoded["candidates"]):
        if isinstance(obj_candidate, list):
            print("\tcandidate: %d, address level: %d" % (idx, obj_candidate[-1]["level"]))
            for dict_addr in obj_candidate:
                __pretty_print_level(dict_addr)
        elif isinstance(obj_candidate, dict):
            print("\tcandidate: %d, address level: %d" % (idx, obj_candidate["level"]))
            __pretty_print_level(obj_candidate)
        else:
            raise AssertionError("unexpected object was passed.")
