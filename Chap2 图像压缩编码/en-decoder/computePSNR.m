function PSNR = computePSNR(img1, img2)
    %图片大小必须相同
    assert( all(size(img1) == size(img2)) );
    
    %计算MSE
    pixelNum = numel(img1);
    MSE = sum(sum( (img1 - img2).^2 )) / pixelNum;
    
    PSNR = 20 * log10(255) - 10 * log10(MSE);
end