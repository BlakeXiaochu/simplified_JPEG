clear all;
%载入数据
img = load('hall.mat');
grayImg = double(img.hall_gray);

%选取随机8 x 8区域
pos = round( rand(1) * (min(size(grayImg)) - 8) ) + 1;
testRegion = grayImg(pos : pos + 7, pos : pos + 7);

%DCT
coff = dct2(testRegion);
%转置
newRegion1 = idct2( coff' );
%旋转90度与180度
newRegion2 = idct2(rot90(coff));
newRegion3 = idct2(rot90(coff, 2));

%对比图像
figure;
subplot(2, 2, 1); imshow(uint8(testRegion)); title('Origin image');
subplot(2, 2, 2); imshow(uint8(newRegion1)); title('Transpose');
subplot(2, 2, 3); imshow(uint8(newRegion2)); title('Rotate 90 degree');
subplot(2, 2, 4); imshow(uint8(newRegion3)); title('Rotate 180 degree');