clear all;
%��������
img = load('hall.mat');
grayImg = img.hall_gray;

%ѡȡ���8 x 8����
pos = round( rand(1) * (min(size(grayImg)) - 8) ) + 1;
testRegion = double(grayImg(pos : pos + 7, pos : pos + 7));
%�ռ���Ԥ����
testCoff1 = dct2( testRegion - 128 );
%�任��Ԥ����
testCoff2 = dct2(testRegion) - 128;

%�ɽ����֪���ռ����ȥ128��Ӱ��DCT�е�ֱ��������������������ͬ�����ڱ任���ȥ128��������������
disp(testCoff1);
disp(testCoff2 + 128);
disp(testCoff2);