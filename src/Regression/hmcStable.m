function [samples, energies, diagn] = hmc(f, x, options, gradf, ...,
                                data, priorPDF, varargs)
%HMC	Hybrid Monte Carlo sampling.
%
%	Description
%	SAMPLES = HMC(F, X, OPTIONS, GRADF) uses a  hybrid Monte Carlo
%	algorithm to sample from the distribution P ~ EXP(-F), where F is the
%	first argument to HMC. The Markov chain starts at the point X, and
%	the function GRADF is the gradient of the `energy' function F.
%
%	HMC(F, X, OPTIONS, GRADF, P1, P2, ...) allows additional arguments to
%	be passed to F() and GRADF().
%
%	[SAMPLES, ENERGIES, DIAGN] = HMC(F, X, OPTIONS, GRADF) also returns a
%	log of the energy values (i.e. negative log probabilities) for the
%	samples in ENERGIES and DIAGN, a structure containing diagnostic
%	information (position, momentum and acceptance threshold) for each
%	step of the chain in DIAGN.POS, DIAGN.MOM and DIAGN.ACC respectively.
%	All candidate states (including rejected ones) are stored in
%	DIAGN.POS.
%
%	[SAMPLES, ENERGIES, DIAGN] = HMC(F, X, OPTIONS, GRADF) also returns
%	the ENERGIES (i.e. negative log probabilities) corresponding to the
%	samples.  The DIAGN structure contains three fields:
%
%	POS the position vectors of the dynamic process.
%
%	MOM the momentum vectors of the dynamic process.
%
%	ACC the acceptance thresholds.
%
%	S = HMC('STATE') returns a state structure that contains the state of
%	the two random number generators RAND and RANDN and the momentum of
%	the dynamic process.  These are contained in fields  randstate,
%	randnstate and mom respectively.  The momentum state is only used for
%	a persistent momentum update.
%
%	HMC('STATE', S) resets the state to S.  If S is an integer, then it
%	is passed to RAND and RANDN and the momentum variable is randomised.
%	If S is a structure returned by HMC('STATE') then it resets the
%	generator to exactly the same state.
%
%	The optional parameters in the OPTIONS vector have the following
%	interpretations.
%
%	OPTIONS(1) is set to 1 to display the energy values and rejection
%	threshold at each step of the Markov chain. If the value is 2, then
%	the position vectors at each step are also displayed.
%
%	OPTIONS(5) is set to 1 if momentum persistence is used; default 0,
%	for complete replacement of momentum variables.
%
%	OPTIONS(7) defines the trajectory length (i.e. the number of leap-
%	frog steps at each iteration).  Minimum value 1.
%
%	OPTIONS(9) is set to 1 to check the user defined gradient function.
%
%	OPTIONS(14) is the number of samples retained from the Markov chain;
%	default 100.
%
%	OPTIONS(15) is the number of samples omitted from the start of the
%	chain; default 0.
%
%	OPTIONS(17) defines the momentum used when a persistent update of
%	(leap-frog) momentum is used.  This is bounded to the interval [0,
%	1).
%
%	OPTIONS(18) is the step size used in leap-frogs; default 1/trajectory
%	length.
%
%	See also
%	METROP
%

%	Copyright (c) Ian T Nabney (1996-2001)

% Global variable to store state of momentum variables: set by set_state
% Used to initialise variable if set

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

diagn_pos = zeros(nsamples, nparams);
diagn_mom = zeros(nsamples, nparams);
diagn_acc = zeros(nsamples, 1);

n = - nomit + 1;
Eold = feval(f, x, data, priorPDF, varargs);	% Evaluate starting energy.
nreject = 0;

p = randn(1, nparams);		% Initialise momenta at random
lambda = 1;

% Main loop.
while n <= nsamples
    % Printing for every 1000 iters
    if(rem(n, 10000) == 0)
        fprintf('current Iteration: %d\n', n)
    end

  xold = x;		    % Store starting position.
  pold = p;		    % Store starting momenta
  Hold = Eold + 0.5*(p*p'); % Recalculate Hamiltonian as momenta have changed

    % Choose a direction at random
    if (rand < 0.5)
      lambda = -1;
    else
      lambda = 1;
    end
    
    
    % Perturb step length.
    epsilon = lambda*step_size*(1.0 + 0.1*randn(1));
  %epsilon = lambda*step_size*(1.0 + 0.1*randn(1))/min(nthroot(max(n, 1), 2), 200);
 %L1 = ceil(L * min(nthroot(max(n, 1), 2), 200));
  %epsilon = lambda*step_size*(1.0 + 0.1*randn(1)) / min(nthroot(max(n,4), 5), 100);

  % First half-step of leapfrog.
  gradient = feval(gradf, x, data, priorPDF, abs(epsilon/2), varargs);
    if(rem(n, 10000) == 0)
        gradient
    end
  p = p - 0.5 * epsilon * gradient;
  x = x + epsilon*p;
  
  % Full leapfrog steps.
  for m = 1 : L - 1
  %for m = 1 : L1 - 1
    p = p - epsilon*feval(gradf, x, data, priorPDF, abs(epsilon), varargs);
    x = x + epsilon*p;
  end
  
  % Final half-step of leapfrog.
  p = p - 0.5*epsilon*feval(gradf, x, data, priorPDF, abs(epsilon/2), varargs);

  % Now apply Metropolis algorithm.
  Enew = feval(f, x, data, priorPDF, varargs);	% Evaluate new energy.
  p = -p;				% Negate momentum
  Hnew = Enew + 0.5*(p*p');		% Evaluate new Hamiltonian.
  a = exp(Hold - Hnew);			% Acceptance threshold.
  if (n > 0)
    diagn_pos(n,:) = x;
    diagn_mom(n,:) = p;
    diagn_acc(n,:) = a;
  end
  
  if (display > 1)
    fprintf(1, 'New position is\n');
    disp(x);
  end
  
  metropolis  = 1;
  if(~metropolis)
      Eold = Enew;			% Update energy
        if (display > 0)
          fprintf(1, 'Finished step %4d  Threshold: %g\n', n, a);
        end
  else
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
%end
  diagn.pos = diagn_pos;
  diagn.mom = diagn_mom;
  diagn.acc = diagn_acc;

return