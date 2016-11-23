# -*- coding: utf-8 -*-
"""
Created on Tue Nov 22 07:25:41 2016

@author: cromp
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Nov 21 14:20:23 2016

@author: Jeff
"""

import matplotlib.pyplot as plt
import numpy as np
import glob


lstDW = glob.glob('E:/surge_project/p063_r017_nc2tif/*_vv_*')

#for i in np.arange(0,len(lstDW)):
for i in np.arange(1):   

    inputFile = lstDW[i]
#    lstYear1= [x.split('/')[-1].split('_')[7] for x in lstDW]
#    lstDay1 = [x.split('/')[-1].split('_')[8] for x in lstDW]
#    lstYear2= [x.split('/')[-1].split('_')[9] for x in lstDW]
#    lstDay2 = [x.split('/')[-1].split('_')[10] for x in lstDW]
    outName = ("E:/surge_project/p063_r017_nc2tif/" + inputFile[27:67] + "vv_masked.tif")
#    os.system("gdal_translate -of GTiff -ot Float32 -outsize 100% 100%  -projwin 0.0 0.0 817.0 827.0 -co COMPRESS=DEFLATE -co PREDICTOR=1 -co ZLEVEL=6 HDF5:E:/surge_project/p63_r17" + inputFile +  "://vv_masked" + outName)

