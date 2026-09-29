function [crop_image,transform_crop_image] = image_one_block_dct( input_image,M,m,n)

crop_image =  input_image( m*M+1:m*M+M,n*M+1:n*M+M);

m*M+1:m*M+M
n*M+1:n*M+M

transform_crop_image = pdip_dct2(crop_image);