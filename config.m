%% Computer Vision Challenge 2020 config.m

%% Generall Settings
% Group number:
 group_number = 19;
% Group members:
 members = {'Zhouyi Gu', 'Wentao Zhang','Zixu Wang','Majdi Abdmoulah','Yu He'};
% Email-Address (from Moodle!):
 mail = {'ge93rit@tum.de', 'ge93rim@tum.de','zixu.wang@tum.de','ga26kek@tum.de','ge35qok@tum.de'};

%% Setup Image Reader
% Specify Scene Folder
src = 'E:\Skript\Computer_Vision\ChokePoint\P2L_S5';

% Select Cameras
% L =
% R =

L=1;
R=2;

% Choose a start point
% start = randi(1000)

start = 600;

% Choose the number of succseeding frames
% N =

N=3;

ir = ImageReader(src, L, R, start, N);

%% Output Settings
% Output Path

dst = 'E:\Skript\Computer_Vision\ChokePoint\output.avi';

% Load Virual Background
% bg = imread("Path\to\my\virtual\background")

bg = imread('E:\Skript\Computer_Vision\ChokePoint\bg.jpg');

% Select rendering mode

render_mode = 'foreground';

% Store Output?
store = false;
