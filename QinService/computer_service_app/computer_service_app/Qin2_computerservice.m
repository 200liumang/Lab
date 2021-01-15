function [StructDate,UI_printInf,flag_isUsed]=Qin2_computerservice(Sigframe_decoded,Pf,flag_yundong)
%%% �龰2 Q>0 T=0
%%% Sigframe_decoder :��ʱ���ռ�������Ч֡���ݽ�����Ľ�� Ĭ����һ֡Ԫ������
%%% flag_yundong: �Ͳ�������Ե����˶�Ŀ�� 0��ֹ 1������ 
%%% ��������� 
%%%  Loc_dingwei:    �����λ���
%%%  StructDate:     ��λ�ṹ
%%%  flag_isUsed=0   ��λ����Ƿ���Ч

%%% �����˲� �����ź���ȷ��
  % there? or other?
addpath 'E:\A_Matlab2020a\Matlab2020a\bin\computer_service_app\ComSer2_situtation2'    

% �غ�׼����
% simulation_sigframe = load('E:\�������֡2����\Mixframe2_2020_11_12_10_53_58_650_decode.mat');
% simulation_sigframe =simulation_sigframe.Struct_data;
% simulation_RD = load('E:\�������֡2����\RD_cell_simulation.mat');
% simulation_RD = simulation_RD.RD_cell;
%

% ��ȡֱ�ﲨ���� ��ȡ����ɢ���巽λ����RD���ݿ�
flag_yundong=0;

Scample_rate_1 = 32500000;        % scamping rate_1: 32.5MHZ
Scample_rate_2 = 16250000;        % scamping rate_2: 16.25MHZ
Scample_rate_3 = 8125000;         % scamping rate_3: 8.125MHZ
Scample_rate_4 = 4062500;         % scamping rate_4: 4.0625MHZ
Scample_rate_5 = 203125;          % scamping rate_5: 203125KHZ
StructDate=cell(1,11);
 StructDate{1}=[Sigframe_decoded{5},Sigframe_decoded{6},Sigframe_decoded{7},Sigframe_decoded{8},Sigframe_decoded{9},Sigframe_decoded{10},Sigframe_decoded{11}]; % ��-��-��-ʱ-��-��-�߾��ȼ���
 Order_num =Sigframe_decoded{4};
 if Order_num==0
     scampling=0.203125;  %%�źŲ�����2013.125ksps
 elseif Order_num==1
     Band=3;            %% ����3MHz
     scampling=4.0625;  %% �źŲ�����4.0625Msps
 elseif Order_num==2
     Band=5;            %% ����5MHz
     scampling=8.125;   %% �źŲ�����8.125Msps
 elseif Order_num==3
     Band=10;           %% ����10MHz
     scampling=16.25;   %% �źŲ�����16.25Msps
 elseif Order_num==4
     Band=30;           %% ����30MHz
     scampling=32.5;    %% �źŲ�����32.25Msps
 end
 StructDate{2}=[Sigframe_decoded{3},Band,scampling];  % ����Ƶ��-����-������
 if scampling ==32.5
     L = 163; K=1;
 elseif scampling ==16.25
     L = 82; K=2;
 elseif scampling ==8.125
     L = 41; K=3;
 elseif scampling ==4.0625
     L = 21; K=6;
 elseif scampling ==0.203125
     L = 1;  K=113;
 end
 StructDate{3}=[1,L,scampling]; % ���뵥Ԫ��ŷ�Χ-����ֱ���(ns)
 StructDate{4}=[1,K,6];         % �����յ�Ԫ��ŷ�Χ-�����շֱ�Ƶ��(HZ)
 StructDate{5}=[0,1];           % ������������
 StructDate{6}=zeros(2,6);      % UCA���� γ�� �߶� �ٶ�x y z
                                % ��x ��y ��z ���� ���� 0
 UCA_state =[Sigframe_decoded{12},Sigframe_decoded{13},Sigframe_decoded{14}];
 UCA_magnetic = [Sigframe_decoded{17},Sigframe_decoded{18},Sigframe_decoded{19}];
 [UCA_azmiuth,UCA_pitch] = AntennaCor2StandardStationCor(UCA_magnetic,Sigframe_decoded{15},Sigframe_decoded{16},0,0);  % UCA��λ�Ǻ͸�����תΪվ������ϵ�½Ƕ�ֵ
 StructDate{6}(1,1:3)=UCA_state;
 StructDate{6}(1,1:3)=UCA_magnetic;
 StructDate{6}(1,4:5)=[UCA_azmiuth,UCA_pitch];
 Q_num = Sigframe_decoded{20};
 StructDate{7} = zeros(5,8);      % S���� Sγ�� S�߶�  S_�ٶ�x S_�ٶ�y S_�ٶ�z ����� ������
 StructDate{7}(1,1) = Q_num;
 index =1;
 for i=1:Q_num
     StructDate{7}(i+1,1:3) = [Sigframe_decoded{20+index},Sigframe_decoded{20+index+1},Sigframe_decoded{20+index+2}];
     StructDate{7}(i+1,4) = Sigframe_decoded{20+index+3};            % ����
     StructDate{7}(i+1,7) = Sigframe_decoded{20+index+4};            % �ٶ�
     index =index+5;
 end
P_num = Sigframe_decoded{41};
StructDate{8} = zeros(8,3);     % DOA��Ϣ 8*3 ��һ�� DOA������
                                % ����� ������ ��������ǿ��
StructDate{8}(1,1)=P_num;
index = 1;
for i=1:P_num
    StructDate{8}(i+1,1:3) = [Sigframe_decoded{41+index},Sigframe_decoded{41+index+1},0];
    index =index+2;
end
StructDate{9}=zeros(5,5);                   % zeros 5*5  Tɢ������Ϣ
refdoa_order = Sigframe_decoded{65};
StructDate{10}=zeros(1,3);                  % �ο�ͨ���ź��������� DOA��Ϣ�е��ֶ�
StructDate{10}(1:2) = StructDate{8}(refdoa_order+1,1:2);
StructDate{10}(3) =  refdoa_order;
TDOA_FDOA_Az_DOA=StructDate;                % TDOA-DOA-Az-FDOA���ݽṹ�� AZ�ο�ͨ�������
doa_ref=StructDate{1,10}(1:2);              % �ο�ͨ��DOA
%

%%%% �洢TDOA-DOA-Azimuth-DOA�ṹ��
    for i=10:-1:5
        TDOA_FDOA_Az_DOA{i+1}=TDOA_FDOA_Az_DOA{i};             %%�ճ�����Ԫ5 ��䷽λ�����ֲ���Ϣ
    end
        TDOA_FDOA_Az_DOA{5}=[1,12,30];                         %% ��λ��������ŷ�Χ����λ�ֱ���
%%%

%%% ��ȡIQ�źŲ����ʺʹ���
    Caiyang = StructDate{1,2}(1,3);
    if Caiyang<=33.5 && Caiyang >=4.0525
        flag_caiyang=1;
    else
        flag_caiyang=0;
    end
    
    if Caiyang==32.5
        flag_caiyangl=1;
    elseif Caiyang==16.25
        flag_caiyangl=2;
    elseif Caiyang==8.125
        flag_caiyangl=3;
    elseif Caiyang==4.0625
        flag_caiyangl=4;
    elseif Caiyang==0.203125
        flag_caiyangl=0;
    end
%%%
   %%% ��ȡɢ�������ꡢ��ȡɢ�����ٶ�
    Q_array=StructDate{1,7}; % ��ȡ��ɢ��������� ��/γ/�� ˲ʱ�ٶ�
    cen_state=StructDate{6}(1,1:3);
   % true area    
    S_xyz=LBM_sXYZ((Q_array(2:Q_num+1,1:3))',cen_state);
    S_xyz = Q_array(2:Q_num+1,1:3)';               %  ���ƵĽ���֡ɢ����������վ������ϵ ����Ҫ����ת�� 
   % temp area %%%
     % S_xyz=StructDate{1,7}(2:Num_Q+1,1:3)';
   %
    vsi_array=Q_array(2:Q_num+1,4);
    fai_array=Q_array(2:Q_num+1,7);
    UCA_sudu =[0 0];                                                 % UCA�ٶ�δ֪     
    S_vxyz=Count_Sv(S_xyz,vsi_array,fai_array,UCA_sudu);             % ����ɢ�������� ɢ�������ꡢɢ����˲ʱ�ٶȡ�����ǡ�UCA�ٶ�1*2(����) 
    StructDate{1,7}(2:Q_num+1,4:6)=S_vxyz';                          % ɢ�����ٶȸ����ṹ��
    TDOA_FDOA_Az_DOA{1,8}(2:Q_num+1,4:6)=S_vxyz';
    RD_data =cell(1,12);                                             % Sigframe_decoded ��ȡRD������
    for i=68:79
        RD_data{i-67} = Sigframe_decoded{i};
    end
   
   UI_printInf =cell(1,5);
%  �ڶ����� ��ȡɢ�������� ɢ�����Ӧ��λ��/������ ��װRd_cell CFAR��� ��ֵ���   
   Rd_cell=cell(1,4);       % ����RD��������  ����װ��ÿ��ɢ�����Ӧ�ķ�λ������RD����
   Pefeng_cell=cell(1,4);   % Pefeng_cell���� ����װ����Ч���׷��������
   Q=Q_num;                 % ���ڼ�¼RD��������Ч��ɢ��������
                                
   record_cfarout = cell(1,Q_num);
   record_noisetype =cell(1,Q_num);

   count_avail=0;
   for i=1:Q_num
       S_xyz_temp=Q_array(i+1,1:3)';
       [S_Aoa,index_Rd]=Select_Rd(S_xyz_temp);                       % ��ȡ��λ��/������ 
       StructDate{1,7}(i+1,7:8)=S_Aoa';                              % Ϊ�ṹ����¶�Ӧɢ����ķ�λ��/������
       TDOA_FDOA_Az_DOA{1,8}(i+1,7:8)=S_Aoa';  
       N=20;                                                         % CFAR��ÿ����ȡ��ǰ���ݵ㼰���ҳ���10
       k_cfar=floor(N*3/4);
       Protect_unit = 2;                                             % Rd_���ݱ�����������
       scampling =Caiyang*1e6;
       if scampling ==Scample_rate_1
           N_pf=200;
       elseif scampling ==Scample_rate_2
           N_pf=150;
       elseif scampling ==Scample_rate_3
           N_pf=70;
       elseif scampling ==Scample_rate_4
           N_pf=30;
       elseif scampling ==Scample_rate_5
       end
       % ȡ��ɢ�����Ӧ��������
       [Rd_cell{1,i},L_k]=AcquireRdDate2(RD_data,index_Rd,flag_caiyangl);  % ��ʼ��ȡRD��������
            
       if flag_caiyang==1   % �߲������µķ�֧
         Rd_array=Rd_cell{1,i};
         feng = zeros(1,L_k(2));
           for j=1:2*L_k(2)+1
               feng(j)=sum(abs(Rd_array(:,j)));   % ѡȡ��ֵ������
           end
           [~,cfar_index]=max(feng);
           flag_noise=NoisType(abs(Rd_array(:,cfar_index)'),0.0001);      % ��ȡ��������  ˮƽ�½���������Ϊ0.1
       
           [Order_l,T_Sn,Xk]=Qin_CFAR(Pf,abs(Rd_array(:,cfar_index)'),2*L_k(1)+1,flag_noise,N_pf,N,k_cfar,Protect_unit);   
                                                                          % �������� Pf��Rd_����/���У�RD���ݳ��� �������� ���ڳ���
                                                                          % k=��3/4-1/2��N ������Ԫ����
           record_cfarout{i} = Order_l;
           record_noisetype{i}=flag_noise;
           
           NoisePower=[Xk,T_Sn(2)];
           [pufeng_array,Index_array]=RD_pufengsearch(abs(Rd_array),Order_l, NoisePower, doa_ref,i,flag_caiyangl, flag_noise); 
                                                                          %  RD����  ��ѡ�������
                                                                          %  ��������(Sn����) ����� ɢ�������
                                                                          %  �����ʾ���  ��������
           if pufeng_array~=-1                                            %  ���pufeng_array����Ч��
               Pefeng_cell{ count_avail+1}=pufeng_array;                          
               Index_array(7,:)=index_Rd;                                 % Index_array �����������ڱ���ͨ��ɸѡ�ĵ㼣��Ϣ
               TDOA_FDOA_Az_DOA{1,11+i}=Index_array';
               count_avail=count_avail+1;
           else
               Q=Q-1;
               TDOA_FDOA_Az_DOA{1,11+i}=0;                                % ��װ��ǰʱ�� RD�׼����
           end        
       else                                                               % �Ͳ������µķ�֧
           Rd_array=Rd_cell{1,i};
           feng = zeros(1,L_k(1));
           for j=1:2*L_k(1)+1
               feng(j)=sum(abs(Rd_array(j,:)));                           % ѡȡ��ֵ������
           end
           [~,cfar_index]=max(feng);
           flag_noise=NoisType(abs(Rd_array(cfar_index,:)),0.0001);       % ��ȡ��������  ˮƽ�½���������Ϊ0.1
           [Order_l,T_Sn,Xk]=Qin_CFAR(Pf,abs(Rd_array(cfar_index,:)),2*L_k(2)+1,flag_noise,N_pf,N,k_cfar,Protect_unit);  %%�������� Pf��Rd_����/���У�RD���ݳ��� �������� ���ڳ��� k=��3/4-1/2��N ������Ԫ����
           
           record_cfarout{i} = Order_l;
           record_noisetype{i}=flag_noise;
           
           NoisePower=[Xk,T_Sn(2)];
           [pufeng_array,Index_array]=RD_pufengsearch(abs(Rd_array),Order_l,NoisePower,doa_ref,i,flag_caiyangl,flag_noise); %%RD���� ��ѡ������� ��������(Sn����) ����� ɢ������� �����ʾ���
           if pufeng_array~=-1
               Pefeng_cell{count_avail+1}=pufeng_array;                          
               Index_array(7,:)=index_Rd;                                % Index_array �����������ڱ���ͨ��ɸѡ�ĵ㼣��Ϣ
               TDOA_FDOA_Az_DOA{1,11+i}=Index_array';
               count_avail=count_avail+1;
           else
               Q=Q-1;
               TDOA_FDOA_Az_DOA{1,11+i}=0;
           end
       end

   end 
      format1=('TDOA-FDOA-Azimuth-DOA-%.3fMHZ-%.3f������-%d��%d��%d��-%dʱ%d��%d��.mat');
      str1 = ['E:\�������֡2����\TDOA_FDOA_Azimuth_DOA\',sprintf(format1,StructDate{2}(1),StructDate{2}(3),StructDate{1}(1),StructDate{1}(2),StructDate{1}(3),StructDate{1}(4),StructDate{1}(5),StructDate{1}(6))];
      save(str1,'TDOA_FDOA_Az_DOA')  % ����ýṹ��
      str2 = sprintf('  �龰2: ����%d��ɢ���壬%dɢ�������������׷����������',Q_num,Q);
%     disp(['�龰2״̬Mention: ',sprintf('%d������ɢ����',Q) ,'�׷������������Ч����']);
      UI_printInf{1} = record_cfarout;
      UI_printInf{2} = str2;   
      UI_printInf{3} = str1;                                              % ��¼TDOA_FDOA_Az_D0A����λ��
       
    % �������� ������ʼ������� TDOA/DOA FDOA/DOA��϶�λ�׶� %
    f_array=ones(1,Q_num)*StructDate{1,2}(1,1);  
    % ��λ�������������� -1������Ч��������   0�����ʺ϶�λ�� (��ʱ�����ֿ��� �׷����޹�������� ���� LMS�޶�λ���)
    if Q>0
       point_cluster_cell=trace_couple_index(Pefeng_cell,Q,doa_ref);    % ���ز�����Խ�� Ԫ������ ����������:
                                                                        % TDOAʱ���Ч�����_tdoa��FDOAʱ���Ч�����_fdoa�������_ref��������_ref ɢ��������
       if flag_caiyang==1                                               % �и߲����ʶ�λ
         if flag_caiyangl~=3
          point_cluster_cell2 = pro_trace_couple(point_cluster_cell,T_Sn(1),flag_caiyang);
         else
          point_cluster_cell2 = pro_trace_couple(point_cluster_cell,T_Sn(2),flag_caiyang);   
         end
         [loc_shunshi,couple_array] = LMS_traceloc(point_cluster_cell2,S_xyz,S_vxyz,f_array,doa_ref,flag_caiyang,flag_yundong); 
                                                                       % point_cluster,S_xyz,S_varray,f_array,doa_ref,flag_caiyang,flag_yundong
       else    %% �Ͳ����ʶ�λ
         point_cluster_cell2 = pro_trace_couple(point_cluster_cell,T_Sn(2),flag_caiyang); 
         [loc_shunshi,couple_array] = LMS_traceloc(point_cluster_cell2,S_xyz,S_vxyz,f_array,doa_ref,flag_caiyang,flag_yundong);
       end
       
       if loc_shunshi(1,1)~=-1  %��λ�н���� ����������� -1�������� / ��Ч����   couple_array ��Ч����Զ�λ��� 
           StructDate{1,11}=loc_shunshi;  
%          disp(['�龰2״̬Mention: ',sprintf('%d������ɢ����',Q) ,'�����Ч�Ķ�λ���']);
           flag_isUsed=1;        % ���ݽ������
       else
           StructDate{1,11}=0;  
%            disp(['�龰2״̬Mention: ',sprintf('%d������ɢ����',Q) ,'�����Ч�Ķ�λ���']);
%            disp(['�쳣ention: ���point_cluster_cell2�Ƿ�ȫ0 ���� ��λ����']);
           flag_isUsed=0;        % ���ݽ��������
       end
     UI_printInf{4} = couple_array;  
    else
        Loc_dingwei=-1;
        StructDate{1,11}=Loc_dingwei;
        flag_isUsed=0;           % ���ݽ��������
    end
     format1=('InstantPosition-%.3fMHZ-%.3f������-%d��%d��%d��-%dʱ%d��%d��.mat');
     str2 = ['E:\�������֡2����\CPIʱ�̵�˲ʱ��λ���\��λ�龰2\',sprintf(format1,StructDate{2}(1),StructDate{2}(3),StructDate{1}(1),StructDate{1}(2),StructDate{1}(3),StructDate{1}(4),StructDate{1}(5),StructDate{1}(6))];
     save(str2,'StructDate')  % ����ýṹ��
     UI_printInf{5} = str2;  
end  
function [Rd,L_k]=AcquireRdDate2(RD_data,index_Rd,flag_caiyangl)
    if flag_caiyangl==1
        l=163;k=1;
    elseif flag_caiyangl==2
        l=82; k=2;
    elseif flag_caiyangl==3
        l=41; k=3;
    elseif flag_caiyangl==4
        l=21; k=6;
    elseif flag_caiyangl==0
        l=1;  k=113;
    end
    L_k=[l,k];
    Rd=RD_data{index_Rd};
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �����Ҫ���� %%%%%%%%%%%%%%%%%%%%%%%%
% function StructDate = Simu_structdata()
% StructDate=cell(1,11);
% StructDate{1}=[2020,10,2,11,32,40];
% StructDate{2}=[15,30,32.5];
% StructDate{3}=[1,163,30.77];
% StructDate{4}=[0,0,0];
% StructDate{5}=[0,1];
% StructDate{6}=[0 0 0 0 0 0       %UCA����ģ�� ���� γ�� �߶� �ٶ�x y z
%                0 0 0 0 0 0];     %��x ��y ��z ���� ���� 0
% StructDate{7}=[ 3  0  0 0 0 0  0  0
%                 300,70,50 0 0 0 13.1 9.21     %% δ����ɢ����Q (NumQ+1)*8  ��һ�У�����
%                -400 70 60 0 0 0 170.1 8.40    %% S���� Sγ�� S�߶�  S_�ٶ�x S_�ٶ�y S_�ٶ�z ���� ����
%                 5 -100 50 0 0 0 272.9 26.53];
% StructDate{8}= [4 0 0                   %% DOA��Ϣ (Num_DOA+1)*3 ��һ�� DOA������
%                 45 4 0 
%                 13.1 9.21 0
%                 170.1 8.40 0
%                 272.9 26.53 0           %% ����� ������ ��������ǿ��                         
%                 ];
% StructDate{9}= [3 0 0 0 0
%                 5 -100 50 3 2
%                 300 70 50 1 3
%                -400 70 60 2 4];         %% zeros 1*5  Tɢ������Ϣ (Num_T+1)*5
% StructDate{10}=[45 4 1];
% end

