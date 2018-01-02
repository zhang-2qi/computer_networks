clc;
close all;
clear;
fp = fopen('da.txt','rb');
A = fread(fp);
%B = dec2hex(A);
pos = 25;
dec2hex(A(pos));
len = size(A,1);
num = 0;%包数量
%%T1--------------------
chutcpnum = 0;
rutcpnum = 0;
chuudpnum = 0;
ruudpnum = 0;
chuothernum = 0;
ruothernum = 0;
chutcpdata = 0;
rutcpdata = 0;
chuudpdata = 0;
ruudpdata = 0;
chuotherdata = 0;
ruotherdata = 0;
%%%--------------------------
%%%T2
tcpmfnum = 0;
tcpdfnum = 0;
udpmfnum = 0;
udpdfnum = 0;
dfnum = 0;
mfnum = 0;
%%%----------------------------
%%%T3
acclength = [];
tcpchuacc = [];
tcpruacc = [];
udpchuacc = [];
udpruacc = [];
%%%-------------------------
%%%T4
tcpdesport1 = [];
tcpsrcport1 = [];
udpdesport1 = [];
udpsrcport1 = [];
tcpdesport2 = [];
tcpsrcport2 = [];
udpdesport2 = [];
udpsrcport2 = [];
%%%-----------------
%%%T5
tcpflag = zeros(1,6);

%%%------------------
lala = [];
total = 0;
totaldesmac = [];
mymac = 'F40669104A7D';
while pos < len
   
    total = total +1;
    pos = pos + 8;
    baochang = A(pos)+A(pos+1)*2^8+A(pos+2)*2^16+A(pos+3)*2^24;
%     if(baochang>200)
%         disp(baochang)
%     end
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
    wanalength = dec2hex(A(pos),2);
    iplength = hex2dec(wanalength(2))*4;
    
    pos = pos + 6;
    if A(pos)== 64 || A(pos)==0
        dfnum =  dfnum + 1;
    end
    pos = pos + 3;
    ip_protocol = A(pos);
    if ip_protocol == 6
        if(srcmac == mymac)
        chutcpnum = chutcpnum+1;
        chutcpdata = chutcpdata+baochang;
        tcpchuacc = [tcpchuacc,baochang];
        port1 = A(pos+11)*2^8 +A(pos+12);
        port2 = A(pos+13)*2^8 +A(pos+14);
        tcpdesport1 = [tcpdesport1,port1];
        tcpsrcport1 = [tcpsrcport1,port2];
        else if(desmac == mymac)
           rutcpnum = rutcpnum+1;
           rutcpdata = rutcpdata+baochang;
           tcpruacc = [tcpruacc,baochang];
           port1 = A(pos+11)*2^8 +A(pos+12);
           port2 = A(pos+13)*2^8 +A(pos+14);
           tcpdesport2 = [tcpdesport2,port1];
           tcpsrcport2 = [tcpsrcport2,port2];
            end
        end
     if A(pos-3)== 64 || A(pos-3)==0
        tcpdfnum =  tcpdfnum + 1;
     end
     pos = pos + 24;
     flag = dec2bin(A(pos),6);
     for pp=1:6 
         tcpflag(pp) =  tcpflag(pp) + str2num(flag(pp));
     end 
    end
       if ip_protocol == 17
         if(srcmac== mymac)
        chuudpnum = chuudpnum+1;
        chuudpdata = chuudpdata+baochang;
        udpchuacc = [udpchuacc,baochang];
        port1 = A(pos+11)*2^8 +A(pos+12);
        port2 = A(pos+13)*2^8 +A(pos+14);
        udpdesport1 = [udpdesport1,port1];
        udpsrcport1 = [udpsrcport1,port2];
         else
             if(desmac == mymac)
           ruudpnum = ruudpnum+1;
           ruudpdata = ruudpdata+baochang;
           udpruacc = [udpruacc,baochang];
           port1 = A(pos+11)*2^8 +A(pos+12);
           port2 = A(pos+13)*2^8 +A(pos+14);
           udpdesport2 = [udpdesport2,port1];
           udpsrcport2 = [udpsrcport2,port2];
            end
         end
        if A(pos-3)== 64 || A(pos-3)==0
        udpdfnum =  udpdfnum + 1;
        end
       end
    if(ip_protocol ~= 6&&ip_protocol ~= 17)
         if(srcmac== mymac)
        chuothernum = chuothernum+1;
        chuotherdata = chuotherdata+baochang;
        else if(desmac == mymac)
           ruothernum = ruothernum+1;
           ruotherdata = ruotherdata+baochang;
            end
         end
       
    end
    
    lala = [lala,ip_protocol];
    totaldesmac = [totaldesmac;desmac];
    pos = ppos+baochang;
    acclength = [acclength,baochang];
end
save('T1.mat','chutcpnum','rutcpnum','chutcpdata','chutcpdata','chuudpnum','ruudpnum','chuudpdata','chuudpdata',...
    'chuothernum','chuotherdata','ruothernum','ruotherdata');
save('T2.mat','tcpmfnum','tcpdfnum','udpmfnum','udpdfnum','dfnum','mfnum');

save('T3.mat','tcpchuacc','tcpruacc','udpchuacc','udpruacc','num');

save('T4.mat','tcpdesport1','tcpsrcport1','udpdesport1','udpsrcport1','tcpdesport2','tcpsrcport2','udpdesport2','udpsrcport2');
save('T5.mat','tcpflag');