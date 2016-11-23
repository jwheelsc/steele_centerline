# -*- coding: utf-8 -*-
"""
Created on Mon Nov 21 14:20:23 2016

@author: Jeff
"""

import matplotlib.pyplot as plt
import numpy as np
import gdalconst as gdc  # constants for gdal - e.g. GA_ReadOnly, GA_Update ( http://www.gdal.org )
from osgeo import ogr
from osgeo import osr
from osgeo import gdal
from osgeo import gdal_array
import gdal

import os
import sys
import time
import datetime as dt
#import osr
import glob


lstDW = glob.glob('E:/surge_project/p063_r017/*.nc')

#    lstYear1= [x.split('/')[-1].split('_')[7] for x in lstDW]
#    lstDay1 = [x.split('/')[-1].split('_')[8] for x in lstDW]
#    lstYear2=[x.split('/')[-1].split('_')[9] for x in lstDW]
#    lstDay2 = [x.split('/')[-1].split('_')[10] for x in lstDW]


for i in np.arange(1):

    inputFile = lstDW[i]
    print(inputFile)
    outName = ("E:/surge_project/p063_r017_nc2tif/" + inputFile[27:67] + "vx_masked.tif")
    os.system("gdal_translate -of GTiff NETCDF:" + inputFile +  ":vx_masked " + "junk.tif")


#for i in np.arange(0,len(lstDW)):
#
#    inputFile = lstDW[i]
#    outName = ("E:/surge_project/p063_r017_nc2tif/" + inputFile[27:67] + "vx_masked.tif")
#    os.system("gdal_translate -of GTiff HDF5:" + inputFile +  "://vx_masked " + outName)

#for i in np.arange(0,len(lstDW)):
#
#    inputFile = lstDW[i]
#    outName = ("E:/surge_project/p063_r017_nc2tif/" + inputFile[27:67] + "vy_masked.tif")
#    os.system("gdal_translate -of GTiff HDF5:" + inputFile +  "://vy_masked " + outName)
#
#for i in np.arange(0,len(lstDW)):
#
#    inputFile = lstDW[i]
#    outName = ("E:/surge_project/p063_r017_nc2tif/" + inputFile[27:67] + "vv_masked.tif")
#    os.system("gdal_translate -of GTiff HDF5:" + inputFile +  "://vv_masked " + outName)
