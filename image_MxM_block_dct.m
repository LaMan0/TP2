function transform_image = image_MxM_block_dct( input_image,M )

N = size(input_image,1);
T = N/M;

transform_image = zeros( size( input_image,1 ),size( input_image,2 ) );
for m = 0:T-1
    for n = 0:T-1
        transform_image( m*M+[1:M],n*M+[1:M] ) = ...
            pdip_dct2( input_image( m*M+[1:M],n*M+[1:M] ) );
    end
end