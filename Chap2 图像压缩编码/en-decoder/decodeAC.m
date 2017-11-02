%AC����
function [quantAC, treeAC] = decodeAC(blockNum, codeAC, ACTAB)
    treeAC = decodeACTree(ACTAB);
    quantAC = huffmanDecodeAC(blockNum, uint8(codeAC), treeAC);
    %cpp��matlab�ж�ά���黥Ϊת��
    quantAC = quantAC';
end

%����AC����Ķ�����
function treeAC = decodeACTree(ACTAB)
    %��ʼ��
    treeDepth = ACTAB(:, 3);
    treeMaxDepth = max(treeDepth) + 1;
    treeSize = 2^treeMaxDepth - 1;
    treeAC = -ones([1, treeSize], 'int32');
    
    %�ڵ��������ͬ��ȵĵ�һ���ڵ��ƫ����
    f = @(depth, ACTAB) (bin2dec(num2str(ACTAB(4 : depth + 3)')'));
    offset = cellfun(f, num2cell(treeDepth), num2cell(ACTAB, 2));
    
    %����ÿ������Ľڵ��(0 ~ 2^n - 2)
    nodeId = 2 .^ treeDepth - 1 + offset;
    treeAC(nodeId + 1) = [1:160]; %#ok<*NBRAK>
    
    %ZRL
    treeAC(2^11 + 2041) = 161;
    %EOB
    treeAC(2^4 + 10) = 0;
end