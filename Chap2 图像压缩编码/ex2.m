clear all;
%载入数据
%coff = load('../JpegCoeff.mat');
img = load('hall.mat');
grayImg = double(img.hall_gray);

%选取随机6 x 8区域
pos = round( rand(1) * (min(size(grayImg)) - 8) ) + 1;
testRegion = grayImg(pos : pos + 5, pos : pos + 7);

[coff, ~, ~] = imgDCT(testRegion);
disp(coff);
disp(dct2(testRegion));

function [coffMat, colTransMat, rowTransMat] = imgDCT(img)
    imgSize = size(img);
    
    %构造DCT列变换矩阵
    X = [0 : imgSize(1) - 1] / (2 * imgSize(1)) * pi; %#ok<*NBRAK>
    Y = [1 : 2 : 2 * imgSize(1) - 1];
    %X = repmat(X', [1, imgSize(1)]); Y = repmat(Y, [imgSize(1), 1]);
    %colTransMat = cos(X .* Y) * sqrt(2.0 / imgSize(1));
    
    %利用bsxfun直接计算 X' .* Y即可; 
    colTransMat = cos(bsxfun(@times, X', Y)) * sqrt(2.0 / imgSize(1));
    colTransMat(1, :) = sqrt(1.0 / imgSize(1));
    
    %构造DCT行变换矩阵
    X = [0 : imgSize(2) - 1] / (2 * imgSize(2)) * pi;
    Y = [1 : 2 : 2 * imgSize(2) - 1];
    %X = repmat(X', [1, imgSize(2)]); Y = repmat(Y, [imgSize(2), 1]);
    %rowTransMat = cos(X .* Y) * sqrt(2.0 / imgSize(2));
    
    %利用bsxfun直接计算 X' .* Y即可
    rowTransMat = cos(bsxfun(@times, X', Y)) * sqrt(2.0 / imgSize(2));
    rowTransMat(1, :) = sqrt(1.0 / imgSize(2));
    
    %计算DCT系数
    coffMat = colTransMat * img * rowTransMat';
end