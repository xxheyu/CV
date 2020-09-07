function [mask] = segmentation(left,right)
  % input: Tensoren left and right
  % output: binary mask with foreground=1, background=0
  % use another 3 frames to calculate current mask
  img = zeros(size(left,1),size(left,2),4);
  diff = zeros(size(left,1),size(left,2));
  Sum = zeros(size(left,1),size(left,2));
  diff_binary = ones(size(left,1),size(left,2));
  % convert RGB-frame into grayscale frame 
  for i = 1:4
      img(:,:,i) = rgb2gray(left(:,:,3*i-2:3*i));
      Sum = Sum + img(:,:,i);
  end  
  average = Sum/4;
  % compute frame difference
  for j = 1:4
      diff(:,:,j) = abs(img(:,:,j)- average);
      % convert frame difference into binary image
      diff_binary = diff_binary.*imbinarize(diff(:,:,j));
  end
  % median filtering to reduce noise
  diff_binary = medfilt2(diff_binary);
  % perform morphological opening(erosion followed by dilation)
  diff_binary = bwmorph(diff_binary,'open');
  % remove spur pixels on edge
  diff_binary = bwmorph(diff_binary,'spur');
  % eliminate noise in background
  diff_binary = bwareaopen(diff_binary, 2500);
  diff_binary = medfilt2(diff_binary);
  % fullfill holes in foreground
  mask = imfill(diff_binary,'holes');
end




  

                
            
     
 
     
     
  
      
  

