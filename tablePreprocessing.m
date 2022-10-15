%% Make a table tbl_inbreast that contains filename, id and classification label
%Run the code on the INBreast Release 1.0\ALLDICOMs\ folder before this

close all 

s = size(INbreast);
tbl_inbreast = zeros(s);

for i = 1:s(1)
    tbl_inbreast = [INbreast(:,3),INbreast(:,7),INbreast(:,8)];
end

roi_name = extractBefore(tbl_inbreast(:,2), 9);
tbl_inbreast = [tbl_inbreast,roi_name];
tbl_inbreast = table(tbl_inbreast(:,1),tbl_inbreast(:,2),tbl_inbreast(:,4),...
               tbl_inbreast(:,3),'VariableNames',["PatientID","DataID","RoiID","Label"]);

tbl_inbreast(any(ismissing(tbl_inbreast),2), :) = [];


