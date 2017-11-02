clear all;
%载入数据
img = load('hall.mat');
grayImg = double(img.hall_gray);

%选取随机8 x 8区域
pos = round( rand(1) * (min(size(grayImg)) - 8) ) + 1;
testRegion = grayImg(pos : pos + 7, pos : pos + 7);

%右侧4列置零
coff = dct2(testRegion);
coff(end - 3 : end) = 0;
newRegion1 = idct2(coff);
%左侧4列置零
coff = dct2(testRegion);
coff(1:4) = 0;
newRegion2 = idct2(coff);

%对比图像
figure;
subplot(1, 3, 1); imshow(uint8(testRegion)); title('原图');
subplot(1, 3, 2); imshow(uint8(newRegion1)); title('右侧4列置零');
subplot(1, 3, 3); imshow(uint8(newRegion2)); title('左侧4列置零');

