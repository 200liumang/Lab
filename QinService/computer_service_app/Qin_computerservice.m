function [StructDate,UI_printInf,flag_Qin,flag_isUsed]=Qin_computerservice(Sigframe_decoded,Pf,flag_yundong)
%  flag_isUsed �ṹ�������д洢��StructDate{1,11}�����ݽṹ���Ƿ���Ч
%  StructDate  �ṹ������  Ԫ������ 1*11

% ���·��������
addpath 'E:\A_Matlab2020a\Matlab2020a\bin\computer_service_app'


% ����ѡ�� ���ȶ�ȡQ/T����
flag_Qin1=0;       % �龰��־λ
flag_Qin2=0;
flag_Qin3=0; 
count_zhen = 1;    % ��ʱĬ��ֻ����һ֡
Q_T=zeros(2,count_zhen);  
sitution=zeros(1,count_zhen);      % ����˵����ǰ֡��Ӧ�ĳ�������
for i=1:count_zhen
    
    Q_T(1,i)=Sigframe_decoded{1,20};   % ��ȡQɢ��������
    Q_T(2,i)=Sigframe_decoded{1,56};   % ��ȡTɢ��������
    if Q_T(1,i)==0 && Q_T(2,i)==0
        flag_Qin1=flag_Qin1+1;
        sitution(i)=1;
    elseif Q_T(1,i)> 0 && Q_T(2,i)==0
         flag_Qin2=flag_Qin2+1;
        sitution(i)=2;
    elseif Q_T(1,i)> 0 && Q_T(2,i)> 0
          flag_Qin3=flag_Qin3+1;
        sitution(i)=3;
    end
end
if flag_Qin1>(count_zhen/2)                % ȷ����λ���� ��Զ�֡Q-Tֵ��ͳһʱѡ��λ�������
    flag_Qin1=1; flag_Qin2=0;flag_Qin3=0;
    flag_Qin =1 ;                          % UI��֪��λ�龰
elseif flag_Qin2>(count_zhen/2)
    flag_Qin1=0; flag_Qin2=1;flag_Qin3=0;
    flag_Qin =2;
elseif flag_Qin3>(count_zhen/2)
    flag_Qin1=0; flag_Qin2=0;flag_Qin3=1;
    flag_Qin =3;
else
    flag_Qin1=0; flag_Qin2=1;flag_Qin3=0;  %% ������֡ѡ���龰2
    flag_Qin =2;
end
% �����龰����
% �������ز���˵���� 
if flag_Qin1==1
    disp('�龰1״̬Mention�����뵽����ɢ���嶨λ����1��');
    
elseif flag_Qin2==1
     % �龰2����
    disp('�龰2״̬Mention�����뵽����ɢ���嶨λ����2��');
    [StructDate,UI_printInf,flag_isUsed]=Qin2_computerservice(Sigframe_decoded,Pf,flag_yundong); %% ��δ���Ƕ�֡�����
    
elseif flag_Qin3==1
     % �龰3����
     disp('�龰3״̬Mention�����뵽����ɢ���嶨λ����3��');
     [StructDate,UI_printInf,flag_isUsed]=Qin3_computerservice(Sigframe_decoded,Pf,flag_yundong);
end


