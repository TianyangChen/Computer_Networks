clc
clear all
% Reading input file
% read file from routeviews-rv2-20161103-1200.txt

file=fopen('routeviews-rv2-20161103-1200.txt');
Dataset=textscan(file,'%s %d %s'); 
fclose(file);
IP=Dataset{1};
prefix=Dataset{2};
ASes=Dataset{3};
num=length(prefix);
S=regexp(ASes,'_','split');
ASes_revise=cell(num,1);
ASes_num=cell(num,1);
prefix_plus=zeros(num,1);
j=1;
for i=1:num
    num_size=length(S{i});
    if num_size==1
        ASes_revise{i}=S{i}{1};
    elseif num_size>1
        ASes_revise{i}=S{i}{1};
        while num_size>1
            ASes_num{j}=S{i}{num_size};
            prefix_plus(j)=prefix(i);
            num_size=num_size-1;
            j=j+1;
        end
    end
end
ASes_revise=str2double(ASes_revise);
ASes_num=str2double(ASes_num);
ASes_num(isnan(ASes_num))=[];
prefix_plus(prefix_plus==0)=[];
AS=cat(1,ASes_revise,ASes_num);
prefix_connected=cat(1,prefix,prefix_plus);
n=length(prefix_connected);
prefix_sorted=zeros(n,1);
[AS,index]=sort(AS);
for i=1:n
    prefix_sorted(i)=prefix_connected(index(i));
    prefix_sorted(i)=2.^(32-prefix_sorted(i));
end
AS_num=unique(AS);
m=length(AS_num);
prefix_num=zeros(m,1);
j=1;
num_1=0;
i=1;
while i<n+1
    if AS(i)==AS_num(j)
        for a=i:n
            if AS(a)==AS_num(j)
                prefix_num(j)=prefix_num(j)+prefix_sorted(a);
                num_1=num_1+1;
            else
                break;
            end
        end
        i=i+num_1;
        j=j+1;
    else
        i=i+1;
    end
    num_1=0;
end
percent=prefix_num./(2^32);

bar_P=zeros(6,1);
for i=1:m
    if percent(i)<=2^(-24)
        bar_P(1)=bar_P(1)+1;
    elseif percent(i)>2^(-24) && percent(i)<=2^(-23)
        bar_P(2)=bar_P(2)+1;
    elseif percent(i)>2^(-23) && percent(i)<=2^(-22)
        bar_P(3)=bar_P(3)+1;
    elseif percent(i)>2^(-22) && percent(i)<=2^(-21)
        bar_P(4)=bar_P(4)+1;
    elseif percent(i)>2^(-21) && percent(i)<=2^(-20)
        bar_P(5)=bar_P(5)+1;
    elseif percent(i)>2^(-20)
        bar_P(6)=bar_P(6)+1;
    end
end
barN=bar_P;
bar_P=bar_P./m;
b=bar(bar_P);
grid on;
% set(b,'XTickLabel',{'1','2-5','5-100','100-200','200-1000','>1000'})
% legend('XX');
xlabel('x axis');
ylabel('y axis');











