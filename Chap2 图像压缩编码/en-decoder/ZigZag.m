function [flatArray, ZigZagIndex] = ZigZag(block, mode)
%   ����8 x 8��block, ��ɨ���ģʽmode����ͬɨ�跽��, ��ȡֵ0, 1, 2�� 
%   ������ZigZagɨ��õ���һά����flatArray
    if(nargin == 1) 
        mode = 0; 
    end

    %ǿ��Ϊ����
    blockSize = size(block);
    assert( blockSize(1) == blockSize(2) );
    blockSize = blockSize(1);
    
    %���� ��ȡ�������� ɨ��
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
    
    %���� ������������ ɨ��
    if(mode == 1)
        ZigZagIndex = indexGen(blockSize);
        flatArray = block(ZigZagIndex);
        
        %������������
        fileName = [pwd, '\ZigZagIndex', int2str(blockSize), '.mat'];
        if(~exist(fileName, 'file'))
            save(fileName, 'ZigZagIndex');
        end
        return
    end
    

    %���� ѭ�� ɨ��
    if(mode == 2)
        flatArray = zeros([1, blockSize^2]);
        ZigZagIndex = zeros([1, blockSize^2]);
        %���ڼ�¼ɨ�跽��(flagΪ1��������������ɨ�裬�����෴)����ɨ�����
        flag = 1; pos = 1;
        
        %ɨ�����ϲ���
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
        
        %ɨ�����²���
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

%����������������
function ZigZagIndex = indexGen(blockSize)
    %blockSizeΪɨ�跽��Ĵ�С
    coorX = [1:blockSize]'; coorX = repmat(coorX, [1, blockSize]); %#ok<*NBRAK>
    coorY = [1:blockSize] ; coorY = repmat(coorY, [blockSize, 1]);
    coorSum = coorX + coorY;
    %���ڼ�¼ɨ�跽��(scanDrtΪ1��������������ɨ�裬�����෴)
    scanDrt = ~mod(coorSum, 2);
    f1 = @(sum, x)( (sum - 1).*(sum - 2)/2 + x );
    f2 = @(sum, x)( sum .* (sum + 1)/2 + x);
    %����ɨ�����ϲ���ÿ��Ԫ�ر�������˳��
    ZigZagIndex1 = (coorSum <= (blockSize + 1)) .* ...
    ( f1(coorSum, coorX) .* ~scanDrt + f1(coorSum, coorY) .* scanDrt );
    %����ɨ�����²���ÿ��Ԫ�ر�������˳��
    ZigZagIndex2 = (coorSum > (blockSize + 1)) .* ...
    ( (blockSize^2 - f2(2*blockSize+1-coorSum, coorX - blockSize - 1)) .* scanDrt + ...
    (blockSize^2 - f2(2*blockSize+1-coorSum, coorY - blockSize - 1)) .* ~scanDrt );

    [~, ZigZagIndex] = sort(reshape((ZigZagIndex1 + ZigZagIndex2), 1, []));
    return
end

