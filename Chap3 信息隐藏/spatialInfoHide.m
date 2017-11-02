%�ռ�����Ϣ����
function [imgWithInfo, infoBits] = spatialInfoHide(img, info)
    %���ش�����Ϣ(�ַ���)��ͼƬ����������Ϣ��bit��
    assert(ischar(info));
    addpath(genpath('..\'));
    
    imgSize = size(img);
    infoBits = 8 * numel(info);
    %��Ҫ���㹻�Ŀռ�����
    assert(numel(img) > infoBits);
    
    binImg = dec2bin(img', 8);
    binInfo = reshape( dec2bin(info, 8)', 1, [] );
    
    %����������Ϣ �� ���ط������λ
    binImg(1 : infoBits, end) = binInfo;
    
    %��������ͼƬ
    imgWithInfo = reshape( bin2dec(binImg) , imgSize(2), imgSize(1))';
    imgWithInfo = uint8(imgWithInfo);
end
