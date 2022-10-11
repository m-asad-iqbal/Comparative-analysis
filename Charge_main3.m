clc;
TOUprice = ones(24,1)*0.869;
TOUprice([1:6,24]) = 0.356;
TOUprice([7:9,13:16,22,23]) = 0.687;

%% Generating data of Distance and its Cumulative Probability
% The mean and standard deviation
uD = 3.2;
sD = 0.88;
% PDF of distance
pdf1 = @(x)(1./x/sD/(2*pi)^0.5.*exp(-(log(x)-uD).^2/2/sD^2));
% Generating Distance data
dRange = 1:1:300;
% Calculating Probability
pd = pdf1(dRange);
% Calculating Cumulative Probability
cpd = cumsum(pd);
% Normalizing Cumulative Probability
cpd = ( cpd-min(cpd) )/( max(cpd)-min(cpd) );

%% Generating data of Coming Home Time "s" and its Cumulative Probability
% The mean and standard deviation
uS = 17.6;
sS = 3.4;
% PDF of s part a (uS-12 <= s <= 24)
pdf2a = @(x)(1/sS/(2*pi)^0.5*exp(-(x-uS).^2/2/sS^2));
% Generating s data part a
sRangea = [5.6,6:0.5:24];
% Calculating Probability part a
psa = pdf2a(sRangea);
% PDF of s part b (0 <= s <= uS-12)
pdf2b = @(x)(1/sS/(2*pi)^0.5*exp(-(x+24-uS).^2/2/sS^2));
% Generating s data part b
sRangeb = 0:1:5.5;
% Calculating Probability part b
psb = pdf2b(sRangeb);
% Combining both part into one set of Data
sRange = [sRangeb, sRangea];
ps = [psb, psa];
% Calculating Cumulative Probability
cps = cumsum(ps);
% Normalizing
cps = ( cps-min(cps) )/( max(cps)-min(cps) );

%% Strategy Selection
for coor = 0:5
%% Monte Carlo
% Ns - List of Number of Total EVs, N
%N = [13000, 40000, 70000, 130000];
N = [10000, 20000, 30000, 40000];
Ncs = round(N/3);

% List of Car Endurance as in Table 1
Ds = [105, 160, 295];
% List of Car Battery Capacity as in Table 1
Cas = [19.2, 24, 63.3];
% Charging power
p = 3.3;
% Monte Carlo Tolerance
Tol = 0.002;

% Initializing matrix, Total Load in various N
LN = zeros(length(N),24);
% Initializing matrix, Load for various car in the selected N
kselect = 3;
Lk = zeros(length(Ds),24);

for k = 1:length(Ncs);
    Nc = Ncs(k);
    
    % Initializing matrix, Total Load
    L = zeros(1,24);
    for j = 1:3  
        D = Ds(j);
        C = Cas(j);
        
        e = Tol;
        % While the error is greater than Tolerance, Monte carlo will
        % restart again
        while e >= Tol
            % Initializing matrix, Load for individual vehicle
            Li = zeros(Nc,24);            
            % Generating random distance covered "d" according to
            % probability distribution
            d = interp1(cpd,dRange,rand(Nc,1));
            % Generating random arrive time "s" according to
            % probability distribution
            s = interp1(cps,sRange,rand(Nc,1));
            % Rounding up s to the nearest hour
            s = ceil(s);
            % Calculating SOC remaining
            SOC = 1-d/D;
            % Converting SOC to capacity
            Cs = SOC*C;
            % Calculating charging time and rounding up to hour
            Ct = ceil((C-Cs)/p);
            
            for i = 1:Nc
                %% Uncoordinated and Coordinated
                % For uncoordinated set coor = 0
                % For coordinated case 1 set coor = 1
                % coor = 2;
                switch coor
                    case 1
                        if SOC(i)>0.3 && s(i)>=19 && s(i)<=22
                            s(i) = s(i)+5;
                        end
                        
                    case 2
                        if SOC(i)>0.3 && s(i)>=16 && s(i)<=22
                            s(i) = s(i)+5;
                        end
                    
                    case 3
                        if SOC(i)>0.3 && s(i)>=16 && s(i)<=22
                            if rand<0.9
                                s(i) = 22;
                            else
                                s(i) = 23;
                            end
                        end
                        
                    case 4
                        if SOC(i)>0.3
                            Price = [TOUprice; TOUprice];
                            lowcost = Inf;
                            for m = 1:Ct(i)
                                st = s(i)+m;
                                en = s(i)+m+Ct(i)-1;
                                if (st<7)&&(en>=7)
                                    break
                                elseif (st<31)&&(en>=31)
                                    break
                                end
                                cost = sum(Price(st:en)*p);
                                if cost<lowcost
                                    lowcost = cost;
                                    lowm = m;
                                end
                            end
                            s(i) = s(i)+lowm;
                        end
                        if (s(i)==7)||(s(i)==31)
                            s(i) = s(i)+1;
                        end
                        if (s(i)<7)&&(s(i)+Ct(i)-1>=7)
                            Ct(i) = 7-s(i);
                        elseif (s(i)<31)&&(s(i)+Ct(i)-1>=31)
                            Ct(i) = 31-s(i);
                        end
                        
                    case 5
                        if SOC(i)>0.3
                            Price = [TOUprice; TOUprice];
                            lowcost = Inf;
                            for m = 1:24
                                st = s(i)+m;
                                en = s(i)+m+Ct(i)-1;
                                if (st<7)&&(en>=7)
                                    break
                                elseif (st<31)&&(en>=31)
                                    break
                                end
                                cost = sum(Price(st:en)*p);
                                if cost<lowcost
                                    lowcost = cost;
                                    lowm = m;
                                end
                            end
                            s(i) = s(i)+lowm;
                        end
                        if (s(i)==7)||(s(i)==31)
                            s(i) = s(i)+1;
                        end
                        if (s(i)<7)&&(s(i)+Ct(i)-1>=7)
                            Ct(i) = 7-s(i);
                        elseif (s(i)<31)&&(s(i)+Ct(i)-1>=31)
                            Ct(i) = 31-s(i);
                        end
                end
                
                %% Assigning load p the selected time slot    
                L2days = zeros(1,48);
                % Assigning load p to time slot s until s+Ct-1
                L2days(s(i):(s(i)+Ct(i)-1)) = p;
                % Rearranging the load to correct position
                Li(i,:) = L2days(1:24)+L2days(25:end);
            end
            
            % Convergence Calculation
            Lc = cumsum(Li);
            Lcmin = min(Lc,[],2);
            Lcmax = max(Lc,[],2);
            iDay = ones(1,24);
            Lc = (Lc-Lcmin*iDay)./((Lcmax-Lcmin)*iDay);
            e = sum(abs(Lc(end,:)-Lc(end-1,:)));  
            e
        end
        e
        % Updating total Load matrix
        L = L+sum(Li);
        % Recording Load for each vehicle type at the first N
        if k == kselect
            Lk(j,:) = sum(Li);
        end
    end
    % Recording total load matrix to LN
    LN(k,:) = L;
end

switch coor
    case 0
        Lk0 = Lk; LN0 = LN;
    case 1
        Lk1 = Lk; LN1 = LN;
    case 2
        Lk2 = Lk; LN2 = LN;
    case 3
        Lk3 = Lk; LN3 = LN;
    case 4
        Lk4 = Lk; LN4 = LN;
    case 5
        Lk5 = Lk; LN5 = LN;
end
end    
%% Plotting
Charge_plot(N,Lk,LN,kselect);

%% Cost calculation

TCost = LN*TOUprice