clear all
POP=xlsread('dataV2_UN\Population_UN.xlsx');
GDP_three=xlsread('dataV2_UN\GDP_three.xlsx');

load 'Results\carbon_country_final'

load 'Results\Energy_country_final'

for q=1:30 %number

CO2_initial_1=carbon_final(:,(q-1)*14+1:(q-1)*14+7)
CO2_initial(1,:,:)=transpose(cell2mat(CO2_initial_1(2:6,4:6)))
CO2_initial_2=carbon_final(:,(q-1)*14+8:(q-1)*14+14) 
CO2_initial(2,:,:)=transpose(cell2mat(CO2_initial_2(2:6,4:6)))


Energy_initial_1=energy_final(:,(q-1)*14+1:(q-1)*14+7)
Energy_initial(1,:,:)=transpose(cell2mat(Energy_initial_1(2:6,4:6)))
Energy_initial_2=energy_final(:,(q-1)*14+8:(q-1)*14+14) 
Energy_initial(2,:,:)=transpose(cell2mat(Energy_initial_2(2:6,4:6)))

W=zeros(1,3,5);%year sector energy
for i=1:1
    for j=1:3
        for m=1:5
           W(i,j,m)=(CO2_initial(i+1,j,m)-CO2_initial(i,j,m))/(log(CO2_initial(i+1,j,m))-log(CO2_initial(i,j,m)));
        end
    end
end
W(isinf(W))=0; 
W(isnan(W))=0;


CI=CO2_initial./Energy_initial;
CI(isinf(CI))=0;
CI(isnan(CI))=0;


CIE=zeros(1,3,5);
for k=1:1
    for j=1:3
        for i=1:5
            if CI(k,j,i)>0
              CIE(k,j,i)=W(k,j,i)*log(CI(k+1,j,i)/CI(k,j,i));
            end
        end
    end
end
CIE(isinf(CIE))=0;
CIE(isnan(CIE))=0;


energy_sum=sum(Energy_initial,3);


ES=zeros(2,3,5);
for k=1:2
    for j=1:3
        for i=1:5
        ES(k,j,i)=Energy_initial(k,j,i)/energy_sum(k,j);
        end
    end
end
ES(isinf(ES))=0;
ES(isnan(ES))=0;

ESE=zeros(1,3,5);
for k=1:1
    for j=1:3
        for i=1:5
            if ES(k,j,i)>0
              ESE(k,j,i)=W(k,j,i)*log(ES(k+1,j,i)/ES(k,j,i));
            end
        end
    end
end
ESE(isinf(ESE))=0;
ESE(isnan(ESE))=0;

EIE=zeros(1,3);
W_a=sum(W,3);
EI=energy_sum./GDP;
for k=1:1
    for j=1:3
        if EI(k,j)>0
              EIE(k,j)=W_a(k,j)*log(EI(k+1,j)/EI(k,j));
        end
    end
end
EIE(isinf(EIE))=0;
EIE(isnan(EIE))=0;


GDP=GDP_three((q-1)*2+1:(q-1)*2+2,:)
GDP_t=sum(GDP,2)
POP1=POP(q,:)'


GDP_p=GDP_t./POP1;
GDP_p(isinf(GDP_p))=0;
GDP_p(isnan(GDP_p))=0;

S=zeros(2,3);
for k=1:2
    for j=1:3
       S(k,j)=(GDP(k,j)/GDP_t(k,1)); 
    end
end

ISE=zeros(1,3);
for k=1:1
    for j=1:3
        if S(k,j)>0
              ISE(k,j)=W_a(k,j)*log(S(k+1,j)/S(k,j));
        end
    end
end
ISE(isinf(ISE))=0;
ISE(isnan(ISE))=0;

GPE=zeros(1,1);
W_b=sum(W_a,2);
for k=1:1
    GPE(k,1)=W_b(k,1)*log(GDP_p(k+1,1)/GDP_p(k,1));
end

PE=zeros(1,1);
for k=1:1
    PE(k,1)=W_b(k,1)*log(POP1(k+1,1)/POP1(k,1));
end

end
    
 