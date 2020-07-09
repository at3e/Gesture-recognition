function [zero_cr] = Zerocr(data_test)

zero_cr = zeros(size(data_test,1),1);
for i = 1:size(data_test,1)-1
    if ((data_test(i)<0 & data_test(i+1)>0) | (data_test(i)>0 & data_test(i+1)<0))
        zero_cr(i)=1;
    end
end
