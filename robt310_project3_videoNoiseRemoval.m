% ROBT 310 - Project 3 Aquarium Challenge
%
% Author: Kudaibergen Urinbayev
% Date: 12 March 2018
%%
close all ; clc; clear;     % Close all figure windows, Clear the screen and the workspace memory
%%

v = VideoReader('robt310_proj3_expert_kurinbayev.avi');

numFrames = 512;

vheight = v.height;
vwidth = v.width;

vid_m  = zeros([vheight, vwidth, numFrames]);


%Mask obtaineed from zeroing diagonal bars in Fourier transform 
        mask = ones(vheight, vwidth);
        mask(209, 241) = 0;
        mask(225, 213) = 0;
        mask(241, 235) = 0;
        mask(249, 246) = 0;
        mask(265, 268) = 0;
        mask(273, 279) = 0;
        mask(289, 301) = 0;
        mask(305, 323) = 0;


%Creating mask for the moving white bar

        %Sinusoidal for the mask
        sinwave = ones(512, 512);

        for k=0:50
            sinwave(k+1, :)= cosd(7.0588*k)* ones(1, 512);
        end
        sinwave = abs((sinwave+1)*17.25-34.5);

        %------video creation
        maskv = zeros ([512 512 512]);
        sinfk =zeros ([512 512]);  
        for k=1:512
        sinfk(k*(345/462) :50+ k*(345/462), :) = sinwave(1:51, :);
        maskv(:,:, k) = sinfk;

        sinfk= sinfk*0;  

        end
        
 % Mask for the intensity fluctuation in 3rd dimension 
                mask3= ones(512,512);
                mask3( 257,253) = 0;
                mask3( 257,261) = 0;







% Noise Removal

for k = 1:numFrames
%read frame
frame = rgb2gray(readFrame(v));


%removing salt and pepper noise
frame = medfilt2(frame, [5 5]);

%removing diagonal bars
ft = (fftshift(fft2(frame)));
frame = abs(ifft2(ifftshift(ft.* mask)));

%removing white moving bar
frame = frame - maskv(:,:,k);


%To store in MAT file
vid_m(:,:,k)=frame;
end


%Removing Intensity fluctuation noise

revvid = zeros (512, 512, 512);

for j = 1:512
    for k=1:512
    revvid(:, k, j) = uint8(vid_m(:,j, k));

    end

im = revvid(:, :, j);
ft3 = (fftshift(fft2(im)));
revvid(:,:,j)= abs(ifft2(ifftshift(ft3.* mask3)));

end

%removing salt and pepper noise from right and left borders
vid_m(:,:,1) = medfilt2(vid_m(:,:,1), [5 5]);
vid_m(:,:,512) = medfilt2(vid_m(:,:,512), [5 5]);



for j = 1:512
    for k=1:512
    vid_m(:, k, j) = uint8(revvid(:,j, k));

    end
end



vid_m = uint8(vid_m);
