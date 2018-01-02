clear;
clc;
close all;
load('T3.mat');
figure;
total = sort([tcpchuacc,tcpruacc,udpchuacc,udpruacc]);
od  = 1:size(total,2);
plot(total,od);
title('traffic accumulation graph');

figure;
total = sort(tcpchuacc);
od  = 1:size(total,2);
plot(total,od);
title('TCP-OUT traffic accumulation graph');
xlabel('length');
ylabel('num');

figure;
total = sort(tcpruacc);
od  = 1:size(total,2);
plot(total,od);
title('TCP-IN accumulation graph');
xlabel('length');
ylabel('num');

figure;
total = sort(udpchuacc);
od  = 1:size(total,2);
plot(total,od);
title('UDP-OUT accumulation graph');
xlabel('length');
ylabel('num');

figure;
total = sort(udpruacc);
od  = 1:size(total,2);
plot(total,od);
title('UDP-IN accumulation graph');
xlabel('length');
ylabel('num');
