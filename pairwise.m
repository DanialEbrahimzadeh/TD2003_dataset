clc
clear all
close all hidden


filename='trainingset.txt';
delimiterIn=' ';
A=importdata(filename,delimiterIn);
% A.textdata(:,2)=strtok(A.textdata(:,2),'qid:');
% A.textdata(:,3)=strtok(A.textdata(:,3),'1:');
a1=[];
a2=[];
for i=1:size(A.textdata,1)
    temp1=A.textdata(i,2);
    temp1=char(temp1(1,1));
    temp1=temp1(5:end);
    a1(i,1)=str2double(temp1);
end
for j=3:46
    for i=1:size(A.textdata,1);
        temp2=A.textdata(i,j);
        temp2=char(temp2(1,1));
        if j<12
            id=3;
        else
            id=4;
        end
        temp2=temp2(id:end);
        a2(i,j-2)=str2double(temp2);
    end
end
        
        
y=str2double(A.textdata(:,1));
x=[a2 a1 A.data];
x=x(1:5000,:);
y=y(1:5000,:);


filename='testset.txt';
delimiterIn=' ';
A_test=importdata(filename,delimiterIn);
a1=[];
a2=[];
for i=1:size(A_test.textdata,1)
    temp1=A_test.textdata(i,2);
    temp1=char(temp1(1,1));
    temp1=temp1(5:end);
    a1(i,1)=str2double(temp1);
end
for j=3:46
    for i=1:size(A_test.textdata,1);
        temp2=A_test.textdata(i,j);
        temp2=char(temp2(1,1));
        if j<12
            id=3;
        else
            id=4;
        end
        temp2=temp2(id:end);
        a2(i,j-2)=str2double(temp2);
    end
end
        
        
y_test=str2double(A_test.textdata(:,1));
x_test=[a2 a1 A_test.data];
map1=[];
map2=[];


for count=1:10
    disp(count);
    a=unifrnd(-1,1,1000,44);
    b=unifrnd(-1,1,1000,1);

    h=x(:,1:44)*a';

    for j=1:1000
        h(:,j)=h(:,j)+b(j,1);
    end

    d_number=size(x,1);
    W=eye(d_number);
    for i=1:size(x,1);
        if y(i,1)==1
            for j=1:size(x,1)
                if x(i,45)==x(j,45) && y(j,1)==1
                    W(i,j)=1;
                end
            end
        end
    end

    D=eye(d_number);
    temp_d=sum(W');
    for i=1:d_number
        D(i,i)=temp_d(1,i);
    end

    L=D-W;

    beta=(inv((eye(1000)/(2^-10))+h'*L*h))*h'*L*y;


    h_test=x_test(:,1:44)*a';

    for j=1:1000
        h_test(:,j)=h_test(:,j)+b(j,1);
    end
    f=h_test*beta;
    y_f1=sign(f);
    sum1=0;
    for i=1:size(y_f1,1)
        if y_f1(i,1)==-1
            y_f1(i,1)=0;
        end
        if y_f1(i,1)==y_test(i,1)
            sum1=sum1+1;
        end
    end
    sum1=sum1/size(y_f1,1);
    map1=[map1 sum1];


    f_kernel=(h_test*h')*(inv((eye(size(x,1))/(2^-10))+L*h*h'))*L*y;
    
        y_f2=sign(f_kernel);
    sum2=0;
    for i=1:size(y_f2,1)
        if y_f2(i,1)==-1
            y_f2(i,1)=0;
        end
        if y_f2(i,1)==y_test(i,1)
            sum2=sum2+1;
        end
    end
    sum2=sum2/size(y_f2,1);
    map2=[map2 sum2];

    
end

final_map1=mean(map1);
disp(final_map1);
final_map2=mean(map2);
disp(final_map2);