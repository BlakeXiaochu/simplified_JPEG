function compressRatio = computeCompressRatio(imgHeight, imgWidth, codeDC, codeAC)
    compressRatio = imgHeight * imgWidth * 8 / (numel(codeDC) + numel(codeAC));
end

