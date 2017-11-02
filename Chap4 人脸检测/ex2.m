clear all;
addpath(genpath('../'));

testImg = imread('sample.jpg');

%训练模型
%L = 3时
model1 = faceTrain('Faces/', 3);
boundingBox1 = faceDetect(testImg, model1);
drawBox(testImg, boundingBox1); title('L = 3, threshold = 0.3');

boundingBox1 = faceDetect(testImg, model1, 0.26);
drawBox(testImg, boundingBox1); title('L = 3, threshold = 0.26');

%L = 4时
model2 = faceTrain('Faces/', 4);
boundingBox2 = faceDetect(testImg, model2);
drawBox(testImg, boundingBox2); title('L = 4, threshold = 0.3');

boundingBox2 = faceDetect(testImg, model2, 0.35);
drawBox(testImg, boundingBox2); title('L = 4, threshold = 0.35');


%L = 5时
model3 = faceTrain('Faces/', 5);
boundingBox3 = faceDetect(testImg, model3);
drawBox(testImg, boundingBox3); title('L = 5');

