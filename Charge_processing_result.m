clc
%% Plotting Charging Profile for Different Cars and Total Charging Profile
% Figure 4, 5 and 6 in the paper
Charge_plot(N,Lk0,LN0,3);
%% Ploting Effect of different scale EVs to the original load
% Figure 7
oriLoad = [16175.28
           14217.35
           13067.67
           12934.92
           12526.87
           14232.49
           16642.68
           25952.86
           36629.09
           41154.10
           43451.12
           41265.41
           39426.11
           39442.43
           44342.21
           46590.21
           47522.30
           42810.31
           39669.27
           36965.39
           35934.80
           31492.23
           25216.95
           20611.92]';
t = 1:24;
figure;
plot(t,LN0(1,:)+oriLoad,'-ok',...
     t,LN0(2,:)+oriLoad,'-or',...
     t,LN0(3,:)+oriLoad,'-ob',...
     t,LN0(4,:)+oriLoad,'-og')
legend({['N = ',num2str(N(1))]
        ['N = ',num2str(N(2))]
        ['N = ',num2str(N(3))]
        ['N = ',num2str(N(4))]});
xlabel('Time'); ylabel('Power (kW)');
title('Effect of different scale EVs on the original Load profile')
%% Total cost of disordered charging of different scale of EVs
TOUprice = ones(24,1)*0.869;
TOUprice([1:6,24]) = 0.356;
TOUprice([7:9,13:16,22,23]) = 0.687;
TCost0 = LN0*TOUprice;
TCost1 = LN1*TOUprice;
TCost2 = LN2*TOUprice;
TCost3 = LN2*TOUprice;
TCost4 = LN2*TOUprice;
TCost5 = LN2*TOUprice;

% Table 5
tit = 'Total Cost of Uncoordinated Charging';
Charge_table(N,TCost0,tit)

% Figure 8
figure;
subplot(121);
plot(N,TCost0,'-ok')
xlabel('N'); ylabel('Total Price ($)');
title('Total cost of Disordered charging of different scale EVs')
%% Total cost of coordinated charging and Comparison 
% Table 6
tit = 'Total Cost of Coordinated Charging';
Charge_table(N,TCost1,tit)

% Figure 10
subplot(122);
plot(N,TCost0,'-ok',N,TCost1,'-or')
xlabel('N'); ylabel('Total Price ($)');
title('Comparison of Total Cost Uncoordinated charging and Coordinated Charging')

% Figure 11 is the same as Figure 6
% Figure 12
figure;
plot(t,LN1(1,:),'-ok',t,LN1(2,:),'-or',t,LN1(3,:),'-ob',t,LN1(4,:),'-og')
legend({['N = ',num2str(N(1))]
        ['N = ',num2str(N(2))]
        ['N = ',num2str(N(3))]
        ['N = ',num2str(N(4))]});
xlabel('Time'); ylabel('Power (kW)');
title('Load profiles of different scale EVs using Coordinated Charging')

% Figure 13
figure;
plot(t,LN1(1,:)+oriLoad,'-ok',...
     t,LN1(2,:)+oriLoad,'-or',...
     t,LN1(3,:)+oriLoad,'-ob',...
     t,LN1(4,:)+oriLoad,'-og')
legend({['N = ',num2str(N(1))]
        ['N = ',num2str(N(2))]
        ['N = ',num2str(N(3))]
        ['N = ',num2str(N(4))]});
xlabel('Time'); ylabel('Power (kW)');
title('Effect of different scale EVs on the original Load profile using Coordinated charging')

%% Comparison of Total Cost Between three strategies
% Table 7
tit = 'Comparison of Total Cost Between 3 Strategies of Charging';
strategy_Name = {'Uncoordinated     ';
                 'Coordinated       ';
                 'Coordinated simple'};
TCostList = [TCost0(4),TCost1(4),TCost5(4)];
fprintf([tit '\n'])
fprintf('----------------------------------\n')
fprintf('Strategy            Tot. Price ($)\n')
fprintf('----------------------------------\n')
for i = 1:3
    fprintf(strategy_Name{i});
    fprintf('  %14.4e\n',TCostList(i))
end
fprintf('----------------------------------\n')

% Figure 14
figure;
subplot(121);
plot(t,LN0(4,:),'-ok',t,LN1(4,:),'-or')
legend('Uncoordinated','Coordinated');
xlabel('Time'); ylabel('Power (kW)');
title('Comparison of Uncoordinated Charging and Coordinated Charging')

% Figure 15
subplot(122);
plot(t,LN0(4,:),'-ok',t,LN5(4,:),'-or')
legend('Uncoordinated','Coordinated simple');
xlabel('Time'); ylabel('Power (kW)');
title('Comparison of Uncoordinated Charging and Coordinated simple Charging')