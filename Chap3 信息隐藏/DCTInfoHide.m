%DCT域信息隐藏
function [imgHeight, imgWidth, codeDC, codeAC, infoBits] = DCTInfoHide(img, info, mode, QTAB, DCTAB, ACTAB)
    %mode = 1, 2, 3。分别表示三种不同的DCT域信息隐藏方法
    if(mode <= 0 || mode >= 4)
        error('Mode error.');
    end
    
    if(nargin < 6)
        %载入数据
        table = load('JpegCoeff.mat');
        ACTAB = table.ACTAB; 
        DCTAB = table.DCTAB; 
        QTAB = table.QTAB;
    end
    addpath(genpath('..\'));
    
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
    
    %二进制信息
    infoBits = 8 * numel(info); 
    binInfo = reshape( dec2bin(info, 8)', 1, [] );
    
    %替换每个DCT最低位
    if(mode == 1)
        %插入信息
        flatMat = flatMat';
        %DCT转化为二进制补码
        binDCT = dec2cmp(flatMat(1:infoBits), 13);
        binDCT(1 : infoBits, end) = binInfo;
        flatMat(1:infoBits) = cmp2dec(binDCT, 13);
        flatMat = flatMat';
        
        %编码
        quantDC = flatMat(:, 1)';
        codeDC = encodeDC(quantDC, DCTAB);
    
        quantAC = flatMat(:, 2:end);
        codeAC = encodeAC(quantAC, ACTAB);
        
        return
    end
    
    %替换每个block的DCT的后5个分量
    if(mode == 2)
        infoBlockNum = ceil(infoBits / 5);
        binDCT = dec2cmp( flatMat(1 : infoBlockNum, end - 4 : end)', 13);
        binDCT(1 : infoBits, end) = binInfo;
        flatMat(1 : infoBlockNum, end - 4 : end) = reshape(cmp2dec(binDCT, 13), 5, [])';
        
        %编码
        quantDC = flatMat(:, 1)';
        codeDC = encodeDC(quantDC, DCTAB);
    
        quantAC = flatMat(:, 2:end);
        codeAC = encodeAC(quantAC, ACTAB);
        
        return
    end
    
    if(mode == 3)
        %找到每个block最后一个非零系数. 如果block最后一个分量非0，则将信息bit添加到该分量
        f = @(blockArray)(find(blockArray, 1, 'last'));
        zeroIndex = cellfun(f, num2cell(flatMat(1:infoBits, :), 2));
        g = @(indice)(mod(indice, 64) + floor(indice/64)*63 + 1);
        zeroIndex = arrayfun(g, zeroIndex);
        
        %转化为1，-1序列
        newBinInfo = (str2num(binInfo')'* 2 - 1);
        
        for i = 1:infoBits
            flatMat(i, zeroIndex(i)) = newBinInfo(i);
        end
        
        %编码
        quantDC = flatMat(:, 1)';
        codeDC = encodeDC(quantDC, DCTAB);
    
        quantAC = flatMat(:, 2:end);
        codeAC = encodeAC(quantAC, ACTAB);
        
        return
    end
end
