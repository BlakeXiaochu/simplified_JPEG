%DC����
function [quantDC, treeDC] =  decodeDC(blockNum, codeDC, DCTAB)
    treeDC = decodeDCTree(DCTAB);
    diffDC = huffmanDecodeDC(blockNum, uint8(codeDC), treeDC);
    %ͨ������ϵͳ����ϵͳ��ֵ��Ӧ,����õ�ԭ����
    diffDC(1) = -diffDC(1);
    quantDC = conv( double(diffDC), -ones([1, size(diffDC, 2)]) );
    quantDC = int32( quantDC(1 : size(diffDC, 2)) );
end

%����DC����Ķ�����
function treeDC = decodeDCTree(DCTAB)
    %��ʼ��
    treeDepth = DCTAB(:, 1);
    treeMaxDepth = max(treeDepth) + 1;
    treeSize = 2^treeMaxDepth - 1;
    treeDC = -ones([1, treeSize], 'int32');
    
    %�ڵ��������ͬ��ȵĵ�һ���ڵ��ƫ����
    f = @(depth, DCTAB) (bin2dec(num2str(DCTAB(2 : depth + 1)')'));
    offset = cellfun(f, num2cell(treeDepth), num2cell(DCTAB, 2));
    
    %����ÿ������Ľڵ��(0 ~ 2^n - 2)
    nodeId = 2 .^ treeDepth - 1 + offset;
    treeDC(nodeId + 1) = [0 : 11]; %#ok<*NBRAK>
end

