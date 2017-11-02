clear all;
%调用en-decoder文件夹下的ZigZag函数
addpath(genpath(pwd));

%载入数据
img = load('hall.mat');
grayImg = double(img.hall_gray);
%选取随机8 x 8区域
pos = round( rand(1) * (min(size(grayImg)) - 8) ) + 1;
testRegion = grayImg(pos : pos + 7, pos : pos + 7);
DCTcoff = dct2(testRegion);

%具体实现请见ZigZag文件夹下的ZigZag.m文件

%1.直接读取索引数组
[flatArray1, index1] = ZigZag(DCTcoff, 0);
%2.利用element-by-element方法，生成索引数组
[flatArray2, index2] = ZigZag(DCTcoff, 1);
%3.利用循环直接遍历
[flatArray3, index3] = ZigZag(DCTcoff, 2);

%打印结果
disp(flatArray1');
disp(flatArray2');
disp(flatArray3');