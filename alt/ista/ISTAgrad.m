function [ gradvalue ] = ISTAgrad( xprevious, A, b, regType )
%function that implements the different gradients needed for the ISTA
%method.

switch regType
    case 'lin'
        gradvalue = 2*A'*(A*xprevious - b);
    case 'log'
        for i = 1 : size(A,1)
            p(i,1) = 1/(1+exp(-A(i,:)*xprevious));
        end
        gradvalue = A'*(p - b);        
end

end

