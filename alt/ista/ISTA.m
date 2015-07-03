function [ fn, xn, ferror, iter, xdiff, funcdiff ] = ISTA( x0, A, b, lambda, gamma, regType, accel )
%Implementation of the ISTA and FISTA algorithms seeking a 
%sparse solution to the problem Ax=b. More specifically, we attempt to
%solve:
%   min{ f(x) + lambda |x|_1 }
%where f is a likelihood penalty depending on whether we are applying
%logistic or linear regression. The function requires
%the following inputs:
%
%       x0      =   starting point
%       A       =   nxp features matrix ( usually with p >> n )
%       b       =   nx1 vector of observations 
%       lambda  =   parameter governing the sparseness of the solution
%       gamma   =   backtracking parameter in (0,1)
%       regType =   string 'lin' or 'log' dictating whether linear or
%                   logistic regression is applied
%       accel   =   bool that determines if FISTA acceleration is used

%It produces the following outputs:

%       ferror  =   f(x) at termination
%       xn      =   the search point at termination
%       fn      =   the objective function at termination
%       iter    =   the number of iterations completed
%       xdiff   =   norm(xn - x(n-1))
%       funcdiff=   the difference between two successive objective
%                   function values

%
%CHECK INPUTS
%
if size(A,1) ~= size(b,1) || size(A,2) ~= size(x0,1),
    error('A, b, x0 are not of appropriate dimensions')
end

if gamma <= 0 | gamma >= 1,
    error('gamma not in (0,1)')
end

if lambda < 0,
    error('lambda must be nonnegative')
end

%
%INITIALIZE
%
iter        = 0;
xdiff       = 1;
funcdiff    = 1;
xcurrent    = x0;
stepsize    = 1;
searchPoint = x0;

%
%RUN UPDATE LOOP
%
while iter < 5000 && xdiff > 1e-8 && funcdiff > 1e-6,
    xprevious               = xcurrent;
    [stepsize, xcurrent]    = ISTAbacktrack(A, b, searchPoint, lambda, gamma, stepsize, regType);
    
    %update terminating values
    funcdiff    = ISTAlikelihood(searchPoint,A,b,regType) + lambda*norm(searchPoint,1) - ISTAlikelihood(xcurrent,A,b,regType) - lambda*norm(xcurrent,1);

    if ~accel, %regular ISTA search
        searchPoint = xcurrent;
    else %FISTA search point,
        searchPoint = xcurrent + iter / (iter + 2) * (xcurrent - xprevious);
    end
    
    iter        = iter + 1;
    xdiff       = norm(xcurrent - xprevious);
end

xn = xcurrent;
ferror = ISTAlikelihood(xcurrent,A,b,regType);
fn = ferror + lambda*norm(xcurrent,1);

end

