n = size(A,1);
Ae_tot = [zeros(n,n) eye(n)
     A zeros(n,n)];
n = size(Ah,1);
Ah_tot = [zeros(n,n) eye(n)
     Ah zeros(n,n)];
n = size(A_aug,1);
Aaug_tot = [zeros(n,n) eye(n)
     A_aug zeros(n,n)];

figure()
p1 = plot(eig(Ae_tot),'rx');
hold on;
p2 = plot(eig(Ah_tot),'gx');
p3 = plot(eig(Aaug_tot),'bx');
xline(0,'--')
yline(0,'--')
xlabel('Real')
ylabel('Im')
title('Eigenvalues of Ae')
legend([p1 p2 p3],{'Ae','Ah','Aaug'})

figure()
subplot(1,3,1)
plot(eig(Ae_tot),'rx');
xline(0,'--')
yline(0,'--')
xlabel('Real')
ylabel('Im')
title('Eigenvalues of Ae')
subplot(1,3,2)
plot(eig(Ah_tot),'gx');
xline(0,'--')
yline(0,'--')
xlabel('Real')
ylabel('Im')
title('Eigenvalues of Ah')
subplot(1,3,3)
plot(eig(Aaug_tot),'bx');
xline(0,'--')
yline(0,'--')
xlabel('Real')
ylabel('Im')
title('Eigenvalues of Aaug')
    