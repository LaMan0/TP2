function Irgb = ycbcr2rgb_(Iycbcr)

y = Iycbcr(:,:,1);
cb = Iycbcr(:,:,2);
cr = Iycbcr(:,:,3);

r = y + 1.402 * (cr  );

g = y - 0.34414 * (cb  ) - 0.71414 * (cr  );

b = y + 1.772 * (cb );

Irgb(:,:,1) =r ;
Irgb(:,:,2) =g ;
Irgb(:,:,3) =b ;