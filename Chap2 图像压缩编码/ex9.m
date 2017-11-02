clear all;
addpath(genpath(pwd));

%��������
load('JpegCoeff.mat');
load('hall.mat');

%jpg����
[imgHeight, imgWidth, codeDC, codeAC] = jpgEncoder(hall_gray, QTAB, DCTAB, ACTAB);

%����
save('jpegcodes.mat', 'imgHeight', 'imgWidth', 'codeDC', 'codeAC');