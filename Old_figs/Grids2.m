%% Sprecifyable Parameters
c.size = [1092 1365] %(c)anvas size [hight width]
c.colour = 218; % 0-255

p.root = '/Users/aidasaglinskas/Desktop/Grids/'
p.ofn = '/Users/aidasaglinskas/Desktop/Saved_grids/'
% Figure out rest of parameters
% Get the pics
addpath(p.root);
temp = dir([p.root '*.jpg']);temp = {temp.name}';
p.pics = cellfun(@(x) fullfile(p.root,x),temp,'UniformOutput',0); clear temp
% Putting images on canvas
s = imread(p.pics{1});
im = repmat(c.colour,c.h,c.w,3);
im(1:size(s,1),1:size(s,2),:) = s;
im = uint8(im);
unique(im)

%% Save Image
imwrite(im,[p.ofn datestr(datetime) '.bmp'],'bmp')
