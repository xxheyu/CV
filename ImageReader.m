classdef ImageReader
  % Input   src:    Datapath
  %         L:      Select which camera should be used as a left or right image.
  %         R:      L can be the values {1, 2} and R the values {2, 3}.
  %         start:  Specifies the frame number from which the scene should be played.
  %         N:       Specifies how many successor images should be loaded per reading process.
  
  % Output  left:   The frames of the left camera are returned as tensor left.
  %         right:  The frames of the right camera are returned as tensor right. 
  %         loop:   It is set to 0 by default. If there are no longer enough pictures available in the folder, 
  %                 irrespective of N, only the existing successors are returned and loop is set to 1.
  properties
      src = '';      % Datapath
      L = 0;         % Select which camera should be used as a left or right image.
      R = 0;         % L can be the values {1, 2} and R the values {2, 3}.
      start = 0;     % Specifies the frame number from which the scene should be played.
      N = 0;         % Specifies how many successor images should be loaded per reading process.
  end
  methods(Access = public)
      function ir = ImageReader(src, L, R, varargin)
          p = inputParser;
          start_def = 0;
          N_def = 1;
          
          % Check if src is valid.
          if isstring(src) || ischar(src)
              [~, dir, ~] = fileparts(src);
          else
              dir = ' ';
          end
          % Validation expressions
          src_val = @(x) (isstring(x) || ischar(x)) && isfile(fullfile(x, strcat(dir, '_C', num2str(L)), 'all_file.txt'));
          L_val = @(x) x >= 1 && x <= 2;
          R_val = @(x) x >= 2 && x <= 3 && x ~=L;
          start_val = @(x) isnumeric(x) && x >= 0 && rem(x,1) == 0;
          N_val = @(x) isnumeric(x) && x>=3 && rem(x,1) == 0;
          % Add the arguments to the input parser.
          p.addRequired('src', src_val);
          p.addRequired('L', L_val);
          p.addRequired('R', R_val);
          p.addOptional('start',start_def, start_val);
          p.addOptional('N',N_def,N_val);
          % Parse all arguments
          parse(p, src, L, R, varargin{:});
          ir.src = p.Results.src;
          ir.L = p.Results.L;
          ir.R = p.Results.R;
          ir.start = p.Results.start;
          ir.N = p.Results.N; 
          
          all_file = importdata(fullfile(src, strcat(dir, '_C', num2str(L)), 'all_file.txt'));
          n_indices = length(all_file); % Total nubmber of images
          if ir.start + 1 > n_indices
              disp(['The start indice is greater than number of images, ', 'falling back to start = ', num2str(n_indices-1)]);
              ir.start = n_indices - 1;
          end        
      end
      
      function [left, right, loop] = next(ir)
          % Description:    The next time you call next (), you should start again at the beginning of the scene (picture 00000000.jpg), regardless of the value start.
          %                 Example for N = 3, the last time next () was called, the stereo image pair was loaded to frame number 42. 
          %                 If the next () function is called again, the frames from the images 00000043.jpg, 00000044.jpg, 00000045.jpg and 00000046.jpg of the left camera are in left. 
          path_split = regexp(ir.src, filesep, 'split'); 
          folder = char(path_split(end));
      
          left_folder = [folder, '_C', num2str(ir.L)];
          right_folder = [folder, '_C', num2str(ir.R)];
          left_camera_path = fullfile(ir.src, left_folder);
          right_camera_path = fullfile(ir.src, right_folder);
          
          % Read the txt, split its contents and extract the indices.
          left_name = importdata(fullfile(left_camera_path, 'all_file.txt'));
          right_name = importdata(fullfile(right_camera_path, 'all_file.txt'));
          n_indices = length(left_name); % Total nubmber of images
          
          left = zeros(600,800,(ir.N + 1)*3, 'uint8');
          right = zeros(600,800,(ir.N  + 1)*3, 'uint8');
          
          % loop_cache has been declared in config.m
          % Please add it in config.m and set loop_cache = []
          global loop_cache;

          % Get the value of loop_start and loop_end for loading images
          if isempty(loop_cache)
              loop_start = 1 + ir.start;
              loop_end = 1 + ir.start + ir.N;
              loop_cache = loop_start;
          else
              loop_start = 1 + loop_cache;
              loop_end = ir.N + loop_start;
              loop_cache = loop_start;
          end
          
          % Check if there are enough images to read
          % Set loop = 0 to end reading image
          if loop_end >= n_indices
              loop_end = n_indices;
              loop = 1;
          else
              loop = 0;
          end
           
          % Load images
          k = 1;
          for i  = loop_start : 1 : loop_end
              left_image_path = fullfile(left_camera_path, left_name(i));
              right_image_path = fullfile(right_camera_path, right_name(i));
              left(:,:,3*k-2:3*k) = imread(left_image_path{1});
              right(:,:,3*k-2:3*k) = imread(right_image_path{1});
              k = k+1;
          end
      end     
  end 
end