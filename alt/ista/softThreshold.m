function [ vec ] = softThreshold( vec, thresh )
%This method applies a soft threshold to the input vector
%   The entries of the new vector are ( |vec| - thresh)_+ sgn(vec).
%   For example, softThreshold([1,3,-2,-1/2,-5], 2) = [0,1,0,0,-3]

for i = 1:size(vec,1)
    for j = 1:size(vec,2)
        if vec(i,j) > thresh
            vec(i,j) = vec(i,j)-thresh;
        elseif vec(i,j) < -thresh
            vec(i,j) = vec(i,j)+thresh;
        else
            vec(i,j) = 0;
        end
    end
end

end

