# -*- coding: utf-8 -*-
"""
Created on Tue Jun 14 17:12:57 2016

@author: cromp
"""

import matplotlib.pyplot as plt
import numpy as np
import gdal
import gdalconst as gdc  # constants for gdal - e.g. GA_ReadOnly, GA_Update ( http://www.gdal.org )
import os
import sys
import time
import datetime as dt
import osr
import glob


lstDW = glob.glob('vel\p063_r017\*_016*dzdw.tif')

lstYr = [x.split('\\')[2].split('_')[7] for x in lstDW]
lstDay = [x.split('\\')[2].split('_')[8] for x in lstDW]

lstYD = []

for i in np.arange(0,len(lstYr)):
    x = lstYr[i]+lstDay[i]
    fn = glob.glob('L8_B8\p063_r017\*'+x+'*.tif')
    lstYD.append(fn)
    
    