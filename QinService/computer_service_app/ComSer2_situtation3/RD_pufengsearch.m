function [pufeng_array,Index_array]=RD_pufengsearch(RD_array,index_c,noise_power,doa_ref,si_index,flag_caiyangl,flag_noise)
%%%%�龰2 ����������CFAR������RD�׽����׷�����
%%%% RD_array ��ǰ�����ɢ����I��Ӧ��RD����
%%%% index_c ���ɼ���ֵ�������ţ�������  doa_ref�ο��Ƕ� �� flag_cayangl ������־λ 1:32.5 2:16.25
%%%% noise_power ������CFAR�з��ص���������  x(k), Sn   ������
%%%% 3:8.125  4:4.0625       0�ǵ�Ƶ�� 6.199  
%%%% pufeng_array ��������  ʱ����롢Ƶ����롢ɢ��������   ������0 ֤����Чɾ����Ӧɢ����
%%%% Index_array  ��������  ʱ����š����롢Ƶ����š����롢�ο�����(5,6) ��������  ��ҪΪTDOA-DOA-FDOA���ݽṹ�� ��Ҫʱ��ɾ��

high_jingdu=[30.77e-9,61.54e-9,123.05e-9,246.15];    %%ʱ��ֱ���            �Ѿ�����4.0625
zhong=[164,83,42,22];    
di_fjindu=6.199;                                     %%�Ͳ���Ƶ�ʷֱ���
di_tjindu=0;                                         %%�Ͳ���ʱ��ֱ���
pufeng_array=zeros(5,200);
Index_array=zeros(7,200);
p_noise=noise_power;                                 %%��������   ����:����CFAR�е���������
col2=size(RD_array);

if flag_noise>=1
    tao_fenbian=high_jingdu(flag_caiyangl);
    fd_fenbian=0;                         %%��Ҫ��¼�߲����¸߷ֱ���,��Ϊ0
    col=size(index_c);

  if index_c~=0
    for i=1:col(1)
        l=index_c(i);
       [C_max,k]=max(RD_array(l,:));
       %%%%���������
       if flag_caiyangl==3
           noise=p_noise(2);
       else
           noise=p_noise(1);
       end
       SNR_t=C_max/noise;
       SNR_f=0;
       %%%%��TDOA��Ž��в�ֵ����   FDOA����Ҫ
%        if l>=2 && l<col2(1)
%            C_pre=RD_array(l-1,k);
%            C_next=RD_array(l+1,k);
%            l=l+0.5*(C_pre-C_next)/(C_pre-2*C_max+C_next);
%        end
       %%%%
       pufeng_array(1,i)=(l-zhong(flag_caiyangl))*tao_fenbian;  % *2;       % ��ʽ������Ҫ��*2 �޳� ��Ϊ����ʱ�źŲ���������2��Ƶʱ�ӽ�Ϊʵ�ʵ�һ�룬��λʹ�õ�����ʵʱ�������Ҫ��2
       pufeng_array(2,i)=SNR_t;             %%SNR_t�Ѿ�����
       pufeng_array(3,i)=k*fd_fenbian;   
       pufeng_array(4,i)=SNR_f;             %%SNR_f�Ѿ�����
       pufeng_array(5,i)=si_index;          %%��¼ɢ��������
       %%%% TDOA-DOA-FODA���ݽṹ����������  ��Ҫʱ�ٽ⿪
       Index_array(1,i)=l;
       Index_array(2,i)=SNR_t;             
       Index_array(3,i)=k;   
       Index_array(4,i)=SNR_f;            
       Index_array(5:6,i)=doa_ref;          %%��¼����
    end
  else
      pufeng_array=-1;                    %%%���׷�array��Ч ɾ����Ӧɢ����
  end
else
     col=size(index_c);
   if index_c ~=0               %%%����Ƿ�CFAR������Ч����
     for i=1:col(1)
        k=index_c(i);
       [C_max,l]=max(RD_array(:,k));
       %%%%���������
       if flag_noise==3
           noise=p_noise(2);
       else
           noise=p_noise(1);
       end
       SNR_t=0;
       SNR_f=C_max/noise;
      %%%%��FDOA��Ž��в�ֵ����   TDOA����Ҫ
       if k>=2 && k<col2(1)
           C_pre=RD_array(l,k-1);
           C_next=RD_array(l,k-1);
           k=k+0.5*(C_pre-C_next)/(C_pre-2*C_max+C_nest);
       end
       %%%%
       pufeng_array(1,i)=l*di_tjindu;
       pufeng_array(2,i)=SNR_t;             %%SNR_t�Ѿ�����
       pufeng_array(3,i)=k*di_fjindu;             
       pufeng_array(4,i)=SNR_f;             %%SNR_f�Ѿ�����
       pufeng_array(5,i)=si_index;          %%��¼ɢ��������
       %%%% ��Ҫʱ�ٽ⿪
       Index_array(1,i)=l;
       Index_array(2,i)=SNR_t;             %%SNR_t����
       Index_array(3,i)=k;   
       Index_array(4,i)=SNR_f;             %%SNR_f����
       Index_array(6:7,i)=doa_ref;          %%��¼ɢ��������
     end
   else
       pufeng_array=-1;
   end
   
end
if index_c(1,1)~=0
pufeng_array(:,all(pufeng_array==0,1))=[];
Index_array(:,all(Index_array==0,1))=[];
end
