function [imgHeight, imgWidth, codeDC, codeAC] = jpgEncoder(img, QTAB, DCTAB, ACTAB)
    if(nargin < 4)
        %载入数据
        table = load('JpegCoeff.mat');
        ACTAB = table.ACTAB; 
        DCTAB = table.DCTAB; 
        QTAB = table.QTAB;
    end
    
    %扩展图片长宽为8的倍数, 并将原图减去128
    imgSize = size(img);
    imgHeight = imgSize(1); imgWidth = imgSize(2);
    
    extImgSize = ceil(imgSize / 8) * 8;
    extImg = zeros(extImgSize, 'double');
    extImg(1:imgSize(1), 1:imgSize(2)) = double(img) - 128;
    %初始化
    [~, index] = ZigZag(ones(8), 0);
    flatMat = zeros([prod(extImgSize / 8), 64]);

    %DCT & ZigZag扫描
    for i = 0 : extImgSize(1)/8 - 1
        for j = 0 : extImgSize(2)/8 - 1
            imgRegion = extImg(8*i+1:8*i+8, 8*j+1:8*j+8);
            coff = dct2(imgRegion);
            %量化系数
            quantCoff = round(coff ./ QTAB);
            %ZigZag
            flatMat(extImgSize(2)/8 * i + j + 1, :) = quantCoff(index);
        end
    end
    
    %DC编码
    quantDC = flatMat(:, 1)';
    codeDC = encodeDC(quantDC, DCTAB);
    
    %AC编码
    quantAC = flatMat(:, 2:end);
    codeAC = encodeAC(quantAC, ACTAB);
end

