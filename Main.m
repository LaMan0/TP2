%% CHARGEMENT DE L IMAGE

close all
clear all
clc

% Facteur de qualité : plus S est petit, plus la quantification est forte.
S = 0.5;
if ~(isscalar(S) && isfinite(S) && S > 0)
    error('S doit etre un scalaire strictement positif.');
end

image_name = 'peppers.tiff';


I = imread(image_name);
if ndims(I) ~= 3 || size(I,3) ~= 3
    error('L''image d''entree doit etre une image RGB a trois composantes.');
end
input_image_rgb = double(I);
figure('Name','Image originale en couleur','NumberTitle','off');
imagesc(I);

%% RGB -> YCbCR

input_image_ycbcr = rgb2ycbcr_(double(input_image_rgb));

input_image_y = input_image_ycbcr(:,:,1);
input_image_cb = input_image_ycbcr(:,:,2);
input_image_cr = input_image_ycbcr(:,:,3);

%% DCT 



N = size(input_image_y,1);
M = 8;
if mod(size(input_image_y,1),M) ~= 0 || mod(size(input_image_y,2),M) ~= 0
    error('Les dimensions de l''image doivent etre divisibles par M = %d.', M);
end
T = N/M;

% perform DCT in 2 dimension over blocks of 8x8 in the given picture
dct_image_y = image_MxM_block_dct( input_image_y,M);
dct_image_cb = image_MxM_block_dct( input_image_cb,M);
dct_image_cr = image_MxM_block_dct( input_image_cr,M);


dct_image_order_y = dct_order(dct_image_y,M);
dct_image_order_cb = dct_order(dct_image_cb,M);
dct_image_order_cr = dct_order(dct_image_cr,M);


%% Affichage

clims = [ 0 255 ];
clims2 = [ 0 1 ];
figure('Name','Image originale et sa DCT','NumberTitle','off');
subplot(2,3,1);
imagesc(input_image_y,clims);
colormap gray;
title( 'image Y');
axis image
subplot(2,3,2);
imagesc(input_image_cb,clims-128);
colormap gray;
title( 'image Cb');
axis image
subplot(2,3,3);
imagesc(input_image_cr,clims-128);
colormap gray;
title( 'image Cr');
axis image
subplot(2,3,4);
imagesc(dct_image_order_y);
colormap gray;
title('DCT de l image Y');
axis image
subplot(2,3,5);
imagesc(dct_image_order_cb);
colormap gray;
title('DCT de l image Cb');
axis image
subplot(2,3,6);
imagesc(dct_image_order_cr);
colormap gray;
title('DCT de l image Cr');
axis image

%% QUANTIFICATION

Qy = (1/S) .*[  16 11 10 16 24  40  51  61;
                12 12 14 19 26  58  60  55;
                14 13 16 24 40  57  69  56;
                14 17 22 29 51  87  80  62;
                18 22 37 56 68  109 103 77;
                24 25 55 64 81  104 113 92;
                49 64 78 87 103 121 120 101;
                72 92 95 98 112 100 103 99];

 
Qc = (1/S) .*[  17  18	24	47	99	99	99	99;
                18	21	26	66	99	99	99	99;
                24	26	56	99	99	99	99	99;
                47	66	99	99	99	99	99	99;
                99	99	99	99	99	99	99	99;
                99	99	99	99	99	99	99	99;
                99	99	99	99	99	99	99	99;
                99	99	99	99	99	99	99	99];

quantized_dct_y = quant_MxM_bloc_quant(dct_image_y,M,Qy);
quantized_dct_cb = quant_MxM_bloc_quant(dct_image_cb,M,Qc);
quantized_dct_cr = quant_MxM_bloc_quant(dct_image_cr,M,Qc);

quantized_dct_y_order = dct_order(quantized_dct_y,M);
quantized_dct_cr_order = dct_order(quantized_dct_cr,M);
quantized_dct_cb_order = dct_order(quantized_dct_cb,M);

%% AFFICHAGE

figure('Name','DCT originale et DCT compressee','NumberTitle','off');
subplot(2,3,1);
imagesc(dct_image_order_y);
colormap gray;
title('DCT de l image Y');
axis image
subplot(2,3,2);
imagesc(dct_image_order_cb);
colormap gray;
title('DCT de l image Cb');
axis image
subplot(2,3,3);
imagesc(dct_image_order_cr);
colormap gray;
title('DCT de l image Cr');
axis image
subplot(2,3,4);
imagesc(quantized_dct_y_order);
colormap gray;
title( 'DCT compressee Y');
axis image
subplot(2,3,5);
imagesc(quantized_dct_cb_order);
colormap gray;
title( 'DCT compressee Cb');
axis image
subplot(2,3,6);
imagesc(quantized_dct_cr_order);
colormap gray;
title( 'DCT compressee Cr');
axis image

%% QUANTIFICATION INVERSE

iquant_image_y = quant_MxM_bloc_iquant(quantized_dct_y,M,Qy);
iquant_image_cb = quant_MxM_bloc_iquant(quantized_dct_cb,M,Qc);
iquant_image_cr = quant_MxM_bloc_iquant(quantized_dct_cr,M,Qc);


%% DCT INVERSE

output_image_ycbcr(:,:,1) = image_MxM_block_idct(iquant_image_y,M );
output_image_ycbcr(:,:,2) = image_MxM_block_idct(iquant_image_cb,M );
output_image_ycbcr(:,:,3) = image_MxM_block_idct(iquant_image_cr,M );

%% YCbCR -> RGB

output_image_rgb =  ycbcr2rgb_(output_image_ycbcr) ;

%% AFFICHAGE

figure('Name','Image compressee et sa DCT','NumberTitle','off');
subplot(2,3,1);
imagesc(quantized_dct_y_order);
colormap gray;
title( 'DCT compressee Y');
axis image
subplot(2,3,2);
imagesc(quantized_dct_cb_order);
colormap gray;
title( 'DCT compressee Cb');
axis image
subplot(2,3,3);
imagesc(quantized_dct_cr_order);
colormap gray;
title( 'DCT compressee Cr');
axis image
subplot(2,3,4);
imagesc(output_image_ycbcr(:,:,1),clims);
colormap gray;
title('Image Y compressee');
axis image
subplot(2,3,5);
imagesc(output_image_ycbcr(:,:,2),clims);
colormap gray;
title('Image Cb compressee');
axis image
subplot(2,3,6);
imagesc(output_image_ycbcr(:,:,3),clims);
colormap gray;
title('Image Cr compressee');
axis image

figure('Name','Resultat de la compression','NumberTitle','off');
subplot(121)
imagesc(input_image_rgb./255,clims2);
axis image
title('image originale')
subplot(122)
imagesc(min(max(output_image_rgb./255,0),1),clims2);
axis image
title('image compressee')

err = input_image_rgb - output_image_rgb;
SNR = 10*log10(sum(input_image_rgb(:).^2) / max(sum(err(:).^2), eps));
MSE = mean(err(:).^2);
PSNR = 10*log10(255^2 / max(MSE, eps));
fprintf('Image : %s | S = %.3g | SNR = %.2f dB | PSNR = %.2f dB | MSE = %.3f\n', ...
    image_name, S, SNR, PSNR, MSE);
fprintf('Coefficients DCT nuls apres quantification : Y %.1f%%, Cb %.1f%%, Cr %.1f%%\n', ...
    100*mean(quantized_dct_y(:)==0), 100*mean(quantized_dct_cb(:)==0), ...
    100*mean(quantized_dct_cr(:)==0));


%% AFFICHAGE ZOOM

figure('Name','Zoom DCT Y','NumberTitle','off');
subplot(121)
imagesc(dct_image_order_y(1:3*T,1:3*T));
title('DTC image Y : zoom');
axis image
colormap gray;
subplot(122)
imagesc(quantized_dct_y_order(1:3*T,1:3*T));
axis image
colormap gray;
title('DTC compressee image Y : zoom');
figure('Name','Zoom DCT Cb','NumberTitle','off');
subplot(121)
imagesc(dct_image_order_cb(1:3*T,1:3*T));
title('DTC image Cb : zoom');
axis image
colormap gray;
subplot(122)
imagesc(quantized_dct_cb_order(1:3*T,1:3*T));
axis image
colormap gray;
title('DTC compressee image Cb : zoom');
figure('Name','Zoom DCT Cr','NumberTitle','off');
subplot(121)
imagesc(dct_image_order_cr(1:3*T,1:3*T));
title('DTC image Cr : zoom');
axis image
colormap gray;
subplot(122)
imagesc(quantized_dct_cr_order(1:3*T,1:3*T));
axis image
colormap gray;
title('DTC compressee image Cr : zoom');

%% AFFICHAGE POUR DEUX BLOCS ET LES TROIS COMPOSANTES
% Les indices sont des indices de bloc, numerotes a partir de zero :
% (0,0) commence au pixel (1,1), (8,8) commence au pixel (65,65).
block_positions = [0 0; 8 8];
component_names = {'Y','Cb','Cr'};
for p = 1:size(block_positions,1)
    m = block_positions(p,1);
    n = block_positions(p,2);
    if m >= T || n >= T
        warning('Bloc (%d,%d) hors image ; il est ignore.', m, n);
        continue;
    end
    figure('Name',sprintf('Coefficients DCT bloc (%d,%d)',m,n),'NumberTitle','off');
    for c = 1:3
        block = input_image_ycbcr(m*M+(1:M), n*M+(1:M), c);
        block_dct = pdip_dct2(block);
        if c == 1
            Q = Qy;
        else
            Q = Qc;
        end
        block_quant = round(block_dct ./ Q);
        subplot(2,3,c);
        imagesc(log1p(abs(block_dct))); axis image; colorbar;
        title(sprintf('%s : log(1+|DCT|)', component_names{c}));
        subplot(2,3,c+3);
        imagesc(block_quant); axis image; colorbar;
        title(sprintf('%s : DCT quantifiee', component_names{c}));
        fprintf('Bloc (%d,%d), composante %s : DCT puis coefficients quantifies\n', m,n,component_names{c});
        disp(block_dct);
        disp(block_quant);
    end
    colormap gray;
end

%% TRACE DES BASES

if(M==8)
plot_bases(M,10,'gray2d');
end


