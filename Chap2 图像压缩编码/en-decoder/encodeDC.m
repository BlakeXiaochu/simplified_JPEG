%DC分量编码
function codeDC = encodeDC(DC, DCTAB)
    %DC差分
    diffDC = -[DC, 0] + [0, DC];
    diffDC = diffDC(1 : end - 1);
    diffDC(1) = -diffDC(1);

    %预测误差分类
    category = floor( log2(abs(diffDC)) ) + 1;
    category(isinf(category)) = 0;
    
    %得到每个分量的编码
    bitLen = num2cell( DCTAB(category + 1, 1) )';
    DCTAB = num2cell(DCTAB(category + 1, :), 2)';
    magDC = num2cell(diffDC);
    
    %转换为包含逻辑数组（每个元素为1个bit）的cell数组
    f = @(bitLen, DCTAB, magDC) ([DCTAB(2 : bitLen + 1) == 1, encodeMag(magDC)]);
    codeDC = cellfun(f, bitLen, DCTAB, magDC, 'UniformOutput', 0); 
    
    %拼接成完整的编码
    num = numel(codeDC);
    DCLen = 0;
    DCPos = 1;
    for i = 1:num
      DCLen = DCLen + size(codeDC{i}, 2);
    end
    code = zeros([1, DCLen], 'logical');
    for i = 1:num
       Len = size(codeDC{i}, 2);
       code(DCPos : DCPos - 1 + Len) = codeDC{i};
       DCPos = DCPos + Len;
    end

    codeDC = code;
end

%对单个DC幅度(标量)进行编码
function codeMag = encodeMag(magDC)
    if(magDC >= 0)
        binStr = dec2bin(magDC);
        codeMag = (str2num(binStr(:))' == 1);
    else
        binStr = dec2bin(-magDC);
        codeMag = ~(str2num(binStr(:))' == 1);
    end
end
