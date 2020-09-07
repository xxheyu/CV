function start_gui
clc
clear
%% Generall Settings
% Group number:
 group_number = 19;
% Group members:
 members = {'Zhouyi Gu', 'Wentao Zhang','Zixu Wang','Majdi Abdmoulah','Yu He'};
% Email-Address (from Moodle!):
 mail = {'ge93rit@tum.de', 'ge93rim@tum.de','zixu.wang@tum.de','ga26kek@tum.de','ge35qok@tum.de'};
% global variables
global src;
global L;
global R;
global start;
global N;
global dst;
global input_l;
global input_r;
global output;
global render_mode;
global store;
global bg;
global handlestopbutton;
global stop;
global loop_cache
global loop_ctrl;
global play_ctrl;
global start_ctrl;
global flag
flag = 0;
bg = [];
store = [];

%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[360,500,700,400]);

% Construct the components.
htext_scene  = uicontrol('Style','text','String','Select Scene Folder',...
           'Position',[600,260,100,15]);
scenefolder = uicontrol('Style','pushbutton',...
             'String','Open Folder','Position',[600,230,70,25],...
             'Callback',@scenefolder_Callback);
htext_bg  = uicontrol('Style','text','String','Select Background File',...
           'Position',[240,200,120,15]);
bgpath = uicontrol('Style','pushbutton',...
             'String','Open File','Position',[600,170,70,25],...
             'Callback',@bgpath_Callback);
htext_dest  = uicontrol('Style','text','String','Select Destination Folder',...
           'Position',[240,140,120,15]);
destfolder = uicontrol('Style','pushbutton',...
             'String','Open Folder','Position',[600,110,70,25],...
             'Callback',@destfolder_Callback);      
% control buttons: play, stop and loop
% choose starting point
%global start;
start = 0;
N = 3;
store = true;
render_mode = 'foreground';

htext_start  = uicontrol('Style','text','String','Choose Starting Point',...
           'Position',[340,230,120,15]);
start_field = uicontrol('Style','edit','Position',[750,210,60,20],...
      'Callback',@start_textChanged);
htext_R  = uicontrol('Style','text','String','Choose R',...
           'Position',[340,270,120,15]);
R_field = uicontrol('Style','edit','Position',[750,250,60,20],...
      'Callback',@R_textChanged); 
htext_L  = uicontrol('Style','text','String','Choose L',...
           'Position',[340,310,120,15]);
L_field = uicontrol('Style','edit','Position',[750,290,60,20],...
      'Callback',@L_textChanged); 
play = uicontrol('Style','pushbutton',...
             'String','Play','Position',[750,180,70,25],...
             'Callback',@playbutton_Callback);
stop = uicontrol('Style','pushbutton',...
             'String','Stop','Position',[750,150,70,25],...
             'Callback',@stopbutton_Callback);
loop = uicontrol('Style','pushbutton',...
             'String','Loop','Position',[750,120,70,25],...
             'Callback',@loopbutton_Callback);
htext  = uicontrol('Style','text','String','Select Mode',...
           'Position',[750,90,70,15]);
hpopup = uicontrol('Style','popupmenu',...
           'String',{'foreground','background','overlay','substitute'},...
           'Position',[750,60,100,25],...
           'Callback',@popup_menu_Callback);
store_text  = uicontrol('Style','text','String','Store or not',...
           'Position',[240,90,70,15]);
store_popup = uicontrol('Style','popupmenu',...
           'String',{'Yes','No'},...
           'Position',[240,60,100,25],...
           'Callback',@store_Callback);

htext_left  = uicontrol('Style','text','String','Left camera',...
           'Position',[50,380,100,15]);
input_l = axes('Units','pixels','Position',[50,240,150,130]);
htext_right  = uicontrol('Style','text','String','Right camera',...
           'Position',[230,380,100,15]);
input_r = axes('Units','pixels','Position',[230,240,150,130]);
htext_output  = uicontrol('Style','text','String','Output',...
           'Position',[120,210,100,15]);
output = axes('Units','pixels','Position',[120,20,200,180]);

align([input_l,input_r],'None','Center');
align([input_l,htext_left],'Center','None');
align([input_r,htext_right],'Center','None');
align([output,htext_output],'Center','None');
align([htext_scene,scenefolder,htext_bg,bgpath,htext_dest,destfolder,store_text,store_popup],'Center','Center');  
align([htext_start,start_field,htext_R,R_field,htext_L,L_field,play,stop,loop,htext,hpopup],'Center','Center');

myHandle = guihandles(f);  % save gui handles to struct
myHandle.breakOP = false;       % flag for break OP
guidata(f,myHandle);       % save structure

%% Initialize the UI.
% Change units to normalized so components resize automatically.
f.Units = 'normalized';
htext_start.Units = 'normalized';
htext_L.Units = 'normalized';
htext_R.Units = 'normalized';
htext_left.Units = 'normalized';
htext_right.Units = 'normalized';
htext_output.Units = 'normalized';
start_field.Units = 'normalized';
L_field.Units = 'normalized';
R_field.Units = 'normalized';
htext_scene.Units = 'normalized';
scenefolder.Units = 'normalized';
htext_bg.Units = 'normalized';
bgpath.Units = 'normalized';
htext_dest.Units = 'normalized';
destfolder.Units = 'normalized';
input_l.Units = 'normalized';
input_r.Units = 'normalized';
output.Units = 'normalized';
play.Units = 'normalized';
loop.Units = 'normalized';
stop.Units = 'normalized';
htext.Units = 'normalized';
hpopup.Units = 'normalized';
store_text.Units = 'normalized';
store_popup.Units = 'normalized';

%% --- Pushbutton to load scene folder
function scenefolder_Callback(hObject, eventdata, handles)
    try
        %global src;
        src = uigetdir(path, 'Scene folder');
        if ~isfolder(src)
            error('Error: The following folder does not exist:\n%s', src);
        end
        disp(src);
    catch errorObj
        errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
    end
end

%% --- Pushbutton to load background file
function bgpath_Callback(hObject, eventdata, handles)
    try 
        [bg_file,path] = uigetfile;
        bg_path = strcat(path,bg_file);
        disp(bg_path)
        if ~isfile(bg_path)
            error('Error: The following file does not exist:\n%s', bg_path);
        end
        bg = imread(bg_path);
    catch errorObj
        errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
    end
end

%% --- Pushbutton to choose destination folder
function destfolder_Callback(hObject, eventdata, handles)
    try
        %global dst;
        dst = uigetdir(path, 'Scene folder');
        if ~isfolder(dst)
            error('Error: The following folder does not exist:\n%s', dst);
        end
        disp(dst);
    catch errorObj
        errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error');
    end
end

% Assign the a name to appear in the window title.
f.Name = 'Computer Vision Challenge';

% Move the window to the center of the screen.
movegui(f,'center')

% Make the window visible.
f.Visible = 'on';

%% Callbacks functions for control buttons
%  Pop-up menu callback to choose the current mode. 
   function popup_menu_Callback(source,eventdata) 
      %global mode;
      modes = get(source,'String');
      idx = get(source,'Value');
      render_mode = modes{idx};
   end

   function store_Callback(source,eventdata) 
      if strcmp(source,'Yes')
          store = true;
      else
          store = false;
      end
   end

  function playbutton_Callback(source,eventdata,handles) 
       clc
       disp(src)
       handlestopbutton = source;
       handlestopbutton.Value = 0;
       tic
       num = 1;
       loop_ctrl = [];
       if ~isempty(play_ctrl) || ~isempty(start_ctrl)
            loop_cache = [];
       else
            play_ctrl = 1;
            start_ctrl = 1;
       end 
       ir = ImageReader(src,L,R,start,N);
       loop = 0;
       flag = 0;
       while loop ~= 1
             if flag ==1
                break;
             end
             drawnow()
             % Get next image tensors
             [left,right,loop] = ir.next();
             % Generate binary mask
             mask = segmentation(left,right);
             result = render(left(:,:,1:3),mask,bg,render_mode);
             % Render new frame
             for i = 1:3:size(result,3)
                 imshow(left(:,:,i:i+2),'Parent',input_l)
                 imshow(right(:,:,i:i+2),'Parent',input_r)
                 imshow(result(:,:,i:i+2),'Parent',output) 
             end
             pause(0.00001)
             movie(:,:,:,num) = result;
             num = num+1;
       end

       elapsed_time = toc;
       disp(['elapsed_time is ', num2str(floor(elapsed_time/60)),' min']);

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
  end

  function loopbutton_Callback(source,eventdata) 
       clc
       disp("loop enabled");
       flag = 0;
       while true
             if flag ==1
                break;
             end
             drawnow()
             if ~isempty(loop_ctrl) || ~isempty(start_ctrl)
                  loop_cache = [];
             else
                 loop_ctrl = 1;
                 start_ctrl = 1;
             end
             ir = ImageReader(src,L,R,start,N);
             loop = 0;
             while loop ~= 1
                   if flag ==1
                      break;
                   end
                   drawnow()
                   % Get next image tensors
                   [left,right,loop] = ir.next();
                   % Generate binary mask
                   mask = segmentation(left,right);
                   result = render(left(:,:,1:3),mask,bg,render_mode);
                   % Render new frame
                   for i = 1:3:size(result,3)
                       imshow(left(:,:,i:i+2),'Parent',input_l)
                       imshow(right(:,:,i:i+2),'Parent',input_r)
                       imshow(result(:,:,i:i+2),'Parent',output) 
                   end
             pause(0.00001)
             end
       end
  end

  function stopbutton_Callback(source,eventdata) 
       clc
       handlestopbutton = source;
       flag = 1;
       play_ctrl = [];
       loop_ctrl = [];
       start_ctrl = [];
       disp("Video stopped");
  end

% callback function for changing variable
function start_textChanged(source, eventdata)
    str = get(source,'String');
    start = str2num(str);
    start_ctrl = 1;
end

function L_textChanged(source, eventdata)
    str = get(source,'String');
    L = str2num(str);
end

function R_textChanged(source, eventdata)
    str = get(source,'String');
    R = str2num(str);
end
end
