p.root = '/Users/aidasaglinskas/Desktop/Marta_script/'
addpath(p.root);
p.background = '/Users/aidasaglinskas/Desktop/Marta_script/Old_figs/background.jpg';
% Get black screen
red_fact = 2; % reduction factor, for smaller screen
allScreens=Screen('Screens');
myScreen=max(allScreens);
backgroundColor = [127 127 127]; % grey
% bakground 1-black, 255 white
[windowPtr] = Screen('Preference','SkipSyncTests', 1);
[width, height]=Screen('WindowSize', myScreen);
windowSize = [0, 0, width, height]; %se voglio lo schermo intero
windowSize = windowSize / red_fact % Smaller Screen
[windowPtr, rect]=Screen('OpenWindow',myScreen, backgroundColor,windowSize);
%[windowPtr,rect]=Screen('OpenWindow',windowPtrOrScreenNumber [,color] [,rect] [,pixelSize] [,numberOfBuffers] [,stereomode] [,multisample][,imagingmode][,specialFlags][,clientRect]);
% Blank Screen is up;
%% Get assets
temp = dir([p.root '*png']);temp = {temp.name}';
p.pics = cellfun(@(x) fullfile(p.root,x),temp,'UniformOutput',0);
% pos = all posible positions of the screen
pos = CombVec(1:windowSize(3)-imsize(1),1:windowSize(4)-imsize(2))';
c = 0; % counter of how many figures are fitted;
disp('Generating')
%
theImage = imread(p.background);
imageTexture = Screen('MakeTexture', windowPtr, theImage);

while pos > 0
c = c+1;
theImage = imread(p.pics{randi(4)});
theImage(ismember(theImage,[210:220])) = backgroundColor(1);
imsize = floor([size(theImage,1) size(theImage,2)] / red_fact);
% Convert to texture
imageTexture = Screen('MakeTexture', windowPtr, theImage);
% Place
r_ind = randi(size(pos,1));
randx = pos(r_ind,1);%randsample(e_space_x,1);%randi(windowSize(3))
randy = pos(r_ind,2);%randsample(e_space_y,1);%randi(windowSize(4))

% Define Pic rect
e1 = randx;
e2 = randx+imsize(1);
e3 = randy;
e4 = randy+imsize(2);

% code so shapes don't overlap
% a combines x and y coordinates of the shape and removes them from the pool
a = CombVec([e1-imsize(1):e2],[e3-imsize(2):e4])';
[C,IA,IB] = intersect(pos,a,'rows');
pos(IA,:) = [];

Screen('DrawTexture', windowPtr, imageTexture, [], [e1 e3 e2 e4],0);
end
% Flip the drawn shapes
Screen('Flip', windowPtr);
disp('Flipped')
c % Number of shapes 
%%

