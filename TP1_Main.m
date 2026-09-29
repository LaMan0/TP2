%% CHARGEMENT DE L IMAGE

close all
clear all
clc

S = 0.5;


I = imread('lena.tiff');
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
title( 'DCT compressee Cr');
axis image
subplot(2,3,6);
imagesc(quantized_dct_cr_order);
colormap gray;
title( 'DCT compressee Cb');
axis image


