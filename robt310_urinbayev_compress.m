% ROBT 310 - Compression Project
%
% Author: Kudaibergen Urinbayev
% Date: 13 April 2018

%%

function [vec] = robt310_urinbayev_compress(filename, fileout)
%   Detailed explanation goes here
%{
The compression algorithm consist of 4 main steps
Step 1: With the theory from project report mathimatical concepts are 
applied to the Discrete cosine Transform encoding by the formula B=UAU' 

Step 2 and 3: each 8x8 window quantized with the common quantization matrix
and then converted into 1D vector 

Step 4: The 1D vector then compressed by Run length encoding
 
%}

% and write your code here
%filename = '9.bmp';
%fileout = 'test.pku';

Im = imread(filename);
I=double(Im) -128; %center the values around the zero
[r, c] = size(I);
%chosen quantization matrix for image compression
qmat = [16    11    10    16    24    40    51    61;
        12    12    14    19    26    58    60    55;
        14    13    16    24    40    57    69    56;
        14    17    22    29    51    87    80    62;
        18    22    37    56    68   109   103    77;
        24    35    55    64    81   104   113    92;
        49    64    78    87   103   121   120   101;
        72    92    95    98   112   100   103    99]*3;
    
% dct matrix   (U) 
dct_mat = dct(eye(8));  

% Step 1:    Discrete cosine Transform encoding
    %By the formula B=UAU'
    
        for j2=1:8:r
            for k2=1:8:c
               dct_I(j2:j2+7,k2:k2+7) =dct_mat*I(j2:j2+7,k2:k2+7)*dct_mat';
               
            end
        end
  
%Step 2: Quantization of DCT
    i=1;
        for j=1:8:r
            for k=1:8:c          
                T=round(dct_I(j:j+7,k:k+7)./qmat);
                dct_Iq(j:j+7,k:k+7)=T;
                % Step 3: making the zigzag of the block by hardway 
                 zigzag =[	T(1,1) T(1,2) T(2,1) T(3,1) T(2,2) T(1,3) T(1,4) T(2,3) 
                            T(3,2) T(4,1) T(5,1) T(4,2) T(3,3) T(2,4) T(1,5) T(1,6) 
                            T(2,5) T(3,4) T(4,3) T(5,2) T(6,1) T(7,1) T(6,2) T(5,3)
                            T(4,4) T(3,5) T(2,6) T(1,7) T(1,8) T(2,7) T(3,6) T(4,5)
                            T(5,4) T(6,3) T(7,2) T(8,1) T(8,2) T(7,3) T(6,4) T(5,5)
                            T(4,6) T(3,7) T(2,8) T(3,8) T(4,7) T(5,6) T(6,5) T(7,4)
                            T(8,3) T(8,4) T(7,5) T(6,6) T(5,7) T(4,8) T(5,8) T(6,7)
                            T(7,6) T(8,5) T(8,6) T(7,7) T(6,8) T(7,8) T(8,7) T(8,8)]; 
                            
                        zigzag = zigzag';
                      zigzag = zigzag (:);
                      %vector of zizagged dct values
                       vec(i:i+63) = zigzag';
                        i=i+64;
            end
            
    %Step 4: Run Length Encoding
            l=length(vec);
            j3=1;
            k3=1;
            i2=1;
            while i2<2*l
                comp=1;
                for j3=j3:l
                    if j3==l 
                        break
                    end;  
                     if vec(j3)==vec(j3+1)
                        comp=comp+1;
                    else
                        break
                    end;
                end;
                    vec2(k3+1)=comp;
                    vec2(k3)=vec(j3);
                    if j3==l && vec(j3-1)==vec(j3) 
                        break
                    end;  
                    i2=i2+1;
                    k3=k3+2;
                    j3=j3+1;
                    if j3==l 
                        if mod(l,2)==0 
                        vec2(k3+1)=1;
                        vec2(k3)=vec(j3);
                        else
                        vec2(k3+1)=1;    
                        vec2(k3)=vec(j3); 
                        end;
                         break
                    end;
             end; 
             
        end
       
file= fopen(fileout,'w'); 
fprintf(file,'%d ', vec2);
fclose(file);


end

