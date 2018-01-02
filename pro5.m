clear;
clc;
close all;
load('T5.mat');
x_idx = 1:6;
x={'UGR' 'ACK' 'PSH' 'RST' 'SYN' 'FIN'};
y=[tcpflag(1) tcpflag(2) tcpflag(3) tcpflag(4) tcpflag(5) tcpflag(6)];
figure;
bar(x_idx,y);
title('各控制位出现次数','FontSize',8);
set(gca,'XTickLabel',x);
figure;
explode = [0 1 0 0 0 0];
pie(y,explode,x);
colormap jet;
title('各控制位出现频率饼状图', 'FontSize', 8);

