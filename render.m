function [result] = render(frame,mask,bg,render_mode)
  % This function provides four types of rendering
  % Parameter mode chooses one of them
  % frame: current image
  % mask: binary segmentation of frame
  % bg: arbitrary virtual RGB-background
  mask = uint8(repmat(mask,[1 1 3]));
  mask_inv = uint8(ones(size(mask)))-mask;
  % flip the binary mask
  switch render_mode
      case 'foreground'
           result = frame.*mask;
      case 'background'
           result = frame.*mask_inv;
      case 'overlay'
           [n,m,~] = size(frame);
           % create a solid green image
           green = uint8(cat(3,zeros(n,m),255*ones(n,m),zeros(n,m)));
           % create a solid red image
           red = uint8(cat(3,255*ones(n,m),zeros(n,m),zeros(n,m)));
           % zone of foreground with red and background with green
           overlay = red.*mask+green.*mask_inv;
           % overlays color and frame using alpha blending 
           result = imfuse(overlay,frame,'blend');
      case 'substitute'
           bg = imresize(bg,[size(frame,1) size(frame,2)]);
           % agjust the size of bg to frame
           result = frame.*mask + uint8(bg).*mask_inv;
           % frame with virtual bg
 end  
end  
