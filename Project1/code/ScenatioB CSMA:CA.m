%Project 1   Tianyang Chen
%Hidden Terminals(CSMA/CA)
%The Simulation time of this pragram is 1 sec.
%So you need to run this program 10 times and reorganize the data
clear all;
lamA=100;
lamC=lamA;
CW=4;
num_of_packets=50;

A=zeros(1,50000);%the status of node A and C
C=zeros(1,50000);


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
A_CW=randi(CW,1)-1;
A_sending=100;
A_SIFS=1;
A_ACK_allow=0;
A_collision=0;
A_success=0;


Cready_to_send=1;
C_DIFS=2;
C_CW=randi(CW,1)-1;
C_sending=100;
C_SIFS=1;
C_ACK_allow=0;
C_collision=0;
C_success=0;

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
                A(t)=2;%2 denotes CW phase
                A_CW=A_CW-1;
            else 
                if A_sending>0
                    A(t)=3;%3 denotes packets sending status
                    A_sending=A_sending-1;
                else
                    if A_SIFS>0
                        A(t)=4;%4 denotes SIFI phase,here we round the SIFI time to 1 slot
                        A_SIFS=A_SIFS-1;
                    else
                        for i=t-100:t%judge the collision
                            if C(i)<3
                                A_ACK_allow=A_ACK_allow+1;
                            end
                        end
                        if A_ACK_allow>100
                            A_success=A_success+1;%transmit successfully
                            A(t)=5;
                            CW=4;
                            Aready_to_send=Aready_to_send+1;
                            A_DIFS=2;
                            A_CW=randi(CW,1)-1;
                            A_sending=100;
                            A_SIFS=1;
                            A_ACK_allow=0;
                        else 
                            A_collision=A_collision+1;%happened a collision
                            CW=CW*2;
                            if CW>1024
                                CW=1024;
                            end
                            A_DIFS=2;
                            A_CW=randi(CW,1)-1;
                            A_sending=100;
                            A_SIFS=1;
                            A_ACK_allow=0;
                            
                        end
                    end
                end
            end
        end
    end
    
    if frameC(Cready_to_send)>t
        idleC=1;
    else
        idleC=0;
    end
 
    if idleC==1
        C(t)=0;
    else
        if C_DIFS>0
            C(t)=1;
            C_DIFS=C_DIFS-1;
        else
            if C_CW>0
                C(t)=2;
                C_CW=C_CW-1;
            else 
                if C_sending>0
                    C(t)=3;
                    C_sending=C_sending-1;
                else
                    if C_SIFS>0
                        C(t)=4;
                        C_SIFS=C_SIFS-1;
                    else
                        %In Hidden Terminals, C to D will not have
                        %collision
                            C_success=C_success+1;
                            C(t)=5;
                            CW=4;
                            Cready_to_send=Cready_to_send+1;
                            C_DIFS=2;
                            C_CW=randi(CW,1)-1;
                            C_sending=100;
                            C_SIFS=1;
                            C_ACK_allow=0;
                        
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
            

    
        



