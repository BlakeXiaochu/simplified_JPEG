clear all;
%����en-decoder�ļ����µ�ZigZag����
addpath(genpath(pwd));

%��������
img = load('hall.mat');
grayImg = double(img.hall_gray);
%ѡȡ���8 x 8����
pos = round( rand(1) * (min(size(grayImg)) - 8) ) + 1;
testRegion = grayImg(pos : pos + 7, pos : pos + 7);
DCTcoff = dct2(testRegion);

%����ʵ�����ZigZag�ļ����µ�ZigZag.m�ļ�

%1.ֱ�Ӷ�ȡ��������
[flatArray1, index1] = ZigZag(DCTcoff, 0);
%2.����element-by-element������������������
[flatArray2, index2] = ZigZag(DCTcoff, 1);
%3.����ѭ��ֱ�ӱ���
[flatArray3, index3] = ZigZag(DCTcoff, 2);

%��ӡ���
disp(flatArray1');
disp(flatArray2');
disp(flatArray3');