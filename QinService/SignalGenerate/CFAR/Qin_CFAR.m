
function [Order_L,T_Sn,xk]=Qin_CFAR(Pf,Rd_date,l,flag_noise,N_pf,N,k,Protuct_unit)
%%%%���ز���˵���� RD���������е����   T��OC-CFAR���޳˻�����  SN;log-t����������
%%%%�������˵�� Pf�龯���� ����Ŀ��10-4 
%%%% IQ_noise 
%%%% Rd_date: Rd�׾����һ�л��ߵ�һ��   �������ն������������ݽ��д���
%%%% l������  flag_noise: ��������  N�����ڳ��� k��ѡ���k����Ԫ 
%%%% Protuct_unit:������Ԫ����
T=1; SN=1;  xk=0;
if flag_noise~=3
[order,T,xk] = OS_CFAR(Pf,Rd_date,l,flag_noise,N_pf,N,k,Protuct_unit);  %%�龯���� �����˲���Ļ���غ���(�����Ӳ�����) signal:RD�����׵�һ��(�и߲���) ��һ��(�Ͳ���) l:�������� N:���ڳ��� k:��k����С��Ԫ 
else
[order,~,SN] = Logt_CFAR(Pf,Rd_date,l,flag_noise,N_pf,N,Protuct_unit);
end
Order_L=order;  %%% ���龯���������
T_Sn=[T,SN];    %%% ���׷����ʱ������ֵ