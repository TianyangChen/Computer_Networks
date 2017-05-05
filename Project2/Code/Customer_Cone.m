clear all;
input_data=xlsread('P2C.xlsx');
provider_raw=input_data(:,1);
customer_raw=input_data(:,2);
provider=unique(provider_raw);
provider_num=length(provider);
num_of_ASes=zeros(provider_num,1);
for i=24:length(provider)
    index_provider=find(provider_raw==provider(i));
    num_adjacent_customer=length(index_provider);
    num_of_ASes(i)=1+num_adjacent_customer;
    name_reach_customer=[provider(i)];
    while num_adjacent_customer>0
        num_adjacent_customer=0;
        reach_customer=customer_raw(index_provider);
        name_reach_customer=[name_reach_customer; reach_customer];
        index_provider=[];
        for j=1:length(reach_customer)
            index_provider=[index_provider; find(provider_raw==reach_customer(j))];            
        end
        index_proider=unique(index_provider);       
        for k=1:length(index_provider)
            if isempty(find(name_reach_customer==customer_raw(index_provider(k))));
                continue;
            else
                index_provider(k)=0;
            end
        end
        index_provider(index_provider==0)=[];       
        raw_m=customer_raw(index_provider);        
        for l=2:length(index_provider)
            for m=1:l-1
                if raw_m(l)==raw_m(m)
                    index_provider(l)=0;
                    break;
                end
            end
        end
        index_provider(index_provider==0)=[];       
        if isempty(index_provider)
            num_adjacent_customer=0;
        else
            num_adjacent_customer=length(index_provider);
        end
        num_of_ASes(i)=num_of_ASes(i)+num_adjacent_customer;
    end
end
