clear all;
%��������
img = load('hall.mat');
grayImg = double(img.hall_gray);

%ѡȡ���8 x 8����
pos = round( rand(1) * (min(size(grayImg)) - 8) ) + 1;
testRegion = grayImg(pos : pos + 7, pos : pos + 7);

%�Ҳ�4������
coff = dct2(testRegion);
coff(end - 3 : end) = 0;
newRegion1 = idct2(coff);
%���4������
coff = dct2(testRegion);
coff(1:4) = 0;
newRegion2 = idct2(coff);

%�Ա�ͼ��
figure;
subplot(1, 3, 1); imshow(uint8(testRegion)); title('ԭͼ');
subplot(1, 3, 2); imshow(uint8(newRegion1)); title('�Ҳ�4������');
subplot(1, 3, 3); imshow(uint8(newRegion2)); title('���4������');

