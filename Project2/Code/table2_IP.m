clc
close all
clear 

load('customer_cone.mat')       %%cone
load('customer_cone_number_sorted.mat')     %%degree_sorted
[IP]=xlsread('table2_IP');
top=degree_sorted(1:100,1:2);
ASes=zeros(100,47542);
for i=1:100
    rows=find(cone(:,1)==top(i,1));
    ASes(i,:)=cone(rows,:);
end
AS_IP=zeros(100,47542);
AS_prefix=zeros(100,47542);
for i=1:100
    for j=1:47542
        if ASes(i,j)>0
            [rows,cols,v]=find(IP(:,1)==ASes(i,j));
            if v==1
                AS_IP(i,j)=IP(rows,2);
                AS_prefix(i,j)=IP(rows,3);
            end
        end
    end
end
ASes_IP=zeros(100,1);
ASes_prefix=zeros(100,1);
for i=1:100
    ASes_IP(i,1)=sum(AS_IP(i,:));
    ASes_prefix(i,1)=sum(AS_prefix(i,:));
end