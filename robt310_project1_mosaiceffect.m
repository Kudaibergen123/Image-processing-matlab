function [image] = slidingf(baseim, s)

basesize = size(baseim);%size of an original image
b=padarray(baseim,[s s], 'symmetric', 'both');
bsize = size(b);



%{
triangular mask

T = tril(ones(s)) ;
a = round(imresize([flip(T,2),T],[round(s/2*tan(pi/3)) s]));
trimask = uint8(imresize(a, [s s]));
ftrimask = uint8(imrotate(trimask, 180));
%}

 SE = strel('disk',s/2);

 mask = uint8(imresize( padarray(SE.Neighborhood,[2 2], 'both'), [s s]));


image = b;
%image2=b;

values = 255*ones(bsize(1), bsize( 2));

 rch_tbaseim = b(:, :, 1);
 gch_tbaseim = b(:, :, 2);
 bch_tbaseim = b(:, :, 3);
 
 
 %     INSERT PATH TO IMAGES HEREEEEEEEEE 
srcFile = dir('C:\Users\User\Desktop\DIP\album\*.jpg'); %  <------------------   INSERT PATH TO IMAGES HERE


for k=1:length(srcFile)
     im= imread(strcat('C:\Users\User\Desktop\DIP\album\', srcFile(k).name)); %  <------------------   INSERT PATH TO IMAGES HERE AS WELL
       

    rim = imresize ( im, [s s]);%resized version of small image
    mrim = rim.* repmat(mask, [1 1 3]);
    
 
    rch_trim = rim(:, :, 1);
    gch_trim = rim(:, :, 2);
    bch_trim = rim(:, :, 3);
    meanRrim = mean2(rch_trim);
    meanGrim = mean2(gch_trim);
    meanBrim = mean2(bch_trim);

for i = 1:s:basesize(1)+s        
    for j= 1:s:basesize(2)+s
        
      

meanRb = mean2(rch_tbaseim(i:i+s-1,j:j+s-1));
meanGb = mean2(gch_tbaseim(i:i+s-1,j:j+s-1));
meanBb = mean2(bch_tbaseim(i:i+s-1,j:j+s-1));
% FOR DELTAE

deltaE = sqrt((meanRrim - meanRb)^2 + (meanGrim - meanGb)^2 + (meanBrim - meanBb)^2);


        if(values(i,j)>= deltaE)
        values(i,j) = deltaE;
        image(i:i+s-1,j:j+s-1,:) = mrim;
       % imshow(image);
        end 
    end
end
end



%{
for k=1:length(srcFile)
     im= imread(strcat('C:\Users\User\Desktop\DIP\color\', srcFile(k).name)); %  <------------------   INSERT PATH TO IMAGES HERE AS WELL
       

    rim = imresize ( im, [s s]);%resized version of small image
    mrim = rim.* repmat(diamond, [1 1 3]);
    

    lch_trim = trim(:, :, 1);
    ach_trim = trim(:, :, 2);
    bch_trim = trim(:, :, 3);
    meanLrim = mean2(lch_trim);
    meanArim = mean2(ach_trim);
    meanBrim = mean2(bch_trim);

for i = 1+round(s/2):s:basesize(1)+s           
    for j= 1+round(s/2):s:basesize(2)+s
        
      

meanLb = mean2(lch_tbaseim(i:i+s-1,j:j+s-1));
meanAb = mean2(ach_tbaseim(i:i+s-1,j:j+s-1));
meanBb = mean2(bch_tbaseim(i:i+s-1,j:j+s-1));
% FOR DELTAE

deltaE = sqrt((meanLrim - meanLb)^2 + (meanArim - meanAb)^2 + (meanBrim - meanBb)^2);


       
        if(values(i,j)>= deltaE)
        values(i,j) = deltaE;
        image2(i:i+s-1,j:j+s-1,:) = mrim;
       % imshow(image);
        end 
    end
end
end



image = image + image2;
%}

image= image(s+1:basesize(1)+s, s+1:basesize(2)+s, :);
figure
subplot(1,2,1);
imshow(baseim);
subplot(1,2,2);
imshow(image);
