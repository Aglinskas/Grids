p.root = '/Users/aidasaglinskas/Desktop/Grids/'
addpath(p.root);
p.background = '/Users/aidasaglinskas/Desktop/Grids/Old_figs/background.jpg';
% Get black screen
red_fact = 2; % reduction factor, for smaller screen

% semi-automatic code below (not the pew-pew-pew kind, the CMD+ENTER code blocks kind)
allScreens=Screen('Screens');
myScreen=max(allScreens);
backgroundColor = [127 127 127]; % grey
% bakground 1-black, 255 white
[windowPtr] = Screen('Preference','SkipSyncTests', 1);
[width, height]=Screen('WindowSize', myScreen);
windowSize = [0, 0, width, height]; %se voglio lo schermo intero
windowSize = windowSize / red_fact % Smaller Screen
[windowPtr, rect]=Screen('OpenWindow',myScreen, backgroundColor,windowSize);
% Blank Screen is up;
%% Get assets
temp = dir([p.root '*.jpg']);temp = {temp.name}';
p.pics = cellfun(@(x) fullfile(p.root,x),temp,'UniformOutput',0);
imsize = [50 50]; % overwrite image size;
% pos = all posible positions of the screen
pos = CombVec(1:windowSize(3)-imsize(1),1:windowSize(4)-imsize(2))';
c = 0; % counter of how many figures are fitted;
disp('Generating')
% B_C,B_T,Y_C,Y_T

% Grid parameters
f(1) = 4; % how many blue_circle_w
f(2) = 12;% how many blue_triangle_w
f(3) = 20;% how many yellow_circle_w
f(4) = 12;% how many yellow_triangle_w

f_row = arrayfun(@(x) repmat(x,1,f(x)),1:4,'UniformOutput',0); % get them in a rowc
f_row = [f_row{:}]';
if sum(f) ~= length(f_row); error('sum(f) doesnt match f_row length, Aidas fucked up');end % gotta check dem dirty hax tho :D
%while pos > 0 
for c = f_row'
theImage = imread(p.pics{c});%imread(p.pics{randi(4)});
theImage(ismember(theImage,[215:219])) = backgroundColor(1);
%imsize = floor([size(theImage,1) size(theImage,2)] / red_fact);

% Convert to texture
imageTexture = Screen('MakeTexture', windowPtr, theImage);
% Place
e.position = 'Ran out of space on the screen when fitting the figures, run me again it''s a random problem';
try r_ind = randi(size(pos,1)); catch error(e.position);end
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
imageArray = Screen('GetImage', windowPtr, windowSize*red_fact);
p.ofn = ['/Users/aidasaglinskas/Desktop/Saved_grids/1.png'];
imwrite(imageArray, p.ofn);
%%