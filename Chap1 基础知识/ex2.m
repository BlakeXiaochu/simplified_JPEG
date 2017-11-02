%(a)
img = load('hall.mat');
colorImg = img.hall_color;
%����Բ�뾶
imgSize = size(colorImg);
rad = min(imgSize(1:2)) / 2;

x = [1 : imgSize(1)]';   %#ok<*NBRAK>
x = repmat(x, [1, imgSize(2)]);
y = [1 : imgSize(2)];
y = repmat(y, [imgSize(1), 1]);
%����Բ����
circleRegion = ((x - imgSize(1)/2).^2 + (y - imgSize(2)/2).^2) <= rad^2;
R = colorImg(:, :, 1); G = colorImg(:, :, 2); B = colorImg(:, :, 3);
R(circleRegion) = 255;
G(circleRegion) = 0; B(circleRegion) = 0;
colorImg(:, :, 1) = R; colorImg(:, :, 2) = G; colorImg(:, :, 3) = B;
%��ʾͼƬ
figure, imshow(colorImg);


%(b)
%�ڰ׸���(������)
Stride = 10;
colorImg = img.hall_color;
%����ڰ׸�����(����mod����������������ƣ��������Ƶġ���򡱼���ڰ׸�)
blockRegion = xor((mod(x, Stride*2) < Stride), (mod(y, Stride*2) < Stride));
R = colorImg(:, :, 1); G = colorImg(:, :, 2); B = colorImg(:, :, 3);
R(blockRegion) = 0; G(blockRegion) = 0; B(blockRegion) = 0;
colorImg(:, :, 1) = R; colorImg(:, :, 2) = G; colorImg(:, :, 3) = B;
%��ʾͼƬ
figure, imshow(colorImg);