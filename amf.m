%% Adaptive Median Filter
function amf_output = amf(img)
    im = img;
    image_s = size(img);
    M = image_s(1);
    N = image_s(2);
    max_M = 7;  
    amf_output = zeros(image_s);
    for i=1:M
        for j=1:N
            c = 1;      %This issue, if kept outside the loop c keeps on increasing without resetting to 1
                        %Min median filter of 3x3 so c = 1
            stage_A=1;
            stage_B=0;
            while stage_A==1
                window = im((max(1,i-c):min(M,i+c)),(max(1,j-c):min(N,j+c)));
                z_med = median(window(:));
                z_max = max(window(:));
                z_min = min(window(:));
                A1 = z_med - z_min;
                A2 = z_med - z_max;
                if A1 > 40 && A2 < -40
                    stage_B = 1;
                    stage_A = 0;
                else
                   c = c+1; 
                end
                if c > max_M
                    amf_output(i,j) = z_med;
                    stage_A = 0;
                end
                
                
            end    
            if stage_B==1
                z_xy = im(i,j);
                B1 = z_xy - z_min;
                B2 = z_xy - z_max;
                if B1 > 40 && B2 < -40
                    amf_output(i,j) = z_xy;
                else
                    amf_output(i,j) = z_med;
                end
            end
            
        end
    end
    