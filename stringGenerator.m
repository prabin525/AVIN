%%Function to generate the final string from the matrix obtained after
%%prediction
function stringAnswer = stringGenerator(outputMatrix)
    s = ''
    m = size(outputMatrix,1);
    
    for i = 1:m
        temp = outputMatrix(i,1)
        strTemp = stringDetector(temp);
        s = strcat(s,strTemp)
    end
    stringAnswer = s
end

