%% Preprocess image and make multiple and save as .png file (data augmentation)
%x is filename, y is label

function preprocessPNG(x,y)
    img_read = dicomread(x);
    info = dicominfo(x);
    img_read = im2double(img_read);
    
    %% Preprocessing steps for the image
    %USM for better sharpening the image using gaussiam lpf
    %img_read = amf(img_read);       %Adaptive Median Filtering not efficient
    %img_read = medfilt2(img_read);
    
    %Conversion to a range of [0 255] // Normalizing 
    mul_image = uint8(255 * mat2gray(img_read));

    %Flip all image into same direction
    M = info.Rows;
    N = info.Columns;
    center = [round(M/2) round(N/2)];
    M_sum = sum(mul_image,1);
    
    sum_from_left = sum(M_sum(1,1:center(1)));
    sum_from_right = sum(M_sum(1,center(1):length(M_sum)));
    
    %If the sum from right edge to center is greater means the ROI is in
    %right so fliping that to left
    if sum_from_left < sum_from_right
        flip_image = flip(mul_image, 2);
    else
        flip_image = mul_image;
    end


    %Contrast Local Adaptive Histogram Equalization // Performs better than
    %Local Adaptive Histogram Equalization and fusing to better detect the
    %cancerous cells
    clahe_img = adapthisteq(flip_image,'clipLimit',2/256,'Distribution','uniform');
    
    %clahe_img = imfuse(clahe_img_1,clahe_img_2);
      
    %Morphological image processing
    %Conversion of original image to binary 
    T = double(205);
    bin_img = imbinarize(clahe_img, T/255);
    
    SE = strel('disk',10,8);
    bin_img_d = imdilate(bin_img, SE);
    
    SE = strel('disk',20,8);
    bin_img_e = imerode(bin_img_d, SE);
    
    inverted_mask = ~bin_img_e;
    
    roi_img = flip_image - uint8(255.*(inverted_mask));
    
    %Applying Gaussian blur to remove the sharp edges, thus for better roi
    roi_img = imgaussfilt(roi_img, 5);
    
    %Adding roi_img created using mask to the clahe_img, to enhance
    W = 0.3;                                   %Considering a value of weight to enhance roi
    preprocessed_img = (1-W).*clahe_img + W .* roi_img; 
    
    %Padding the image into square // Most transfer learning image uses
    %square images, since all of our data set have fixed image size we dont
    %really need M==N and N>M but, this makes system robust
    
    %     if M == N
    %         out_img = clahe_img;
    %     elseif M>N
    %         out_img = zeros(M,M,3);
    %         out_img(1:M,1:N,:) = clahe_img;
    %     elseif N>M
    %         out_img = zeros(N,N,3);
    %         out_img(1:M,1:N,:) = clahe_img;
    %     end
    
    if M == N
        out_img = preprocessed_img;
    elseif M>N
        out_img = padarray(preprocessed_img, double(M-N),0,'post');
    elseif N>M
        out_img = padarray(preprocessed_img, double(N-M),0,'post');
    end

    if y == 0
        filepath = 'C:\Users\tripats\Documents\Mammography Cancer Detection\Datastore6_mal_ben_512x512Normal\';
    elseif y == 1
        filepath = 'C:\Users\tripats\Documents\Mammography Cancer Detection\Datastore6_mal_ben_512x512\Benign\';
    elseif y == 2
        filepath = 'C:\Users\tripats\Documents\Mammography Cancer Detection\Datastore6_mal_ben_512x512\Malignant\';
    end
    
    out_img = imresize(out_img, [512 512]);
    
    flip_img = flip(out_img,2);
    c = 1;
    for i=30:30:270
        imwrite(out_img, fullfile(filepath, strcat(char(extractBetween(x,'INbreast Release 1.0\INbreast Release 1.0\AllDICOMs\','.dcm')),...
            num2str(c),'.png')));
        imwrite(flip_img, fullfile(filepath, strcat(char(extractBetween(x,'INbreast Release 1.0\INbreast Release 1.0\AllDICOMs\','.dcm')),...
            num2str(-c),'.png')));
        out_img = imrotate(out_img,i,"bicubic","crop");
        flip_img = imrotate(flip_img,i,"bicubic","crop");
        c = c + 1;
    end
%     figure
%     imshow(clahe_img);
%     
%     figure
%     imshow(255.*(bin_img));
% 
%     figure
%     imshow(255.*(bin_img_d));
% 
%     figure
%     imshow(255.*(bin_img_e));
% 
%     figure
%     imshow(roi_img)
% 
%     figure
%     imshow(preprocessed_img, []);
    
end

