% This function performs a Nelder-Mead search over a parameter space.  It
% takes as inputs a function handle, an initial parameter guess, a vector of starting
% parameter values, and a vector of values by which to perturb the starting
% matrix to generate the initial simplex.  Only dimensions with non-zero
% perturbed values will be searched over.

function [MaxParams, MaxVal] = MyNMsearch(MyFunc,InitParams,Perturb,Options)

% Set the search options
alpha = 1;
gamma = 2;
rho = 0.5;
sigma = 0.5;

% Unpack the terminal options
ValTol = Options.ValTol;
SpanTol = Options.SpanTol;
MaxIter = Options.MaxIter;
Resume = Options.Resume;
DataFile = Options.DataFile;
SaveEveryT = Options.SaveEveryT; % Set this to zero if not saving
DispEveryT = Options.DispEveryT; % Set this to zero if not reporting

% If this is a resumed search, load in the saved data
if Resume,
    load(DataFile);
    disp(['Resuming search after iteration #' num2str(Iter) ' (' num2str(Evals) ' evaluations), maxval = ' num2str(Values(1))]);
else
    % Otherwise, find the parameters that will be maximized over
    ParamsToOpt = Perturb ~= 0;
    K = sum(ParamsToOpt);
    N = numel(InitParams);
    ParamsToOpt = find(ParamsToOpt);
    % Generate the initial simplex
    Simplex = nan(N,K+1);
    Simplex(:,1) = InitParams;
    for k = 1:K,
        Index = ParamsToOpt(k);
        Simplex(:,k+1) = InitParams;
        Simplex(Index,k+1) = Simplex(Index,k+1) + Perturb(Index);
    end
    % Evaluate the points in the initial simplex
    if DispEveryT > 0,
        disp(['Beginning analysis of the initial simplex.  Will evaluate ' num2str(K+1) ' vertices.']);
    end
    Values = nan(1,K+1);
    for k = 1:(K+1),
        TheseParams = Simplex(:,k);
        Values(k) = MyFunc(TheseParams);
    end
    % Sort the initial simplex from best to worst
    [Values Order] = sort(Values,'descend');
    for n = 1:N,
        Simplex(n,:) = Simplex(n,Order);
    end
    if DispEveryT > 0,
        disp(['Finished evaluating the initial simplex.  Beginning search, maxval = ' num2str(Values(1))]);
    end
    Iter = 0;
    Evals = K+1;
end

% Iterate on the Nelder-Mead method until a terminal condition is satisfied
KeepGoing = true;
while KeepGoing,
    BestVal = Values(1);
    BestPt = Simplex(:,1);
    WorstVal = Values(K+1);
    WorstPt = Simplex(:,K+1);
    NextVal = nan;
    NextPt = nan(N,1);
    % Find the center of all but the worst point
    CenterPt = sum(Simplex(:,1:K),2)/K;
    % Find the reflected point and evaluate it.  Use it if it's better than
    % the second worst.
    ReflectPt = CenterPt + alpha*(CenterPt - WorstPt);
    ReflectVal = MyFunc(ReflectPt);
    Evals = Evals + 1;
    if ReflectVal > Values(K),
        NextVal = ReflectVal;
        NextPt = ReflectPt;
    end
    % Find and evaluate the expanded point if the reflected point is the
    % best so far.  Use it if it's better than the reflected point.
    if ReflectVal > BestVal,
        ExpandPt = CenterPt + gamma*(CenterPt - WorstPt);
        ExpandVal = MyFunc(ExpandPt);
        Evals = Evals + 1;
        if ExpandVal > ReflectVal,
            NextVal = ExpandVal;
            NextPt = ExpandPt;
        end
    end
    % If the reflected point is worse than the second worst, find and
    % evaluate the contracted point.  Use it if it's better than the worst.
    if isnan(NextVal),
        ContractPt = CenterPt + rho*(CenterPt - WorstPt);
        ContractVal = MyFunc(ContractPt);
        Evals = Evals + 1;
        if ContractVal > WorstVal,
            NextVal = ContractVal;
            NextPt = ContractPt;
        end
    end
    % If an acceptable point has been found, substitute it for the worst
    if ~isnan(NextVal),
        Simplex(:,K+1) = NextPt;
        Values(K+1) = NextVal;
    % Otherwise, have to reduce all but the best point
    else
        for k = 2:(K+1),
            ThisPt = Simplex(:,k);
            ReducePt = BestPt + sigma*(ThisPt - BestPt);
            ReduceVal = MyFunc(ReducePt);
            Evals = Evals + 1;
            Simplex(:,k) = ReducePt;
            Values(k) = ReduceVal;
        end
    end
    % Re-order the simplex from best to worst
    [Values Order] = sort(Values,'descend');
    for n = 1:N,
        Simplex(n,:) = Simplex(n,Order);
    end
    % Check the terminal conditions
    Diff = abs(Values(1) - Values(K+1));
    Span = sqrt(sum((Simplex(:,1) - Simplex(:,K+1)).^2));
    Iter = Iter + 1;
    if ((Diff < ValTol) || (Span < SpanTol)) || (Iter >= MaxIter),
        KeepGoing = false;
    end
    % If this is a Tth iteration, save the progress to the specified file
    if mod(Iter,SaveEveryT) == 0,
        save(DataFile,'Simplex','Values','Iter','Evals','K','N','ParamsToOpt');
    end
    if mod(Iter,DispEveryT) == 0,
        disp(['Finished iteration #' num2str(Iter) ' (' num2str(Evals) ' evaluations): maxval = ' num2str(Values(1)) ', span = ' num2str(Span) ', diff = ' num2str(Diff)]);
    end
end

% Report the output
if SaveEveryT ~= 0,
    save(DataFile,'Simplex','Values','Iter','Evals','K','N','ParamsToOpt');
end
MaxParams = Simplex(:,1);
MaxVal = Values(1);
