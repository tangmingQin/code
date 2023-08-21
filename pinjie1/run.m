clc;
clear;
close all;
addpath('harris')
addpath('sift')


% % 按照顺序读取5副图像 中间 一前一后
imgc  = imread('DSC00228.JPG');
imgl1 =  imread('DSC00226.JPG');
imgr1 = imread('DSC00230.JPG');
imgl2 = imread('DSC00224.JPG');
imgr2 = imread('DSC00232.JPG');

% % 选择方法，1为sift 2为 Harris
method = 1;

% % sift 拼接
% sift_numberpoints = [];
% sift_rumtime = [];
% % 3 副图像
% [sift_img123,numberpoints1,rumtime1]= DoStitch(imgc,imgl1,imgr1,method,1);
% sift_numberpoints = [numberpoints1];
% sift_rumtime = [rumtime1];
% 
% sift_img123 = uint8(sift_img123*255);
% figure;imshow(sift_img123)
% imwrite(sift_img123, 'sift_img123.png');
% title('三幅图拼接结果')
% 
% % 5 副图像
% [sift_img12345,numberpoints2,rumtime2] = DoStitch(sift_img123,imgl2,imgr2,method,1);
% sift_numberpoints = [sift_numberpoints;numberpoints2];
% sift_rumtime = [sift_rumtime rumtime2];
% 
% sift_img12345 = uint8(sift_img12345*255);
% figure, imshow(sift_img12345);
% title('五幅图拼接结果')
% imwrite(sift_img12345, 'sift_img12345.png');

% % 选择方法，1为sift 2为 Harris
method = 2;

% % harris 拼接
harris_numberpoints = [];
harris_rumtime = [];
% 3 副图像
[harris_img123,numberpoints1,rumtime1]= DoStitch(imgc,imgl1,imgr1,method,1);
harris_numberpoints = [numberpoints1];
harris_rumtime = [rumtime1];

harris_img123 = uint8(harris_img123*255);
figure;imshow(harris_img123)
imwrite(harris_img123, 'harris_img123.png');
title('三幅图拼接结果')

% 5 副图像
[harris_img12345,numberpoints2,rumtime2] = DoStitch(harris_img123,imgl2,imgr2,method,1);
harris_numberpoints = [harris_numberpoints;numberpoints2];
harris_rumtime = [harris_rumtime rumtime2];

harris_img12345 = uint8(harris_img12345*255);
figure, imshow(harris_img12345);
title('五幅图拼接结果')
imwrite(harris_img12345, 'harris_img12345.png');

% % 特征点个数 匹配速度 信息量对比
% 计算信息熵
S_sift_123 = shannon(sift_img123); 
S_sift_12345  = shannon(sift_img12345);
S_harris_123 = shannon(harris_img123); 
S_harris_12345  = shannon(harris_img12345);

save data2.mat sift_numberpoints sift_rumtime S_sift_123 S_sift_12345
save data1.mat harris_numberpoints harris_rumtime S_harris_123 S_harris_12345

% % 绘制对比分析结果
load data1.mat
load data2.mat
figure
bar(harris_numberpoints)
ylabel('数量')
legend({'图像1 Harris特征点数量','图像2 Harris特征点数量','匹配对数量'})
title('Harris特征点的4次匹配结果')
grid on

figure
bar(sift_numberpoints)
ylabel('数量')
legend({'图像1 Sift特征点数量','图像2 Sift特征点数量','匹配对数量'})
title('Sift特征点的4次匹配结果')
grid on

figure
bar([sift_rumtime' harris_rumtime'])
ylabel('时间(s)')
legend({'Sift特征提取与匹配','Harris特征提取与匹配'})
title(' 4次匹配两种算法时间 ')
grid on

figure
bar([S_sift_123 S_harris_123;S_sift_12345 S_harris_12345])
ylabel('信息熵')
ylabel('分别为三幅图和五幅图拼接')
legend({'Sift方法','Harris方法'})
title('两种方法匹配结果图像的信息熵对比')
grid on










