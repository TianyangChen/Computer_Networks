%Project 1   Tianyang Chen
%Hidden Terminals(RTS/CTS)
%The Simulation time of this pragram is 1 sec.
%So you need to run this program 10 times and reorganize the data
clear all;
lamA=1000;
lamC=lamA/2;
CW=4;
num_of_packets=50;

A=zeros(1,50000);%the status of node A and C
C=zeros(1,50000);
B_freeze=zeros(1,50000);%if node B or C is freezed,set the corresponding number to 1
C_freeze=zeros(1,50000);


UA=rand(1,num_of_packets);
XA=-log(1-UA)./lamA;
frameA=round(XA./0.00002);%generate the frames by Poisson Distribution,the unit is slot
UC=rand(1,num_of_packets);
XC=-log(1-UC)./lamC;
frameC=round(XC./0.00002);

for i=2:num_of_packets%compute the time each frame was generated
    frameA(i)=frameA(i)+frameA(i-1);
    frameC(i)=frameC(i)+frameC(i-1);
end
frameA=[frameA,80000];
frameC=[frameC,80000];

Aready_to_send=1;%the number of packet that is going to be transmitted
A_DIFS=2;%initialization
A_CW=0;
A_sending=100;
A_SIFS=1;

A_collision=0;
A_success=0;
A_RTS=2;
A_SIFS_CTS=1;%the SIFS before CTS
A_CTS=2;%the SIFS before ACK
A_SIFS_DATA=1;% the SIFS before DATA


Cready_to_send=1;
C_DIFS=2;
C_CW=0;
C_sending=100;
C_SIFS=1;

C_collision=0;
C_success=0;
C_RTS=2;
C_SIFS_CTS=1;
C_CTS=2;
C_SIFS_DATA=1;

for t=1:50000%Main loop, use this to update the data in A and C
    if frameA(Aready_to_send)>t
        idleA=1;%means the frame is idle
    else
        idleA=0;
    end
 
    if idleA==1
        A(t)=0;%0 denotes nothing happened
    else
        if A_DIFS>0
            A(t)=1;%1 denotes DIFS phase
            A_DIFS=A_DIFS-1;
        else
            if A_CW>0
                A(t)=2;%2 denotes CW phase, the value is 0 at the beginning
                A_CW=A_CW-1;
            else         
                if A_RTS>0% 6 denotes the RTS
                    A(t)=6;
                    A_RTS=A_RTS-1;
                else
                    if C(t-1)==6 || C(t-2)==6%judge whether RTS transmissions collide
                        A_collision=A_collision+1;

                        A(t)=4;
                        A_CW=randi(CW,1)-1;
                        A_DIFS=2;
                        A_RTS=2;
                        CW=CW*2;
                        if CW>1024
                            CW=1024;
                        end
                    else
                        if A_SIFS_CTS>0% if RTS didn't collide, continue to transmit the SIFS
                            A(t)=4;
                            A_SIFS_CTS=A_SIFS_CTS-1;
                        else
                            if B_freeze(t)==1%now it's time for B to send CTS, but if B is freezed,invoke the exponential backoff mechanism
                                A(t)=1;
                                A_CW=randi(CW,1)-1;
                                A_DIFS=1;
                                A_RTS=2;
                                A_SIFS_CTS=1;
                                CW=CW*2;
                                if CW>1024
                                    CW=1024;
                                end
                            else
                                if A_CTS>0% B is not freezed, send CTS
                                    A(t)=7;
                                    for i=t+1:t+103
                                        C_freeze(i)=1;
                                    end
                                    A_CTS=A_CTS-1;
                                else
                                    if A_SIFS_DATA>0% send the SIFS before DATA
                                        A(t)=4;
                                        A_SIFS_DATA=A_SIFS_DATA-1;
                                    else
                                        if A_sending>0% send the frame
                                            A(t)=(3);
                                            A_sending=A_sending-1;
                                        else
                                            if A_SIFS>0% the SIFS before ACK
                                                A(t)=4;
                                                A_SIFS=A_SIFS-1;
                                            else
                                                A(t)=5;
                                                A_success=A_success+1;%transmit successfully
                                                CW=4;
                                                Aready_to_send=Aready_to_send+1;
                                                A_DIFS=2;
                                                A_CW=randi(CW,1)-1;
                                                A_sending=100;
                                                A_SIFS=1;
                                                A_RTS=2;
                                                A_SIFS_CTS=1;
                                                A_CTS=2;
                                                A_SIFS_DATA=1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end


    if frameC(Cready_to_send)>t
        idleC=1;%means the frame is idle
    else
        idleC=0;
    end
 
    if idleC==1
        C(t)=0;%0 denotes nothing happened
    else
        if C_DIFS>0
            C(t)=1;%1 denotes DIFS phase
            C_DIFS=C_DIFS-1;
        else
            if C_CW>0
                C(t)=2;
                C_CW=C_CW-1;
            else%before transmitting the RTS, judge whether C is freezed
                if C_freeze(t)==1
                    C(t)=1;
                    C_CW=randi(CW,1)-1;
                    C_DIFS=1;
                    CW=CW*2;
                    if CW>1024
                        CW=1024;
                    end
                else
                    if C_RTS>0
                        for i=t+1:t+106
                            B_freeze(i)=1;
                        end
                        C(t)=6;
                        C_RTS=C_RTS-1;
                    else
                        if C_SIFS_CTS>0
                            C(t)=4;
                            C_SIFS_CTS=C_SIFS_CTS-1;
                        else
                            if C_CTS>0;
                                C(t)=7;
                                C_CTS=C_CTS-1;
                            else
                                if C_SIFS_DATA>0
                                    C(t)=4;
                                    C_SIFS_DATA=C_SIFS_DATA-1;
                                else
                                    if C_sending>0
                                        C(t)=3;
                                        C_sending=C_sending-1;
                                    else
                                        if C_SIFS>0
                                            C(t)=4;
                                            C_SIFS=C_SIFS-1;
                                        else
                                            C(t)=5;
                                            C_success=C_success+1;%成功传送
                                            CW=4;
                                            Cready_to_send=Cready_to_send+1;
                                            C_DIFS=2;
                                            C_CW=randi(CW,1)-1;
                                            C_sending=100;
                                            C_SIFS=1;
                                            C_RTS=2;
                                            C_SIFS_CTS=1;%CTS前的SIFS
                                            C_CTS=2;
                                            C_SIFS_DATA=1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                end
            end
        end
    end
end
%calculate Throughput & delay
A_first=find(A~=0);
A_end=find(A==5);
A_throughput=A_success*1500*8/((A_end(end)-A_first(1))*0.00002);
A_delay=(sum(A_end(1:A_success))-sum(frameA(1:A_success)))*0.00002/num_of_packets;

C_first=find(C~=0);
C_end=find(C==5);
C_throughput=C_success*1500*8/((C_end(end)-C_first(1))*0.00002);
C_delay=(sum(C_end(1:C_success))-sum(frameC(1:C_success)))*0.00002/num_of_packets;


    
        



