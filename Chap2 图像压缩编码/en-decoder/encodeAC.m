%AC����(�Զ���array)
function codeAC = encodeAC(AC, ACTAB) 
    %����size
    Size = floor( log2(abs(AC)) ) + 1;
    Size(isinf(Size)) = 0;
    
    %��ȡ��Ч��run, size, AC ampitude
    Run = cellfun(@computeRun, num2cell(Size, 2), 'UniformOutput', 0);
    f = @(array) (array(array ~= 0));
    Size = cellfun(f, num2cell(Size, 2), 'UniformOutput', 0);
    ampAC = cellfun(f, num2cell(AC, 2), 'UniformOutput', 0);
    
    %�������
    %��ÿһλ����
    f = @(Run, Size, ampAC)([encodeRunSize(Run, Size, ACTAB), encodeAmp(ampAC)]);
    %��ÿһ��(һ�д���һ��block������cell���飬����ÿ��Ԫ�ش���һλ�ı���01����)
    g = @(Run, Size, ampAC) arrayfun(f, Run, Size, ampAC, 'UniformOutput', 0);
    codeAC = cellfun(g, Run, Size, ampAC, 'UniformOutput', 0);
    %��ÿһ��ƴ�ӳ������ı���
    function code = h(codeCell)
        num = numel(codeCell);
        totalLen = 0;
        pos = 1;
        for i = 1:num
            totalLen = totalLen + size(codeCell{i}, 2);
        end
        code = zeros([1, totalLen + 4], 'logical');
        for i = 1:num
            Len = size(codeCell{i}, 2);
            code(pos : pos - 1 + Len) = codeCell{i};
            pos = pos + Len;
        end
        code(end - 3 : end) = [1 0 1 0];
    end

    codeAC = cellfun(@h, codeAC, 'UniformOutput', 0)';
    
    %�����п�ƴ�ӳ������ı���
    ACLen = 0;
    ACPos = 1;
    for k = 1 : numel(codeAC)
        ACLen = ACLen + size(codeAC{k}, 2);
    end
    code = zeros([1, ACLen], 'logical');
    for k = 1 : numel(codeAC)
        L = size(codeAC{k}, 2);
        code(ACPos : ACPos - 1 + L) = codeAC{k};
        ACPos = ACPos + L;
    end
    codeAC = code;
end

%�Ե���AC����(����)���б���
function codeMag = encodeAmp(magDC)
    if(magDC >= 0)
        binStr = dec2bin(magDC);
        codeMag = (str2num(binStr(:))' == 1);
    else
        binStr = dec2bin(-magDC);
        codeMag = ~(str2num(binStr(:))' == 1);
    end
end

%�����г�run(��һάarray)
function run = computeRun(AC)
    zero = (AC == 0);
    zeroCumNum = cumsum(zero);
    run = zeroCumNum(AC ~= 0);
    run = run - [0, run(1 : end - 1)];
end

%�� һ��(run/size)�� ���б���
function codeRunSize = encodeRunSize(run, size, ACTAB)
    if(run <= 15)
        codeRunSize = ACTAB(run * 10 + size, :);
        bitLen = codeRunSize(3);
        codeRunSize = (codeRunSize(4 : 3 + bitLen) == 1);
    else
        num = floor(run/16);
        codeRunSize = ACTAB((run - num*16) * 10 + size, :);
        bitLen = codeRunSize(3);
        ZRL = [1 1 1 1 1 1 1 1 0 0 1];
        codeRunSize = [repmat(ZRL, [1, num]), codeRunSize(4 : 3 + bitLen)];
        codeRunSize = (codeRunSize == 1);
    end
end