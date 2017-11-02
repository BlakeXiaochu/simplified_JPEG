function boundingBox = faceDetect(img, model, thr, stride, maxScale)
    %对输入图像进行人脸检测, 返回人脸边框. stride为检测窗每次移动的像素
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
    
    %最小检测窗大小
    minWinSize = [60 60];
    scale = 1;
    imgSize = size(img);
    
    while(true)
        %缩放检测窗, 以检测不同尺度的人脸
        if(scale > maxScale) break; end
        winSize = round(minWinSize * scale);
        
        %移动检测窗
        posX = 1;
        while(true)
            if(posX + winSize(1) > imgSize(1)) break; end
            
            posY = 1;
            while(true)
                if(posY + winSize(2) > imgSize(2)) break; end
                
                %检测
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

