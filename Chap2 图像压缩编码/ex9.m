clear all;
addpath(genpath(pwd));

%载入数据
load('JpegCoeff.mat');
load('hall.mat');

%jpg编码
[imgHeight, imgWidth, codeDC, codeAC] = jpgEncoder(hall_gray, QTAB, DCTAB, ACTAB);

%保存
save('jpegcodes.mat', 'imgHeight', 'imgWidth', 'codeDC', 'codeAC');