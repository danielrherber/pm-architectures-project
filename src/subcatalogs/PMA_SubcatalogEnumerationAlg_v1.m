%--------------------------------------------------------------------------
% PMA_SubcatalogEnumerationAlg_v1.m
% Generate all subcatalogs for a provided (P,R) under some additional
% network structure constraints
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [L,R,P] = PMA_SubcatalogEnumerationAlg_v1(Rin,Pin,NSC,opts)

% extract
Rmin = Rin.min; Rmax = Rin.max;
Pmin = Pin.min; Pmax = Pin.max;
nscNrmin = NSC.Nr(1); nscNrmax = NSC.Nr(2);
nscNpmin = NSC.Np(1); nscNpmax = NSC.Np(2);

% set flags
if nscNrmax == uint64(inf)
    Rflag = false;
else
    Rflag = true;
end
if nscNpmax == uint64(inf)
    Pflag = false;
else
    Pflag = true;
end

% overall maximum ports and replicates for any type
NPmax = max([Pmin,Pmax]); NRmax = max([Rmin,Rmax]);

% initialize storage
Rs = cell(NPmax+1,NPmax,NRmax); % +1 offset because of 0 indexing
Ps = cell(NPmax+1,NPmax,NRmax); % +1 offset because of 0 indexing

% number of types
Nt = length(Rmin);

% initialize
R = {[]}; P = {[]}; L = {[]};

% go through each type
for k = 1:Nt
    % size of previous catalogs
    if k == 1
        Nc = 1; % initially only 1 catalog
    else
        Nc = size(R,2); % compute the previous number of catalogs
    end

    % initialize
    Lnow = {}; Rnow = {}; Pnow = {};

    % go through previous catalogs
    for ic = 1:Nc
        % extract previous catalog
        Rc = R{ic}; % replicates
        Pc = P{ic}; % ports
        Lc = L{ic}; % labels

        % go through each number of replicates
        for r = Rmin(k):Rmax(k)
            %--------------------------------------------------------------
            % enhancement: replicate counts
            %--------------------------------------------------------------
            if (sum(Rc) + r > nscNrmax)
                continue % continue, too many replicates
            end
            %--------------------------------------------------------------

            % determine all subcatalogs (or use previous result)
            [Rp,Pp,Rs,Ps] = PMA_SubcatalogEnumerationAlg_Ports(...
                r,Pmin(k),Pmax(k),Rs,Ps,nscNrmax,Rflag,nscNpmax,Pflag);

            %--------------------------------------------------------------
            % enhancement: port counts
            %--------------------------------------------------------------
            % find all subcatalogs that don't have too many ports
            if ic ~= 1
                I = sum(Rc.*Pc,2) + sum(Rp.*Pp,2) <= nscNpmax;

                % extract feasible subcatalogs
                Rp = Rp(I,:);
                Pp = Pp(I,:);
            end
            %--------------------------------------------------------------

            % number of feasible subcatalogs
            NI = size(Rp,1);

            % combine current replicate results with current subcatalogs
            Llocal = [Lc,repmat(k,1,size(Rp,2))];
            Rlocal = [repmat(Rc,NI,1),Rp];
            Plocal = [repmat(Pc,NI,1),Pp];

            % append feasible subcatalogs
            for ip = 1:NI
                Lnow{end+1} = Llocal;
                Rnow{end+1} = Rlocal(ip,:);
                Pnow{end+1} = Plocal(ip,:);
            end
        end
    end

    % assign current list of catalogs
    L = Lnow;
    R = Rnow;
    P = Pnow;

    % output some stats to the command window
    if (opts.displevel > 0) % minimal
        ttime = toc; % stop the timer
        disp(['Created ',num2str(length(R)),' subcatalogs in ',num2str(ttime),' s'])
    end

end

% counts for each subcatalog
Lcounts = cellfun(@length,L);

% maximum subcatalog size
Nmax = max(Lcounts);

% pad vectors with zeros
for k = 1:length(L)
    zeropad = zeros(1,Nmax-Lcounts(k));
    L{k} = [L{k},zeropad];
    R{k} = [R{k},zeropad];
    P{k} = [P{k},zeropad];
end

% combine
L = vertcat(L{:});
R = vertcat(R{:});
P = vertcat(P{:});

% check minimum number of replicates
if Rflag
    Ik = sum(R,2) >= nscNrmin;
    L = L(Ik,:);
    R = R(Ik,:);
    P = P(Ik,:);
end

% check minimum number of ports
if Pflag
    Ik = sum(P.*R,2) >= nscNpmin;
    L = L(Ik,:);
    R = R(Ik,:);
    P = P(Ik,:);
end

% convert data type
R = double(R);
P = double(P);

end
%
function [R,P,Rs,Ps] = PMA_SubcatalogEnumerationAlg_Ports(n,pmin,pmax,...
    Rs,Ps,nscNrmax,Rflag,nscNpmax,Pflag)

%--------------------------------------------------------------------------
% simple cases
%--------------------------------------------------------------------------
% no replicates
if n == 0
    % assign
    R = zeros(1,0,'uint8');
    P = zeros(1,0,'uint8');
    return
end

% no choice in the number of ports
if (pmin == pmax)
    % assign
    R = uint8(n);
    P = uint8(pmin);
    return
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% see if previous results are available
%--------------------------------------------------------------------------
% extract and assign
R = Rs{pmin+1,pmax,n};

% check if it is empty
if ~isempty(R)
    % assign
    P = Ps{pmin+1,pmax,n};
    return
end
%--------------------------------------------------------------------------

% store minimum value of pmin (it may be changed later)
PMIN = pmin;

% initialize
R = zeros(1,n,'uint8');
P = zeros(1,n,'uint8');

% go through each replicate
for k = 1:n
    % reset
    idx = 0;

    % size of previous catalogs
    Nc = size(R,1);

    % maximum number of new catalogs (better bound?)
    Nmax = Nc*(pmax-PMIN+1)*(n-k+1);
    Nadd = 1e5;
    Nmax = min(Nadd,Nmax);

    % preallocate
    Rnow = zeros(Nmax,n,'uint8');
    Pnow = zeros(Nmax,n,'uint8');

    % go through previous catalogs
    for ic = 1:Nc
        % copy previous catalog
        Rlocal = R(ic,:); % replicates
        Plocal = P(ic,:); % ports

        % number of remaining replicates
        Nr = n - sum(Rlocal);

        % continue if no replicates remain
        if (Nr == 0)
            % increment counter
            idx = idx + 1;

            % check if we need to increase storage size
            if idx > size(Rnow,1)
                Rnow = [Rnow;zeros(Nmax,n,'uint8')];
                Pnow = [Pnow;zeros(Nmax,n,'uint8')];
            end

            % assign
            Rnow(idx,:) = Rlocal;
            Pnow(idx,:) = Plocal;
            continue
        end

        % go through assigning the number of replicates to the bin
        for r = 1:Nr
            % update minimum value of port quantity
            if k == 1
                % for first replicate quantity, don't change pmin
                % pmin = pmin;
            else
                % increment value by 1 to ensure increasing port quantities
                pmin = Plocal(k-1)+1;
            end

            % assign current number of replicates
            Rlocal(k) = r;

            %--------------------------------------------------------------
            % enhancement: replicate counts
            %--------------------------------------------------------------
            if Rflag
                if (sum(Rlocal) > nscNrmax)
                    continue % continue, too many replicates
                end
            end
            %--------------------------------------------------------------

            % go through each possible port quantity
            for p = pmin:pmax
                % assign current number of ports
                Plocal(k) = p;

                %----------------------------------------------------------
                % enhancement: port counts
                %----------------------------------------------------------
                if Pflag
                    if (sum(Rlocal.*Plocal,2) > nscNpmax)
                        continue % continue, too many ports
                    end
                end
                %----------------------------------------------------------

                % increment counter
                idx = idx + 1;

                % check if we need to increase storage size
                if idx > size(Rnow,1)
                    Rnow = [Rnow;zeros(Nmax,n,'uint8')];
                    Pnow = [Pnow;zeros(Nmax,n,'uint8')];
                    disp(1)
                end

                % assign
                Rnow(idx,:) = Rlocal;
                Pnow(idx,:) = Plocal;
            end % for p = pmin:pmax
        end % for r = 1:Nr
    end % for ic = 1:Nc

    % extract the current catalogs
    Rnow = Rnow(1:idx,:);
    Pnow = Pnow(1:idx,:);

    % assign current list of catalogs
    R = Rnow;
    P = Pnow;
end

% assign to storage elements
Rs{PMIN+1,pmax,n} = R;
Ps{PMIN+1,pmax,n} = P;

end