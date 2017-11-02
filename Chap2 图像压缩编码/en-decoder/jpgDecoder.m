function img = jpgDecoder(imgHeight, imgWidth, codeDC, codeAC, QTAB, DCTAB, ACTAB)
    if(nargin < 7)
        %载入数据
        table = load('JpegCoeff.mat');
        ACTAB = table.ACTAB; 
        DCTAB = table.DCTAB; 
        QTAB = table.QTAB;
    end

    %初始化
    extImgSize = ceil([imgHeight, imgWidth] / 8) * 8;
    extImg = zeros(extImgSize, 'double');
    blockNum = prod(extImgSize / 8);
    
    %解码
    quantDC = decodeDC(blockNum, codeDC, DCTAB);
    quantAC = decodeAC(blockNum, codeAC, ACTAB);
    flatMat = horzcat(quantDC', quantAC);
    %恢复为图片
    [~, index] = ZigZag(ones(8), 0);
    for i = 0 : extImgSize(1)/8 - 1
        for j = 0 : extImgSize(2)/8 - 1
            quantCoff = zeros(8, 'double');
            quantCoff(index) = flatMat(extImgSize(2)/8 * i + j + 1, :);
            coff = quantCoff .* QTAB;
            extImg(8*i+1:8*i+8, 8*j+1:8*j+8) = idct2(coff);
        end
    end
    
    img = uint8(extImg(1:imgHeight, 1:imgWidth) + 128);
end
