% PARAMETERS TO TWEAK AS NEEDED
p.root = 'C:\Users\Marta\Desktop\GRIDS_unzipped\Grids-master'; %root directory to the script
p.ofn = 'C:\Users\Marta\Desktop\GRIDS_unzipped\Grids-master\Saved_Grids'; %Choose where you want the output to be
p.ofn_fn_temp = 'BC=%d_BT=%d_YC=%d_YT=%d'; %filename template, replaces %d with number of shapes 
%BC = blue Circle, etc
p.f_list_dir = 'C:\Users\Marta\Desktop\GRIDS_unzipped\Grids-master\f_list.mat'; % location of thre f_list file;
% f_list assumes the following
% f(1) = 4; % how many blue_circle_w
% f(2) = 12;% how many blue_triangle_w
% f(3) = 20;% how many yellow_circle_w
% f(4) = 12;% how many yellow_triangle_w
variations = 4; %how many variation of the same configuration of grids you want
% dictionary: 
% Configuration == Matrix (Matrix is defined by the ratio of the different shapes)
% Variation = version of the matrix (different placement, same ratio of shapes)
c.size = [1092 1365] %(c)anvas size [hight width]
c.colour = 218; % 0-255 % 218 is the PTB grey colour
size_factor = 2.31; %how much to shring the original images
% 2.31 is a magic number, like pi or e apparently,
% input 1 to keep original size
% for 100x100 shapes


% END OF PARAMETERS, SELF SUFFICIENT CODE BELOW
% ignore the annoying warnings
w{1} =  'MATLAB:colon:nonIntegerIndex';
for w_ind = 1:length(w);
    warning('off',w{w_ind});
end
% Try and load f_list
try 
    load(p.f_list_dir)
    disp('F_list loaded')
catch % if fails 
    error(['Not found' p.f_list_dir]) %throw error 
end

% Get pics
addpath(p.root); % yeah, adds the path for good measure; 

temp = dir([p.root '\*.jpg']);temp = {temp.name}';
% ^ goes to root dir, gets all files that end in .jpg and collects full
% addresses of them

p.pics = cellfun(@(x) fullfile(p.root,x),temp,'UniformOutput',0);
% Warning, if you change the picture files double check whether 
% p.pics is still in line with f(1:end)

s = imread(p.pics{1});% initial estimate of shape size, to get the borders
s = s(1:size_factor:end,1:size_factor:end,:); %resamples the image according to paramter specified 
imsize = size(s); 
for conf = 1:size(f_list,1) % conf = configuration counter, loops through the f_list
    f = f_list(conf,:); %gets all items from the row
for vv = 1:variations %vv = variation counter, variation loop. 
    % vv doesnt really factor into anything just the amount of times it
    % loops
    disp(sprintf('Running Configuration %d/%d, version %d/%d',conf,size(f_list,1),vv,variations))
        

%Re-efine canvas
im = repmat(c.colour,c.size(1),c.size(2),3); %im == the canvas 
im = uint8(im); %convertion needed
% pos == combination of all possible x and y to draw the shape
pos = CombVec(1:c.size(1)-imsize(1),1:c.size(2)-imsize(2))'; % pos = all posible positions of the screen
s_ind = 0; % initiate counter of how many shapes are fitted;
disp('Fitting shapes')

% converts f[20     4    12    12] to smtg like [1 1 1 1 1 1 2 2 2 3 3 3  3 3 3  3 3]
f_row = arrayfun(@(x) repmat(x,1,f(x)),1:4,'UniformOutput',0); % get them in a rowc
f_row = [f_row{:}]';
if sum(f) ~= length(f_row); error('sum(f) doesnt match f_row length, Aidas fucked up');end % gotta check dem dirty hax tho :D
s_counter = 0;
for s_ind = f_row' % shape drawing loop, loops iterations == amount of shapes to be drawn 
s = imread(p.pics{s_ind}); %reads in the image
s = s(1:size_factor:end,1:size_factor:end,:); % resizes it according to the parameter specified
imsize = size(s); % recalculates the shrunk size
% Place the shape on the canvas 
er.position = 'Ran out of space on the screen when fitting the figures, run me again it''s a random problem';
try r_ind = randi(size(pos,1)); catch error(er.position);end
% ^ takes a randow row in <pos> variable
randx = pos(r_ind,1);% x coordinate of that randow row
randy = pos(r_ind,2);% y coordinate of that randow row

% Define Picture rectangle
e(1) = randx; % edge 1
e(2) = randx+imsize(1)-1; %edge 2 == edge+length of the image minus 1 (because of 1indexing onstead 0 indexing, I dunno, I just made tht up lol)
e(3) = randy; %
e(4) = randy+imsize(2)-1;

if sum([e([1 2]) > c.size(1) e([3 4]) > c.size(2)]) > 0
   error('Edge outside of canvas');end 
% ^ this checks, before drawing, whether any of the edges are outside of
% the canvas; throws an error if it is

im(e(1):e(2),e(3):e(4),:) = s; %actual drawing of the shape


% code so shapes don't overlap
% a combines x and y coordinates of the shape and removes them from the pool
a = CombVec([e(1)-imsize(1):e(2)],[e(3)-imsize(2):e(4)])'; % Permutations of the length and width
[C,IA,IB] = intersect(pos,a,'rows'); % finds the <indexes> of where a matches the pool (<pos>)
% IA are the actual indexes, rest is unneccesary crap
pos(IA,:) = []; % remove taken space from the pool
s_counter = s_counter+1; % count shapes drawn
disp(sprintf('%d/%d',s_counter,sum(f)))
end
% Save the images to file 
imwrite(im,fullfile(p.ofn,[sprintf(p.ofn_fn_temp,f(1),f(2),f(3),f(4)) ' var ' num2str(vv) '.bmp']),'bmp')
% ^ Tweak this as needed;
%imwrite(shape==im,filename,format_in_string)
%figure(1)
%h = image(im);
end
end