%% Make the dataset from raw image and classify onto the folders
%Run defineClass first, it give the logical array for seperate classes

tbl_input = tbl_inbreast_mass;

array_inbreast = table2array(tbl_input);
array_inbreast_label = str2double(array_inbreast);
Label = array_inbreast_label(:,4);

dataID = array_inbreast(:,2);

dataID = strcat('INbreast Release 1.0\INbreast Release 1.0\AllDICOMs\',dataID);
Label(normal_label) = 0;
Label(benign_label) = 1;
Label(malignant_label) = 2;

for i = 1:size(dataID)
    preprocessPNG(char(dataID(i)), Label(i));
end



