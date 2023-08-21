function [m1,m2,number1,number2,number3] = genharrisMatches(imgC,imgL,showid)

im01 = imgC;
im02 = imgL; 

% 灰度化
im1 = rgb2gray(im01);
im2 = rgb2gray(im02);

%% （特征点提取）harris角点检测算法
% Harris corner threshold
thresh = 60;    
% Non-maximal suppression radius
nonmaxrad = 2;   
% Find Harris corners in image1 and image2
[cim1, r1, c1] = harris(im1, 1, thresh, 3);
% figure;imshow(im01);hold on, plot(c1,r1,'r+');title('待匹配图像1')
[cim2, r2, c2] = harris(im2, 1, thresh, 3);
% figure;imshow(im02);hold on, plot(c2,r2,'r+');title('待匹配图像2')

%% （粗匹配）NCC算法
% Window size for correlation matching
% 大一点误匹配少
w = 75;   
[m1,m2] = matchbycorrelation(im1, [r1';c1'], im2, [r2';c2'], w);

if showid == 1
    img3 = appendimages(im01,im02);
    figure('Position', [100 100 size(img3,2) size(img3,1)]);
    colormap('gray');
    imagesc(img3);
    hold on;
    cols1 = size(im01,2);
    for i = 1:length(m1);
          line([m1(2,i) m2(2,i)+cols1], ...
              [m1(1,i) m2(1,i)],'color','r','LineWidth',1);
       plot(m1(2,i),m1(1,i),'y+','LineWidth',2);
       plot(m2(2,i)+cols1,m2(1,i) ,'b+','LineWidth',2);
    end
    hold off;
    title('Harris特征点粗匹配 NCC算法结果')
end
% Assemble homogeneous feature coordinates for fitting of the
% fundamental matrix, note that [x,y] corresponds to [col, row]
x1 = [m1(2,:); m1(1,:)];
x2 = [m2(2,:); m2(1,:)];
m1 = x1';
m2 = x2';

%% 返回特征点个数
number1 = size(r1,1);
number2 = size(r2,1);
number3 = size(m1,1);
