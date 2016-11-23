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

class GeoImg:  # modified 9/7/2015 for LO8 fname -> date
	"""geocoded image input and info
		a=GeoImg(in_file_name,indir='.')
			a.img will contain image
			a.parameter etc..."""
	def __init__(self, in_filename,in_dir='.',datestr=None,datefmt='%m/%d/%y'):
		self.filename = in_filename
		self.in_dir_path = in_dir  #in_dir can be relative...
		self.in_dir_abs_path=os.path.abspath(in_dir)  # get absolute path for later ref if needed
		self.gd=gdal.Open(self.in_dir_path + os.path.sep + self.filename)
		self.srs=osr.SpatialReference(wkt=self.gd.GetProjection())
		self.gt=self.gd.GetGeoTransform()
		self.proj=self.gd.GetProjection()
		self.intype=self.gd.GetDriver().ShortName
		self.min_x=self.gt[0]
		self.max_x=self.gt[0]+self.gd.RasterXSize*self.gt[1]
		self.min_y=self.gt[3]+self.gt[5]*self.gd.RasterYSize
		self.max_y=self.gt[3]
		self.pix_x_m=self.gt[1]
		self.pix_y_m=self.gt[5]
		self.num_pix_x=self.gd.RasterXSize
		self.num_pix_y=self.gd.RasterYSize
		self.XYtfm=np.array([self.min_x,self.max_y,self.pix_x_m,self.pix_y_m]).astype('float')
		if (datestr is not None):
			self.imagedatetime=dt.datetime.strptime(datestr,datefmt)
		elif ((self.filename.find('LC8') == 0) | (self.filename.find('LO8') == 0) | \
				(self.filename.find('LE7') == 0) | (self.filename.find('LT5') == 0) | \
				(self.filename.find('LT4') == 0)):	# looks landsat like - try parsing the date from filename (contains day of year)
			self.sensor=self.filename[0:3]
			self.path=int(self.filename[3:6])
			self.row=int(self.filename[6:9])
			self.year=int(self.filename[9:13])
			self.doy=int(self.filename[13:16])
			self.imagedatetime=dt.date.fromordinal(dt.date(self.year-1,12,31).toordinal()+self.doy)
		else:
			self.imagedatetime=None  # need to throw error in this case...or get it from metadata
		self.img=self.gd.ReadAsArray().astype(np.float32)   # works for L8 and earlier - and openCV correlation routine needs float or byte so just use float...
# 		self.img=self.gd.ReadAsArray().astype(np.uint8)		# L7 and earlier - doesn't work with plt.imshow...
		self.img_ov2=self.img[0::2,0::2]
		self.img_ov10=self.img[0::10,0::10]
		self.srs=osr.SpatialReference(wkt=self.gd.GetProjection())
	def imageij2XY(self,ai,aj,outx=None,outy=None):
		it = np.nditer([ai,aj,outx,outy],
						flags = ['external_loop', 'buffered'],
						op_flags = [['readonly'],['readonly'],
									['writeonly', 'allocate', 'no_broadcast'],
									['writeonly', 'allocate', 'no_broadcast']])
		for ii,jj,ox,oy in it:
			ox[...]=(self.XYtfm[0]+((ii+0.5)*self.XYtfm[2]));
			oy[...]=(self.XYtfm[1]+((jj+0.5)*self.XYtfm[3]));
		return np.array(it.operands[2:4])
	def XY2imageij(self,ax,ay,outi=None,outj=None):
		it = np.nditer([ax,ay,outi,outj],
						flags = ['external_loop', 'buffered'],
						op_flags = [['readonly'],['readonly'],
									['writeonly', 'allocate', 'no_broadcast'],
									['writeonly', 'allocate', 'no_broadcast']])
		for xx,yy,oi,oj in it:
			oi[...]=((xx-self.XYtfm[0])/self.XYtfm[2])-0.5;  # if python arrays started at 1, + 0.5
			oj[...]=((yy-self.XYtfm[1])/self.XYtfm[3])-0.5;  # " " " " "
		return np.array(it.operands[2:4])
		
def makePlot(gvz):
    
    plt.figure()
    #[580:660,380:550]
    #steele
    plt.imshow(gvz[450:550,500:580], vmin = -0.003, vmax = 0.003)
    plt.colorbar()
    plt.ion()
    plt.show()

    plt.figure()
    #[580:660,380:550]
    plt.imshow(gvz[580:660,380:550], vmin = -0.003, vmax = 0.003)
    plt.colorbar()
    plt.ion()
    plt.show()
		
#
#lstVX = glob.glob('vel\p063_r017\*_032*vx.tif')
#lstVY = glob.glob('vel\p063_r017\*_032*vy.tif')
#
#for i in np.arange(0,len(lstVX)):
#    
#    fNameVX = lstVX[i]
#    fNameVY = lstVY[i]
#    
##    vx=GeoImg(fNameVX, in_dir = 'vel\p063_r017')
##    vy=GeoImg(fNameVY, in_dir = 'vel\p063_r017')
#
#    vx=GeoImg(fNameVX)
#    vy=GeoImg(fNameVY)
#    
#    gvx = np.gradient(vx.img,300.0,300.0)
#    gvy = np.gradient(vy.img,300.0,300.0)
#    gvz = -(gvx[1]-gvy[0])
#    
##    makePlot(gvz)  
#      
#    file_name_base = vx.filename.replace('_vx','_dzdw')
#    out_pixels = vx.num_pix_x
#    out_lines = vx.num_pix_y
#    out_bands = 1
#    
#    #output_array_ul_corner=chip_center_grid_xy[:,0,0]-((inc/2.0)*img1.pix_x_m,(inc/2.0)*img1.pix_y_m)
#    #output_array_pix_x_m=inc*img1.pix_x_m
#    #output_array_pix_y_m=inc*img1.pix_y_m
#    
#    format = "GTiff"
#    driver = gdal.GetDriverByName( format )
#    metadata = driver.GetMetadata()
#    
#    #dst_filename = file_name_base+ '_vx.tif'
#    dst_filename = file_name_base
#    dst_ds = driver.Create( dst_filename, out_pixels, out_lines, out_bands, gdal.GDT_Float32 )
#    print 'out image %s %s %d, %d, %d'%(dst_filename, format, out_pixels, out_lines, out_bands)
#    dst_ds.SetGeoTransform(vx.gt) # note pix_y_m typically negative
#    dst_ds.SetProjection(vx.proj)
#    dst_ds.GetRasterBand(1).WriteArray( (gvz).astype('float32') )
#    dst_ds = None # done, close the dataset
#    
#    		
#    # img1=GeoImg(args.img1_name,in_dir=image1dir,datestr=args.img1datestr,datefmt=args.datestrfmt)
#    

#bb = [475700,6777000,557800,6740000] #all of the walsh
bb = [526800,6800000,559000,6770000] #all of the steele
#bb = [525000,6765000,550000,6745000] #upper walsh

bbminx=bb[0]
bbmaxy=bb[1]
bbmaxx=bb[2]
bbminy=bb[3]  
  

lstDW = glob.glob('E:/surge_project/p063_r017_nc2tif/*_vv_*')

#for j in np.arange(0,len(lstDW)):
for j in np.arange(1):
    
    inputName = lstDW[j]
    output = inputName[34:83]
    vv = GeoImg('2012')
    minivv,maxjvv = vv.XY2imageij(bbminx,bbminy)
    maxivv,minjvv = vv.XY2imageij(bbmaxx,bbmaxy)


    plt.figure()
    plt.imshow(vv.img[minjvv:maxjvv,minivv:maxivv],cmap='jet',extent=[bbminx,bbmaxx,bbminy,bbmaxy],vmin=0.0,vmax=0.5)
    #plt.ion()
    #plt.show()

    plt.savefig("E:/surge_project/steele/" + output + ".tif")


