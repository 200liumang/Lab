function [StructDate,UI_printInf,flag_isUsed]=Qin1_computerseverce(MutilState_cell,Num_m,Num_zhen,ya, yb, k_up, k_down, r)
%%% �龰һ��������� �����龰1�����������龰���ύ�������� ���龰һ��ֱ�ӻ��֡��
%%% Num_m    �����Чվ��
%%% Num_zhen һվ��õ���Ч֡��
%%% tcp -> MutilState_cell  cellԪ�� ��cellԪ�� ��cellԪ����ÿ��վ�ڵĽ������֡����
%%% Loc:  ��õ����ն�λĿ��
%%% flag_isUsed =0;     %%�����ж����������Ƿ�����Ч����
addpath(genpath('E:\A_Matlab2020a\Matlab2020a\bin\computer_service_app\ComSer2_situtation1'))
Process_M=0;         %%�Ѿ������վ��
XYZ_ref=[0;0;0];     %%�ο�վ ��ʼΪ[0 0 0]
ClusterDoa_cell=cell(1,Num_m);  %%%�洢 Num_m����Чվ�ĵ�DOA������
count_num=0;        %%�����õ�վDOA
Loc_n=zeros(3,Num_m);
Loc_Target=zeros(4,100); %%ֱ�߽��㶨λ��Ŀ���洢 Ĭ�ϲ�����100
count_Target=1;     %%���ڸ���Loc_Target
UI_printInf=cell(1,3);
FrameInState_num = Num_zhen;
index = 0;
 while (true)
    %
        % δ�� tcp ��ȡָ��վ�µĹ̶�����֡�� ���ж�ͬվ��֡�Ƿ���ЧĬ�������ռ���֡��Ч
        % �ռ��꽫cell����(�洢֡)���ηŽ�MutilState_cell��
        index = index+1;
    %
     if Process_M>=1
        LBH_next =[MutilState_cell{index}{1}{12},MutilState_cell{index}{1}{13},MutilState_cell{index}{1}{14}]';
        % XYZ_next = LBH_XYZ(LBH_next,LBH_ref);   % ����ʵ����ʱ���յ�������ʱվ������
        XYZ_next = LBH_next;
        is=isvaild_n(XYZ_next,XYZ_ref);
        if is <1
            continue;
        end
        XYZ_ref = XYZ_next;
        CPI_DOAcell = AcquireDoA(MutilState_cell{index},FrameInState_num);        % CPI_DOAcell��Ԫ������ ��һ֡���ݵ�DOA�Ѿ����й���
        ClusterDoa_cell{count_num+1} = DOA_cluster(CPI_DOAcell,FrameInState_num); % �ռ���ǰվDOA������; 
        Loc_n(:,count_num+1) = XYZ_next;
        count_num = count_num+1;
        lineloc_res = line_location(Loc_n(:,count_num-1:count_num),ClusterDoa_cell(count_num-1:count_num));
        lineloc_res(:,all(lineloc_res==0,1)) = [];  
        
        dim=size(lineloc_res,2);                                                     % ��ȡֱ�߽����γ��
        if dim>0
            Loc_Target(:,count_Target:count_Target+dim-1)=lineloc_res;
            count_Target=count_Target+dim;     % �䵱����Loc_Target ������
        end
        Process_M = Process_M+1;
     end
     if Process_M==0                                                                % ������ʼվ ����Ҫ����XYZ_ref���бȽ�
         LBH_ref =[MutilState_cell{1}{1}{12},MutilState_cell{1}{1}{13},MutilState_cell{1}{1}{14}]';
         CPI_DOAcell = AcquireDoA(MutilState_cell{1},FrameInState_num);              % CPI_DOAcell��Ԫ������ ��һ֡���ݵ�DOA�Ѿ����й���
         ClusterDoa_cell{count_num+1}=DOA_cluster(CPI_DOAcell,FrameInState_num);     % �ռ���ǰվDOA������
         
         XYZ_ref= LBH_ref;               %% ����ʵ���ݣ�������վ������ʱXYZ_ref ��=[0,0,0]
         Loc_n(:,count_num+1)=XYZ_ref;
         count_num=count_num+1;
         Process_M = Process_M+1;
     end
     
     disp(['�龰1״̬Mention����õ�',sprintf('%d',Process_M),'վ��Ч����']);
     
    if  Process_M == Num_m                       % ��ǰ���ж���ʽ��û���ж�ÿ����Чվλ�Ƿ�õ���Ч�Ĳ��򽻻㶨λ
        break;                                 % ����ֻҪ������������㷨�еĿ��ܵ�Ŀ�����Ϊ�ռ���
    end
 end
% ***�ڶ����ֶ�վ���򽻻㶨λ ���м������� ������ն�λ��***
Loc_Target(:,all(Loc_Target==0,1))=[];  

dim=size(Loc_Target);                  % ��ȡֱ�߽����γ��
str = sprintf("�龰1��%dվ�����%d����򽻻㶨λ�����",Process_M,dim(2));
UI_printInf{1}=str;
if dim(2)>0
    Loc_sub=subcluster_loc(Loc_Target,Num_m,ya, yb, k_up, k_down, r);
    dim_sub=size(Loc_sub);
    if dim_sub(2)>0
        disp(['�龰1״̬Mention��',sprintf('%d',Process_M),'վ������λ�����ɣ���λ�����Ч��']);
        flag_isUsed=1;
    else
        disp(['�龰1״̬Mention��',sprintf('%d',Process_M),'վ������λ�����ɣ���λ�����Ч�������޸ļ��������㷨������']);
        Loc_sub=0;
        flag_isUsed=0;
    end
else
       disp(['�龰1״̬Mention��',sprintf('%d',Process_M),'վ���򽻻�����Ч��λ�����']);
       Loc_sub=-1;
       flag_isUsed=0;
end
UI_printInf{3}=Loc_sub;
loc_end=zeros(3,200);
if  flag_isUsed==1
    for i=1:dim_sub(2)
        loc_group= Loc_sub{i};
        loc_end(1,i)=sum(loc_group(1,:))/size(loc_group,2);
        loc_end(2,i)=sum(loc_group(2,:))/size(loc_group,2);
    end
end
loc_end(:,all(loc_end==0,1))=[];
str = sprintf("�龰1��%dվ�����%d�������ඨλ�����",Process_M,size(loc_end,2));
UI_printInf{2}=str;

StructDate = ComponentStruct(MutilState_cell{index}{Num_zhen});  % ���һվ ���һ֡
StructDate{1,11}=loc_end;  % Ϊ���ݽṹ����붨λ���
format1=('InstantPosition-%.3fMHZ-%.3f������-%d��%d��%d��-%dʱ%d��%d��.mat');
save(['E:\�������֡2����\CPIʱ�̵�˲ʱ��λ���\��λ�龰1\',sprintf(format1,StructDate{2}(1),StructDate{2}(3),StructDate{1}(1),StructDate{1}(2),StructDate{1}(3),StructDate{1}(4),StructDate{1}(5),StructDate{1}(6))],'StructDate')  %%����ýṹ��
end
   


function [XYZ,flag_isSame]=isSameStation(ByteDate,Num_zhen,Process_M,LBH_ref)
%%%ByteDate ��Ԫ������
    LBH_temp=zeros(3,Num_zhen);
    XYZ=[];
    flag_isSame=0;
    if Process_M==0           %%ֻ�жϾ�γ�Ȳ����������
         for i=1:Num_zhen
             date=ByteDate{i};
             jindu_zheng=typecast(date(1,20),'int8');      %%��ȡ��������
             jindu_xiaoshu=typecast(date(1,21:22),'int16');%%��ȡ����С��
             widu_zheng=typecast(date(1,23),'int8');       %%��ȡγ������
             widu_xiaoshu=typecast(date(1,24:25),'int16'); %%��ȡγ��С��
             Gaodu =typecast(date(1,26:27),'int16');       %%��ȡ�߶�����
             jindu=jindu_zheng+(jindu_xiaoshu/2^16);
             widu=widu_zheng+(widu_xiaoshu/2^16);
             LBH_temp(1,i)=jindu;
             LBH_temp(2,i)=widu;
             LBH_temp(3,i)=Gaodu;
         end
             XYZ=LBH_temp(:,2);                       %%��ʱ�����Ƿ�ͬһվ�ж�ֱ�ӷ������� �����м�֡����
    else
          for i=1:Num_zhen
             date=ByteDate{i};
             jindu_zheng=typecast(date(1,20),'int8');      %%��ȡ��������
             jindu_xiaoshu=typecast(date(1,21:22),'int16');%%��ȡ����С��
             widu_zheng=typecast(date(1,23),'int8');       %%��ȡγ������
             widu_xiaoshu=typecast(date(1,24:25),'int16'); %%��ȡγ��С��
             Gaodu =typecast(date(1,26:27),'int16');       %%��ȡ�߶�����
             jindu=jindu_zheng+(jindu_xiaoshu/2^16);
             widu=widu_zheng+(widu_xiaoshu/2^16);
             LBH_temp(1,i)=jindu;
             LBH_temp(2,i)=widu;  
             LBH_temp(3,i)=Gaodu;
          end
         
         XYZ_temp=LBM_XYZ(coordinate_LBH,LBH_ref);        %%����վַ����
         XYZ_error=XYZ_temp(1:2,2:3)-XYZ_temp(1:2,1);
         error=sqrt(sum(XYZ_error.^2));  count_youxiao=0;
         for i=1:Num_zhen-1
             if error(i)<5.5
                 count_youxiao=count_youxiao+1;
             end
         end
         if count_youxiao==Num_zhen-1
             flag_isSame=1;
             XYZ=XYZ_temp(:,1);                             %%����վλ����
         end
    end
end

function CPI_DOAcell=AcquireDoA(MutilState_decoder,zhen_Num)
  % MutilState_decoder�ǰ�����֡��Ԫ������

  CPI_DOAcell=cell(1,zhen_Num);
  for i=1:zhen_Num
     date=MutilState_decoder{i};
     DoA_num=date{41};                        % DOA���ݸ���
     CPI_DOA=zeros(DoA_num,3);                %
     count_doa=0;
     index=1;
     for j=1:DoA_num
         fangwei=date{41+index};                                % 0-360
          fuyang=date{41+index+1};                              % 0-90
         if fangwei~=0
             CPI_DOA(count_doa+1,1)=fangwei;
             CPI_DOA(count_doa+1,2)=fuyang;     %% �����ǿ������ ��ʱ��0
             count_doa=count_doa+1;
         end
         index = index+2;
         if (count_doa)>=DoA_num
             break;
         end
     end
     CPI_DOA=CPI_DOA';                         %% ��������ת��λ������
     if i==1                                   %% ɾ����һ֡�еĽ��ƽǶ�
         for j=1:DoA_num
            doa1=CPI_DOA(1,j);
            k=j+1;
             while(k<=DoA_num)
                 doa2=CPI_DOA(1,k);
                 if abs(doa1-doa2)<=3
                     CPI_DOA(:,j)=[];
                     DoA_num=DoA_num-1;
                     k=k-1;
                 end
                 k=k+1;
             end
         end
     end
     CPI_DOAcell{1,i}=CPI_DOA;
  end
end

function is=isvaild_n(station_xyz,ref_xyz)
% �龰һδʩ������ɢ�����˲ʱ��λ�㼣����_��n����Чվλʵʱ�ж�
% station_xyz����վλ�ռ����꣬�������ͣ���ǰվλ����
%ref_xyz ��ǰ��n������µĲο�վ
% ��Ч�ж�ԭ�򣺵�ǰվ����һվ������������20m ���ж�Ϊ��Ч is=0��Ч is=1 ��Ч

    pre=station_xyz-ref_xyz;
    dis=sqrt(pre'*pre);     %
    if dis>=20
        is=1;
    else
        is=0;
    end
end

function DOA_array=DOA_cluster(DOA_cell,I)
% �龰һδʩ������ɢ�����˲ʱ��λ�㼣����_��λ�Ǿ����㷨
% �ú�������UCA������ĳ��վλ��DOA���࣬��ҪĿ���ǹ��˷�Ŀ�����������
% DOA_cell�������ͣ�Ԫ����������Ϊ��I��֡��ȡ������DOA���ݣ�ÿһ��cell�������һ֡��DOA���ݵ�һ�з���ǣ��ڶ����Ǹ�����
% I��֡������,DOA�ĵ�λ�Ƕ�

shape=size(DOA_cell);  %��ȡԪ������������Ӧ����I��ͬ
DOA_array=zeros(4,100);  %�����õĽǶȲ��ᳬ��100��

cluster_cen=DOA_cell{1};               % ��һ��doa����Ϊ��ʼ�ο���������
cluster_shape=size(cluster_cen);       %��ȡ����������С
cluster_col=cluster_shape(2);          %��¼��ʼ�����ĵ�����
cluster_cell=cell(1,cluster_col*20);   %�����յľ���ռ�

for c=1:cluster_col
    cluster_cell{c}=cluster_cen(:,c);   %�������ĵ㴴������ռ� 
end
dfai=ones(1,100);                     %��Ϊÿ�β�ֵ�ļ�¼,��������ֵ���ᳬ��100��
dfai=dfai*500;                        %��֤��ʼԪ�����

for c=2:shape(2)
    %��DOA_cell����ȡԪ���������ھ���
    doa_cell=DOA_cell{c};dim=size(doa_cell);                %doa_cellһ֡��DOA����
    for c2=1:dim(2)
        for c3=1:cluster_col
            dfai(c3)=abs(doa_cell(1,c2)-cluster_cen(1,c3));%��¼��ǰdoa�����ĵ�ĸ�����ֵ
        end
          [res,index]=min(dfai);
            if res<=3
                cluster_cell{index}(:,end+1)=doa_cell(:,c2);  %������С������ӵ���Ӧ����ռ�
                r=size(cluster_cell{index});                %�õ�indexָ��ľ���ռ�
                cluster_cen(:,index)=((r(2)-1)*cluster_cen(:,index)+doa_cell(:,c2))/r(2);
            else
                cluster_cen(:,end+1)=doa_cell(:,c2);  %res����Сֵ����ֵ����3������Ϊ�µķ�������
                cluster_col=cluster_col+1;            %�������ĵ�����
                cluster_cell{cluster_col}=doa_cell(:,c2);   %�ھ���ռ��������´���һ����
            end
            dfai=ones(1,100);                     %���³�ʼ��dfai
            dfai=dfai*500;                       
    end
end

%%%�Ծ���ռ���м�飬���˵���Ч����
%         cluster_cell(i)=[];    %ɾ����Ӧ�ľ���ռ�
%         cluster_cen(:,i)=[];   %ɾ����Ӧ������ֵ   ��������������ֵ�;���ռ�ֵ��ͬ
shape2=size(cluster_cell);
col=1;
for i=1:cluster_col
    cell_shape=size(cluster_cell{i});
    if cell_shape(2)>=(I/2)
       cluster_space=cluster_cell{i};
       DOA_array(1,col)=cluster_cen(1,i);        %�ȷ��ø÷��������֧
       DOA_array(2,col)=cluster_cen(2,i);        %�ȷ��ø÷��������֧
       doa_euler=cluster_space-cluster_cen(:,i); 
       fai_euler=sqrt(sum(doa_euler(1,:).^2));
       theta_euler=sqrt(sum(doa_euler(2,:).^2));
       DOA_array(3,col)=fai_euler;                 %���ø÷���ĸ����Ǿ�ֵ
       DOA_array(4,col)=theta_euler;               %���øķ���ķ���Ǿ�ֵ
       col=col+1;
    end
end
DOA_array(:,all(DOA_array==0,1))=[];              %��ȥȫ����
%%%��I�ϴ���ԣ��Ƚ��й��ˣ��Ӷ�֪����DOA_CELLԤ�ȷ�����ռ�
end
% �ӽ���֡�й���ṹ��
function StructDate = ComponentStruct(Sigframe_decoded)
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
 P_num = Sigframe_decoded{41};
 StructDate{8} = zeros(8,3);     % DOA��Ϣ 8*3 ��һ�� DOA������
                                % ����� ������ ��������ǿ��
StructDate{8}(1,1)=P_num;
StructDate{9}=zeros(5,5);                   % zeros 5*5  Tɢ������Ϣ
refdoa_order = Sigframe_decoded{65};
StructDate{10}=zeros(1,3);                  % �ο�ͨ���ź��������� DOA��Ϣ�е��ֶ�
StructDate{10}(1:2) = StructDate{8}(refdoa_order+1,1:2);
StructDate{10}(3) =  refdoa_order;%
end

function location=line_location(station_n,DOA_n)
% �龰һδʩ������ɢ�����˲ʱ��λ�㼣����_˫վ��ά���߽��㶨λ
% station_n ��n����Ч��˫վ����x��y��z
% DOA_n�������ͣ�Ԫ����������Ϊ��n��˫վ���Ե�DOA���� cell������ǡ������ǡ�����Ǿ����������Ǿ������
% location Ӧ�ð������㶨λ�����������ζȣ�������
% �ú������ڵ�n��ǰ����վֱ�߽��㶨λ������¼��¼��λ�������������ζ�
% ע�⣺ ����ĽǶȱ��뱣֤0-360

%%%��ʼ��
state_1=station_n(1:2,1);  %%��������վ�Ķ�������
state_2=station_n(1:2,2);
DOA_1=DOA_n{1};          %%�洢����վ��DOA����
DOA_2=DOA_n{2};
shape1=size(DOA_1);      %%��¼��С
shape2=size(DOA_2);
loc_cell=zeros(1,5);     %%���㶨λ����С��Ԫ �������1�������2,��ֵ����1����ֵ����2;�����ǣ�
location=zeros(4,min(shape1(2),shape2(2)));  Index=1;
for col=1:shape1(2)
    loc_cell(1)=DOA_1(1,col);  %��ȡһ����С��Ԫ
    loc_cell(3)=DOA_1(3,col);
    for col2=1:shape2(2)   
        loc_cell(2)=DOA_2(1,col2);
        loc_cell(4)=DOA_2(3,col2);
        loc_cell(5)=DOA_2(2,col2);  %��ȡ������
        if (abs(loc_cell(1)-loc_cell(2))<=1)   %%�������ж���������ȣ������ΪС��1�ȼ�������ͬ
            continue;
        end
        Km_1=tan(loc_cell(1)*(pi/180));
          Km=tan(loc_cell(2)*(pi/180));
        x_j=(state_2(2)-state_1(2)-Km*state_2(1)+Km_1*state_1(1))/(Km_1-Km);
        y_j=(Km_1*state_2(2)-Km*state_1(2)-Km*Km_1*(state_2(1)-state_1(1)))/(Km_1-Km);
        if (loc_cell(2)>=0 && loc_cell(2)<90)
            if (x_j>state_2(1) && y_j>=state_2(2))
                flag=1 ;                     %%��־λ�������ж��Ƿ����ζ�λ�� 1Ϊ����
            else
                flag=0;
            end
        elseif (loc_cell(2)>=90 && loc_cell(2)<180)
            if (x_j<=state_2(1) && y_j>state_2(2))
                flag=1 ;                     %%��־λ�������ж��Ƿ����ζ�λ�� 1Ϊ����
            else
                flag=0;
            end
         elseif (loc_cell(2)>=180 && loc_cell(2)<270)
            if (x_j<state_2(1) && y_j<=state_2(2))
                flag=1 ;                     %%��־λ�������ж��Ƿ����ζ�λ�� 1Ϊ����
            else
                flag=0;
            end
        elseif (loc_cell(2)>=180 && loc_cell(2)<270)
             if (x_j<state_2(1) && y_j<=state_2(2))
                flag=1 ;                     %%��־λ�������ж��Ƿ����ζ�λ�� 1Ϊ����
            else
                flag=0;
             end
        elseif (loc_cell(2)>=270 && loc_cell(2)<360)
            if (x_j>=state_2(1) && y_j<state_2(2))
                flag=1 ;                     %%��־λ�������ж��Ƿ����ζ�λ�� 1Ϊ����
            else
                flag=0;
            end
        end
        if (flag==1)
            %%����������ζȺ���
            m_1=sec(loc_cell(1)*(pi/180));
            m=sec(loc_cell(2)*(pi/180));
            A_j=(state_2(2)-state_1(2)-(state_2(1)-state_1(1))*Km_1)/(Km_1-Km)^2*m^2;
            B_j=(state_2(2)-state_1(2)-(state_2(1)-state_1(1))*Km)/(Km_1-Km)^2*m_1^2;
            dx=A_j*loc_cell(4)+B_j*loc_cell(3);
            dy=Km_1*A_j*loc_cell(4)+Km*B_j*loc_cell(3);
            S_j=1/(dx*dy);          %%����������ζ�
            location(1,Index)=x_j;  %%��¼��Ч��λ��
            location(2,Index)=y_j;
            location(3,Index)=S_j;
            location(4,Index)=loc_cell(5);
            Index=Index+1;
        end
    end
end
end

function [sta_fw,sta_fy,alph,beta] = AntennaCor2StandardStationCor(H,fw,fy,ant_fw,ant_fy)

% ���ݵ�ǰ���������ڵ�xyz�ų���������ƫ�ǡ��������Ϣ����������doa���Ƶõ��ĽǶ�
% ��Ϣת��Ϊ��׼վ������ϵ�µķ�λ�Ǻ͸����ǡ�����Ķ�λ�����ڱ�׼վ������ϵ�½��е�

% H�����ų�������(Hx,Hy,Hz)1*3�ķ���
% fw����ƫ�ǣ��Ƕȣ���y��нǣ��ش�N����
% fy������ǣ��Ƕȣ���xoy��ļн�
% ant_fw������������ϵ�еķ�λ�ǣ��Ƕ�
% ant_fy������������ϵ�еĸ����ǣ��Ƕ�
% 
% sta_fw��վ������ϵ�ķ�λ�ǣ��Ƕ�
% sta_fy��վ������ϵ�ĸ����ǣ��Ƕ�

H_value = sqrt(H*H');
x1 = [H_value*cosd(fw)*cosd(fy);H_value*sind(fw)*cosd(fy);H_value*sind(fy)];
x2 = H';
A = (x1*x2')*(x2*x2')^(-1);
beta = acosd(H_value*sind(fy)/sqrt(H(1:2)*H(1:2)')) + atand(H(1)/H(3));
alph = acosd(H_value*cosd(fy)*sind(fw)/sqrt((H(1,1)*cosd(beta) - H(1,3)*sind(beta))^2 + H(1,2)^2)) - atand(H(1,3)/(H(1,1)*cosd(beta) - H(1,3)*sind(beta)));
ant = [cosd(ant_fy)*cosd(ant_fw);cosd(ant_fy)*sind(ant_fw);sind(ant_fy)];
sta = A*ant;
sta_fw = atand(sta(2,1)/sta(1,1));
sta_fy = asind(sta(3,1));


end

