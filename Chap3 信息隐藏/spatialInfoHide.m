%空间域信息隐藏
function [imgWithInfo, infoBits] = spatialInfoHide(img, info)
    %返回带有信息(字符串)的图片，和隐藏信息的bit数
    assert(ischar(info));
    addpath(genpath('..\'));
    
    imgSize = size(img);
    infoBits = 8 * numel(info);
    %需要有足够的空间隐藏
    assert(numel(img) > infoBits);
    
    binImg = dec2bin(img', 8);
    binInfo = reshape( dec2bin(info, 8)', 1, [] );
    
    %插入隐藏信息 至 像素分量最低位
    binImg(1 : infoBits, end) = binInfo;
    
    %重新生成图片
    imgWithInfo = reshape( bin2dec(binImg) , imgSize(2), imgSize(1))';
    imgWithInfo = uint8(imgWithInfo);
end
