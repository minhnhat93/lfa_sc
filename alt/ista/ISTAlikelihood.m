function [ value ] = ISTAlikelihood( x, A, b, regType )
%This function implements the different likelihood function that we see in
%the ISTA method.

switch regType
    case 'lin'
        value = norm(A*x - b)^2;
    case 'log'
        value = 0;
        for i = 1 : size(A,1)
            value = value + log(1+exp(A(i,:)*x)) - A(i,:)*x*b(i,1);
        end
end

end

