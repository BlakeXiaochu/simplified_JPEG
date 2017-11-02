clear all;
addpath(genpath('..\'));

load('hall.mat');
load('JpegCoeff.mat');

%������Ϣ(I love you)
[imgWithInfo, infoBits] = spatialInfoHide(hall_gray, 'I love you');
figure;
subplot(1, 2, 1); imshow(hall_gray); title('Origin Image');
subplot(1, 2, 2); imshow(imgWithInfo); title('Image with Information');

%��δ�������ͼƬ����ȡ��Ϣ
info1 = spatialInfoExtract(imgWithInfo, infoBits);
disp(info1);

%���ѱ������ͼƬ����ȡ��Ϣ
[imgHeight, imgWidth, codeDC, codeAC] = jpgEncoder(imgWithInfo, QTAB, DCTAB, ACTAB);
newImgWithInfo = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC, QTAB, DCTAB, ACTAB);

info2 = spatialInfoExtract(newImgWithInfo, infoBits);
disp(info2);