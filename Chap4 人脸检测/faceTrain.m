function model = faceTrain(path, L)
    %ѵ��ģ��, ������ÿ����ɫ��������Lλbit
    files = dir(path);
    
    imgNum = 0;
    colorFtr = zeros([1, 2^(L*3)], 'double');
    for i = 1 : size(files, 1)
        file = files(i);
        fileName = file.name;
        fileExt = strsplit(fileName, '.');
        fileExt = fileExt{end};

        %ͼƬ
        if(isequal(fileExt, 'bmp') && ~file.isdir)
            imgNum = imgNum + 1;
            img = imread([path, '\', fileName]);
            
            %������ÿ����ɫ��������Lλbit
            colorFtr = colorFtr + computeFeature(img, L);
        end
    end
    
    model = colorFtr / imgNum;
end
