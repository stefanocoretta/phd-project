% save_interp_surfaces.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a script from the project 'Vowel duration and consonant voicing: An
% articulatory study', Stefano Coretta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MIT License
%
% Copyright (c) 2016-2018 Stefano Coretta
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.


% Set traces/ as current folder

files = dir('*.mat');

file_names = {files.name};

n_files = length(file_names);

frames = [7 8 10 6 9 10 6 11 8 10];

for n = 1:n_files
    load(file_names{n});
    
    frame = frames(n);
    
    x = traces{1}.surface{frame}.x;
    y = traces{1}.surface{frame}.y;
    z = traces{1}.surface{frame}.z;
    
    data = [x(:), y(:), z(:)];
    data = data(find(~isnan(data(:,3))),:);
    
    output_file = strrep(file_names{n}, '_traces.mat', '');
    
    csvwrite(strcat('../../datasets/', output_file, '.csv'), data)
end
