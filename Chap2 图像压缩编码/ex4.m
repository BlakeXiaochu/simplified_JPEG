clear all;
%��������
img = load('hall.mat');
grayImg = double(img.hall_gray);

%ѡȡ���8 x 8����
pos = round( rand(1) * (min(size(grayImg)) - 8) ) + 1;
testRegion = grayImg(pos : pos + 7, pos : pos + 7);

%DCT
coff = dct2(testRegion);
%ת��
newRegion1 = idct2( coff' );
%��ת90����180��
newRegion2 = idct2(rot90(coff));
newRegion3 = idct2(rot90(coff, 2));

%�Ա�ͼ��
figure;
subplot(2, 2, 1); imshow(uint8(testRegion)); title('Origin image');
subplot(2, 2, 2); imshow(uint8(newRegion1)); title('Transpose');
subplot(2, 2, 3); imshow(uint8(newRegion2)); title('Rotate 90 degree');
subplot(2, 2, 4); imshow(uint8(newRegion3)); title('Rotate 180 degree');