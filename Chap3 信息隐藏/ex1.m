clear all;
addpath(genpath('..\'));

load('hall.mat');
load('JpegCoeff.mat');

%隐藏信息(I love you)
[imgWithInfo, infoBits] = spatialInfoHide(hall_gray, 'I love you');
figure;
subplot(1, 2, 1); imshow(hall_gray); title('Origin Image');
subplot(1, 2, 2); imshow(imgWithInfo); title('Image with Information');

%从未编码过的图片中提取信息
info1 = spatialInfoExtract(imgWithInfo, infoBits);
disp(info1);

%从已编码过的图片中提取信息
[imgHeight, imgWidth, codeDC, codeAC] = jpgEncoder(imgWithInfo, QTAB, DCTAB, ACTAB);
newImgWithInfo = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC, QTAB, DCTAB, ACTAB);

info2 = spatialInfoExtract(newImgWithInfo, infoBits);
disp(info2);