clear all;
addpath(genpath(pwd));

%ÔØÈëÊı¾İ
load('jpegcodes.mat');

compressRatio = computeCompressRatio(imgHeight, imgWidth, codeDC, codeAC);
disp(compressRatio);