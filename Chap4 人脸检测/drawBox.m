function drawBox(img, boundingBox)
%绘制有矩形框的图片, 并显示
 lineWidth = 2;
 
 boxNum = size(boundingBox, 2);
 
    for i = 1:boxNum
        box = boundingBox{i};
        img(box(1):box(1)+box(3), box(2):box(2)+lineWidth, 1) = 255;
        img(box(1):box(1)+box(3), box(2)+box(4):box(2)+box(4)+lineWidth, 1) = 255;
        img(box(1):box(1)+lineWidth, box(2):box(2)+box(4), 1) = 255;
        img(box(1)+box(3):box(1)+box(3)+lineWidth, box(2):box(2)+box(4), 1) = 255;
        img(box(1):box(1)+box(3), box(2):box(2)+lineWidth, 2) = 0;
        img(box(1):box(1)+box(3), box(2)+box(4):box(2)+box(4)+lineWidth, 2) = 0;
        img(box(1):box(1)+lineWidth, box(2):box(2)+box(4), 2) = 0;
        img(box(1)+box(3):box(1)+box(3)+lineWidth, box(2):box(2)+box(4), 2) = 0;
        img(box(1):box(1)+box(3), box(2):box(2)+lineWidth, 3) = 0;
        img(box(1):box(1)+box(3), box(2)+box(4):box(2)+box(4)+lineWidth, 3) = 0;
        img(box(1):box(1)+lineWidth, box(2):box(2)+box(4), 3) = 0;
        img(box(1)+box(3):box(1)+box(3)+lineWidth, box(2):box(2)+box(4), 3) = 0;
    end
    figure; imshow(img);
end
