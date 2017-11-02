function info = DCTInfoExtract(imgHeight, imgWidth, codeDC, codeAC, infoBits, mode, DCTAB, ACTAB)
%mode = 1, 2, 3。分别表示三种不同的DCT域信息隐藏方法
    if(mode <= 0 || mode >= 4)
        error('Mode error.');
    end
    
    if(nargin < 8)
        %载入数据
        table = load('JpegCoeff.mat');
        ACTAB = table.ACTAB; 
        DCTAB = table.DCTAB; 
    end
    addpath(genpath('..\'));
    
     %初始化
    extImgSize = ceil([imgHeight, imgWidth] / 8) * 8;
    blockNum = prod(extImgSize / 8);
    
    %解码
    quantDC = decodeDC(blockNum, codeDC, DCTAB);
    quantAC = decodeAC(blockNum, codeAC, ACTAB);
    flatMat = horzcat(quantDC', quantAC);
    
    %替换每个DCT最低位
    if(mode == 1)
        flatMat = flatMat';
        binDCT = dec2cmp(flatMat(1:infoBits), 13);
        binInfo = binDCT(1 : infoBits, end);
        info = char( bin2dec(reshape(binInfo, 8, [])') )';
        return
    end
    
    %替换每个block的DCT的后5个分量
    if(mode == 2)
        infoBlockNum = ceil(infoBits / 5);
        binDCT = dec2cmp( flatMat(1 : infoBlockNum, end - 4 : end)', 13);
        binInfo = binDCT(1 : infoBits, end);
        info = char( bin2dec(reshape(binInfo, 8, [])') )';
        
        return
    end
    
    if(mode == 3)
        f = @(blockArray)(find(blockArray, 1, 'last'));
        infoBitsIndex = cellfun(f, num2cell(flatMat(1:infoBits, :), 2));
        binInfo = zeros([infoBits, 1], 'uint8');
        
        for i = 1:infoBits
            binInfo(i) = (flatMat(i, infoBitsIndex(i)) + 1)/2;
        end
        binInfo = num2str(binInfo);
        
        info = char( bin2dec(reshape(binInfo, 8, [])') )';
        
        return
    end

end
