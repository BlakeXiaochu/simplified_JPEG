%补码转十进制
function dec = cmp2dec(cmp, bitsNum)
    dec = (cmp(:, 1) == '0') .* (bin2dec(cmp)) + (cmp(:, 1) == '1') .* (bin2dec(cmp) - 2^bitsNum);
end
