%十进制转补码
function bin = dec2cmp(num, bitsNum)
    bin = dec2bin((num >= 0) .* double(num) + (num < 0) .* (2^bitsNum + double(num)), bitsNum);
end
