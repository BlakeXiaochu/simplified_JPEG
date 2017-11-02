%AC解码
function [quantAC, treeAC] = decodeAC(blockNum, codeAC, ACTAB)
    treeAC = decodeACTree(ACTAB);
    quantAC = huffmanDecodeAC(blockNum, uint8(codeAC), treeAC);
    %cpp与matlab中二维数组互为转置
    quantAC = quantAC';
end

%生成AC解码的二叉树
function treeAC = decodeACTree(ACTAB)
    %初始化
    treeDepth = ACTAB(:, 3);
    treeMaxDepth = max(treeDepth) + 1;
    treeSize = 2^treeMaxDepth - 1;
    treeAC = -ones([1, treeSize], 'int32');
    
    %节点相对于相同深度的第一个节点的偏移量
    f = @(depth, ACTAB) (bin2dec(num2str(ACTAB(4 : depth + 3)')'));
    offset = cellfun(f, num2cell(treeDepth), num2cell(ACTAB, 2));
    
    %计算每个编码的节点号(0 ~ 2^n - 2)
    nodeId = 2 .^ treeDepth - 1 + offset;
    treeAC(nodeId + 1) = [1:160]; %#ok<*NBRAK>
    
    %ZRL
    treeAC(2^11 + 2041) = 161;
    %EOB
    treeAC(2^4 + 10) = 0;
end