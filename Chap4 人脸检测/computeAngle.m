function confidence = computeAngle(model, colorFtr)
%������ʸ���ļн�
    confidence = sqrt(model) * sqrt(colorFtr)';
end

