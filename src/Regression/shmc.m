function [samples, energies] = shmc(f, x, options, gradf, ...,
                                XData, yData, lambda, batchSize, fisher, varargs)
%HMC	Hybrid Monte Carlo sampling.

display = options(1);

L = max(1, options(7)); % At least one step in leap-frogging
if options(14) > 0
  nsamples = options(14);
else
  nsamples = 100;	% Default
end
% burn in
if options(15) >= 0
  nomit = options(15);
else
  nomit = 0;
end

if options(18) > 0
  step_size = options(18);	% Step size.
else
  step_size = 1/L;		% Default  
end
alpha = 0.1;
salpha = sqrt(1-alpha^2);

x = x(:)';		% Force x to be a row vector
nparams = length(x);

samples = zeros(nsamples, nparams);	% Matrix of returned samples.


en_save = 1;
energies = zeros(nsamples, 1);

n = - nomit + 1;
Eold = feval(f, x, XData, yData, lambda);
nreject = 0;

p = randn(1, nparams);		% Initialise momenta at random

%%%%%%%%%%% Friction additions %%%%%%%%%%%%%%%
Bhat = fisher;
incB = 0.01 * ones(1, length(fisher));% This is C-Bhat
C = Bhat + incB; 
%%%%%%
% C = zeros(size(C));
% incB = zeros(size(incB));
%%%%%%
zeroMu = zeros(1, length(fisher));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        

% Main loop.
noCount = 0

while n <= nsamples
    % Printing for every 1000 iters
    if(rem(n, 1000) == 0)
        fprintf('current Iteration: %d\n', n)
    end

  xold = x;		    % Store starting position.
  pold = p;		    % Store starting momenta
  Hold = Eold + 0.5*(p*p'); % Recalculate Hamiltonian as momenta have changed

    % Choose a direction at random
    if (rand < 0.5)
        direction = -1;
    else
      direction = 1;
    end
    % Perturb step length.
  epsilon = direction*step_size*(1.0 + 0.1*randn(1));

  % First half-step of leapfrog.
  % Pick a batch for stochastic gradient
  batchInds = randi(length(yData), batchSize);
  XBatch = XData(batchInds, :);
  yBatch = yData(batchInds);
  
  gradient = feval(gradf, x, XBatch, yBatch, lambda, abs(epsilon/2), length(yData)) ...
                                - 0.5 * epsilon * (p.* C) + ...
                                0.5 * mvnrnd(zeroMu, 2 * incB * abs(epsilon), 1);
  
%     if(rem(n, 10000) == 0)
%         gradient
%     end
  p = p - 0.5 * epsilon * gradient;
  x = x + epsilon*p;
  
  % Full leapfrog steps.
  for m = 1 : L - 1
      gradient = feval(gradf, x, XBatch, yBatch, lambda, abs(epsilon), length(yData)) ...
                                - epsilon * (p.*C) + ...
                                   mvnrnd(zeroMu, 2*incB * abs(epsilon), 1);
    p = p - epsilon* gradient;
    x = x + epsilon*p;
  end
  
  % Final half-step of leapfrog.
     gradient = feval(gradf, x, XBatch, yBatch, lambda, abs(epsilon/2), length(yData)) ...
                                - 0.5 * epsilon * (p.* C) + ...
                                0.5 * mvnrnd(zeroMu, 2 * incB * abs(epsilon), 1);
                            
    p = p - 0.5*epsilon*gradient;
    
  % Now apply Metropolis algorithm.
  Enew = feval(f, x, data, priorPDF, varargs);	% Evaluate new energy.
  p = -p;				% Negate momentum
  Hnew = Enew + 0.5*p*p';		% Evaluate new Hamiltonian.
  a = exp(Hold - Hnew);			% Acceptance threshold.

  metropolis  = 1;
  if(~metropolis)
      Eold = Enew;			% Update energy
        if (display > 0)
          fprintf(1, 'Finished step %4d  Threshold: %g\n', n, a);
        end
  else
    batchSize = 30;
    [accept, entireBatch] = ...
            modifiedMH(data, x, xold, p, pold, batchSize, 0.05, priorPDF);
        
    noCount = noCount + entireBatch; 
      
      
      % Pass through true MH
    if(entireBatch)
        %Simple metropolis
      random_number = rand(1);
      if a > random_number			% Accept the new state.
        Eold = Enew;			% Update energy
        if (display > 0)
          fprintf(1, 'Finished step %4d  Threshold: %g\n', n, a);
        end
      else					% Reject the new state.
        if n > 0 
          nreject = nreject + 1;
        end
        x = xold;				% Reset position 
        p = pold;   			% Reset momenta
        if (display > 0)
          fprintf(1, '  Sample rejected %4d.  Threshold: %g\n', n, a);
        end
      end
    else
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if accept			% Accept the new state.
            Eold = Enew;			% Update energy
            if (display > 0)
              fprintf(1, 'Finished step %4d  Threshold: %g\n', n, a);
            end
        else					% Reject the new state.
            if n > 0 
              nreject = nreject + 1;
            end
            x = xold;				% Reset position 
            p = pold;   			% Reset momenta
            if (display > 0)
              fprintf(1, '  Sample rejected %4d.  Threshold: %g\n', n, a);
            end    
        end
    end
  end
  
  if n > 0
    samples(n,:) = x;			% Store sample.
    if en_save 
      energies(n) = Eold;		% Store energy.
    end
  end

  % Set momenta for next iteration
  p = randn(1, nparams);	% Replace all momenta.
  n = n + 1;
end

%if (display > 0)
  fprintf(1, '\nFraction of samples rejected:  %g\n', ...
    nreject/(nsamples));
%end
  diagn.pos = diagn_pos;
  diagn.mom = diagn_mom;
  diagn.acc = diagn_acc;

return
