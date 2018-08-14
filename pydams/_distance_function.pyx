#!/usr/bin/env python
# -*- coding:utf-8 -*-
from libc.math cimport sqrt, pow, sin, cos, pi

cdef double __deg2rad(double deg):
    return deg * pi / 180.0

cpdef double hubeny(geo_point_x, geo_point_y):
    # type: (List[float], List[float]) -> (float)
    """
    calculate distance between two geographical points with Hubeny's formula.
    geo-point must be represented as the list with [latitude, longitude] order.
    ref: K. Hubeny: Zur Entwicklung der Gauss'schen Mittelbreitenformeln. Österreichische Zeitschrift für Vermessungswesen, 42 Jahrgang (1954) Nr. 1, S. 8-47.
    :param geo_point_x: point x
    :param geo_point_y: point y
    """
    cdef double a = 6378137.0
    cdef double b = 6356752.314140
    cdef double lat_x, long_x, lat_y, long_y
    cdef double dy, dx, my, e2
    cdef double Mnum, W, M, N, d
    lat_x, long_x = geo_point_x
    lat_y, long_y = geo_point_y
    dy = __deg2rad(lat_x - lat_y)
    dx = __deg2rad(long_x - long_y)
    my = __deg2rad(0.5 * (lat_x + lat_y))
    e2 = (a*a - b*b) / (a*a)
    Mnum = a * (1 - e2)
    W = sqrt(1 - e2 * pow(sin(my), 2.0))
    M = Mnum / pow(W, 3.0)
    N = a / W
    d = sqrt(pow(dy * M, 2.0) + pow(dx * N * cos(my), 2.0))
    return d