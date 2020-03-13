%--------------------------------------------------------------------------
% PMA_SubcatalogEnumerationAlg_v2.m
% Generate all subcatalogs for a provided (P,R) under some additional
% network structure constraints
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [L,R,P] = PMA_SubcatalogEnumerationAlg_v2(Rmin,Rmax,Pmin,Pmax,...
    nscNrmin,nscNrmax,nscNpmin,nscNpmax,PENmatrix,PENvalue,SATmatrix,...
    SATvalue,displevel)

% set flags
if nscNrmax == uint64(inf)
    Nrflag = false;
else
    Nrflag = true;
end
if nscNpmax == uint64(inf)
    Npflag = false;
else
    Npflag = true;
end
if isempty(PENvalue)
    PENflag = false;
else
    PENflag = true;
end
if isempty(SATvalue)
    SATflag = false;
else
    SATflag = true;
end

% overall maximum ports and replicates for any type
NPmax = max([Pmin,Pmax]); NRmax = max([Rmin,Rmax]);

% initialize storage
Rs = cell(NPmax+1,NPmax,NRmax); % +1 offset because of 0 indexing
Ps = cell(NPmax+1,NPmax,NRmax); % +1 offset because of 0 indexing

% number of types
Nt = length(Rmin);

% initialize
R = zeros(1,0); P = zeros(1,0); L = zeros(1,0); PEN = 0;

% go through each type
for k = 1:Nt
    % size of previous catalogs
    if k == 1
        Nc = 1; % initially only 1 catalog
    else
        Nc = size(R,1); % compute the previous number of catalogs
    end

    % initialize
    Rg = cell(Nc,1); Pg = cell(Nc,1); Lg = cell(Nc,1); PENg = cell(Nc,1);
    idx = 0;

    % go through previous catalogs
    for ic = 1:Nc
        % extract previous catalog
        Rc = R(ic,:); % replicates
        Pc = P(ic,:); % ports
        Lc = L(ic,:); % labels
        if PENflag
            PENc = PEN(ic); % penalty values
        end

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
                r,Pmin(k),Pmax(k),Rs,Ps,nscNrmax,Nrflag,nscNpmax,Npflag);

            %--------------------------------------------------------------
            % enhancement: port counts
            %--------------------------------------------------------------
            % find all subcatalogs that don't have too many ports
            if Npflag
                I = sum(Rc.*Pc,2) + sum(Rp.*Pp,2) <= nscNpmax;

                % extract feasible subcatalogs
                Rp = Rp(I,:);
                Pp = Pp(I,:);
            end
            %--------------------------------------------------------------

            %--------------------------------------------------------------
            % enhancement: linear penalty constraints
            %--------------------------------------------------------------
            if PENflag
                % calculate current penalty
                PENp = sum(PENmatrix(:,k).*double(Rp),2);

                % calculate total penalty
                PENp = PENc + PENp';

                % find all subcatalogs that satisfy linear penalty constraints
                I = all(PENp <= PENvalue(:)',2);

                % extract feasible subcatalogs
                Rp = Rp(I,:);
                Pp = Pp(I,:);
                PENp = PENp(I,:);
            end
            %--------------------------------------------------------------

            % number of feasible subcatalogs
            NI = size(Rp,1);

            % combine current replicate results with current subcatalogs
            Llocal = [Lc,repmat(k,1,size(Rp,2))];
            Rlocal = [repmat(Rc,NI,1),Rp];
            Plocal = [repmat(Pc,NI,1),Pp];

            % increment index
            idx = idx + 1;

            % if extra storage is needed
            if size(Rg,1) < idx
                Lg = [Lg;cell(2*Nc,1)];
                Rg = [Rg;cell(2*Nc,1)];
                Pg = [Pg;cell(2*Nc,1)];
                if PENflag
                    PENg = [PENg;cell(2*Nc,1)];
                end
            end

            % add
            Lg{idx} = repmat(Llocal,NI,1);
            Rg{idx} = Rlocal;
            Pg{idx} = Plocal;
            if PENflag
                PENg{idx} = PENp;
            end

        end
    end

    % determine which subcatalog groupings are empty
    Iremove = cellfun(@isempty, Rg);

    % check if any subcatalog groupings should be removed
    if any(Iremove)
        % remove empty entries
        Lg(Iremove) = []; Rg(Iremove) = []; Pg(Iremove) = [];
    end

    % compute rows and columns for each subcatalog grouping
    [Rnrows,Rncols] = cellfun(@size, Rg);

    % if padding is needed
    if any(diff(Rncols))

        % maximum number of entries in a subcatalog grouping
        Nmax = max(Rncols);

        % go through each subcatalog grouping
        for ic = 1:length(Rncols)

            % compute padding matrix
            zpad = zeros(Rnrows(ic),Nmax-Rncols(ic));

            % pad
            Lg{ic} = [Lg{ic},zpad];
            Rg{ic} = [Rg{ic},zpad];
            Pg{ic} = [Pg{ic},zpad];
        end

    end

    % assign current list of catalogs
    L = vertcat(Lg{:}); R = vertcat(Rg{:}); P = vertcat(Pg{:});
    if PENflag
        PEN = vertcat(PENg{:});
    end

    % output some stats to the command window
    if (displevel > 1) % minimal
        ttime = toc; % stop the timer
        disp(strcat(string(length(R))," subcatalogs in ",string(ttime)," s"))
    end

end

% check minimum number of replicates
if Nrflag
    Ik = sum(R,2) >= nscNrmin;
    L = L(Ik,:); R = R(Ik,:); P = P(Ik,:);
end

% check minimum number of ports
if Npflag
    Ik = sum(P.*R,2) >= nscNpmin;
    L = L(Ik,:); R = R(Ik,:); P = P(Ik,:);
end

% check linear satisfaction constraints
if SATflag
    for k = 1:length(SATvalue)
        PENl = PMA_changem(L,[0 SATmatrix(k,:)],0:size(L,2));
        Ik = dot(PENl,double(R),2) >= SATvalue(k);
        L = L(Ik,:); R = R(Ik,:); P = P(Ik,:);
    end
end

% convert data type
R = double(R); P = double(P);

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
    R = zeros(1,1,'uint8');
    P = zeros(1,1,'uint8');
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
Rdone = cell(n,1); Pdone = cell(n,1);

% go through each replicate
for k = 1:n

    % check if any catalogs remain
    if isempty(R)
        R = []; P = []; % clear
        break % continue, too many replicates to continue
    end

    % number of remaining replicates
    Nr = n - sum(R,2);

    % find all catalogs that have no remaining ports
    done = (Nr == 0);

    % check if any catalogs have all replicates allocated
    if any(done)
        % assign done
        Rdone{k} = R(done,:);
        Pdone{k} = P(done,:);

        % remove done
        R(done,:) = []; P(done,:) = []; Nr(done) = [];
    end

    % current number of catalogs
    Nc = size(R,1);

    % sequence of replicate counts
    rs = 1:max(Nr);

    % initialize
    rstorage = cell(1,length(rs));
    r2 = cell(1,Nc);

    % create increasing replicate sequence (e.g. {[1],[1,2],[1,2,3]}
    for ip = 1:length(rs)
        rstorage{ip} = 1:rs(ip);
    end

    % assign appropriate replicate sequences
    r2(:) = rstorage(Nr);

    % replicate
    R = repelem(R,Nr,1);
    P = repelem(P,Nr,1);

    % assign current number of ports
    R(:,k) = horzcat(r2{:})';

    %----------------------------------------------------------------------
    % enhancement: replicate counts
    %----------------------------------------------------------------------
    if Rflag
        failed = (sum(R,2) > nscNrmax);
        if all(failed)
            R = []; P = []; % clear
            break % continue, too many replicates to continue
        end

        % remove failed
        R(failed,:) = []; P(failed,:) = [];
    end
    %----------------------------------------------------------------------

    % current number of catalogs
    Nc = size(R,1);

    % update minimum value of port quantity
    % increment value by 1 to ensure increasing port quantities
    if k == 1
        pmin = repelem(PMIN,Nc,1);
    else
        pmin = max(P,[],2)+1;
    end

    % sequence of port counts
    ps = min(pmin):pmax;

    % change to linear indexing
    pmin2 = PMA_changem(pmin,1:length(ps),ps);

    % initialize
    pstorage = cell(1,length(ps)+1+max(pmin));
    p2 = cell(1,Nc);

    % create shrinking port sequence (e.g. {[1,2,3],[2,3],[3]}
    for ip = 1:length(ps)
        pstorage{ip} = ps(ip):pmax;
    end

    % assign empty array to appropriate entries
    pstorage(length(ps)+1:end) = {zeros(1,0)};

    % assign appropriate port sequences
    p2(:) = pstorage(pmin2);

    % replicate
    R = repelem(R,pmax+1-pmin,1);
    P = repelem(P,pmax+1-pmin,1);

    % assign current number of ports
    P(:,k) = horzcat(p2{:})';

    %----------------------------------------------------------------------
    % enhancement: port counts
    %----------------------------------------------------------------------
    if Pflag
        failed = (sum(R.*P,2) > nscNpmax);
        if all(failed)
            R = []; P = []; % clear
            break % continue, too many ports to continue
        end

        % remove failed
        R(failed,:) = []; P(failed,:) = [];
    end
    %----------------------------------------------------------------------

end

% combine
R = [vertcat(Rdone{:});R];
P = [vertcat(Pdone{:});P];

% assign to storage elements
Rs{PMIN+1,pmax,n} = R;
Ps{PMIN+1,pmax,n} = P;

end