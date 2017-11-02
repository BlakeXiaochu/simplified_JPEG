clear all;
addpath(genpath('../'));

testImg = imread('sample.jpg');

%L = 4
model = faceTrain('Faces/', 4);

%旋转
testImg1 = imrotate(testImg, 90);
boundingBox1 = faceDetect(testImg1, model, 0.35);
drawBox(testImg1, boundingBox1); title('Rotate');

%拉伸
imgSize = size(testImg);
testImg2 = imresize(testImg, [imgSize(1), 2*imgSize(2)]);
boundingBox2 = faceDetect(testImg2, model, 0.35);
drawBox(testImg2, boundingBox2); title('Resize');

%改变颜色
testImg3 = imadjust(testImg, [.2 .3 0; .6 .7 1],[]);
boundingBox3 = faceDetect(testImg3, model, 0.35);
drawBox(testImg3, boundingBox3); title('Adjust');