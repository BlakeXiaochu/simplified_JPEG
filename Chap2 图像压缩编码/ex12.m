clear all;
addpath(genpath(pwd));

%��������
load('jpegCoeff.mat');
load('hall.mat');

%��С��������
QTAB = round(QTAB/2);

%����
[imgHeight, imgWidth, codeDC, codeAC] = jpgEncoder(hall_gray, QTAB, DCTAB, ACTAB);

%����
img = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC, QTAB, DCTAB, ACTAB);

figure;
subplot(1, 2, 1); imshow(hall_gray); title('Origin Image');
subplot(1, 2, 2); imshow(img); title('Compressed Image');

%����ѹ���ȣ�PSNR
compressRatio = computeCompressRatio(imgHeight, imgWidth, codeDC, codeAC);
disp(compressRatio);
PSNR = computePSNR(img, hall_gray);
disp(PSNR);