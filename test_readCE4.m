clear,clc,close all

files = dir('I:\CE4\data\2B\2019\*.2B');
% file = fopen(data,'r','b');
A = [];
X = [];
Y = [];

% stiching all data collected druing 2019
for i=1:length(files)
    filepath = [files(i).folder '\' files(i).name];
    [datasec, pos] = readCE4LPR(filepath);
    A = [A datasec];
    X = [X; pos.x];
    Y = [Y; pos.y];
end

figure, imagesc(A), colormap gray
% save('out\2019_CE4_LRP_2B.mat','A')

figure, plot(X, Y); 


%%
dt = 0.3125e-3; % μs
er = 3;
dh = 3e8*dt*1e-6/sqrt(er)/2;

[m, n] = size(A1);
y = (1:m)*dh;
x = 1:n;

[~, idx] = max(A1(:,1));
for i = idx:m
    alpha = 0.2;
    r = 3e8*(i - idx)*dt*1e-6/sqrt(er)/2;
    A1(i,:) = A1(i,:)*r*exp(alpha*r);
end
figure, imagesc(x,y,A1), colormap gray, title('Gain');
