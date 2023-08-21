function [xs, xd,number1,number2,number3] = genSIFTMatches(imgs, imgd,showflag)

% Add the sift library to path if the sift mex file cannot be found
% Here we assume the sift_lib is placed at a predefined location 
% (relative path)
% if ~isequal(exist('vl_sift'), 3)
%     sift_lib_dir = fullfile('sift_lib', ['mex' lower(computer)]);
%     orig_path = addpath(sift_lib_dir);
%     % Restore the original path upon function completion 
%     temp = onCleanup(@()path(orig_path));
% end

imgs = im2single(imgs); gray_s = rgb2gray(imgs);
imgd = im2single(imgd); gray_d = rgb2gray(imgd);

[Fs, Ds] = vl_sift(gray_s);
% Each column of Fs is a feature frame and has the format [X; Y; S; TH],
% where X, Y is the (fractional) center of the frame, S is the scale and TH
% is the orientation (in radians)
% Ds is the descriptor of the corresponding frame in F.
[Fd, Dd] = vl_sift(gray_d);

[matches, scores] = vl_ubcmatch(Ds, Dd);
% matches: 2xn matrix, scores: 1xn matrix
% The two rows of matches store the indices of Ds and Dd that match with
% each other

xs = Fs(1:2, matches(1, :))';
xd = Fd(1:2, matches(2, :))';
% xs and xd are the centers of matched frames

if showflag == 1
    % 显示匹配结果
    allimg = appendimages(imgs,imgd);
    figure;imshow(allimg);hold on
    plot(xs(:,1),xs(:,2),'y+','LineWidth',2);
    plot(xd(:,1)+ size(imgs,2),xd(:,2)  ,'b+','LineWidth',2);
    for i = 1:size(xs,1)
       line([xs(i,1),xd(i,1)+ size(imgs,2)],[xs(i,2) xd(i,2)],'color','r','LineWidth',1);
    end
    title('Sift特征点粗匹配结果')
end
%% 返回特征点个数
number1 = size(Fs,2);
number2 = size(Fd,2);
number3 = size(matches,2);