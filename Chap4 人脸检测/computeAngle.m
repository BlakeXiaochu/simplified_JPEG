function confidence = computeAngle(model, colorFtr)
%计算两矢量的夹角
    confidence = sqrt(model) * sqrt(colorFtr)';
end

