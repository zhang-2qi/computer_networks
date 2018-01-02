clear;
clc;
close all;
load('T4.mat');
tdp1 = tabulate(tcpdesport1);
tdp2 = tabulate(tcpdesport2);
tsp1 = tabulate(tcpsrcport1);
tsp2 = tabulate(tcpsrcport2);
udp1 = tabulate(udpdesport1);
udp2 = tabulate(udpdesport2);
usp1 = tabulate(udpsrcport1);
usp2 = tabulate(udpsrcport2);
p1 = sortrows(tdp1,3,'descend');
p2 = sortrows(tdp2,3,'descend');
p3 = sortrows(tsp1,3,'descend');
p4 = sortrows(tsp2,3,'descend');
p5 = sortrows(udp1,3,'descend');
p6 = sortrows(udp2,3,'descend');
p7 = sortrows(usp1,3,'descend');
p8 = sortrows(usp2,3,'descend');
p11 = p1(1:10);
p21 = p2(1:10);
p31 = p3(1:10);
p41 = p4(1:10);
p51 = p5(1:10);
p61 = p6(1:10);
p71 = p7(1:10);
p81 = p8(1:10);
fp = fopen('da.txt','rb');
A = fread(fp);
%B = dec2hex(A);
nnnn = 0;
for m = 1:10 
 porta1 =  p11(m);
 porta2 = p21(m);
 porta3 = p31(m);
 porta4 = p41(m);
 porta5 = p51(m);
 porta6 = p61(m);
 porta7 = p71(m);
 porta8 = p81(m);
pos = 25;
dec2hex(A(pos));
len = size(A,1);
num = 0;%包数量
total = 0;
res1 = [];
res2 = [];
res3 = [];
res4 = [];
res5 = [];
res6 = [];
res7 = [];
res8 = [];
lala = [];
total = 0;
totaldesmac = [];
mymac = 'F40669104A7D';
while pos < len
   
    total = total +1;
    pos = pos + 8;
    baochang = A(pos)+A(pos+1)*2^8+A(pos+2)*2^16+A(pos+3)*2^24;
    pos = pos +8;
    ppos = pos;
    %Ethernet 
    desmac = cat(2,dec2hex(A(pos),2),dec2hex(A(pos+1),2),dec2hex(A(pos+2),2),dec2hex(A(pos+3),2),dec2hex(A(pos+4),2),dec2hex(A(pos+5),2));
    pos = pos + 6;
    srcmac = cat(2,dec2hex(A(pos),2),dec2hex(A(pos+1),2),dec2hex(A(pos+2),2),dec2hex(A(pos+3),2),dec2hex(A(pos+4),2),dec2hex(A(pos+5),2));
    pos = pos +6;
    if(A(pos)~=8) %先跳过不是ipv4的包
        pos = ppos+baochang;
        continue;
    end
    if(A(pos+1)~=0)
        pos = ppos+baochang;
        continue;
    end
    
    num = num +1;
    %IP 
    pos = pos + 2;
    
    pos = pos + 6;
    pos = pos + 3;
    ip_protocol = A(pos);
    port1 = A(pos+11)*2^8 +A(pos+12);
    port2 = A(pos+13)*2^8 +A(pos+14);
    if ip_protocol == 6
        if(srcmac == mymac)
            if port1 == porta1
                res1 = [res1,baochang];
            end
            if port2 == porta3
                res3 = [res3,baochang];
            end
        end
         if(desmac == mymac)
            if port1 == porta2
                res2 = [res2,baochang];
            end
            if port2 == porta4
                res4 = [res4,baochang];
            end
            
        end

    end
       if ip_protocol == 17
         if(srcmac== mymac)
          if port1 == porta5
                res5 = [res5,baochang];
            end
            if port2 == porta7
                res7 = [res7,baochang];
            end

         else
             if(desmac == mymac)
             if port1 == porta6
                res6 = [res6,baochang];
            end
            if port2 == porta8
                res8 = [res8,baochang];
            end
                 
            end
         end

       end

    
       
    pos = ppos+baochang;
  
end


figure;
figure('visible','off')
total = sort(res1);
od  = 1:size(total,2);
h = plot(total,od);
title(cat(2,'TCP-DES OUT traffic accumulation graph:','port ',string(porta1)));
xlabel('length');
ylabel('num');
print(gcf,'-dpng',cat(2,'photo/TCP_DES_IN_traffic_accumulation_graph_','port_',num2str(porta1),'.png'));
close(gcf)

figure;
figure('visible','off')
total = sort(res2);
od  = 1:size(total,2);
h=plot(total,od);
title(cat(2,'TCP-DES IN traffic accumulation graph','port ',string(porta2)));
xlabel('length');
ylabel('num');
%saveas(h,cat(2,'photo/TCP_DES_IN_traffic_accumulation_graph_','port_',num2str(porta2),'.png'));
print(gcf,'-dpng',cat(2,'photo/TCP_DES_IN_traffic_accumulation_graph_','port_',num2str(porta2),'.png'));
close(gcf)

figure;
figure('visible','off')
total = sort(res3);
od  = 1:size(total,2);
h = plot(total,od);
title(cat(2,'TCP-SRC OUT traffic accumulation graph','port ',string(porta3)));
xlabel('length');
ylabel('num');
print(gcf,'-dpng',cat(2,'photo/TCP_DES_IN_traffic_accumulation_graph_','port_',num2str(porta3),'.png'));
close(gcf)


figure;
figure('visible','off')
total = sort(res4);
od  = 1:size(total,2);
h=plot(total,od);
title(cat(2,'TCP-SRC IN traffic accumulation graph','port',string(porta4)));
xlabel('length');
ylabel('num');
print(gcf,'-dpng',cat(2,'photo/TCP_DES_IN_traffic_accumulation_graph_','port_',num2str(porta4),'.png'));
close(gcf)

figure;
figure('visible','off')
total = sort(res5);
od  = 1:size(total,2);
h=plot(total,od);
title(cat(2,'UDP-DES OUT traffic accumulation graph','port ',string(porta5)));
xlabel('length');
ylabel('num');
print(gcf,'-dpng',cat(2,'photo/TCP_DES_IN_traffic_accumulation_graph_','port_',num2str(porta5),'.png'));
close(gcf)

figure;
figure('visible','off')
total = sort(res6);
od  = 1:size(total,2);
h=plot(total,od);
title(cat(2,'TCP-DES IN traffic accumulation graph','port ',string(porta6)));
xlabel('length');
ylabel('num');
print(gcf,'-dpng',cat(2,'photo/TCP_DES_IN_traffic_accumulation_graph_','port_',num2str(porta6),'.png'));
close(gcf)

figure;
figure('visible','off')
total = sort(res7);
od  = 1:size(total,2);
h=plot(total,od);
title(cat(2,'UDP-SRC OUT traffic accumulation graph','port ',string(porta7)));
xlabel('length');
ylabel('num');
print(gcf,'-dpng',cat(2,'photo/TCP_DES_IN_traffic_accumulation_graph_','port_',num2str(porta7),'.png'));
close(gcf)

figure;
figure('visible','off')
total = sort(res8);
od  = 1:size(total,2);
h = plot(total,od);
title(cat(2,'UDP-SRC IN traffic accumulation graph','port ',string(porta8)));
xlabel('length');
ylabel('num');
print(gcf,'-dpng',cat(2,'photo/TCP_DES_IN_traffic_accumulation_graph_','port_',num2str(porta8),'.png'));
close(gcf)
end

figure;
p111 = cellstr(string(p11));
bar(categorical(p111),p1(1:10,2));
title('TCP-DES OUT PORT','FontSize',8);



figure;
p211 = cellstr(string(p21));
bar(categorical(p211),p1(1:10,2));
title('TCP-DES IN PORT','FontSize',8);


figure;
p311 = cellstr(string(p31));
bar(categorical(p311),p1(1:10,2));
title('TCP-SRC OUT PORT','FontSize',8);



figure;
p411 = cellstr(string(p41));
bar(categorical(p411),p1(1:10,2));
title('TCP-SRC IN PORT','FontSize',8);


figure;
p511 = cellstr(string(p51));
bar(categorical(p511),p1(1:10,2));
title('UDP-DES OUT PORT','FontSize',8);


figure;
p611 = cellstr(string(p61));
bar(categorical(p611),p1(1:10,2));
title('UDP-DES IN PORT','FontSize',8);


figure;
p711 = cellstr(string(p71));
bar(categorical(p711),p1(1:10,2));
title('UDP-SRC OUT PORT','FontSize',8);



figure;
p811 = cellstr(string(p81));
bar(categorical(p811),p1(1:10,2));
title('UDP-SRC IN PORT','FontSize',8);
