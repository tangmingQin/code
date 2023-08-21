function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)
%% 图像融合
% 转到double类型
wrapped_imgs = im2double(wrapped_imgs);
wrapped_imgd = im2double(wrapped_imgd);
masks = im2double(masks);
maskd = im2double(maskd);

% 获得二进制mask
masks(masks > 0) = 1;
maskd(maskd > 0) = 1;

% 融合模式
if strcmp(mode,'overlay')
    
    maskd = ~maskd;
    % Superimpose the image
    out_img = wrapped_imgs .* cat(3, maskd, maskd, maskd) + wrapped_imgd;
    
elseif strcmp(mode,'blend')
    
    % 用距离变换计算权重
    weighted_masks = bwdist(~masks);
    weighted_maskd = bwdist(~maskd);
    weighted_masks = cat(3, weighted_masks, weighted_masks, weighted_masks);
    weighted_maskd = cat(3, weighted_maskd, weighted_maskd, weighted_maskd);
    % 加权融合
    weight_wrapped_imgs = wrapped_imgs .* weighted_masks;
    weight_wrapped_imgd = wrapped_imgd .* weighted_maskd;
    % 输出融合后图像
    out_img = (weight_wrapped_imgs + weight_wrapped_imgd)./(weighted_masks + weighted_maskd);
    
else
    print('wrong input')   
end
    
end