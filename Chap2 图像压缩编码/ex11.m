clear all;
addpath(genpath(pwd));

%��������
load('jpegcodes.mat');
load('jpegCoeff.mat');
load('hall.mat');

%����
img = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC, QTAB, DCTAB, ACTAB);

figure;
subplot(1, 2, 1); imshow(hall_gray); title('Origin Image');
subplot(1, 2, 2); imshow(img); title('Compressed Image');

%����PSNR
PSNR = computePSNR(img, hall_gray);
disp(PSNR);