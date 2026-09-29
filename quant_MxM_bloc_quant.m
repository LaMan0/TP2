function quantized_image = quant_MxM_bloc_quant(transform_image,M,Q)

N = size(transform_image,1);
T = N/M;

quantized_image = zeros( size(transform_image,1 ),size(transform_image,2 ) );

for m = 0:T-1
    for n = 0:T-1
        quantized_image( m*M+[1:M],n*M+[1:M] ) = round( transform_image( m*M+[1:M],n*M+[1:M] )./Q);
    end
end