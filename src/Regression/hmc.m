function [samples, energies] = hmc(f, x, options, gradf, ...,
                            XData, yData, lambda, varargs)
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
Eold = feval(f, x, XData, yData, lambda);	% Evaluate starting energy.
nreject = 0;

p = randn(1, nparams);		% Initialise momenta at random


% Debugging for modified MH
noCount = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Precomputations for gradient
XtX = XData' * XData;
Xty = XData' * yData;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main loop.
while n <= nsamples
    %n
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
  gradient = feval(gradf, x, XData, yData, XtX, Xty, lambda, abs(epsilon/2));
%     if(rem(n, 10000) == 0)
%         gradient
%     end
  p = p - 0.5 * epsilon * gradient;
  x = x + epsilon*p;
  
  % Full leapfrog steps.
  for m = 1 : L - 1
    p = p - epsilon*feval(gradf, x, XData, yData, XtX, Xty, lambda, abs(epsilon));
    %p = p - epsilon*feval(gradf, x, data, priorPDF, abs(epsilon), varargs);
    x = x + epsilon*p;
  end
  
  % Final half-step of leapfrog.
  
  p = p - 0.5*epsilon*feval(gradf, x, XData, yData, XtX, Xty, lambda, abs(epsilon/2));

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    metropolis = 1;
  switch metropolis
      case 0
        %Eold = Enew;			% Update energy
        if (display > 0)
          fprintf(1, 'Finished step %4d  Threshold: %g\n', n, a);
        end
            
      case 1
        %Simple metropolis
        % Now apply Metropolis algorithm.
          Enew = feval(f, x, XData, yData, lambda);	% Evaluate new energy.
          p = -p;				% Negate momentum
          Hnew = Enew + 0.5*(p*p');		% Evaluate new Hamiltonian.
          a = exp(Hold - Hnew);			% Acceptance threshold.
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
      
      case 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Batch based metropolis hastings
        % Function signature
        % accept = modifiedMH(data, curSample, prevSample, curP, ...
        %                        prevP, batchSize, threshold, priorPDF);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        batchSize = 30;
        [accept, entireBatch] = ...
                modifiedMH(XData, yData, x, xold, p, pold, lambda, batchSize, 0.1);

        noCount = noCount + entireBatch; 

        % Pass through true MH
        if(entireBatch)
            % Now apply Metropolis algorithm.
          Eold = feval(f, xold, XData, yData, lambda);	% Evaluate old energy.
          Enew = feval(f, x, XData, yData, lambda);	% Evaluate new energy.
          p = -p;				% Negate momentum
          Hold = Eold + 0.5 * (pold * pold');
          Hnew = Enew + 0.5*(p*p');		% Evaluate new Hamiltonian.
          a = exp(Hold - Hnew);			% Acceptance threshold.
            %Simple metropolis
          random_number = rand(1);
          if a > random_number			% Accept the new state.
            accept = true;
          else
              accept = false; % Reject the new state.
          end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if ~accept			% Accept the new state.
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
  
      if n > 0
        samples(n,:) = x;			% Store sample.
        if en_save 
          energies(n) = Eold;		% Store energy.
        end
      end



      % Set momenta for next iteration
      if(rem(n, 50) == 0)
            p = randn(1, nparams);	% Replace all momenta.
      else
          p = -p;
        % Adjust momenta by a small random amount.
          p = alpha.*p + salpha.*randn(1, nparams);
      end
      %p = randn(1, nparams);	% Replace all momenta.

      n = n + 1;
end

%if (display > 0)
  fprintf(1, '\nFraction of samples rejected:  %g\n', ...
    nreject/(nsamples));

    fprintf('Count : %d / %d = %f\n', noCount, n, noCount/n);
%end
return
