function output_image = quant_MxM_bloc_iquant(quantized_image,M,Q)

N = size(quantized_image,1);
T = N/M;

output_image = zeros( size(quantized_image,1 ),size(quantized_image,2 ) );

for m = 0:T-1
    for n = 0:T-1
       output_image( m*M+[1:M],n*M+[1:M] ) =  quantized_image( m*M+[1:M],n*M+[1:M] ).*Q;
    end
end