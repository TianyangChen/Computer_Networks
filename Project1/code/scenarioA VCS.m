%Hidden Terminals(CSMA/CA)
%Tianyang Chen
clc
clear all
lamC=500;
lamA=2*lamC;
CW=4;
num_of_packets=100;

A=zeros(1,100000);
C=zeros(1,100000);
B_freeze=zeros(1,100000);
C_freeze=zeros(1,100000);

UA=rand(1,num_of_packets);
XA=-log(1-UA)./lamA;
frameA=round(XA./0.00002);
UC=rand(1,num_of_packets);
XC=-log(1-UC)./lamC;
frameC=round(XC./0.00002);

for i=2:num_of_packets
    frameA(i)=frameA(i)+frameA(i-1);
    frameC(i)=frameC(i)+frameC(i-1);
end
frameA=[frameA,160000];
frameC=[frameC,160000];

Aready_to_send=1;
A_DIFS=2;
A_CW=randi(CW,1)-1;
A_sending=100;
A_SIFS_CTS=1;
A_SIFS=1;
A_SIFS_DATA=1;
A_RTS=2;
A_CTS=2;
A_collision=0;
A_success=0;


Cready_to_send=1;
C_DIFS=2;
C_CW=randi(CW,1)-1;
C_sending=100;
C_SIFS_CTS=1;
C_SIFS=1;
C_SIFS_DATA=1;
C_RTS=2;
C_CTS=2;
C_collision=0;
C_success=0;

for t=1:100000
    if frameA(Aready_to_send)>t
        idleA=1;
	else
		idleA=0;
	end
	
    if idleA==1
        A(t)=0;
    else
        if A_DIFS>0 && C(t)<3
            A(t)=1;
            A_DIFS=A_DIFS-1;
        else
            if A_CW>0 
				A(t)=2;
				if A_CW<C_CW
					A_CW=A_CW-1;
					C_CW=C_CW-1;
				elseif A_CW==C_CW
					A_CW=A_CW-1;
					C_CW=C_CW-1;
					if A_CW==0 && C_CW==0
						A_collision=A_collision+1;
						C_collision=C_collision+1;
						CW=CW*2;
						if CW>1024
							CW=1024;
						end
						A_DIFS=2;
						A_CW=randi(CW,1)-1;
						C_DIFS=2;
						C_CW=randi(CW,1)-1;
					end	
				elseif A_CW>C_CW
					if C_CW>0
						A_CW=A_CW-1;
						C_CW=C_CW-1;
					end	
				end	
            else
				if A_RTS>0
					A(t)=6;
					A_RTS=A_RTS-1;
				else
					if A_SIFS_CTS>0
						A(t)=4;
						A_SIFS_CTS=A_SIFS_CTS-1;
					else
                        if B_freeze(t)==1
                            A_CW=randi(CW,1)-1;
                            A_DIFS=2;
                            A_RTS=2;
                            A_SIFS=1;
                            CW=CW*2;
                            if CW>1024
                                CW=1024;
                            end
                        else
							if A_CTS>0
								A(t)=7;
								for i=t+1:t+103
									c_freeze(i)=1;
								end
								A_CTS=A_CTS-1;
							else
								if A_SIFS_DATA>0
									A(t)=4;
									A_SIFS_DATA=A_SIFS_DATA-1;
								else
									if A_sending>0
										A(t)=3;
										A_sending=A_sending-1;
									else
										if A_SIFS>0
											A(t)=4;
											A_SIFS=A_SIFS-1;
										else
											A_success=A_success+1;
											A(t)=5;
											CW=4;
											Aready_to_send=Aready_to_send+1;
											A_DIFS=2;
											A_CW=randi(CW,1)-1;
											A_sending=100;
											A_SIFS=1;
											A_SIFS_CTS=1;
											A_SIFS_DATA=1;
											A_CTS=2;
											A_RTS=2;
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
        idleC=1;
    else
        idleC=0;
    end
    if idleC==1
        C(t)=0;
	else
        if C_DIFS>0 && A(t)<3
            C(t)=1;
            C_DIFS=C_DIFS-1;
        else
            if C_CW>0
				C(t)=2;
            else
				if C_freeze(t)==1
                    C_CW=randi(CW,1)-1;
                    C_DIFS=2;
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
                        if A(t-1)==6 || A(t-2)==6
                            C_collision=C_collision+1;
                            C_CW=randi(CW,1)-1;                            
                            C_DIFS=2;
                            C_RTS=2;
                            CW=CW*2;
                            if CW>1024
                                CW=1024;
                            end       
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
                                                C_success=C_success+1;%�?功传�?
                                                CW=4;
                                                Cready_to_send=Cready_to_send+1;
                                                C_DIFS=2;
                                                C_CW=randi(CW,1)-1;
                                                C_sending=100;
                                                C_SIFS=1;
                                                C_RTS=2;
                                                C_SIFS_CTS=1;%CTS�?的SIFS
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
end
%对Throughput和delay的计算
A_first=find(A~=0);
A_end=find(A==5);
A_throughput=A_success*1500*8/((A_end(end)-A_first(1))*0.00002);
A_delay=(sum(A_end(1:A_success))-sum(frameA(1:A_success)))*0.00002/num_of_packets;

C_first=find(C~=0);
C_end=find(C==5);
C_throughput=C_success*1500*8/((C_end(end)-C_first(1))*0.00002);
C_delay=(sum(C_end(1:C_success))-sum(frameC(1:C_success)))*0.00002/num_of_packets;

Athroughput=A_throughput
Adelay=A_delay
Cthroughput=C_throughput
Cdelay=C_delay
	