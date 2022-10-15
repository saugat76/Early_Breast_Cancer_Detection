%% Select in array tumor only tumor datas
%Also, load the INbreast.xls file onto MATLAB as INbreast1 variable

close all; 
tbl_mass = table(INbreast1.FileName, INbreast1.Mass, 'VariableName',["FileName","Mass"]);

tbl_mass(any(ismissing(tbl_mass),2), :) = [];

array_inbreast = table2array(tbl_inbreast);
array_tumor = tbl_mass.FileName;
array_inbreast = str2double(array_inbreast);
array_inbreast = array_inbreast(:,3);
array_tumor = array_tumor(:,1);

s = size(tbl_inbreast);
true_cases = ismember(array_inbreast, array_tumor);

array_inbreast = table2array(tbl_inbreast);
array_inbreast_mass = array_inbreast(true_cases,:);

tbl_inbreast_mass = table(array_inbreast_mass(:,1),array_inbreast_mass(:,2),...
                    array_inbreast_mass(:,3),array_inbreast_mass(:,4),...
                    'VariableNames',["PatientID","DataID","RoiID","Label"]);



