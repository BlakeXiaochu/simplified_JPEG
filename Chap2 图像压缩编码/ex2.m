clear all;
%��������
%coff = load('../JpegCoeff.mat');
img = load('hall.mat');
grayImg = double(img.hall_gray);

%ѡȡ���6 x 8����
pos = round( rand(1) * (min(size(grayImg)) - 8) ) + 1;
testRegion = grayImg(pos : pos + 5, pos : pos + 7);

[coff, ~, ~] = imgDCT(testRegion);
disp(coff);
disp(dct2(testRegion));

function [coffMat, colTransMat, rowTransMat] = imgDCT(img)
    imgSize = size(img);
    
    %����DCT�б任����
    X = [0 : imgSize(1) - 1] / (2 * imgSize(1)) * pi; %#ok<*NBRAK>
    Y = [1 : 2 : 2 * imgSize(1) - 1];
    %X = repmat(X', [1, imgSize(1)]); Y = repmat(Y, [imgSize(1), 1]);
    %colTransMat = cos(X .* Y) * sqrt(2.0 / imgSize(1));
    
    %����bsxfunֱ�Ӽ��� X' .* Y����; 
    colTransMat = cos(bsxfun(@times, X', Y)) * sqrt(2.0 / imgSize(1));
    colTransMat(1, :) = sqrt(1.0 / imgSize(1));
    
    %����DCT�б任����
    X = [0 : imgSize(2) - 1] / (2 * imgSize(2)) * pi;
    Y = [1 : 2 : 2 * imgSize(2) - 1];
    %X = repmat(X', [1, imgSize(2)]); Y = repmat(Y, [imgSize(2), 1]);
    %rowTransMat = cos(X .* Y) * sqrt(2.0 / imgSize(2));
    
    %����bsxfunֱ�Ӽ��� X' .* Y����
    rowTransMat = cos(bsxfun(@times, X', Y)) * sqrt(2.0 / imgSize(2));
    rowTransMat(1, :) = sqrt(1.0 / imgSize(2));
    
    %����DCTϵ��
    coffMat = colTransMat * img * rowTransMat';
end