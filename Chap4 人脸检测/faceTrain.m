function model = faceTrain(path, L)
    %训练模型, 仅计算每个颜色分类的最高L位bit
    files = dir(path);
    
    imgNum = 0;
    colorFtr = zeros([1, 2^(L*3)], 'double');
    for i = 1 : size(files, 1)
        file = files(i);
        fileName = file.name;
        fileExt = strsplit(fileName, '.');
        fileExt = fileExt{end};

        %图片
        if(isequal(fileExt, 'bmp') && ~file.isdir)
            imgNum = imgNum + 1;
            img = imread([path, '\', fileName]);
            
            %仅计算每个颜色分类的最高L位bit
            colorFtr = colorFtr + computeFeature(img, L);
        end
    end
    
    model = colorFtr / imgNum;
end
