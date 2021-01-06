function [range,T,Xk,xk] = OS_CFAR(Pf,signal,L,test,N_pf,N,k,protect_unit)
%Pf:�ĺ��龯����,signal:�����ķ���Դ����������,
%L:�������ȣ���ͬ�������¾��뵥Ԫ��Ŀ����,test:�Ӳ��ֲ�����,N���۲ⴰ�ڳ���k:�۲ⴰ���е�kС��Ԫ
syms x
num = length(signal);
range = zeros(L,1);
snr =zeros(L,1);
xk  =zeros(1,200);
%%%%%%%%%%%%%�����Ӳ���������龯����Pf%%%%%%%%%%%%%%%%%%%%
if test == 1%testָʾ���Ӳ��ֲ����ͣ�1�������ֲ���2���������ֲ�,4��K�ֲ�
    k_pf = floor((3/4)*N_pf);
	tmp = vpasolve(k*nchoosek(N_pf,k_pf)*gamma(N_pf-k_pf+1+x)*gamma(k_pf)/gamma(N_pf+1+x) == Pf);
	T = double(tmp);
elseif test == 2 %�������ֲ��ĺ��龯������״����c�йأ���ͨ���Ӳ���������c�������T
	mean = sum(log(signal))/num;
	sigma_square = sum((log(signal)-mean).^2)/num;
	c = pi/((6*sigma_square)^(1/2));
	tmp =  vpasolve(k*nchoosek(N,k)*gamma(N-k+1+x)*gamma(k)/gamma(N+1+x) == Pf);
	a = double(tmp);
	T = a^(1/c);
elseif test == 4 %K�ֲ������c=1�Ĺ�һ���ֲ�			 
%vͨ���Ӳ������Ķ���ԭ�����������빫ʽ�������һ��K�ֲ���PDF��CDF
	syms z pf fx x;
    signal_win = signal(1:N_pf);
	[PDF_z,CDF_z]  =knormalized_noise2(signal_win,z);%normalized K 
	fx = (1-CDF_xz)*k*nchoosek(N,k)*(1-CDF_z).^(N-k)*CDF_z.^(k-1)*PDF_z; 
	pf = int(fx,'z',0,inf);%�����pf��z-��������Ļ��֣��õ���Ӧ���ǹ���x�ĺ�
	tmp =  vpasolve(pf == Pf); %�����龯�µ�x����ֵ��tmp���ٸı��������͸�T
	T = double(tmp);
else
	T =0;
end
  Left=((1:L)-protect_unit-1);
  Right=((1:L)+protect_unit+N/2);
  %%%���ݱ�����Ԫ�ó����Ҽ���%%%
  for i=1:L
      if Left(i)>=N/2
          Left_limt=i-1;
          break;
      end
  end
  for i=L:-1:1
      if Right(i)<=L
          Right_limt=i+1;
          break;
      end
  end
  count=0;
if T ~= 0
	for i = (Left_limt+1):Right_limt-1        %����������зֳ��������֣��м䲿�����Ҷ�����ȡ��N/2����  
		xi = [signal(i-N/2-protect_unit:1:i-protect_unit-1),signal(i+protect_unit+1:1:i+N/2+protect_unit)];
		xi_sort = sort(xi);
		zk = xi_sort(k);
		S = zk*T;
		if signal(i) > S
			range(i) = i;
			snr(i) = signal(i)/S;
            xk(count+1)=zk;
            count=count+1;
		else
			range(i) = 0;
			snr(i) = 0;
		end
	end

	for i = 1:Left_limt
        left_end=i-protect_unit-1;
        if left_end>0
        left=signal(1:left_end);
        xi = [left signal(i+protect_unit+1:i+protect_unit+N-left_end)];  %%i+protect_unit+1:1:i+protect+N/2 
        else
            left_end=0;
            xi = signal(i+protect_unit+1:i+protect_unit+N-left_end);     %%i+protect_unit+1:1:i+protect+N/2 
        end
		xi_sort = sort(xi);
		zk = xi_sort(k);

		S = zk*T;
		if signal(i) > S
			range(i) = i;
			snr(i) = signal(i)/S;
            xk(count+1)=zk;
            count=count+1;
		else
			range(i) = 0;
			snr(i) = 0;
		end
	end
	for i = Right_limt:L
        right_start=i+protect_unit+1;
        if  right_start<L              %% right_start
        right=signal( right_start:L);
        right_num=size(right,2);
        xi = [signal(i-protect_unit-N-right_num:i-protect_unit-1) right];  %% �Ұ�ߵ�Ԫ���������߲���
        else
        right_num=0;
        xi = signal(i-protect_unit-N-right_num:i-protect_unit-1);          %% �Ұ�ߵ�Ԫ���������߲���
        end
		xi_sort = sort(xi);
		zk = xi_sort(k);

		S = zk*T;
		if signal(i) > S
			range(i) = i;
			snr(i) = signal(i)/S;
            xk(count+1)=zk;
            count=count+1;
		else
			range(i) = 0;
			snr(i) = 0;
		end
	end
else
	for i = 1:1:L
		range(i) = 0;
		snr(i) = 0;
	end
end
if count>0
   xk(all(xk==0,1))=[];
 Xk=sum(xk)/count;     %%ȡ����ƽ��
else
    Xk=1;
end
end
function [PDF,CDF]=knormalized_noise2(signal_win,z)
    N = length(signal_win);
    m2 = sum((signal_win).^2)/N;
    v = m2/4;
    c = 2*sqrt(v/m2);
    %���Ʋ�������ϵ�k�ֲ�
    PDF = 2*c/gamma(v)*((c*z/2).^v).*besselk(v-1,c*z);
    CDF = 1-2/gamma(v)*((z*c/2).^v).*besselk(v,z*c);
end