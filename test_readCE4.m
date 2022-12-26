clear,clc,close all
% lbl='I:\CE4\CE4_GRAS_LPR-2B_SCI_N_20201219044001_20201220084500_0163_A.2BL';
file='I:\CE4\CE4_GRAS_LPR-2B_SCI_N_20201219044001_20201220084500_0163_A.2B';

files = dir('I:\CE4\data\2B\2019\*.2B');
% file = fopen(data,'r','b');
A = [];
X = [];
Y = [];
for i=1:length(files)
    filepath = [files(i).folder '\' files(i).name];
    [datasec, pos] = readCE4LPR(filepath);
    A = [A datasec];
    X = [X; pos.x];
    Y = [Y; pos.y];
end

figure, imagesc(A), colormap gray

figure, plot(X, Y);


%%
dt = 0.3125e-3; % μs
er = 3;
dh = 3e8*dt*1e-6/sqrt(er)/2;

A1 = A(1:1024,:);
[m, n] = size(A1);
y = (1:m)*dh;
x = 1:n;
% offset = 5;
% for i=offset+1:n-offset
%     A1(:,i) = sum(A(:,i-offset:i+offset), 2)/(2*offset+1);
% end

% for i=1:n
%     A1(:,i) = detrend(A(:,i));
% end
% 
% tmp = sum(A,2);
% for i=1:n
%     A1(:,i) = A1(:,i)- tmp;
% end
% figure, imagesc(x,y,A1), colormap gray, title('去背景');

[~, idx] = max(A1(:,1));
for i = idx:m
    alpha = 0.2;
    r = 3e8*(i - idx)*dt*1e-6/sqrt(er)/2;
    A1(i,:) = A1(i,:)*r*exp(alpha*r);
end
figure, imagesc(x,y,A1), colormap gray, title('增益');


% colormap(flip(nclCM(151,120)))

% figure, plot(A(:,200))
% save('out\2019_CE4_LRP_2B.mat','A')