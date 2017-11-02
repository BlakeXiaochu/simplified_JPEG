%计算人脸的颜色特征. 仅计算每个颜色分类的最高L位bit
function colorFtr = computeFeature(img, L)
    R = img(:, :, 1);
    G = img(:, :, 2);
    B = img(:, :, 3);
    
    %取高L位bit
    R = double( bitshift(R, -(8 - L)) );
    G = double( bitshift(G, -(8 - L)) );
    B = double( bitshift(B, -(8 - L)) );
    RGB = R * 2^(L*2) + G * 2^L + B;
    
    %计算特征
    binEdge = [0 : 2^(L * 3)];
    bins = histcounts(RGB(:), binEdge);
    colorFtr = double(bins) / (numel(img)/3);
end

