
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 19 09:57:50 2016

@author: Jeff
"""
import yaml
from collections import namedtuple
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.image as mpimg
import matplotlib.patches as patches
im
        
            
fileVY = 'E:/surge_project/vel/p063_r017/akv0_S8_063_017_016_2016_056_2016_072_vy.tif'
imgVY = mpimg.imread(fileVY, '.tif')   
f, axarr = plt.subplots()
axarr.imshow(imgVY)
print(imgVY)
      
#f.savefig(out, dpi = 600, orientation= 'landscape')