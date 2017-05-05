clc
close all
clear 
file=fopen('20161001as-rel2.txt');
Dataset=textscan(file,'%d|%d|%d|%s'); 
fclose(file);
ASes_F=Dataset{1};
ASes_S=Dataset{2};
Link=Dataset{3};
num=length(Link);
AS_F=zeros(num,1);
AS_S=zeros(num,1);
j=1;
for i=1:num
    if Link(i)==-1
        AS_F(j)=ASes_F(i);
        AS_S(j)=ASes_S(i);
        j=j+1;
    end
end
AS_F(AS_F==0)=[];
AS_S(AS_S==0)=[];