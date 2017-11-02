clear all;
addpath(genpath(pwd));

%载入数据
load('jpegCoeff.mat');
load('snow.mat');

%编码
[imgHeight, imgWidth, codeDC, codeAC] = jpgEncoder(snow, QTAB, DCTAB, ACTAB);

%解码
img = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC, QTAB, DCTAB, ACTAB);

figure;
subplot(1, 2, 1); imshow(snow); title('Origin Image');
subplot(1, 2, 2); imshow(img); title('Compressed Image');

%计算压缩比，PSNR
compressRatio = computeCompressRatio(imgHeight, imgWidth, codeDC, codeAC);
disp(compressRatio);
PSNR = computePSNR(img, snow);
disp(PSNR);