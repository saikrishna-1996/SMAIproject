clear;
clc;

%classes are as follows:
%class-14: stop
%class-19: left (advanced)
%class-20: right (advanced)
%class-22: speed breaker
%ckass-26: traffic signal
%class-33: right
%class-34: left

%correspondances are as follows:
%class-14 ---> class-1
%class-19 ---> class-2
%class-20 ---> class-3
%class-22 ---> class-4
%class-26 ---> class-5
%class-33 ---> class-6
%class-34 ---> class-7
%no class ---->class-8

filename = '/home/krish/RRC_Spring16/roadsigns/GTSRB/Final_Training/Images/00033/GT-00033.csv';
delimiter = ';';
startRow = 2;

%% Format string for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
formatSpec = '%s%f%f%f%f%f%f%f%[^\n\r]';


fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

Filename = dataArray{:, 1};
Width = dataArray{:, 2};
Height = dataArray{:, 3};
RoiX1 = dataArray{:, 4};
RoiY1 = dataArray{:, 5};
RoiX2 = dataArray{:, 6};
RoiY2 = dataArray{:, 7};
ClassId = dataArray{:, 8};

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

RoiY2

n1 = 64; %number of input units
n2 = 12; %number of hidden units
n3 = 8; %number of output vectors
ntest = 700; %number of test samples

%extract the required data (output = 0 or 7) into the matrix 'mydata'
[rows,cols] = size(optdigits);
max = 0;
j = 0;

%for i = 1:rows
%        if( optdigits(i,cols) == 0 || optdigits(i,cols) == 7)
%            j = j + 1;
%            for k = 1:cols-1
%                mydata(j,k) = optdigits(i,k);
%                ideal_output(j) = optdigits(i,65);
%                if(max < mydata(j,k))
%                    max = mydata(j,k);
%                end
%            end
%        end
%end

for i = 1:rows
    if( optdigits(i,cols) == 14 || optdigits(i,cols) == 19 || optdigits(i,cols) == 20 || optdigits(i,cols) == 22 || optdigits(i,cols) == 26 || optdigits(i,cols) == 33 || optdigits(i,cols) == 34)
        j = j+1;
        for k = 1:cols-1
            mydata(j,k) = optdigits(i,k);
            if(max < mydata(j,k))
                max = mydata(j,k);
            end
            if(optdigits(i,65) == 14)
                ideal_ouput(j) = 1;
            elseif(optdigits(i,65) == 19)
                ideal_output(j) = 2;
            elseif(optdigits(i,65) == 20)
                ideal_output(j) = 3;
            elseif(optdigits(i,65) == 22)
                ideal_output(j) = 4;
            elseif(optdigits(i,65) == 26)
                ideal_output(j) = 5;
            elseif(optdigits(i,65) == 33)
                ideal_output(j) = 6;
            elseif(optdigits(i,65) == 34)
                ideal_output(j) = 7;
            else
                ideal_output(j) = 8;
            end
        end
    end
end
            

%normalize the input data
%mydata = mydata/max;
[mydata_rows,mydata_cols] = size(mydata); %just an error check

%My structure of neural network is as follows:
%input layer = 64 units
%output layer = 8 units
%There is only one hidden layer
%no.of units in hidden layer = 4

%initialize weight vectors and bias vectors
for i = 1:n2
    for j = 1:n1
        w2(i,j) = 0.00001;
    end
end

for i = 1:n3
    for j = 1:n2
        w3(i,j) = 0.00001;
    end
end

for i = 1:n2
    b2(i) = 0.00001;
end
b2 = (b2.');

for i = 1:n3
    b3(:,i) = 0.00001;
end
b3 = (b3.');

%take the input as a(1). it's a row vector
for k = 1:ntest
    a(:,k) = mydata(k,:);

    [w2_rows, w2_cols] = size(w2); %just an error check
    [a_rows, a_cols] = size(a); %just an error check

    sum_y(:,1) = w2*a(:,k) + b2;

    [z_rows,z_cols] = size(sum_y); %just an error check
    [b2_rows, b2_cols] = size(b2); %just an error check

    y = sigmf(sum_y,[1,0]);

%output column
    sum_z(:,1) = w3*y + b3;

    z = sigmf(sum_z,[1,0]);

    ideal_output; %just an error check

    for i = 1:8
        myoutput(i,1) = 0;
    end
    
    if(ideal_output(:,k) == 1)
        my_output(1,1) = 1;
    elseif(ideal_output(;,k) == 2)
        my_output(2,1) = 1;
    elseif(ideal_output(;,k) == 3)
        my_output(3,1) = 1;
    elseif(ideal_output(;,k) == 4)
        my_output(4,1) = 1;
    elseif(ideal_output(;,k) == 5)
        my_output(5,1) = 1;
    elseif(ideal_output(;,k) == 6)
        my_output(6,1) = 1;
    elseif(ideal_output(;,k) == 7)
        my_output(7,1) = 1;
    else
        my_output(8,1) = 1;
    end

    [rows_z, cols_z] = size(z); %just an error check
    [rows_myoutput, cols_myoutput] = size(my_output); %just an error check

    %compute delta3
    diff3 = (z - my_output);
    derivative3 = (exp(-sum_z))./((1+exp(-sum_z)).^2);
    delta3 = diff3.*derivative3

    %compute delta2
    derivative2 = (exp(-sum_y))./((1+exp(-sum_y)).^2);
    mult2 = (w3.')*delta3;
    delta2 = mult2.*derivative2;

    w3 = w3 - delta3*(y.')
    b3 = b3 - delta3

    w2 = w2 - delta2*(a(:,k).')
    b2 = b2 - delta2
end

count = 0;
for k = ntest+1:mydata_rows
    a(:,k) = mydata(k,:);
    z = forward_prop(a(:,k),w2,w3,b2,b3)
    %if (z(1) > z(2))
    %    if(ideal_output(k) == 0)
    %        count = count+1;
    %    end
    %else
    %    if(ideal_output(k) == 7)
    %        count = count + 1;
    %    end
    %end
    [max,myindex] = max(z);
    if(myindex == ideal_output(k))
        count = count + 1;
    end
end
count