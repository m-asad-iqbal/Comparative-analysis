function Charge_table(N,TCost,tit)
fprintf([tit '\n'])
fprintf('---------------------\n')
fprintf('N      Tot. Price ($)\n')
fprintf('---------------------\n')
for i = 1:length(N)
    fprintf('%5.0f  %14.4e\n',N(i),TCost(i))
end
fprintf('---------------------\n\n')
end