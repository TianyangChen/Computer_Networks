clc
clear all
% Reading input file
% read file from 20161001as-rel2.txt
file=fopen('20161001as-rel2.txt');
Dataset=textscan(file,'%d|%d|%d|%s'); 
fclose(file);
ASes_F=Dataset{1};
ASes_S=Dataset{2};
Link_F=Dataset{3};
num=length(ASes_F);
Link_S=zeros(num,1);
[ASes_S,index]=sort(ASes_S);
for i=1:num
    Link_S(i)=Link_F(index(i));
end
AS_F=unique(ASes_F);
num_1=length(AS_F);
AS_S=unique(ASes_S);
num_2=length(AS_S);
AS_FF=zeros(num_1,3);
AS_SS=zeros(num_2,3);
i=1;
j=1;
n=0;
m=0;
while i<num+1
    if ASes_F(i)==AS_F(j)
        AS_FF(j,1)=AS_F(j);
        for a=i:num
            if ASes_F(a)==AS_F(j) && Link_F(a)==0
                n=n+1;
            elseif ASes_F(a)==AS_F(j) && Link_F(a)==-1
                m=m+1;
            else
                break;
            end
        end
        i=i+(n+m);
        AS_FF(j,2)=n;
        AS_FF(j,3)=m;
        j=j+1;
    else
        i=i+1;
    end
    n=0;
    m=0;
end
i=1;
j=1;
n=0;
while i<num+1
    if ASes_S(i)==AS_S(j)
        AS_SS(j,1)=AS_S(j);
        for a=i:num
            if ASes_S(a)==AS_S(j) && Link_S(a)==0
                n=n+1;
            elseif ASes_S(a)==AS_S(j) && Link_S(a)==-1
                m=m+1;
            else
                break;
            end
        end
        i=i+(n+m);
        AS_SS(j,2)=n;
        AS_SS(j,3)=0;
        j=j+1;
    else
        i=i+1;
    end
    n=0;
    m=0;
end
ASes=cat(1,AS_F,AS_S);
ASes=unique(ASes);
X=length(ASes);
AS=zeros(X,3);
num_3=X;
while num_3>0
    AS(num_3,1)=ASes(num_3);
    [r,c,V]=find(AS_F==ASes(num_3));
    if V==1
        AS(num_3,2)=AS_FF(r,2);
        AS(num_3,3)=AS_FF(r,3);
    end
    [rr,cc,VV]=find(AS_S==ASes(num_3));
    if VV==1
        AS(num_3,2)=AS(num_3,2)+AS_SS(rr,2);
        AS(num_3,3)=AS(num_3,3)+AS_SS(rr,3);
    end
    num_3=num_3-1;
end
Transit=0;
Content=0;
Enterpise=0;
for j=1:X
    if AS(j,2)==0 && AS(j,3)==0
        Enterpise=Enterpise+1;
    elseif AS(j,3)>0
        Transit=Transit+1;
    elseif AS(j,2)>0 && AS(j,3)==0
        Content=Content+1;
    end
end
y=Transit+Enterpise+Content;
data=[Transit Content Enterpise];
label={'Transit ASes','Content ASes','Enterpise ASes'};
bili=data/sum(data);
baifenbi=num2str(bili'*100,'%1.2f');
baifenbi=[repmat(blanks(2),length(data),1),baifenbi,repmat('%',length(data),1)];
baifenbi=cellstr(baifenbi);
Label=strcat(label,baifenbi');
pie(data,Label)