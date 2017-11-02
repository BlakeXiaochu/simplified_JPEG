function boundingBox = faceDetect(img, model, thr, stride, maxScale)
    %������ͼ������������, ���������߿�. strideΪ��ⴰÿ���ƶ�������
    if(nargin < 3)
        thr = 0.3;
    end
    if(nargin < 4)
        stride = 30;
    end
    if(nargin < 5)
        maxScale = 2;
    end
    L = round(log2(size(model, 2)) / 3);
    boundingBox = {};
    boxNum = 0;
    
    %��С��ⴰ��С
    minWinSize = [60 60];
    scale = 1;
    imgSize = size(img);
    
    while(true)
        %���ż�ⴰ, �Լ�ⲻͬ�߶ȵ�����
        if(scale > maxScale) break; end
        winSize = round(minWinSize * scale);
        
        %�ƶ���ⴰ
        posX = 1;
        while(true)
            if(posX + winSize(1) > imgSize(1)) break; end
            
            posY = 1;
            while(true)
                if(posY + winSize(2) > imgSize(2)) break; end
                
                %���
                imgRegion = img(posX : posX + winSize(1), posY : posY + winSize(2), :);
                colorFtr = computeFeature(imgRegion, L);
                confidence = computeAngle(model, colorFtr);
                
                if(1 - confidence < thr)
                    boxNum = boxNum + 1;
                    boundingBox{boxNum} = [posX, posY, winSize, confidence];
                end
                
                posY = posY + stride;
            end
            posX = posX + stride;
        end
        
        scale = scale * 2^(1/2);
    end
end

