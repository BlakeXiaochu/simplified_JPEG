function [flatArray, ZigZagIndex] = ZigZag(block, mode)
%   输入8 x 8的block, 和扫描的模式mode（不同扫描方法, 可取值0, 1, 2） 
%   生成有ZigZag扫描得到的一维序列flatArray
    if(nargin == 1) 
        mode = 0; 
    end

    %强制为方阵
    blockSize = size(block);
    assert( blockSize(1) == blockSize(2) );
    blockSize = blockSize(1);
    
    %采用 读取索引数组 扫描
    if(mode == 0)
        fileName = [pwd, '\ZigZagIndex', int2str(blockSize), '.mat'];
        if(exist(fileName, 'file'))
            load(fileName, 'ZigZagIndex');
            flatArray = block(ZigZagIndex);
            return
        else
            ZigZagIndex = indexGen(blockSize);
            flatArray = block(ZigZagIndex);
            save(fileName, 'ZigZagIndex');
            return
        end
    end
    
    %采用 构建数组索引 扫描
    if(mode == 1)
        ZigZagIndex = indexGen(blockSize);
        flatArray = block(ZigZagIndex);
        
        %保存索引数组
        fileName = [pwd, '\ZigZagIndex', int2str(blockSize), '.mat'];
        if(~exist(fileName, 'file'))
            save(fileName, 'ZigZagIndex');
        end
        return
    end
    

    %采用 循环 扫描
    if(mode == 2)
        flatArray = zeros([1, blockSize^2]);
        ZigZagIndex = zeros([1, blockSize^2]);
        %用于记录扫描方向(flag为1，从左下往右上扫描，否则相反)和已扫描点数
        flag = 1; pos = 1;
        
        %扫描左上部分
        for i = 2 : (blockSize + 1)
            for j = 1 : (i - 1)
                if(flag == 1)
                    flatArray(pos) = block(i - j, j);
                    ZigZagIndex(pos) = (j-1)*blockSize + i - j;
                else
                    flatArray(pos) = block(j, i - j);
                    ZigZagIndex(pos) = (i-j-1)*blockSize + j;
                end
                pos = pos + 1;
            end 
            flag = -flag;
        end
        
        %扫描右下部分
        for i = (blockSize + 2) : (2 * blockSize)
            for j = (i - blockSize) : blockSize
                if(flag == 1)
                    flatArray(pos) = block(i - j, j);
                    ZigZagIndex(pos) = (j-1)*blockSize + i - j;
                else
                    flatArray(pos) = block(j, i - j);
                    ZigZagIndex(pos) = (i-j-1)*blockSize + j;
                end
                pos = pos + 1;
            end
            flag = -flag;
        end
        
        return
    end
end

%用于生成索引数组
function ZigZagIndex = indexGen(blockSize)
    %blockSize为扫描方块的大小
    coorX = [1:blockSize]'; coorX = repmat(coorX, [1, blockSize]); %#ok<*NBRAK>
    coorY = [1:blockSize] ; coorY = repmat(coorY, [blockSize, 1]);
    coorSum = coorX + coorY;
    %用于记录扫描方向(scanDrt为1，从左下往右上扫描，否则相反)
    scanDrt = ~mod(coorSum, 2);
    f1 = @(sum, x)( (sum - 1).*(sum - 2)/2 + x );
    f2 = @(sum, x)( sum .* (sum + 1)/2 + x);
    %生成扫描左上部分每个元素被索引的顺序
    ZigZagIndex1 = (coorSum <= (blockSize + 1)) .* ...
    ( f1(coorSum, coorX) .* ~scanDrt + f1(coorSum, coorY) .* scanDrt );
    %生成扫描右下部分每个元素被索引的顺序
    ZigZagIndex2 = (coorSum > (blockSize + 1)) .* ...
    ( (blockSize^2 - f2(2*blockSize+1-coorSum, coorX - blockSize - 1)) .* scanDrt + ...
    (blockSize^2 - f2(2*blockSize+1-coorSum, coorY - blockSize - 1)) .* ~scanDrt );

    [~, ZigZagIndex] = sort(reshape((ZigZagIndex1 + ZigZagIndex2), 1, []));
    return
end

