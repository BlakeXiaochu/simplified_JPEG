clear all;
addpath(genpath(pwd));

%��������
load('jpegcodes.mat');

compressRatio = computeCompressRatio(imgHeight, imgWidth, codeDC, codeAC);
disp(compressRatio);