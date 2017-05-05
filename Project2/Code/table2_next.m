clc
close all
clear 

% load('customer_cone.mat')       %%cone
% load('customer_cone_number_sorted.mat')     %%degree_sorted
[AS]=xlsread('AS_degree');
load('customer_cone_number_sorted.mat')     %%degree_sorted
top=degree_sorted(1:100,1:2);
ASes=zeros(100,1);
for i=1:100
    rows=find(AS(:,1)==top(i,1));
    ASes(i)=AS(rows,2);
end

