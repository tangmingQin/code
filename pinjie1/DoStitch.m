function [result,numberpoints,rumtime] = DoStitch(imgC,imgL,imgR,method,showid)
   numberpoints = [];
   rumtime = [];
   if method == 1
        %% ��ȡsift�����㣬�õ���ƥ����
        tic
        [xCL,xL,number1,number2,number3] = genSIFTMatches(imgC,imgL,showid);
         % [xCL,xL,number1,number2,number3]  = siftMatch(imgC, imgL);
        timetemp = toc
        rumtime = [rumtime timetemp];
        numberpoints = [numberpoints;number1,number2,number3];
        tic
        [xCR,xR,number1,number2,number3] = genSIFTMatches(imgC,imgR,showid);
         %   [xCR,xR,number1,number2,number3] = siftMatch(imgC, imgR);
        timetemp = toc
        rumtime = [rumtime timetemp];
        numberpoints = [numberpoints;number1,number2,number3];
   else
        tic
        [xCL,xL,number1,number2,number3] = genharrisMatches(imgC,imgL,showid);
         % [xCL,xL,number1,number2,number3]  = siftMatch(imgC, imgL);
        timetemp = toc
        rumtime = [rumtime timetemp];
        numberpoints = [numberpoints;number1,number2,number3];
        tic
        [xCR,xR,number1,number2,number3] = genharrisMatches(imgC,imgR,showid);
         %   [xCR,xR,number1,number2,number3] = siftMatch(imgC, imgR);
        timetemp = toc
        rumtime = [rumtime timetemp];
        numberpoints = [numberpoints;number1,number2,number3];
   end
 
    %%  ransac�޳���㣬������homography����
    % �������ͼ����м�ͼ��homography����
    [innerID,H_LC] = runRANSAC(xL, xCL);
    if showid == 1
        % ��ʾƥ����
        allimg = appendimages(imgC,imgL);
        figure;imshow(allimg);hold on
        plot(xCL(innerID,1),xCL(innerID,2),'y+','LineWidth',2);
        plot(xL(innerID,1)+ size(imgL,2),xL(innerID,2)  ,'b+','LineWidth',2);
        for i = 1:size(innerID,1)
           line([xCL(innerID(i),1),xL(innerID(i),1)+ size(imgC,2)],[xCL(innerID(i),2) xL(innerID(i),2)],'color','r','LineWidth',1);
        end
        title('Ransac�޳�������')
    end
    % �����ұ�ͼ����м�ͼ��homography����
    [innerID,H_RC] = runRANSAC(xR, xCR);
    if showid == 1
       % ��ʾƥ����
        allimg = appendimages(imgC,imgR);
        figure;imshow(allimg);hold on
        plot(xCR(innerID,1),xCR(innerID,2),'y+','LineWidth',2);
        plot(xR(innerID,1)+ size(imgR,2),xR(innerID,2)  ,'b+','LineWidth',2);
        for i = 1:size(innerID,1)
           line([xCR(innerID(i),1),xR(innerID(i),1)+ size(imgC,2)],[xCR(innerID(i),2) xR(innerID(i),2)],'color','r','LineWidth',1);
        end
        title('Ransac�޳�������')  
    end
    % �����µ�ͼ��߽�
    %M is y, N is x
    [ML, NL, ~] = size(imgL);
    [MR, NR, ~] = size(imgR);
    Left_bounds = [1,1;NL,1;NL,ML;1,ML];
    Right_bounds = [1,1;NR,1;NR,MR;1,MR];
    Lref_bounds = applyHomography(H_LC,Left_bounds);
    Rref_bounds = applyHomography(H_RC,Right_bounds);
    % ��ֹ�쳣��߽�
    Loffset_x = round(min(Lref_bounds(:,1)));
    Loffset_yn = round(min(Lref_bounds(:,2)));
    Loffset_yp = round(max(Lref_bounds(:,2)));
    
    Roffset_x = round(max(Rref_bounds(:,1)));
    Roffset_yn = round(min(Rref_bounds(:,2)));
    Roffset_yp = round(max(Rref_bounds(:,2)));
    
    offset_yn = min(Loffset_yn,Roffset_yn);
    offset_yp = max(Loffset_yp,Roffset_yp);
   %% ���������չͼ��
    img_ref = imgC;
    %append offset_x zeros to the left reference image
    if (Loffset_x < 0) 
        img_ref = [zeros(size(imgC,1), -Loffset_x, 3) img_ref];
    end
    if (Roffset_x > size(imgC,2)) 
        img_ref = [img_ref, zeros(size(imgC,1), Roffset_x-size(imgC,2), 3) ];
    end
    %append offset_yn amount of zeros to the top of reference image
    if (offset_yn < 0 ) 
        img_ref= [zeros(-offset_yn, size(img_ref,2), 3); img_ref];
    end
    %append offset_yp amount of zeros to the bottom of reference image
    if (offset_yp > size(imgC,1)) 
        img_ref= [img_ref;zeros(offset_yp-size(imgC,1), size(img_ref,2), 3)];
    end
    
    %% ��������µĲο�ͼ�� img_ref �� imgL,imgR ֮��ĵ�Ӧ�Ծ���
    if method == 1
        [xrefL,xL] = genSIFTMatches(img_ref,imgL,0);
        [xrefR,xR] = genSIFTMatches(img_ref,imgR,0);
    %     [xrefL,xL] = siftMatch(img_ref, imgL);
    %     [xrefR,xR] = siftMatch(img_ref, imgR);
    else
        [xrefL,xL] = genharrisMatches(img_ref,imgL,0);
        [xrefR,xR] = genharrisMatches(img_ref,imgR,0);
    end
    % �������ͼ����м�ͼ��homography����
    [~,H_Lref] = runRANSAC(xL, xrefL);
    % �����ұ�ͼ����м�ͼ��homography����
    [~,H_Rref] = runRANSAC(xR, xrefR);  
    % �������ߴ�
    dest_wh = [size(img_ref, 2), size(img_ref, 1)];
    % �任��ͼ
    [maskL, left_img]=backwardWarpImg(im2single(imgL),inv(H_Lref),dest_wh);
    maskL(isnan(maskL))=0;
    % �任��ͼ
    [maskR, right_img]=backwardWarpImg(im2single(imgR),inv(H_Rref),dest_wh);
    maskR(isnan(maskR))=0;
    
    % ԭ�м�ͼ��maskλ��
    maskC = ones(size(imgC(:,:,1)));
    if (Loffset_x < 0) 
        maskC = [zeros(size(imgC,1), -Loffset_x) maskC];
    end
    if (Roffset_x > size(imgC,2))
        maskC = [maskC, zeros(size(imgC,1), Roffset_x-size(imgC,2))];
    end
    if (offset_yn < 0) 
        maskC = [zeros(-offset_yn, size(maskC,2)); maskC];
    end
    if (offset_yp > size(imgC,1) )
        maskC= [maskC;zeros(offset_yp-size(imgC,1), size(maskC,2))];
    end
    
    %% ���μ�Ȩ�ں�ͼ��
    maskCL = maskC + maskL;  
    maskCL (maskCL > 0) = 1;  
    maskCL(isnan(maskCL))=0; 
    result1 = blendImagePair(left_img, maskL, img_ref, maskC,'blend');
    result1 (isnan(result1))=0;  
    result = blendImagePair(right_img, maskR, result1, maskCL,'blend');
    result (isnan(result))=0;
end