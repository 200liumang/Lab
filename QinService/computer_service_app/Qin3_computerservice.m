function [StructDate,UI_printInf,flag_isUsed]=Qin3_computerservice(Sigframe_decoded,Pf,flag_yundong)
%%% �龰3 Q>0 T>0
%%% Sigframe_decoder :��ʱ���ռ�������Ч֡���ݽ�����Ľ�� Ĭ����һ֡Ԫ������
%%% flag_yundong: �Ͳ�������Ե����˶�Ŀ�� 0��ֹ 1������
%%% Q��T���� ����ѡ���֧
%%% ��������� 
%%%  Loc_dingwei:    �����λ���
%%%  StructDate:     ��λ�ṹ�� ĳ��֧��
%%%  flag_isUsed=0   ��λ����Ƿ���Ч

%%% �����˲� �����ź���ȷ��
    %%% there? or other?
addpath 'E:\A_Matlab2020a\Matlab2020a\bin\computer_service_app\ComSer2_situtation3'

% �غ�׼����
% simulation_sigframe = load('E:\�������֡2����\Mixframe2_2020_11_12_10_53_58_650_decode.mat');
% simulation_sigframe =simulation_sigframe.Struct_data;
% ServiceFram =load('E:\�������֡2����\Service2_Qin3Frame');
% simulation_RD=ServiceFram.RD_cell;
%

% ��һ���� ���ݽ�֡ %
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
index =1;
for i=1:P_num
    StructDate{8}(i+1,1:3) = [Sigframe_decoded{41+index},Sigframe_decoded{41+index+1},0];
    index = index+2;
end
StructDate{9}=zeros(5,5);                   % zeros 5*5  Tɢ������Ϣ
T_num = Sigframe_decoded{56};
StructDate{9}(1,1) = T_num;

refdoa_order = Sigframe_decoded{65};
refS_order =1;
index=56;
for i=1:T_num
    S_order =Sigframe_decoded{index+1};
    doa_order =Sigframe_decoded{index+2};
    if doa_order == refdoa_order
        refS_order = S_order;              % ��òο�ɢ��������
    end
    StructDate{9}(i+1,1:3)=StructDate{7}(S_order+1,1:3);
    StructDate{9}(i+1,4)=S_order;
    StructDate{9}(i+1,5)=doa_order;
    index =index+2;
end

StructDate{10}=zeros(1,3);                  % �ο�ͨ���ź��������� DOA��Ϣ�е��ֶ�
StructDate{10}(1:2) = StructDate{8}(refdoa_order+1,1:2);
StructDate{10}(3) =  refdoa_order;
doa_ref=StructDate{1,10}(1:2);               % �ο�ͨ��DOA
%%%

if(T_num>1)
   flag_branch3=1;                                     %% ������֧2����һ����־
else
   flag_branch3=2;
end
TDOA_FDOA_Az_DOA_1=StructDate;                         %%TDOA-DOA-Az-FDOA���ݽṹ�� AZ�ο�ͨ�������
TDOA_FDOA_Az_DOA_2=StructDate;
TDOA_FDOA_Az_DOA_3=StructDate;
%%%
Q=Q_num-1;                                             % ��¼����������
T=T_num-1;                                             % ��¼����������
%%% ��ȡֱ�ﲨ���� ��ȡ����ɢ���巽λ����RD���ݿ�
    flag_yundong=0;
    Scample_rate_1 = 32500000;        % scamping rate_1: 32.5MHZ
    Scample_rate_2 = 16250000;        % scamping rate_2: 16.25MHZ
    Scample_rate_3 = 8125000;         % scamping rate_3: 8.125MHZ
    Scample_rate_4 = 4062500;         % scamping rate_4: 4.0625MHZ
    Scample_rate_5 = 203125;          % scamping rate_5: 203125KHZ       
%%%

%%%% �洢TDOA-DOA-Azimuth-DOA�ṹ��
    for i=10:-1:5
        TDOA_FDOA_Az_DOA_1{i+1}=TDOA_FDOA_Az_DOA_1{i};             %% �ճ�����Ԫ5 ��䷽λ�����ֲ���Ϣ
        TDOA_FDOA_Az_DOA_2{i+1}=TDOA_FDOA_Az_DOA_2{i};             %% �ճ�����Ԫ5 ��䷽λ�����ֲ���Ϣ
        TDOA_FDOA_Az_DOA_3{i+1}=TDOA_FDOA_Az_DOA_3{i};             %% �ճ�����Ԫ5 ��䷽λ�����ֲ���Ϣ
    end
        TDOA_FDOA_Az_DOA_1{5}=[1,12,30];                           %% ��λ��������ŷ�Χ����λ�ֱ���
        TDOA_FDOA_Az_DOA_2{5}=[1,12,30];                           %% ��λ��������ŷ�Χ����λ�ֱ���
        TDOA_FDOA_Az_DOA_3{5}=[1,12,30];                           %% ��λ��������ŷ�Χ����λ�ֱ���
%%%

%%% ��ȡIQ�źŲ����ʺʹ���
    Caiyang=StructDate{1,2}(1,3);
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
   Q_array=StructDate{1,7};  %%% ��ȡ��ɢ��������� ��/γ/�� ˲ʱ�ٶ�
   T_array=StructDate{1,9};  %%% 5*5 ɢ����λ����Ϣ ������ɢ�����ֶ��е���� ��DOA������Ϣ�ֶ��е����
   
   %%% ��ȡɢ�������ꡢ��ȡɢ�����ٶ�
    cen_state=StructDate{6}(1,1:3); %% ��ȡUCA��γ������
  % true area
    S_xyz = LBM_sXYZ((Q_array(2:Q_num+1,1:3))',cen_state);
    S_xyz = Q_array(2:Q_num+1,1:3)';               %  ���ƵĽ���֡ɢ����������վ������ϵ ����Ҫ����ת��         
  % temple area
   % S_xyz = StructDate{1,7}(2:end,1:3)';
    

%%%     true area                 % �غ�����ر��򽫴������
    S_ref =S_xyz(:,refS_order);   % Ĭ�Ͻ���һ���ɹ۲��ɢ������Ϊ�ο�ɢ����  �޸�:Ĭ�Ͻ���ǿɢ���������������Ϊ�ο� 
    T_sxyz=zeros(3,5);            
    j=1;
    for i=1:T_num                 % ��ȡ�������ο�ɢ���������ɢ��������
        if T_array(i+1,4) ~= refS_order
            T_sxyz(:,j)=S_xyz(:,T_array(i+1,4));
            j=j+1;
        end
    end

    vsi_array=Q_array(2:Q_num+1,4);
    fai_array=Q_array(2:Q_num+1,7);
    UCA_sudu =[0 0];                                                 %% UCA�ٶ�δ֪     
    S_vxyz=Count_Sv(S_xyz,vsi_array,fai_array,UCA_sudu);             %% ����ɢ�������� ɢ�������ꡢɢ����˲ʱ�ٶȡ�����ǡ�UCA�ٶ�1*2(����)
    S_vref=S_vxyz(:,T_array(2,4));                                   %% ��¼�²ο�ɢ������ٶ�
    
    StructDate{1,7}(2:Q_num+1,4:6)=S_vxyz';                          %% ɢ�����ٶȸ����ṹ��
    TDOA_FDOA_Az_DOA_1{1,8}(2:Q_num+1,4:6)=S_vxyz';
    TDOA_FDOA_Az_DOA_2{1,8}(2:Q_num+1,4:6)=S_vxyz';
    TDOA_FDOA_Az_DOA_3{1,8}(2:Q_num+1,4:6)=S_vxyz';    
    RD_data =cell(1,12);                                            % Sigframe_decoded ��ȡRD������
    for i=68:79
        RD_data{i-67} = Sigframe_decoded{i};
    end
    
    % �غ� %
%     StructDate=Simu_structdata();
%      RD_data = simulation_RD;
%     S_xyz=StructDate{1,7}(2:Q_num+1,1:3)';
%     S_vxyz=Count_Sv(S_xyz,vsi_array,fai_array,UCA_sudu);             %% ����ɢ�������� ɢ�������ꡢɢ����˲ʱ�ٶȡ�����ǡ�UCA�ٶ�1*2(����)
%     StructDate{1,7}(2:Q_num+1,4:6)=S_vxyz';
%     doa_ref=StructDate{1,10}(1:2);                                   % �ο�ͨ��DOA
%     refS_order = 3;
%     S_ref =S_xyz(:,refS_order);   %% Ĭ�Ͻ���һ���ɹ۲��ɢ������Ϊ�ο�ɢ����  �޸�:Ĭ�Ͻ���ǿɢ���������������Ϊ�ο� 
%     T_array=StructDate{1,9};  %%% 5*5 ɢ����λ����Ϣ ������ɢ�����ֶ��е���� ��DOA������Ϣ�ֶ��е����
%     T_sxyz=zeros(3,5); 
%     j=1;
%     for i=1:T_num                 % ��ȡ�������ο�ɢ���������ɢ��������
%         if T_array(i+1,4) ~= refS_order
%             T_sxyz(:,j)=S_xyz(:,T_array(i+1,4));
%             j=j+1;
%         end
%     end
    %
    UI_printInf =cell(1,11);
%%%

%%% �ڶ����� ��ȡɢ�������� ɢ�����Ӧ��λ��/������ ��װRd_cell CFAR��� ��ֵ���   
   Rd1_cell=cell(1,6);       %%% ����Rd1��������  ����װ�ط�֧1 p-1��DOA��Ӧ�ķ�λ������RD����
   Rd2_cell=cell(1,3);       %%% ����Rd2��������  ����װ�ط�֧2 Q-1���ǲο�ɢ�����Ӧ��λ����RD����
   Rd3_cell=cell(1,3);       %%% ����Rd3��������  ����װ�ط�֧3 T-1���ǲο�ɢ�����Ӧ��λ����RD����
   Pefeng1_cell=cell(1,6);   %%% Pefeng1_cell���� ����װ�ط�֧1 p-1��DOA��Ч���׷��������
   Pefeng2_cell=cell(1,3);   %%% Pefeng2_cell���� ����װ�ط�֧2 Q-1��ɢ������Ч���׷��������
   Pefeng3_cell=cell(1,3);   %%% Pefeng3_cell���� ����װ�ط�֧2 T-1���ɹ۲���Ч���׷��������

    
   %%% CFAR �������Ҫ�Ĳ���
   N=20;
   k=floor(N*3/4);
   Protect_unit = 2;  %% Rd_���ݱ�����������
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
  
   % ���ݷ�֧���ɷ�ֵ�������   
      Order_Sdoaref=refdoa_order;          %% �ο�T��DOA���    ���뱣֤T_array ��һ���ǲο�ɢ����
      DOA_array=StructDate{1,8};
      DOA_num = DOA_array(1,1)-1;          %% ��¼��ȥ�ο�ɢ���巽�������DOA�Ƕ�
      
       T_doa =zeros(2,5);  T_v=zeros(3,5);
       j=1;
       for i=1:T_num                       % ��ȡ�������ο�ɢ����ķ���Ǻ��ٶ�
        if T_array(i+1,4)~=refS_order
        T_doa(:,j)=(DOA_array(T_array(i+1,5)+1,1:2))';                  %% DOA
        T_v(:,j)=S_vxyz(:,T_array(i+1,4));
        j=j+1;
        end
       end
        S_vxyz(:,refS_order)=[];                                      % ����ɾ���ο�ɢ������ٶ�
        S_xyz(:,refS_order) = [];                                     % ����ɾ���ο�ɢ����
        DOA_array(Order_Sdoaref+1,:)=[];                              % ɾ���ο�ɢ�����DOA�� ��һ����DOA������
        DOA_num2 = DOA_num-1;                                           % ���ڼ�¼��Ч��DOA����
        doa_array =DOA_array(2:end,1:2)';

      % ��ʼ��ȡp-1��RD������ 
      rd_index1=zeros(1,DOA_num);  
      count_branch1=0;
      record_cfarout_branch1 = cell(1,DOA_num);
      for i=1:DOA_num                              % ��֧1
         rd_index1(i) =Select_RdBaseDoa(DOA_array(i+1,1));
         [Rd1_cell{1,i},L_k]=AcquireRdDate2(RD_data,rd_index1(i),flag_caiyangl); % ��ʼ��ȡRD��������
          
         if flag_caiyang==1                        % �߲������µķ�֧
           Rd_array=Rd1_cell{1,i};
           feng = zeros(1,L_k(2));
           for j=1:2*L_k(2)+1
               feng(j)=sum(abs(Rd_array(:,j)));    % ѡȡ��ֵ������
           end
           [~,cfar_index]=max(feng);
           flag_noise=NoisType(abs(Rd_array(:,cfar_index)'),0.0001); % ��ȡ�������� 0.0001������ˮƽ ˮƽ�½���������Ϊ0.1
           [Order_l,T_Sn,Xk]=Qin_CFAR(Pf,abs(Rd_array(:,cfar_index)'),2*L_k(1)+1,flag_noise,N_pf,N,k,Protect_unit);   
                                                                     % �������� Pf��Rd_����/���У�RD���ݳ��� �������� ���ڳ���
                                                                     % k=��3/4-1/2��N ������Ԫ����   
           record_cfarout_branch1{i} = Order_l;
           NoisePower=[Xk,T_Sn(2)];
           [pufeng_array,Index_array]=RD_pufengsearch(abs(Rd_array), Order_l,   NoisePower,   doa_ref,  i,   flag_caiyangl, flag_noise); 
                                                                     %  RD����  ��ѡ�������
                                                                     %  ��������(Sn����) ����� ɢ�������
                                                                     %  �����ʾ���  ��������
           if pufeng_array~=-1                                       % ���pufeng_array����Ч��
               Pefeng1_cell{count_branch1+1}=pufeng_array;                          
               Index_array(7,:)=rd_index1(i);                        % Index_array �����������ڱ���ͨ��ɸѡ������
            %  doa_array(:,count_branch1+1)=(DOA_array(i+1,1:2))';
               TDOA_FDOA_Az_DOA_1{1,11+i}=Index_array';
               count_branch1=count_branch1+1;
           else
               DOA_num2=DOA_num2-1;
               TDOA_FDOA_Az_DOA_1{1,11+i}=0;                           %% ��װ��ǰʱ�� RD�׼����
           end
           
         else                                   % �Ͳ������µķ�֧
           Rd_array=Rd1_cell{1,i};
           feng = zeros(1,L_k(1));
           for j=1:2*L_k(1)+1
               feng(j)=sum(abs(Rd_array(j,:)));  % ѡȡ��ֵ������
           end
           [~,cfar_index]=max(feng);
           flag_noise=NoisType(abs(Rd_array(cfar_index,:)),0.0001);    %% ��ȡ��������  ˮƽ�½���������Ϊ0.1
           [Order_l,T_Sn,Xk]=Qin_CFAR(Pf,abs(Rd_array(cfar_index,:)),2*L_k(2)+1,flag_noise,N_pf,N,k,Protect_unit);  %%�������� Pf��Rd_����/���У�RD���ݳ��� �������� ���ڳ��� k=��3/4-1/2��N ������Ԫ����
           record_cfarout_branch1{i} = Order_l;
           
           NoisePower=[Xk,T_Sn(2)];
           [pufeng_array,Index_array]=RD_pufengsearch(abs(Rd_array),Order_l,NoisePower,doa_ref,i,flag_caiyangl,flag_noise); %%RD���� ��ѡ������� ��������(Sn����) ����� ɢ������� �����ʾ���
           if pufeng_array~=-1
               Pefeng1_cell{count_branch1+1}=pufeng_array;                          
               Index_array(7,:)=rd_index1(i);                            %% Index_array �����������ڱ���ͨ��ɸѡ�ĵ㼣��Ϣ
             % doa_array(:,count_branch1+1)=(DOA_array(i+1,1:2))';
               TDOA_FDOA_Az_DOA_1{1,11+i}=Index_array';
               count_branch1=count_branch1+1;
           else
               DOA_num2=DOA_num2-1;
               TDOA_FDOA_Az_DOA_1{1,11+i}=0;
           end
         end   
      end
      format1=('TDOA-FDOA-Azimuth-DOA-%.3fMHZ-%.3f������-%d��%d��%d��-%dʱ%d��%d��.mat');
      str1 = ['E:\�������֡2����\TDOA_FDOA_Azimuth_DOA_sit3_1\',sprintf(format1,StructDate{2}(1),StructDate{2}(3),StructDate{1}(1),StructDate{1}(2),StructDate{1}(3),StructDate{1}(4),StructDate{1}(5),StructDate{1}(6))];
      save(str1,'TDOA_FDOA_Az_DOA_1')  %%����ýṹ��
%       disp(['�龰3��֧1: ',sprintf('������%d��������%d��DOAֵ��Ӧ����',DOA_num-1,DOA_num2) ,'�����׷��������']);
      str2 = sprintf('  �龰3��֧1: ����%d��������%d���������׷�����',DOA_num-1,DOA_num2);
      UI_printInf{1} =record_cfarout_branch1;
      UI_printInf{2} = str2;
      UI_printInf{3} = str1;
            
   if ((Q_num>1 && T_num==1) || flag_branch3==1) %% ��֧2
     count_branch2=0;
     record_cfarout_branch2 = cell(1,Q_num-1);                                  % ��¼CFAR���������뵽UI��
     
     for i=1:(Q_num-1)
       [S_Aoa,index_Rd]=Select_Rd(S_xyz(:,i));                                % ��ȡ��λ��/������    
       StructDate{1,7}(i+1,7:8)=S_Aoa';                                       % Ϊ�ṹ����¶�Ӧɢ����ķ�λ��/������
       TDOA_FDOA_Az_DOA_2{1,8}(i+1,7:8)=S_Aoa';
       [Rd2_cell{1,i},L_k]=AcquireRdDate2(RD_data,index_Rd,flag_caiyangl);    % ��ʼ��ȡRD��������
       
       if flag_caiyang==1   %%% �߲������µķ�֧
           Rd_array=Rd2_cell{1,i};
           feng = zeros(1,L_k(2));
           for j=1:2*L_k(2)+1
               feng(j)=sum(abs(Rd_array(:,j)));   %% ѡȡ��ֵ������
           end
           [~,cfar_index2]=max(feng);
           flag_noise=NoisType(abs(Rd_array(:,cfar_index2)'),0.0001);                   %% ��ȡ��������  0.0001������ˮƽ ˮƽ�½���������Ϊ0.1
           [Order_l,T_Sn,Xk]=Qin_CFAR(Pf,abs(Rd_array(:,cfar_index2)'),2*L_k(1)+1,flag_noise,N_pf,N,k,Protect_unit);   
                                           %%% �������� Pf��Rd_����/���У�RD���ݳ��� �������� ���ڳ���
                                           %%% k=��3/4-1/2��N ������Ԫ����  
           record_cfarout_branch2{i} = Order_l;
           
           NoisePower=[Xk,T_Sn(2)];
           [pufeng_array,Index_array]=RD_pufengsearch(abs(Rd_array), Order_l,   NoisePower,   doa_ref,  i,   flag_caiyangl, flag_noise); 
                                                                     %%%  RD����  ��ѡ�������
                                                                     %%%  ��������(Sn����) ����� ɢ�������
                                                                     %%%  �����ʾ���  ��������
           if pufeng_array~=-1             %%  ���pufeng_array����Ч��
               Pefeng2_cell{count_branch2+1}=pufeng_array;                          
               Index_array(7,:)=index_Rd;                            %% Index_array �����������ڱ���ͨ��ɸѡ�ĵ㼣��Ϣ
               TDOA_FDOA_Az_DOA_2{1,11+i}=Index_array';
               count_branch2=count_branch2+1;
           else
               Q=Q-1;
               TDOA_FDOA_Az_DOA_2{1,11+i}=0;                           %% ��װ��ǰʱ�� RD�׼����
           end
           
       else   % �Ͳ������µķ�֧
           Rd_array=Rd2_cell{1,i};
           feng = zeros(1,L_k(1));
           for j=1:2*L_k(1)+1
               feng(j)=sum(abs(Rd_array(j,:)));   %% ѡȡ��ֵ������
           end
           [~,cfar_index2]=max(feng);
           flag_noise=NoisType(abs(Rd_array(cfar_index2,:)),0.0001);  % ��ȡ�������� ˮƽ�½���������Ϊ0.1
           [Order_l,T_Sn,Xk]=Qin_CFAR(Pf,abs(Rd_array(cfar_index2,:)),2*L_k(2)+1,flag_noise,N_pf,N,k,Protect_unit);  %%�������� Pf��Rd_����/���У�RD���ݳ��� �������� ���ڳ��� k=��3/4-1/2��N ������Ԫ����
           record_cfarout_branch2{i} = Order_l;                        % ��¼CFAR���������뵽UI��
           
           NoisePower=[Xk,T_Sn(2)];
           [pufeng_array,Index_array]=RD_pufengsearch(abs(Rd_array),Order_l,NoisePower,doa_ref,i,flag_caiyangl,flag_noise); %%RD���� ��ѡ������� ��������(Sn����) ����� ɢ������� �����ʾ���
           if pufeng_array~=-1
               Pefeng2_cell{count_branch2+1}=pufeng_array;
               Index_array(7,:)=index_Rd;                             % Index_array ��������
               TDOA_FDOA_Az_DOA_2{1,11+i}=Index_array';
               count_branch2=count_branch2+1;
           else
               Q=Q-1;
               TDOA_FDOA_Az_DOA_2{1,11+i}=0;
           end
       end
     end
      format1=('TDOA-FDOA-Azimuth-DOA-%.3fMHZ-%.3f������-%d��%d��%d��-%dʱ%d��%d��.mat');
      str1 = ['E:\�������֡2����\TDOA_FDOA_Azimuth_DOA_sit3_2\',sprintf(format1,StructDate{2}(1),StructDate{2}(3),StructDate{1}(1),StructDate{1}(2),StructDate{1}(3),StructDate{1}(4),StructDate{1}(5),StructDate{1}(6))];
      save(str1,'TDOA_FDOA_Az_DOA_2')  %%����ýṹ��
      str2 = sprintf('  �龰3��֧2: ����%d��ɢ���壬%dɢ�������������׷�����',Q_num-1,Q);
%       disp(['�龰3״̬Mention��֧2: ',sprintf('%d��ɢ����',Q) ,'�׷����������Ч']);
      UI_printInf{4} =record_cfarout_branch2;
      UI_printInf{5} = str2;
      UI_printInf{6} = str1;

   end  
   
   if (Q_num>1 && T_num>1)  % ��֧3
      count_branch3=0;
      record_cfarout_branch3 = cell(1,T_num-1);
      for i=1:(T_num-1)
       index_Rd=Select_RdBaseDoa(T_doa(1,i));                                 % ��ȡ��λ��/������ 
       
       StructDate{1,7}(i+1,7:8)=S_Aoa';                                       % Ϊ�ṹ����¶�Ӧɢ����ķ�λ��/������
       TDOA_FDOA_Az_DOA_3{1,8}(i+1,7:8)=T_doa(:,i)';
       [Rd3_cell{1,i},L_k]=AcquireRdDate2(RD_data,index_Rd,flag_caiyangl);    % ��ʼ��ȡRD��������
       if flag_caiyang==1   % �߲������µķ�֧
           Rd_array=Rd3_cell{1,i};
           feng = zeros(1,L_k(2));
           for j=1:2*L_k(2)+1
               feng(j)=sum(abs(Rd_array(:,j)));   % ѡȡ��ֵ������
           end
           [~,cfar_index3]=max(feng);
           flag_noise=NoisType(abs(Rd_array(:,cfar_index3)'),0.0001);          % ��ȡ�������� ˮƽ�½���������Ϊ0.1
           [Order_l,T_Sn,Xk]=Qin_CFAR(Pf,abs(Rd_array(:,cfar_index3)'),2*L_k(1)+1,flag_noise,N_pf,N,k,Protect_unit);   
                                           %%% �������� Pf��Rd_����/���У�RD���ݳ��� �������� ���ڳ���
                                           %%% k=��3/4-1/2��N ������Ԫ����
           record_cfarout_branch3{i} = Order_l;
           
           NoisePower=[Xk,T_Sn(2)];
           [pufeng_array,Index_array]=RD_pufengsearch(abs(Rd_array), Order_l,   NoisePower,   doa_ref,  i,   flag_caiyangl, flag_noise); 
                                                                     %%%  RD����  ��ѡ�������
                                                                     %%%  ��������(Sn����) ����� ɢ�������
                                                                     %%%  �����ʾ���  ��������
           if pufeng_array~=-1              %%  ���pufeng_array����Ч��
               Pefeng3_cell{count_branch3+1}=pufeng_array;                          
               Index_array(7,:)=index_Rd;                            %% Index_array �����������ڱ���ͨ��ɸѡ�ĵ㼣��Ϣ
               TDOA_FDOA_Az_DOA_3{1,11+i}=Index_array';
               count_branch3=count_branch3+1;
           else
               T=T-1;
               TDOA_FDOA_Az_DOA_3{1,11+i}=0;                        % ��װ��ǰʱ�� RD�׼����
           end
       else                 %%% �Ͳ������µķ�֧
           Rd_array=Rd3_cell{1,i};
           feng = zeros(1,L_k(1));
           for j=1:2*L_k(1)+1
               feng(j)=sum(abs(Rd_array(j,:)));   % ѡȡ��ֵ������
           end
           [~,cfar_index3]=max(feng);
           flag_noise=NoisType(abs(Rd_array(cfar_index3,:)),0.0001); % ��ȡ��������  ˮƽ�½���������Ϊ0.1
           [Order_l,T_Sn,Xk]=Qin_CFAR(Pf,abs(Rd_array(cfar_index3,:)),2*L_k(2)+1,flag_noise,N_pf,N,k,Protect_unit);  %%�������� Pf��Rd_����/���У�RD���ݳ��� �������� ���ڳ��� k=��3/4-1/2��N ������Ԫ����
           record_cfarout_branch3{i} = Order_l;
           
           NoisePower=[Xk,T_Sn(2)];
           [pufeng_array,Index_array]=RD_pufengsearch(abs(Rd_array),Order_l,NoisePower,doa_ref,i,flag_caiyangl,flag_noise); %%RD���� ��ѡ������� ��������(Sn����) ����� ɢ������� �����ʾ���
           if pufeng_array~=-1
               Pefeng3_cell{count_branch3+1}=pufeng_array;
               Index_array(7,:)=index_Rd;                            % Index_array ��������
               TDOA_FDOA_Az_DOA_3{1,11+i}=Index_array';              % CFAR�������Ű���������
               count_branch3=count_branch3+1;
           else
               T=T-1;
               TDOA_FDOA_Az_DOA_3{1,11+i}=0;
           end
       end
     end
%       disp(['�龰3״̬Mention��֧3: ',sprintf('%d���ɹ۲�ɢ����',T) ,'�׷����������Ч']);
      format1=('TDOA-FDOA-Azimuth-DOA-%.3fMHZ-%.3f������-%d��%d��%d��-%dʱ%d��%d��.mat');
      str1 = ['E:\�������֡2����\TDOA_FDOA_Azimuth_DOA_sit3_3\',sprintf(format1,StructDate{2}(1),StructDate{2}(3),StructDate{1}(1),StructDate{1}(2),StructDate{1}(3),StructDate{1}(4),StructDate{1}(5),StructDate{1}(6))];
      save(str1,'TDOA_FDOA_Az_DOA_3')  %%����ýṹ��
      str2 = sprintf('  �龰3��֧3: ����%d��ɢ���壬%dɢ�����������������׷�����',T_num-1,T);
      UI_printInf{7} =record_cfarout_branch3;
      UI_printInf{8} = str2;
      UI_printInf{9} = str1;
   end
   

   
%%%%% �������� ������ʼ������� TDOA/DOA FDOA/DOA��϶�λ�׶�%%%%%
    if (Q_num==1 && T_num==1)
       [trace_cell_1,is_trace1]=Q3_tracecouple_branch1(Pefeng1_cell,DOA_num2,doa_array);   %% ��Ч��DOA_num2���� point_cell_1=0
       flag_branch=1;
    elseif (Q_num>1 && T_num==1)
       [trace_cell_1,is_trace1]=Q3_tracecouple_branch1(Pefeng1_cell,DOA_num2,doa_array);   %% ��Ч��DOA_num2���� point_cell_1=0
       [trace_cell_2,is_trace2]=Q3_tracecouple_branch2(Pefeng2_cell,Q_num);                %% ��Ч��Num_Q����    point_cell_2=0
       flag_branch=2;
    elseif (Q_num>1 && T_num>1) 
       [trace_cell_1,is_trace1]=Q3_tracecouple_branch1(Pefeng1_cell,DOA_num2,doa_array);   %% ��Ч��DOA_num2���� point_cell_1=0
       [trace_cell_2,is_trace2]=Q3_tracecouple_branch2(Pefeng2_cell,Q_num);                %% ��Ч��Num_Q����    point_cell_2=0
       [trace_cell_3,is_trace3]=Q3_tracecouple_branch3(Pefeng3_cell,T_num);               %% ��Ч��Num_T����    point_cell_3=0
       flag_branch=3;
    end
   
    trace_array_1=0;       trace_array_2=0;               trace_array_3=0;
    if (Q_num==1 && T_num==1)
       if is_trace1~=0
           if flag_caiyangl~=3
               trace_cell2_1=Qin3_pro_trace_couple(trace_cell_1,T_Sn(1),flag_caiyang);
               trace_array_1=trace_cell2_1{1};
           else
               trace_cell2_1=Qin3_pro_trace_couple(trace_cell_1,T_Sn(2),flag_caiyang);
               trace_array_1=trace_cell2_1{1};
           end
       else
%            disp('�龰3״̬Mention��֧1: ����1����Ч��λ�������');
       end
       
    elseif (Q_num>1 && T_num==1)
       if is_trace1~=0
           if flag_caiyangl~=3
               trace_cell2_1=Qin3_pro_trace_couple(trace_cell_1,T_Sn(1),flag_caiyang);
               trace_array_1=trace_cell2_1{1};
           else
               trace_cell2_1=Qin3_pro_trace_couple(trace_cell_1,T_Sn(2),flag_caiyang);
               trace_array_1=trace_cell2_1{1};
           end
       else
%             disp('�龰3״̬Mention��֧2:  ����1����Ч��λ�������');
       end
       if is_trace2~=0
           if flag_caiyangl~=3
               trace_cell2_2=Qin3_pro_trace_couple(trace_cell_2,T_Sn(1),flag_caiyang);
               trace_array_2=trace_cell2_2{1};
           else
               trace_cell2_2=Qin3_pro_trace_couple(trace_cell_2,T_Sn(2),flag_caiyang);
               trace_array_2=trace_cell2_2{1};
           end
       else
%              disp('�龰3״̬Mention��֧2:  ����2����Ч��λ�������');
       end
       
    elseif (Q_num>1 && T_num>1)
       if is_trace1~=0
           if flag_caiyangl~=3
               trace_cell2_1=Qin3_pro_trace_couple(trace_cell_1,T_Sn(1),flag_caiyang);
               trace_array_1=trace_cell2_1{1};
           else
               trace_cell2_1=Qin3_pro_trace_couple(trace_cell_1,T_Sn(2),flag_caiyang);
               trace_array_1=trace_cell2_1{1};
           end
       else
%             disp('�龰3״̬Mention��֧3:  ����1����Ч��λ�������');
       end
       if is_trace2~=0
           if flag_caiyangl~=3
               trace_cell2_2=Qin3_pro_trace_couple(trace_cell_2,T_Sn(1),flag_caiyang);
               trace_array_2=trace_cell2_2{1};
           else
               trace_cell2_2=Qin3_pro_trace_couple(trace_cell_2,T_Sn(2),flag_caiyang);
               trace_array_2=trace_cell2_2{1};
           end
       else
%             disp('�龰3״̬Mention��֧3:  ����2����Ч��λ�������');
       end
       if is_trace3~=0
           if flag_caiyangl~=3
               trace_cell2_3=Qin3_pro_trace_couple(trace_cell_3,T_Sn(1),flag_caiyang);
               trace_array_3=trace_cell2_3{1};
               
           else
               trace_cell2_3=Qin3_pro_trace_couple(trace_cell_3,T_Sn(2),flag_caiyang);
               trace_array_3=trace_cell2_3{1};
           end
       else
%             disp('�龰3״̬Mention��֧3: ����3����Ч��λ�������');
       end
    end
    
    trace_cluster=cell(1,3);
    trace_cluster{1}=trace_array_1; trace_cluster{2}=trace_array_2;  trace_cluster{3}=trace_array_3;
    S_txyz=[S_ref ,T_sxyz];
    S_tv  =[S_vref,T_v];
    f_array=ones(1,4)*StructDate{1,2}(1,1);
    [loc_shunshi,couple_array]=Qin3_LMStraceloc(trace_cluster,S_xyz,S_txyz,S_vxyz,S_tv,f_array,doa_ref,flag_caiyang,flag_branch,Q_num,T_num); 
    
    if loc_shunshi~=-1        % ��λ�н���� ����������� -1�������� / ��Ч����   couple_array ��Ч����Զ�λ��� 
       StructDate{1,11}=loc_shunshi;  
%        disp(['�龰3״̬Mention: ',sprintf('��֧%d',flag_branch) ,'��λ�����Ч']);
       flag_isUsed=1;        % ���ݽ������
    else
       StructDate{1,11}=0;  
%        disp(['�龰3״̬Mention: ',sprintf('��֧%d',flag_branch) ,'��λ�����Ч']);
       disp('�쳣ention: ��� trace_cluster�Ƿ�ȫ0 ���� ��λ����');
       flag_isUsed=0;        % ���ݽ��������
    end
    format1=('InstantPosition-%.3fMHZ-%.3f������-%d��%d��%d��-%dʱ%d��%d��.mat');
    str2 = ['E:\�������֡2����\CPIʱ�̵�˲ʱ��λ���\��λ�龰3\',sprintf(format1,StructDate{2}(1),StructDate{2}(3),StructDate{1}(1),StructDate{1}(2),StructDate{1}(3),StructDate{1}(4),StructDate{1}(5),StructDate{1}(6))];
    save(str2,'StructDate')  % ����ýṹ��
    UI_printInf{10} = couple_array; 
    UI_printInf{11} = str2; 
end


function index_Rd=Select_RdBaseDoa(fai)
% index_Rd ��������
if fai<180
    if fai<90
       if fai>=0 && fai<30
           index_Rd=1;
       elseif fai>=30 && fai<60
           index_Rd=2;
       else
           index_Rd=3;
       end
    else
       if fai>=90 && fai<120
           index_Rd=4;
       elseif fai>=120 && fai<150
           index_Rd=5;
       else
           index_Rd=6;
       end
    end
else
    if fai<270
        if fai>=180 && fai<210
           index_Rd=7;
       elseif fai>=210 && fai<240
           index_Rd=8;
       else
           index_Rd=9;
       end
    else
       if fai>=270 && fai<300
           index_Rd=10;
       elseif fai>=300 && fai<330
           index_Rd=11;
       else
           index_Rd=12;
       end
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �����Ҫ���� %%%%%%%%%%%%%%%%%%%%%%%%
function [StructDate] = Simu_structdata()
StructDate=cell(1,11);
StructDate{1}=[2020,10,2,11,32,40,1];
StructDate{2}=[15,30,32.5];
StructDate{3}=[1,163,30.77];
StructDate{4}=[0,0,0];
StructDate{5}=[0,1];
StructDate{6}=[0 0 0 0 0 0       %UCA����ģ�� ���� γ�� �߶� �ٶ�x y z
               0 0 0 0 0 0];     %��x ��y ��z ���� ���� 0
StructDate{7}=[ 3  0  0 0 0 0  0  0
                300,70,50 0 0 0 13.1 9.21     %% δ����ɢ����Q (NumQ+1)*8  ��һ�У�����
               -400 70 60 0 0 0 170.1 8.40    %% S���� Sγ�� S�߶�  S_�ٶ�x S_�ٶ�y S_�ٶ�z ���� ����
                5 -100 50 0 0 0 272.9 26.53];
StructDate{8}= [4 0 0                   %% DOA��Ϣ (Num_DOA+1)*3 ��һ�� DOA������
                45 4 0 
                272.9 26.53 0           %% ����� ������ ��������ǿ��                         
                13.1 9.21 0
                170.1 8.40 0
                ];
StructDate{9}= [3 0 0 0 0
                5 -100 50 3 2
                300 70 50 1 3
               -400 70 60 2 4];         %% zeros 1*5  Tɢ������Ϣ (Num_T+1)*5
StructDate{10}=[272.9 26.53 2];
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