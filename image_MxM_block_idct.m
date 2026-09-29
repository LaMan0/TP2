function output_image = image_MxM_block_idct(transform_image,M )

N = size(transform_image,1);
T = N/M;

output_image= zeros( size(transform_image,1 ),size(transform_image,2 ) );
for m = 0:T-1
    for n = 0:T-1
        output_image( m*M+[1:M],n*M+[1:M] ) = ...
            pdip_inv_dct2(transform_image( m*M+[1:M],n*M+[1:M] ) );
    end
end