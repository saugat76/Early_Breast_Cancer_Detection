%% Make 3 Datastore for 3 different classes
%Run tablePreprocessing before this

close all; 
tbl_input = tbl_inbreast_mass;

dicomDir = fullfile('INbreast Release 1.0\INbreast Release 1.0\AllDICOMs');

dicomds = imageDatastore(dicomDir, 'FileExtensions', '.dcm','ReadFcn',@(x) dicomread(x));

array_inbreast = table2array(tbl_input);
array_inbreast_label = str2double(array_inbreast);
array_inbreast_label = array_inbreast_label(:,4);

normal_label = (array_inbreast_label == 1);

benign_label = (array_inbreast_label == 2) | (array_inbreast_label == 3);

malignant_label = ~(normal_label | benign_label);

normal_inbreast = tbl_input.DataID(normal_label, :);
benign_inbreast = tbl_input.DataID(benign_label, :);
malignant_inbreast = tbl_input.DataID(malignant_label, :);

% normalds = imageDatastore(strcat('INbreast Release 1.0\INbreast Release 1.0\AllDICOMs\',normal_inbreast),...
%             'FileExtensions', '.dcm', 'ReadFcn',@(x) dicomread(x));
% 
% benignds = imageDatastore(strcat('INbreast Release 1.0\INbreast Release 1.0\AllDICOMs\',benign_inbreast),...
%             'FileExtensions', '.dcm', 'ReadFcn',@(x) dicomread(x));
% 
% malignantds = imageDatastore(strcat('INbreast Release 1.0\INbreast Release 1.0\AllDICOMs\',malignant_inbreast),...
%             'FileExtensions', '.dcm', 'ReadFcn',@(x) dicomread(x));







