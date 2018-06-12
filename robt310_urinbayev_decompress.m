% ROBT 310 - Compression Project
%
% Author: Kudaibergen Urinbayev
% Date: 13 April 2018

%%


function[]=   robt310_urinbayev_decompress(filename, fileout)
%ROBT310_YOURSECONDNAME_COMPRESS Summary of this function goes here
%   Detailed explanation goes here
%{
The decompression algorithm consist of 4 main steps
Step 1: 1D vector decompressed by inverse RLE algorithm
Step 2 and 3: Each part of a vector transforms by unzigzagging into 8x8 matrix
 and dequantized
Step 4: The inverse DCT algorithm creates decompressed image
 
%}
% and write your code here

%filename = 'test.pku';
%fileout = 'test.bmp';
%read the file
    file= fopen(filename,'r');
    vec2 = fscanf(file, '%d');
    vec2 = vec2';
    fclose(file);
          
       %Step 1:Inverse Run Length Encoding   
            l=length(vec2);
            s=1;
            k=1;
            p=1;
            while p<=l
                while s<=vec2(p+1)
                    vec(k)=vec2(p);
                    s=s+1;
                    k=k+1;
                end;
                p=p+2;
                s=1;
            end;


%chosen quantization matrix for image compression
qmat = [16    11    10    16    24    40    51    61;
        12    12    14    19    26    58    60    55;
        14    13    16    24    40    57    69    56;
        14    17    22    29    51    87    80    62;
        18    22    37    56    68   109   103    77;
        24    35    55    64    81   104   113    92;
        49    64    78    87   103   121   120   101;
        72    92    95    98   112   100   103    99]*3;
 r=3456; c =4608;   
% dct matrix   (U) 
dct_mat = dct(eye(8)); 

%  Step 2: Dequantization of DCT Coefficients
i=1;
        for j=1:8:r
            for k=1:8:c
                
                %Step 3: unzigzag the vector
                T=vec(1, i:i+63);
                izigzag= [T(1,1)  T(1,2)  T(1,6)  T(1,7)  T(1,15) T(1,16) T(1,28) T(1,29)
                    T(1,3)  T(1,5)  T(1,8)  T(1,14) T(1,17) T(1,27) T(1,30) T(1,43)
                    T(1,4)  T(1,9)  T(1,13) T(1,18) T(1,26) T(1,31) T(1,42) T(1,44)
                    T(1,10) T(1,12) T(1,19) T(1,25) T(1,32) T(1,41) T(1,45) T(1,54)
                    T(1,11) T(1,20) T(1,24) T(1,33) T(1,40) T(1,46) T(1,53) T(1,55)
                    T(1,21) T(1,23) T(1,34) T(1,39) T(1,47) T(1,52) T(1,56) T(1,61) 
                    T(1,22) T(1,35) T(1,38) T(1,48) T(1,51) T(1,57) T(1,60) T(1,62)
                    T(1,36) T(1,37) T(1,49) T(1,50) T(1,58) T(1,59) T(1,63) T(1,64) ];
                dct_Iq(j:j+7,k:k+7) = izigzag;

        dct_Idq(j:j+7,k:k+7) = dct_Iq(j:j+7,k:k+7).*qmat;
 i=i+64;
            end
        end
        
%Step 4: Inverse discrete cosine transform

        for j=1:8:r
            for k=1:8:c           
        dct_Irest(j:j+7,k:k+7) =dct_mat'*dct_Idq(j:j+7,k:k+7)*dct_mat;
      
            end
        end

    I2 = uint8(dct_Irest+128);
   
    imwrite(I2, fileout);


end

