%% Computer Vision Challenge 2020 challenge.m
clc
clear
%% Start timer here
tic
 
%% Generate Movie
config();
num = 1;
global loop_cache
loop_cache = [];
ir = ImageReader(src,L,R,start,N);
loop = 0;
while loop ~= 1
  % Get next image tensors
    [left,right,loop] = ir.next();
  % Generate binary mask
    mask = segmentation(left,right);
  % Render new frame
    result = render(left(:,:,1:3),mask,bg,render_mode);
    movie(:,:,:,num) = result;
    num = num+1;
end

%% Stop timer here
elapsed_time = toc;
disp(['elapsed_time is ', num2str(floor(elapsed_time/60)),' min']);


%% Write Movie to Disk
if store
   disp('Writing video...');
   avi = strcat(dst, '\output.avi');
   v = VideoWriter(avi,'Motion JPEG AVI');
   open(v)
   for i = 1:num-1
       writeVideo(v,movie(:,:,:,i));
   end
   close(v)
end
disp('Finish'); 
