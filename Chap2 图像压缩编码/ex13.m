clear all;
addpath(genpath(pwd));

%��������
load('jpegCoeff.mat');
load('snow.mat');

%����
[imgHeight, imgWidth, codeDC, codeAC] = jpgEncoder(snow, QTAB, DCTAB, ACTAB);

%����
img = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC, QTAB, DCTAB, ACTAB);

figure;
subplot(1, 2, 1); imshow(snow); title('Origin Image');
subplot(1, 2, 2); imshow(img); title('Compressed Image');

%����ѹ���ȣ�PSNR
compressRatio = computeCompressRatio(imgHeight, imgWidth, codeDC, codeAC);
disp(compressRatio);
PSNR = computePSNR(img, snow);
disp(PSNR);