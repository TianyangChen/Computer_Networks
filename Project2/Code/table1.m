clc
close all
clear 

[data]=xlsread('table1');
file=fopen('20161001as-rel2.txt');
Dataset=textscan(file,'%d|%d|%d|%s'); 
fclose(file);
AS(:,1)=Dataset{1};
AS(:,2)=Dataset{2};
degree_sorted=sortrows(data,-2);
R=degree_sorted(:,1);
num=length(R);
S=zeros(num,1);
S(1)=R(1);
i=2;

while i<num+1
    [FF]=find(AS(:,1)==R(i));
%     ff=length(FF);
%     ASes_FF=zeros(ff,1);
%     for xx=1:ff
%         ASes_FF(xx)=AS(FF(xx),2);
%     end
    [SS]=find(AS(:,2)==R(i));
%     ss=length(SS);
%     ASes_SS=zeros(ss,1);
%     for yy=1:ss
%         ASes_SS(yy)=AS(SS(yy),1);
%     end
%     set=cat(1,ASes_FF,ASes_SS);
    set=[FF;SS];
    set=unique(set);
    n=i-1;
    for x=1:i-1
        for y=1:length(set)
            if (AS(set(y),1)==S(x) && AS(set(y),2)==R(i))|| (AS(set(y),2)==S(x) && AS(set(y),1)==R(i))
                n=n-1;
            end
        end
    end
%     if n==0
    if n<i-1
        S(i)=R(i);
    elseif n==i-1
        break;
    end
    i=i+1;
    FF=0;
    SS=0;
    set=0;
end
S(S==0)=[];