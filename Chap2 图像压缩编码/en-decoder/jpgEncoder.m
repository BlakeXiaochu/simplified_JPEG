function [imgHeight, imgWidth, codeDC, codeAC] = jpgEncoder(img, QTAB, DCTAB, ACTAB)
    if(nargin < 4)
        %��������
        table = load('JpegCoeff.mat');
        ACTAB = table.ACTAB; 
        DCTAB = table.DCTAB; 
        QTAB = table.QTAB;
    end
    
    %��չͼƬ����Ϊ8�ı���, ����ԭͼ��ȥ128
    imgSize = size(img);
    imgHeight = imgSize(1); imgWidth = imgSize(2);
    
    extImgSize = ceil(imgSize / 8) * 8;
    extImg = zeros(extImgSize, 'double');
    extImg(1:imgSize(1), 1:imgSize(2)) = double(img) - 128;
    %��ʼ��
    [~, index] = ZigZag(ones(8), 0);
    flatMat = zeros([prod(extImgSize / 8), 64]);

    %DCT & ZigZagɨ��
    for i = 0 : extImgSize(1)/8 - 1
        for j = 0 : extImgSize(2)/8 - 1
            imgRegion = extImg(8*i+1:8*i+8, 8*j+1:8*j+8);
            coff = dct2(imgRegion);
            %����ϵ��
            quantCoff = round(coff ./ QTAB);
            %ZigZag
            flatMat(extImgSize(2)/8 * i + j + 1, :) = quantCoff(index);
        end
    end
    
    %DC����
    quantDC = flatMat(:, 1)';
    codeDC = encodeDC(quantDC, DCTAB);
    
    %AC����
    quantAC = flatMat(:, 2:end);
    codeAC = encodeAC(quantAC, ACTAB);
end

