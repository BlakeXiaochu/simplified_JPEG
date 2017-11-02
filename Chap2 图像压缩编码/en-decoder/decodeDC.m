%DC解码
function [quantDC, treeDC] =  decodeDC(blockNum, codeDC, DCTAB)
    treeDC = decodeDCTree(DCTAB);
    diffDC = huffmanDecodeDC(blockNum, uint8(codeDC), treeDC);
    %通过与差分系统的逆系统样值响应,卷积得到原序列
    diffDC(1) = -diffDC(1);
    quantDC = conv( double(diffDC), -ones([1, size(diffDC, 2)]) );
    quantDC = int32( quantDC(1 : size(diffDC, 2)) );
end

%生成DC解码的二叉树
function treeDC = decodeDCTree(DCTAB)
    %初始化
    treeDepth = DCTAB(:, 1);
    treeMaxDepth = max(treeDepth) + 1;
    treeSize = 2^treeMaxDepth - 1;
    treeDC = -ones([1, treeSize], 'int32');
    
    %节点相对于相同深度的第一个节点的偏移量
    f = @(depth, DCTAB) (bin2dec(num2str(DCTAB(2 : depth + 1)')'));
    offset = cellfun(f, num2cell(treeDepth), num2cell(DCTAB, 2));
    
    %计算每个编码的节点号(0 ~ 2^n - 2)
    nodeId = 2 .^ treeDepth - 1 + offset;
    treeDC(nodeId + 1) = [0 : 11]; %#ok<*NBRAK>
end

