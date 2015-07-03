function [ newStep, trialPoint ] = ISTAbacktrack(A, b, xprevious, lambda, gamma, stepsize, regType)
%Simple backtracking method used in ISTA.m algorithm

numTrials   = 0;
newStep     = stepsize;
gradvalue   = ISTAgrad( xprevious, A, b, regType );
trialPoint  = softThreshold(xprevious - newStep*gradvalue, lambda*newStep);
difference  = ISTAlikelihood(trialPoint,A,b,regType) - ISTAlikelihood(xprevious,A,b,regType) - (trialPoint-xprevious)'*gradvalue-1/(2*newStep)*norm(trialPoint-xprevious)^2;

while numTrials < 100 && difference > 0,
    numTrials = numTrials + 1;
    newStep = newStep*gamma;
    trialPoint  = softThreshold(xprevious - newStep*gradvalue, lambda*newStep);
    difference  = ISTAlikelihood(trialPoint,A,b,regType) - ISTAlikelihood(xprevious,A,b,regType) - (trialPoint-xprevious)'*gradvalue-1/(2*newStep)*norm(trialPoint-xprevious)^2;
end


if numTrials == 100,
    error('backtracking failed')
end

end
