function Charge_plot(N,Lk,LN,kselect)
t=1:24;
figure;
subplot(121);
plot(t,Lk(1,:),'-ok',t,Lk(2,:),'-or',t,Lk(3,:),'-ob')
legend('Mini','Nissan','BYD');
xlabel('Time'); ylabel('Power (kW)');

subplot(122);
plot(t,LN(1,:));
legend(['Total Load at N = ',num2str(N(kselect))]);
xlabel('Time'); ylabel('Power (kW)');

figure;
plot(t,LN(1,:),'-ok',t,LN(2,:),'-or',t,LN(3,:),'-ob',t,LN(4,:),'-og')
legend({['N = ',num2str(N(1))]
        ['N = ',num2str(N(2))]
        ['N = ',num2str(N(3))]
        ['N = ',num2str(N(4))]});
xlabel('Time'); ylabel('Power (kW)');
end