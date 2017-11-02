clear all;
addpath(genpath('..\'));

load('hall.mat');
load('JpegCoeff.mat');

info = 'Love';

%第一种方法
[imgHeight, imgWidth, codeDC, codeAC, infoBits] = DCTInfoHide(hall_gray, info, 1, QTAB, DCTAB, ACTAB);
info1 = DCTInfoExtract(imgHeight, imgWidth, codeDC, codeAC, infoBits, 1, DCTAB, ACTAB);
disp(info1);
compressRatio1 = computeCompressRatio(imgHeight, imgWidth, codeDC, codeAC);
disp(compressRatio1)
img = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC);
PSNR1 = computePSNR(img, hall_gray);
disp(PSNR1);

%第二种方法
[imgHeight, imgWidth, codeDC, codeAC, infoBits] = DCTInfoHide(hall_gray, info, 2, QTAB, DCTAB, ACTAB);
info2 = DCTInfoExtract(imgHeight, imgWidth, codeDC, codeAC, infoBits, 2, DCTAB, ACTAB);
disp(info2);
compressRatio2 = computeCompressRatio(imgHeight, imgWidth, codeDC, codeAC);
disp(compressRatio2)
img = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC);
PSNR2 = computePSNR(img, hall_gray);
disp(PSNR2);

%第三种方法
[imgHeight, imgWidth, codeDC, codeAC, infoBits] = DCTInfoHide(hall_gray, info, 3, QTAB, DCTAB, ACTAB);
info3 = DCTInfoExtract(imgHeight, imgWidth, codeDC, codeAC, infoBits, 3, DCTAB, ACTAB);
disp(info3);
compressRatio3 = computeCompressRatio(imgHeight, imgWidth, codeDC, codeAC);
disp(compressRatio3)
img = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC);
PSNR3 = computePSNR(img, hall_gray);
disp(PSNR3);