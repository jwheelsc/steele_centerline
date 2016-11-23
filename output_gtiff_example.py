
output_array_ul_corner=chip_center_grid_xy[:,0,0]-((inc/2.0)*img1.pix_x_m,(inc/2.0)*img1.pix_y_m)
output_array_pix_x_m=inc*img1.pix_x_m
output_array_pix_y_m=inc*img1.pix_y_m

format = "GTiff"
driver = gdal.GetDriverByName( format )
metadata = driver.GetMetadata()

dst_filename = file_name_base+ '_vx.tif'
(out_lines,out_pixels)=vx.shape
out_bands=1
dst_ds = driver.Create( dst_filename, out_pixels, out_lines, out_bands, gdal.GDT_Float32 )
print 'out image %s %s %d, %d, %d'%(dst_filename, format, out_pixels, out_lines, out_bands)
dst_ds.SetGeoTransform( [ output_array_ul_corner[0], output_array_pix_x_m, 0, output_array_ul_corner[1], 0, output_array_pix_y_m ] ) # note pix_y_m typically negative
dst_ds.SetProjection( img1.proj )
dst_ds.GetRasterBand(1).WriteArray( (vx).astype('float32') )
dst_ds = None # done, close the dataset
