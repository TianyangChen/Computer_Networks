clc
close all
clear 

[AS]=xlsread('table2_AS');
[IP]=xlsread('table2_IP');
provider=unique(AS(:,1));
num_of_provider=length(provider);
cone(:,1)=provider;
j=2;
for i=1:num_of_provider
    [FF]=find(AS(:,1)==provider(i));
    n=length(FF);
    cone(i,2:1+n)=AS(FF,2);
    num=n+1;
    while j<num+1
        [SS]=find(AS(:,1)==cone(i,j));
        m=length(SS);
        if m==0
            j=j+1;
        else
            for x=1:m
                [r,c,V]=find(cone(i,:)==AS(SS(x),2));
                if sum(V)==0
                    num=num+1;
                    cone(i,num)=AS(SS(x),2);
                end
            end
            j=j+1;
        end
    end
    j=2;
    FF=0;
end
