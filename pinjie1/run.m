clc;
clear;
close all;
addpath('harris')
addpath('sift')


% % ����˳���ȡ5��ͼ�� �м� һǰһ��
imgc  = imread('DSC00228.JPG');
imgl1 =  imread('DSC00226.JPG');
imgr1 = imread('DSC00230.JPG');
imgl2 = imread('DSC00224.JPG');
imgr2 = imread('DSC00232.JPG');

% % ѡ�񷽷���1Ϊsift 2Ϊ Harris
method = 1;

% % sift ƴ��
% sift_numberpoints = [];
% sift_rumtime = [];
% % 3 ��ͼ��
% [sift_img123,numberpoints1,rumtime1]= DoStitch(imgc,imgl1,imgr1,method,1);
% sift_numberpoints = [numberpoints1];
% sift_rumtime = [rumtime1];
% 
% sift_img123 = uint8(sift_img123*255);
% figure;imshow(sift_img123)
% imwrite(sift_img123, 'sift_img123.png');
% title('����ͼƴ�ӽ��')
% 
% % 5 ��ͼ��
% [sift_img12345,numberpoints2,rumtime2] = DoStitch(sift_img123,imgl2,imgr2,method,1);
% sift_numberpoints = [sift_numberpoints;numberpoints2];
% sift_rumtime = [sift_rumtime rumtime2];
% 
% sift_img12345 = uint8(sift_img12345*255);
% figure, imshow(sift_img12345);
% title('���ͼƴ�ӽ��')
% imwrite(sift_img12345, 'sift_img12345.png');

% % ѡ�񷽷���1Ϊsift 2Ϊ Harris
method = 2;

% % harris ƴ��
harris_numberpoints = [];
harris_rumtime = [];
% 3 ��ͼ��
[harris_img123,numberpoints1,rumtime1]= DoStitch(imgc,imgl1,imgr1,method,1);
harris_numberpoints = [numberpoints1];
harris_rumtime = [rumtime1];

harris_img123 = uint8(harris_img123*255);
figure;imshow(harris_img123)
imwrite(harris_img123, 'harris_img123.png');
title('����ͼƴ�ӽ��')

% 5 ��ͼ��
[harris_img12345,numberpoints2,rumtime2] = DoStitch(harris_img123,imgl2,imgr2,method,1);
harris_numberpoints = [harris_numberpoints;numberpoints2];
harris_rumtime = [harris_rumtime rumtime2];

harris_img12345 = uint8(harris_img12345*255);
figure, imshow(harris_img12345);
title('���ͼƴ�ӽ��')
imwrite(harris_img12345, 'harris_img12345.png');

% % ��������� ƥ���ٶ� ��Ϣ���Ա�
% ������Ϣ��
S_sift_123 = shannon(sift_img123); 
S_sift_12345  = shannon(sift_img12345);
S_harris_123 = shannon(harris_img123); 
S_harris_12345  = shannon(harris_img12345);

save data2.mat sift_numberpoints sift_rumtime S_sift_123 S_sift_12345
save data1.mat harris_numberpoints harris_rumtime S_harris_123 S_harris_12345

% % ���ƶԱȷ������
load data1.mat
load data2.mat
figure
bar(harris_numberpoints)
ylabel('����')
legend({'ͼ��1 Harris����������','ͼ��2 Harris����������','ƥ�������'})
title('Harris�������4��ƥ����')
grid on

figure
bar(sift_numberpoints)
ylabel('����')
legend({'ͼ��1 Sift����������','ͼ��2 Sift����������','ƥ�������'})
title('Sift�������4��ƥ����')
grid on

figure
bar([sift_rumtime' harris_rumtime'])
ylabel('ʱ��(s)')
legend({'Sift������ȡ��ƥ��','Harris������ȡ��ƥ��'})
title(' 4��ƥ�������㷨ʱ�� ')
grid on

figure
bar([S_sift_123 S_harris_123;S_sift_12345 S_harris_12345])
ylabel('��Ϣ��')
ylabel('�ֱ�Ϊ����ͼ�����ͼƴ��')
legend({'Sift����','Harris����'})
title('���ַ���ƥ����ͼ�����Ϣ�ضԱ�')
grid on










