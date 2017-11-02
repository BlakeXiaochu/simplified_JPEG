%空间域信息提取
function info = spatialInfoExtract(imgWithInfo, infoBits)
    addpath(genpath('..\'));
    binImg = dec2bin(imgWithInfo', 8);
    binInfo = binImg(1 : infoBits, end);
    info = char( bin2dec(reshape(binInfo, 8, [])') )';
end

