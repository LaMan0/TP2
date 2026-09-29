function dct_image_order = dct_order(dct_image,M)

N = size(dct_image,1);

dct_image_order = zeros(N,N);

T = N/M;

for i = 0:M-1
    
    for j = 0:M-1
        
        D = dct_image(i+1:M:end,j+1:M:end);
        dct_image_order( i*T+[1:T],j*T+[1:T] ) = D;
    end
end
        


