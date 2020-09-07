This project consists of six .m-files
 * config.m 
 * ImagerReader.m 
 * segmentation.m
 * render.m
 * challenge.m
 * start_gui.m

Environment
 * Matlab with Image Processing Toolbox 

Run the function step by step
 * run start_gui.m
 * select scene folder
 * select background image if you want to run substitute mode
 * select destination folder if you want to save output video
 * The paramter L {1,2} R {2,3} and they cannot be 2 at the same time
 * choose starting point(optional), it should less than the number of images in folder 
 * select rendering mode
 * press "play" to run the code,
   if you choose store with "Yes" to get output video, please let the code run until the end
   if there is any problem with store, please restart GUI
 * if you press "stop", then it stops at current frame
 * if you press "loop", then it loops over and over

Please press "stop" button before you close the GUI