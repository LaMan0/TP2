function Iycbcr = rgb2ycbcr_(Irgb)

r = Irgb(:,:,1)  ;
g = Irgb(:,:,2)  ;
b = Irgb(:,:,3)  ;

y = 0.299 * r + 0.587 * g + 0.114*b;
cb = - 0.1687 * r - 0.3313 * g + 0.5*b ;
cr = 0.5 * r - 0.4187 * g - 0.0813 *b ;

Iycbcr(:,:,1) = y;
Iycbcr(:,:,2) = cb;
Iycbcr(:,:,3) = cr;
