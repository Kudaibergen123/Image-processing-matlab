function robt310_project2_dither(input_file_name, output_file_name, part)

I=imread(input_file_name);



if (part==0)

     
 out=padarray(I,[2 2], 'symmetric', 'both');
    s= size(out);
    for j = 2:s(1)-1
        for i = 2:s(2)-1
            old=out(j,i);
            if(127<old)
                new=255;
            else
                new=0;
            end  
            out(j,i) = new;
             quant_error  = old-new;
         out(j,i+1) = out(j,i+1) +  quant_error * 7 / 16;
         out(j+1,i-1) = out(j+1,i-1) +  quant_error * 3 / 16;
         out(j+1,i) =  out(j+1,i )+  quant_error * 5 / 16;
         out(j+1,i+1) = out(j+1,i+1) +  quant_error * 1 / 16;       
        end
    end 
     out= out(3:s(1)-2, 3:s(2)-2);

     
   %--------------------------
     elseif (part==1)
         out=padarray(I,[2 2], 'symmetric', 'both');
            s= size(out);
   for k= 1:3
    for j = 2:s(1)-1
        for i = 2:s(2)-1
            old=out(j,i,k);
            new = round(old/32); 
            out(j,i, k) = new;
             quant_error  = old-new;
         out(j,i+1,k) = out(j,i+1,k) +  quant_error * 7 / 16;
         out(j+1,i-1,k) = out(j+1,i-1,k) +  quant_error * 3 / 16;
         out(j+1,i,k) =  out(j+1,i,k )+  quant_error * 5 / 16;
         out(j+1,i+1,k) = out(j+1,i+1,k) +  quant_error * 1 / 16;       
        end
    end 
    
   end
     out= 32*out(3:s(1)-2, 3:s(2)-2,:);
     
  
   %--------------------------
     elseif (part==2)
         
    out = padarray(I,[1 1], 'symmetric', 'post');
    s2 = size(out);
    mat = [0.2, 0.8; 0.6, 0.4];

    for j = 1:2:s2(1)-1
        for i = 1:2:s2(2)-1
            out(j: j+1, i: i+1) = (double(out(j: j+1, i: i+1)).* mat)/255;
            
        end
    end 
    
  
  out= out(1:s2(1)-1, 1:s2(2)-1,:);
     
end

imwrite(out, output_file_name);


