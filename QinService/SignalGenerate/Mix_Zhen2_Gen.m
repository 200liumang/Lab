% Model
% MixresultZhen = cell(1,77);
% MixresultZhen{1,1} = 85;
% MixresultZhen{1,2} = 16;
% MixresultZhen{1,3} = 32.5;        % ������ 32.5Msps/MHZ
% MixresultZhen{1,4} = 4;          % ����
% MixresultZhen{1,5} = 2020;        % ��
% MixresultZhen{1,6} = 11;          % ��
% MixresultZhen{1,7} = 9;           % ��
% MixresultZhen{1,8} = 9;           % ʱ
% MixresultZhen{1,9} = 58;          % ��
% MixresultZhen{1,10} = 30;         % ��
% MixresultZhen{1,11} = 1;          % ���ڼ���
% MixresultZhen{1,12} = 0;          % վ�ľ���
% MixresultZhen{1,13} = 0;          % վ��γ��
% MixresultZhen{1,14} = 0;          % վ�ĸ߶� ����
% MixresultZhen{1,15} = 0;          % �����
% MixresultZhen{1,16} = 0;          % ������
% MixresultZhen{1,17} = 0;          % x��ų�����
% MixresultZhen{1,18} = 0;          % Y��ų�����
% MixresultZhen{1,19} = 0;          % z��ų�����
% MixresultZhen{1,20} = 3;          % ����ɢ������� 
% MixresultZhen{1,21} = 0;          % ����ɢ���徫�� S1
% MixresultZhen{1,22} = 0;          % ����ɢ����γ�� S1
% MixresultZhen{1,23} = 0;          % ����ɢ����߶� S1
% MixresultZhen{1,24} = 0;          % ����ɢ�����ٶ� S1
% MixresultZhen{1,25} = 0;          % ����ɢ���巽�� S1
% MixresultZhen{1,26} = 0;          % ����ɢ���徫�� S2
% MixresultZhen{1,27} = 0;          % ����ɢ����γ�� S2
% MixresultZhen{1,28} = 0;          % ����ɢ����߶� S2
% MixresultZhen{1,29} = 0;          % ����ɢ�����ٶ� S2
% MixresultZhen{1,30} = 0;          % ����ɢ���巽�� S2
% MixresultZhen{1,31} = 0;          % ����ɢ���徫�� S3
% MixresultZhen{1,32} = 0;          % ����ɢ����γ�� S3
% MixresultZhen{1,33} = 0;          % ����ɢ����߶� S3
% MixresultZhen{1,34} = 0;          % ����ɢ�����ٶ� S3
% MixresultZhen{1,35} = 0;          % ����ɢ���巽�� S3
% MixresultZhen{1,36} = 0;          % ����ɢ���徫�� S4
% MixresultZhen{1,37} = 0;          % ����ɢ����γ�� S4
% MixresultZhen{1,38} = 0;          % ����ɢ����߶� S4
% MixresultZhen{1,39} = 0;          % ����ɢ�����ٶ� S4
% MixresultZhen{1,40} = 0;          % ����ɢ���巽�� S4
% MixresultZhen{1,41} = 4;          % DOA���ƽ������
% MixresultZhen{1,42} = 0;          % ��λ��1 
% MixresultZhen{1,43} = 0;          % ������1
% MixresultZhen{1,44} = 0;          % ��λ��2
% MixresultZhen{1,45} = 0;          % ������2
% MixresultZhen{1,46} = 0;          % ��λ��3
% MixresultZhen{1,47} = 0;          % ������3
% MixresultZhen{1,48} = 0;          % ��λ��4
% MixresultZhen{1,49} = 0;          % ������4
% MixresultZhen{1,50} = 0;          % ��λ��5
% MixresultZhen{1,51} = 0;          % ������5
% MixresultZhen{1,52} = 0;          % ��λ��6
% MixresultZhen{1,53} = 0;          % ������6
% MixresultZhen{1,54} = 0;          % ��λ��7
% MixresultZhen{1,55} = 0;          % ������7
% MixresultZhen{1,56} = 3;          % ����ɢ����ɲ������T
% MixresultZhen{1,57} = 0;          % ��һ��Tɢ������ţ�DOAֵ���
% MixresultZhen{1,58} = 0;          % �ڶ���Tɢ������ţ�DOAֵ���
% MixresultZhen{1,59} = 0;          % ������Tɢ������ţ�DOAֵ���
% MixresultZhen{1,60} = 0;          % ���ĸ�Tɢ������ţ�DOAֵ���
% MixresultZhen{1,61} = 1;          % ��ǰ�ο�ͨ���ź�����������DOAֵ�����к�
% MixresultZhen{1,62} = zeros(8,8);              % Э�������
% MixresultZhen{1,63} = zeros(1,32768);          % IQ�źŵ�
% 
% 
% scampling =MixresultZhen{1,3};
% if scampling ==32.5
%    l = 163; k=1;
% elseif scampling ==16.25
%    l = 82; k=2;
% elseif scampling ==8.125
%    l = 41; k=3;
% elseif scampling ==4.0625
%    l = 21; k=6;
% elseif scampling ==2.03125
%    l = 1;  k=113;
% end
% MixresultZhen{1,64} = zeros(2*l+1,2*k+1);            % ������32.5MHZ��һ������RD����
% MixresultZhen{1,65} = zeros(2*l+1,2*k+1);            % ������32.5MHZ�ڶ�������RD����
% MixresultZhen{1,66} = zeros(2*l+1,2*k+1);            % ������32.5MHZ����������RD����
% MixresultZhen{1,67} = zeros(2*l+1,2*k+1);            % ������32.5MHZ����������RD����
% MixresultZhen{1,68} = zeros(2*l+1,2*k+1);            % ������32.5MHZ����������RD����
% MixresultZhen{1,69} = zeros(2*l+1,2*k+1);            % ������32.5MHZ����������RD����
% MixresultZhen{1,70} = zeros(2*l+1,2*k+1);            % ������32.5MHZ����������RD����
% MixresultZhen{1,71} = zeros(2*l+1,2*k+1);            % ������32.5MHZ�ڰ�������RD����
% MixresultZhen{1,72} = zeros(2*l+1,2*k+1);            % ������32.5MHZ�ھ�������RD����
% MixresultZhen{1,73} = zeros(2*l+1,2*k+1);            % ������32.5MHZ��ʮ������RD����
% MixresultZhen{1,74} = zeros(2*l+1,2*k+1);            % ������32.5MHZ��ʮһ������RD����
% MixresultZhen{1,75} = zeros(2*l+1,2*k+1);            % ������32.5MHZ��ʮ��������RD����
% MixresultZhen{1,76} = 0;                             % У����
% MixresultZhen{1,77} =170;                            % ֡β
%% ����·����load�ض���Mixframe_decoder�����ú�������Mixframe2��bin�ļ�
% path1='D:\ZZJ_��Ŀ\����ɢ����-���������\�������֡2\MixZhen2_Qin2_1.bin';
% path2='D:\ZZJ_��Ŀ\����ɢ����-���������\�������֡2\MixZhen2_Qin2_2.bin';
% path3='D:\ZZJ_��Ŀ\����ɢ����-���������\�������֡2\MixZhen2_Qin2_3.bin';
% path4='D:\ZZJ_��Ŀ\����ɢ����-���������\�������֡2\MixZhen2_Qin2_4.bin';
% path5='D:\ZZJ_��Ŀ\����ɢ����-���������\�������֡2\MixZhen2_Qin2_5.bin';
pathQin3_1='D:\ZZJ_��Ŀ\����ɢ����-���������\�������֡2\MixZhen2_Qin3_1.bin';
pathQin3_2='D:\ZZJ_��Ŀ\����ɢ����-���������\�������֡2\MixZhen2_Qin3_2.bin';
pathQin3_3='D:\ZZJ_��Ŀ\����ɢ����-���������\�������֡2\MixZhen2_Qin3_3.bin';
pathQin3_4='D:\ZZJ_��Ŀ\����ɢ����-���������\�������֡2\MixZhen2_Qin3_4.bin';
pathQin3_5='D:\ZZJ_��Ŀ\����ɢ����-���������\�������֡2\MixZhen2_Qin3_5.bin';
Mixframe_decoder = load('E:\�������֡2����\Mixframe2_Qin3-S3-T1-���5_decode').Struct_data;
Mixframe_decoder{66} = zeros(8,8);
generate_Mixframe(Mixframe_decoder,pathQin3_5);
%%
fileId =fopen(pathQin3_3,'rb');
mixframe2_bin=fread(fileId,'uint8');
fclose(fileId);
[Struct_data2,isdecode]=decoder(mixframe2_bin);
%%
% rd_data = temp;
rd_data = Struct_data{68};
k=1; l=163;
[Y,X] =meshgrid(-k:k,-l:l);
Rd_plot = rd_data;
Rd_plot = abs(Rd_plot);
surf(X,Y,abs(Rd_plot),'Edgecolor','none');
%%
function generate_Mixframe(Mixframe_decoder,path)
MixresultZhen = cell(1,77);
for i=1:56
    MixresultZhen{1,i} = Mixframe_decoder{i};
end
MixresultZhen{1,57} = Mixframe_decoder{57}*2^4+Mixframe_decoder{58};      % ��һ��Tɢ������ţ�DOAֵ���
MixresultZhen{1,58} = Mixframe_decoder{59}*2^4+Mixframe_decoder{60};      % �ڶ���Tɢ������ţ�DOAֵ���
MixresultZhen{1,59} = Mixframe_decoder{61}*2^4+Mixframe_decoder{62};      % ������Tɢ������ţ�DOAֵ���
MixresultZhen{1,60} = Mixframe_decoder{63}*2^4+Mixframe_decoder{64};      % ���ĸ�Tɢ������ţ�DOAֵ���
for i=61:77
    MixresultZhen{1,i} =  Mixframe_decoder{i+4};
end
fileId =fopen(path,'w');
% fwrite(fileId,uint8(221),'uint8');
% fwrite(fileId,uint8(204),'uint8');
% fwrite(fileId,uint8(187),'uint8');
% fwrite(fileId,uint8(170),'uint8');
% fwrite(fileId,uint32(167060),'uint32');
fwrite(fileId,uint8(MixresultZhen{1,1}),'uint8');
fwrite(fileId,uint8(MixresultZhen{1,2}),'uint8');
cenfre_integer = uint16(floor(MixresultZhen{1,3}));
cenfre_decimal = uint16(floor((MixresultZhen{1,3}-floor(MixresultZhen{1,3}))*2^16)); 
fwrite(fileId,cenfre_integer,'uint16');              % ����Ƶ������
fwrite(fileId,cenfre_decimal,'uint16');              % ����Ƶ��С��
fwrite(fileId,uint8(MixresultZhen{1,4}),'uint8');    % ����
fwrite(fileId,uint16(MixresultZhen{1,5}),'uint16');  % ��
fwrite(fileId,uint8(MixresultZhen{1,6}),'uint8');    % ��
fwrite(fileId,uint8(MixresultZhen{1,7}),'uint8');    % ��
fwrite(fileId,uint8(MixresultZhen{1,8}),'uint8');    % ʱ
fwrite(fileId,uint8(MixresultZhen{1,9}),'uint8');    % ��
fwrite(fileId,uint8(MixresultZhen{1,10}),'uint8');   % ��
fwrite(fileId,uint32(MixresultZhen{1,11}),'uint32'); % ���ڼ���
statejin_integer = uint8(floor(MixresultZhen{1,12}));
statejin_decimal = uint16(floor((MixresultZhen{1,12}-floor(MixresultZhen{1,12}))*2^16));
fwrite(fileId,0,'uint8');                           % վַ��������
fwrite(fileId,statejin_integer,'uint8');            % վַ��������
fwrite(fileId,statejin_decimal,'uint16');           % վַ����С��
statewei_integer = int8(floor(MixresultZhen{1,13}));
statewei_decimal = uint16(floor((MixresultZhen{1,13}-floor(MixresultZhen{1,13}))*2^16));
fwrite(fileId,statewei_integer,'int8');             % վַγ������
fwrite(fileId,statewei_decimal,'uint16');           % վַγ��С��
fwrite(fileId,uint16(MixresultZhen{1,14}),'uint16');% վַ�߶�
azmiuth_integer = uint16(floor(MixresultZhen{1,15}));
azmiuth_decimal = uint8(floor((MixresultZhen{1,15}-floor(MixresultZhen{1,15}))*2^4));
fwrite(fileId,azmiuth_integer,'uint16');            % վַ���������
fwrite(fileId,azmiuth_decimal,'uint8');             % վַ�����С��
pitch_integer = uint8(floor(MixresultZhen{1,16}));
pitch_decimal = uint8(floor((MixresultZhen{1,16}-floor(MixresultZhen{1,16}))*2^4));
fwrite(fileId,pitch_integer,'uint8');               % վַ����������
fwrite(fileId,pitch_decimal,'uint8');               % վַ������С��
magneticx_integer = int16(floor(MixresultZhen{1,17}));
magneticx_decimal = uint8(floor((MixresultZhen{1,17}-floor(MixresultZhen{1,17}))*2^4));
fwrite(fileId,magneticx_integer,'int16');           % �ų�x��������
fwrite(fileId,magneticx_decimal,'uint8');           % �ų�x����С��
magneticy_integer = int16(floor(MixresultZhen{1,18}));
magneticy_decimal = uint8(floor((MixresultZhen{1,18}-floor(MixresultZhen{1,18}))*2^4));
fwrite(fileId,magneticy_integer,'int16');           % �ų�y��������
fwrite(fileId,magneticy_decimal,'uint8');           % �ų�y����С��
magneticz_integer = int16(floor(MixresultZhen{1,19}));
magneticz_decimal = uint8(floor((MixresultZhen{1,19}-floor(MixresultZhen{1,19}))*2^4));
fwrite(fileId,magneticz_integer,'int16');           % �ų�z��������
fwrite(fileId,magneticz_decimal,'uint8');           % �ų�z����С��
fwrite(fileId,uint8(MixresultZhen{1,20}),'uint8');  % ����ɢ��������
for i=21:40
    fwrite(fileId,single(MixresultZhen{1,i}),'single'); % 4������ɢ����:���ȡ�γ�ȡ��߶ȡ��ٶȡ�����
end
fwrite(fileId,uint8(MixresultZhen{41}),'uint8');    % ��Դ�ྶDOA���Ƹ���
for i=42:55
     fwrite(fileId,uint16(MixresultZhen{1,i}*2^3),'uint16'); %  7��DOA: ����ǣ�������
end
fwrite(fileId,uint8(MixresultZhen{56}),'uint8');    % �ɲ��������ɢ�������
for i=57:60
    fwrite(fileId,uint8(MixresultZhen{i}),'uint8'); % �ɲ�������ɢ������ſɲ�������ɢ���巽��
end
fwrite(fileId,uint8(MixresultZhen{61}),'uint8');    % �ο�ͨ����DOA���
for i=1:8
    for j=1:8
        rel = real(MixresultZhen{1,62}(i,j));
        img = imag(MixresultZhen{1,62}(i,j));
        fwrite(fileId,single(rel),'single');   % 8*8Э�������
        fwrite(fileId,single(img),'single');   % 8*8Э�������
    end
end
for i=1:32768
    rel = real(MixresultZhen{1,63}(1,i));
    img = imag(MixresultZhen{1,63}(1,i));             % 32768���źŲ�����
    fwrite(fileId,int16(floor(rel*2^16)),'int16');    % I·
    fwrite(fileId,int16(floor(img*2^16)),'int16');    % Q·
end
for i=64:75
  [row,column] = size(MixresultZhen{1,i});
  for j=1:row
    for k=1:column                                            % ʮ����������
        d1 = abs(MixresultZhen{1,i}(j,k))*2^24;               % ���ݷŴ�
        rel = d1*2^8;
        decimal = (rel-floor(rel))*2^8;            
        fwrite(fileId,uint16(floor(rel)),'uint16');    
        fwrite(fileId,uint8(floor(decimal)),'uint8');
    end
  end
end
fwrite(fileId,uint16(MixresultZhen{76}),'uint16');
fwrite(fileId,uint8(MixresultZhen{77}),'uint8');  % ���֡��ֹλ
fclose(fileId);
end
%%
function [Struct_data,isdecode]=decoder(ByteDate)
ByteDate = uint8(ByteDate(1:end)');
[~,len]=size(ByteDate) ;
isdecode = 0;
Struct_data = 0;
if len==167060
    %%%%% ȫ����֡��ʱ0.175s = 175 ms
    Struct_data=cell(1,81);            %% ���ݴ����
    Struct_data{1,1} = ByteDate(1,1);  %% ֡ͷ
    Struct_data{1,2} = ByteDate(1,2);  %% ������
    %%%����Ƶ�ʽ���%%%
    zhong_pinInteger=double(typecast(ByteDate(1,3:4),'uint16'));              %% ����Ƶ����������
    zhong_pinXiaoshu=double(typecast(ByteDate(1,5:6),'uint16'))*2^-16;        %% ����Ƶ��С������
    Struct_data{1,3}=zhong_pinInteger+zhong_pinXiaoshu;                       %% ����Ƶ��
    %%%������%%%
    Order_num = typecast(ByteDate(1,7),'uint8');                  %%������
    Struct_data{1,4} = Order_num;
    %%%%ʱ�����%%%%
    Struct_data{1,5}=typecast(ByteDate(1,8:9),'uint16');   %% ��
    Struct_data{1,6}=typecast(ByteDate(1,10),'uint8');     %% ��
    Struct_data{1,7}=typecast(ByteDate(1,11),'uint8');     %% ��
    Struct_data{1,8}=typecast(ByteDate(1,12),'uint8');     %% ʱ
    Struct_data{1,9}=typecast(ByteDate(1,13),'uint8');     %% ��
    Struct_data{1,10}=typecast(ByteDate(1,14),'uint8');    %% ��
    Struct_data{1,11}=typecast(ByteDate(1,15:18),'uint32');%% �߾���ʱ��
    %%%%UCAվַ��Ϣ����%%%%
    jindu_zheng=typecast(ByteDate(1,20),'int8');                          %% ��ȡ��������
    jindu_xiaoshu=typecast(ByteDate(1,21:22),'uint16');                   %% ��ȡ����С��
    widu_zheng=typecast(ByteDate(1,23),'int8');                           %% ��ȡγ������
    widu_xiaoshu=typecast(ByteDate(1,24:25),'uint16');                    %% ��ȡγ��С��
    Gaodu =typecast(ByteDate(1,26:27),'int16');                           %% ��ȡ�߶�����
    jindu=double(jindu_zheng)+(double(jindu_xiaoshu)/2^16);
    widu=double(widu_zheng)+(double(widu_xiaoshu)/2^16);
    Struct_data{1,12}= jindu;                                              %% ����
    Struct_data{1,13}= widu;                                               %% γ��
    Struct_data{1,14}= Gaodu;                                              %% �߶�
    jiao_fangxiang = typecast(ByteDate(1,28:29),'uint16');                 %% �������������
    jiao_fangXiao = typecast(ByteDate(1,30),'uint8');                      %% �����С������ 0-9
    Struct_data{1,15} = double(jiao_fangxiang)+(jiao_fangXiao)/2^4;        %% ����� ��ȷ����0.1��  0-360
    jiao_fuyang = typecast(ByteDate(1,31),'int8');                         %% ��������������
    jiao_fuyangX = typecast(ByteDate(1,32),'uint8');                       %% ������С������ 0-9
    Struct_data{1,16} = double(jiao_fuyang)+double(jiao_fuyangX)/2^4;      %% ������ ��ȷ����0.1��-90-90
    %%%%UCA�ų���Ϣ����%%%%
    magnetic_x = typecast(ByteDate(1,33:34),'int16');
    magnetic_xXiao = typecast(ByteDate(1,35),'uint8');
    if magnetic_x < 0
        magnetic_xXiao=magnetic_xXiao*-1;
    end
    magnetic_X = double(magnetic_x)+double(magnetic_xXiao)/2^4;
    magnetic_y = typecast(ByteDate(1,36:37),'int16');
    magnetic_yXiao = typecast(ByteDate(1,38),'uint8');
    if magnetic_y < 0
        magnetic_yXiao=magnetic_yXiao*-1;
    end
    magnetic_Y = double(magnetic_y)+double(magnetic_yXiao)/2^4;
    magnetic_z = typecast(ByteDate(1,39:40),'int16');
    magnetic_zXiao = typecast(ByteDate(1,41),'uint8');
    if magnetic_z < 0
        magnetic_zXiao=magnetic_zXiao*-1;
    end
    magnetic_Z = double(magnetic_z)+double(magnetic_zXiao)/2^4;
    Struct_data{1,17} = magnetic_X;                                       %% �ų�����x
    Struct_data{1,18} = magnetic_Y;                                       %% �ų�����y
    Struct_data{1,19} = magnetic_Z;                                       %% �ų�����z
    %%%����ɢ����Q��Ϣ����%%%
    NumQ = typecast(ByteDate(1,42),'uint8');
    Struct_data{1,20} = NumQ;                                                %% ɢ�������
    index = 1;
    for i=43:20:103
        Struct_data{1,20+index} = typecast(ByteDate(1,i:i+3),'single');      %% ��ȡ��������
        Struct_data{1,20+index+1} = typecast(ByteDate(1,i+4:i+7),'single');  %% ��ȡγ��
        Struct_data{1,20+index+2} = typecast(ByteDate(1,i+8:i+11),'single'); %% ��ȡ�߶�
        Struct_data{1,20+index+3} = typecast(ByteDate(1,i+12:i+15),'single');%% ��ȡ�ٶ�
        Struct_data{1,20+index+4} = typecast(ByteDate(1,i+16:i+19),'single');%% ��ȡ����
        index = index+5;
    end
    %%%DOA��Ϣ����%%%%
    DoA_num=typecast(ByteDate(1,123),'uint8');
    Struct_data{1,41} = DoA_num;                                                       %% DOA���ݸ���
    index =1;
    for i=124:4:148
        Struct_data{1,41+index} = double(typecast(ByteDate(1,i:i+1),'uint16'))/2^3;     %% �����0-360
        Struct_data{1,41+index+1}=double(typecast(ByteDate(1,i+2:i+3),'uint16'))/2^3;   %% ������0-90
        index = index + 2;
    end
    %%%%����ɢ����T��Ϣ����%%%%%
    Num_T=typecast(ByteDate(1,152),'uint8');
    Struct_data{1,56} = Num_T;                                            %% �ɲ���ɢ�������
    index =1;
    for i=1:4
        order=typecast(ByteDate(1,152+i),'uint8');                    %% 57-64
        s_order=floor(double(order)/2^4);
        doa_order=floor((double(order)/2^4-s_order)*2^4);
        Struct_data{1,56+index} = s_order;                                %% �ɲ�������ɢ�������
        Struct_data{1,56+index+1} = doa_order;                            %% DOAֵ���
        index = index+2;
    end
    %%%�ο�ͨ��DOA����%%%%%
    order=typecast(ByteDate(1,157),'uint8');
    Struct_data{1,65} = order;
    %%%Э�������%%%
    Rss = zeros(8,8);
    index = 158;
    for i=1:8
        for j=1:8
            rel = typecast(ByteDate(1,index:index+3),'single');
            img = typecast(ByteDate(1,index+4:index+7),'single');
            Rss(i,j) = rel+1i*img;
            index = index+8;
        end
    end
    Struct_data{1,66} =Rss;
    %%%IQ�ź�%%%
    IQ = zeros(1,32768);
    index = 670;
    for i=1:32678
        rel=double(typecast(ByteDate(1,index:index+1),'int16'));
        img=double(typecast(ByteDate(1,index+2:index+3),'int16'));
        IQ(1,i)=rel + 1i*img;
        index = index+4;
    end
    Struct_data{1,67} = IQ;
    %%%ʮ�����������������%%%
    Order_num =Struct_data{1,4};
    if Order_num==0
        scampling=0.203125;  %%�źŲ�����2013.125ksps
    elseif Order_num==1
        % CPI_SigFrequent(1,2)=3;       %%����3MHz
        scampling=4.0625;  %%�źŲ�����4.0625Msps
    elseif Order_num==2
        % CPI_SigFrequent(1,2)=5;       %%����5MHz
        scampling=8.125;   %%�źŲ�����8.125Msps
    elseif Order_num==3
        % CPI_SigFrequent(1,2)=10;       %%����10MHz
        scampling=16.25;   %%�źŲ�����16.25Msps
    elseif Order_num==4
        % CPI_SigFrequent(1,2)=30;       %%����30MHz
        scampling=32.5;   %%�źŲ�����32.25Msps
    end
    if scampling ==32.5
        l = 163; k=1;
    elseif scampling ==16.25
        l = 82; k=2;
    elseif scampling ==8.125
        l = 41; k=3;
    elseif scampling ==4.0625
        l = 21; k=6;
    elseif scampling ==0.203125
        l = 1;  k=113;
    end
    index = 131742;
    for i=68:79
        temple=zeros(2*l+1,2*k+1);
        for j=1:2*l+1
            for jj=1:2*k+1                                   % ʮ����������
            value1 = typecast(ByteDate(1,index:index+1),'uint16');
            value3 = typecast(ByteDate(1,index+2),'uint8');
            temple(j,jj) = (double(value1)*2^-8+double(value3)*2^-16);
            index = index +3;
%             value1 = typecast(ByteDate(1,index),'uint8');
%             value2 = typecast(ByteDate(1,index+1),'uint8');
%             value3 = typecast(ByteDate(1,index+2),'uint8');
%             temple(j,jj) = (double(value1)/2^16+double(value3))/2^24;
%             index = index +3;
            end
        end
        Struct_data{1,i} = temple;
    end
    %%%У����%%%%
    Struct_data{1,80} = typecast(ByteDate(1,167058:167059),'uint16');
    %%%֡β%%%
    Struct_data{1,81} = typecast(ByteDate(1,167060),'uint8');
    %%Struct_data ��������ȫ��תΪdouble����
    for i=1:81
        Struct_data{i} = double(Struct_data{i});
    end
    filename = sprintf('%d_%d_%d_%d_%d_%d_%d',Struct_data{1,5},Struct_data{1,6},Struct_data{1,7},Struct_data{1,8},Struct_data{1,9},Struct_data{1,10},Struct_data{1,11});
    name=sprintf('E:\\�������֡2����\\Mixframe2_%s.mat',filename);
    save(name,'Struct_data');
    isdecode = 1;
 end
end