clear all;
addpath(genpath(pwd));

%载入数据
load('jpegCoeff.mat');
load('hall.mat');

%减小量化步长
QTAB = round(QTAB/2);

%编码
[imgHeight, imgWidth, codeDC, codeAC] = jpgEncoder(hall_gray, QTAB, DCTAB, ACTAB);

%解码
img = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC, QTAB, DCTAB, ACTAB);

figure;
subplot(1, 2, 1); imshow(hall_gray); title('Origin Image');
subplot(1, 2, 2); imshow(img); title('Compressed Image');

%计算压缩比，PSNR
compressRatio = computeCompressRatio(imgHeight, imgWidth, codeDC, codeAC);
disp(compressRatio);
PSNR = computePSNR(img, hall_gray);
disp(PSNR);