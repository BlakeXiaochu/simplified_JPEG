%DCT����Ϣ����
function [imgHeight, imgWidth, codeDC, codeAC, infoBits] = DCTInfoHide(img, info, mode, QTAB, DCTAB, ACTAB)
    %mode = 1, 2, 3���ֱ��ʾ���ֲ�ͬ��DCT����Ϣ���ط���
    if(mode <= 0 || mode >= 4)
        error('Mode error.');
    end
    
    if(nargin < 6)
        %��������
        table = load('JpegCoeff.mat');
        ACTAB = table.ACTAB; 
        DCTAB = table.DCTAB; 
        QTAB = table.QTAB;
    end
    addpath(genpath('..\'));
    
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
    
    %��������Ϣ
    infoBits = 8 * numel(info); 
    binInfo = reshape( dec2bin(info, 8)', 1, [] );
    
    %�滻ÿ��DCT���λ
    if(mode == 1)
        %������Ϣ
        flatMat = flatMat';
        %DCTת��Ϊ�����Ʋ���
        binDCT = dec2cmp(flatMat(1:infoBits), 13);
        binDCT(1 : infoBits, end) = binInfo;
        flatMat(1:infoBits) = cmp2dec(binDCT, 13);
        flatMat = flatMat';
        
        %����
        quantDC = flatMat(:, 1)';
        codeDC = encodeDC(quantDC, DCTAB);
    
        quantAC = flatMat(:, 2:end);
        codeAC = encodeAC(quantAC, ACTAB);
        
        return
    end
    
    %�滻ÿ��block��DCT�ĺ�5������
    if(mode == 2)
        infoBlockNum = ceil(infoBits / 5);
        binDCT = dec2cmp( flatMat(1 : infoBlockNum, end - 4 : end)', 13);
        binDCT(1 : infoBits, end) = binInfo;
        flatMat(1 : infoBlockNum, end - 4 : end) = reshape(cmp2dec(binDCT, 13), 5, [])';
        
        %����
        quantDC = flatMat(:, 1)';
        codeDC = encodeDC(quantDC, DCTAB);
    
        quantAC = flatMat(:, 2:end);
        codeAC = encodeAC(quantAC, ACTAB);
        
        return
    end
    
    if(mode == 3)
        %�ҵ�ÿ��block���һ������ϵ��. ���block���һ��������0������Ϣbit��ӵ��÷���
        f = @(blockArray)(find(blockArray, 1, 'last'));
        zeroIndex = cellfun(f, num2cell(flatMat(1:infoBits, :), 2));
        g = @(indice)(mod(indice, 64) + floor(indice/64)*63 + 1);
        zeroIndex = arrayfun(g, zeroIndex);
        
        %ת��Ϊ1��-1����
        newBinInfo = (str2num(binInfo')'* 2 - 1);
        
        for i = 1:infoBits
            flatMat(i, zeroIndex(i)) = newBinInfo(i);
        end
        
        %����
        quantDC = flatMat(:, 1)';
        codeDC = encodeDC(quantDC, DCTAB);
    
        quantAC = flatMat(:, 2:end);
        codeAC = encodeAC(quantAC, ACTAB);
        
        return
    end
end
