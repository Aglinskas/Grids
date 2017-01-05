p.root = '/Users/aidasaglinskas/Desktop/Grids/';
p.ofn = '/Users/aidasaglinskas/Desktop/Saved_grids/'; %where to save
p.ofn_fn_temp = 'BC=%d,BT=%d,YC=%d,YT=%d'; %filename template
%p.background = '/Users/aidasaglinskas/Desktop/Grids/Old_figs/background.jpg';
c.size = [1092 1365] %(c)anvas size [hight width]
c.colour = 218; % 0-255
size_factor = 2.31; %how much to shring the original images
% 2.31 is a magic number, like pi or e apparently,
% for 100x100 shapes
% semi-automatic code below (not the pew-pew-pew kind, the CMD+ENTER code blocks kind)
% Blank Screen is up;
% Get assets
addpath(p.root);
temp = dir([p.root '*.jpg']);temp = {temp.name}';
p.pics = cellfun(@(x) fullfile(p.root,x),temp,'UniformOutput',0);
% initial counter, to get the borders
s = imread(p.pics{1});
s = s(1:size_factor:end,1:size_factor:end,:);
imsize = size(s);

im = repmat(c.colour,c.size(1),c.size(2),3);
im = uint8(im); %convertion needed
pos = CombVec(1:c.size(1)-imsize(1),1:c.size(2)-imsize(2))'; % pos = all posible positions of the screen
s_ind = 0; % initiate counter of how many shapes are fitted;
disp('Fitting shapes')

% Grid parameters
f(1) = 4; % how many blue_circle_w
f(2) = 12;% how many blue_triangle_w
f(3) = 20;% how many yellow_circle_w
f(4) = 12;% how many yellow_triangle_w

f_row = arrayfun(@(x) repmat(x,1,f(x)),1:4,'UniformOutput',0); % get them in a rowc
f_row = [f_row{:}]';
if sum(f) ~= length(f_row); error('sum(f) doesnt match f_row length, Aidas fucked up');end % gotta check dem dirty hax tho :D
s_counter = 0;
for s_ind = f_row'
%theImage = imread(p.pics{s_ind});%imread(p.pics{randi(4)});
%theImage(ismember(theImage,[215:219])) = backgroundColor(1);
%imsize = floor([size(theImage,1) size(theImage,2)] / red_fact);
s = imread(p.pics{s_ind});
s = s(1:size_factor:end,1:size_factor:end,:);
imsize = size(s);
% Convert to texture
%imageTexture = Screen('MakeTexture', windowPtr, theImage);
% Place
er.position = 'Ran out of space on the screen when fitting the figures, run me again it''s a random problem';
try r_ind = randi(size(pos,1)); catch error(er.position);end
randx = pos(r_ind,1);%randsample(e_space_x,1);%randi(windowSize(3))
randy = pos(r_ind,2);%randsample(e_space_y,1);%randi(windowSize(4))

% Define Pic rect
e(1) = randx;
e(2) = randx+imsize(1)-1;
e(3) = randy;
e(4) = randy+imsize(2)-1;

if sum([e([1 2]) > c.size(1) e([3 4]) > c.size(2)]) > 0
   error('Edge outside of canvas');end

im(e(1):e(2),e(3):e(4),:) = s;
% code so shapes don't overlap
% a combines x and y coordinates of the shape and removes them from the pool
a = CombVec([e(1)-imsize(1):e(2)],[e(3)-imsize(2):e(4)])'; % original
[C,IA,IB] = intersect(pos,a,'rows');
pos(IA,:) = [];
%Screen('DrawTexture', windowPtr, imageTexture, [], [e(1) e(3) e(2) e(4)],0);
s_counter = s_counter+1;
disp(sprintf('%d/%d',s_counter,sum(f)))
end
% Flip the drawn shapes
%Screen('Flip', windowPtr);
%disp('Flipped')
%imageArray = Screen('GetImage', windowPtr, windowSize*red_fact);
%p.ofn = ['/Users/aidasaglinskas/Desktop/Saved_grids/1.png'];
imwrite(im,fullfile(p.ofn,[sprintf(p.ofn_fn_temp,f(1),f(2),f(3),f(4)) '  : ' datestr(datetime) '.bmp']),'bmp')
figure(1)
h = image(im);