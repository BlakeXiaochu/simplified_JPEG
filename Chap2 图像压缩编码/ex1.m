clear all;
%载入数据
img = load('hall.mat');
grayImg = img.hall_gray;

%选取随机8 x 8区域
pos = round( rand(1) * (min(size(grayImg)) - 8) ) + 1;
testRegion = double(grayImg(pos : pos + 7, pos : pos + 7));
%空间域预处理
testCoff1 = dct2( testRegion - 128 );
%变换域预处理
testCoff2 = dct2(testRegion) - 128;

%由结果可知：空间域减去128仅影响DCT中的直流分量，其他分量均相同。故在变换域减去128的做法并不可行
disp(testCoff1);
disp(testCoff2 + 128);
disp(testCoff2);