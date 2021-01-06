% Gengerate IQ data and Process IQ data FOR COMPUTER SECOND SEVERCE
    A_Rxyz = [0,0,5]';       % location of Receiver column 
    A_Txyz = [140,460,5]';     % location of Target   column
%   A_Sxyz = [300,70,50;
%              -400,70,60;
%               5,-100,50]';   % location of S_array  column
    A_Sxyz = [600,70,50;       % ɢ�������� 2
             -700,70,60]';   
     A_Tv = [0,0,0]';
     A_fc = 1500000000;                  % carrier frequence:1.5G
    [azimuth_dir_sit, pitch_dir_sit, azimuth_sca_sit, pitch_sca_sit,time_delay_sit,fd,P_dir,P_sca] = Situtation(A_Rxyz,A_Txyz,A_Sxyz,A_Tv,A_fc);  %% Build situtation include:Receiver;Target;S
                                                                                                                      %%%   azimuth_dir:azimuth of direct wave at situtation
                                                                                                                      %%% pitch_dir:pitch angle of direct wave at situtation etc..
    A_dir_num = size(A_Txyz,2);                % the number of direct wave
    A_sca_num = size(A_Sxyz,2);                % the number of scatter wave
   azimuth_dir = roundn(azimuth_dir_sit,-1);   % azimuth of direct wave  [0 360] included angle between the flat-xy and the height of Target
    pangle_dir = roundn(pitch_dir_sit,0);      % pitch angle of direct wave  [-90 90]
    
    azimuth_sca =roundn(azimuth_sca_sit,-1);   % azimuth of scatter wave [0 360] included angle between the flat-xy and the height of S
    pangle_sca = roundn(pitch_sca_sit,0);      % pitch angle of scatter wave [-90 90]
    fd_sca = fd;                               % Doppler shift
    
    Scample_rate_1 = 32500000;        % scamping rate_1: 32.5MHZ
    Scample_rate_2 = 16250000;        % scamping rate_2: 16.25MHZ
    Scample_rate_3 = 8125000;         % scamping rate_3: 8.125MHZ
    Scample_rate_4 = 4062500;         % scamping rate_4: 4.0625MHZ
    Scample_rate_5 = 2.03125;          % scamping rate_5: 2.03125MHZ
    
                                      % time delay for scatter wave convert time delay point
    delaypoint_sca =  floor(time_delay_sit.*Scample_rate_1);    
    
    A_c = 300000000;                  % speed of light
    lambda = A_c/A_fc;    
    load('location.mat');             % load��Ԫxyz����ֵ
    location = location/200*2.5;      %% ��Ԫ����벨����ֱ��Ӱ�쵽�׷�������ʵDOA�Ľ����ȡֵ������ʵDOAȡֵ���������ٷ�ֵ
    order  = 149;   
    Hd = filter_65M_70_6_5m;               % Fir filter; order=16 scampleing rate=32.5M band pass=5MHZ 
    
    N  = 32768*3;                             % the length of generated IQ squence
    N2 = 32768;                               % the length of IQ squence Decimated by 2 :2����ȡ
    Power_noise =0.17*1.38*(1e-23)*(30e6)*1*290;
    Pn = 10*log10(Power_noise)+30;
    Noise_sig = wgn(8,N2,Pn,'dBm','complex'); % gengerate Noise 
    SNR_dir = 10*log10(P_dir/(Power_noise));
    SNR_sca = 10*log10(P_sca/(Power_noise)); 

%%                                    �龰2 ��������ͼ
   figure
    axis([-750 700 -350 350]); hold on;
    scatter(A_Txyz(1,:),A_Txyz(2,:),'MarkerEdgeColor','b', 'LineWidth',1.5);hold on; 
    text(A_Txyz(1,:)+15,A_Txyz(2,:)-10,'Target');
    scatter(A_Sxyz(1,1:A_sca_num), A_Sxyz(2,1:A_sca_num),'d','MarkerEdgeColor','k', 'LineWidth',1.5);hold on; 
    text(A_Sxyz(1,1),A_Sxyz(2,1)-13,'S1'); text(A_Sxyz(1,2),A_Sxyz(2,2)-13,'S2'); %text(A_Sxyz(1,3),A_Sxyz(2,3)-13,'S3');
    
    scatter(A_Rxyz(1),A_Rxyz(2),'*','MarkerEdgeColor','k','MarkerFaceColor',[0,0.5,0.5]); hold on;
    text(A_Rxyz(1),A_Rxyz(2)-15,'R');
    legend('Ŀ��λ��','ɢ����λ��','���浥վ');
    
    xlabel('m/��');
    ylabel('m/��');
    title('����ɢ���帨����λ�龰2')
    set(gca, 'GridAlpha', 1,'GridColor',[0 0 0],'MinorGridColor',[0 0 0],'XMinorTick','on','YMinorTick','on');  % ����͸����
    grid minor;
%%  ���㶨λ���  
 A_T = [55,220,5]';
 Loc_error = sqrt((loc_result(1,:)-A_T(1,1)).^2+(loc_result(2,:)-A_T(2,1)).^2);
[Loc_error ,index_loc] = sort(Loc_error);
for i=1:size(Loc_error,2)
   if (Loc_error(i)>15)
       Locindex_error15 = index_loc(i-1);
       errorindex_15 = i-1;
       break;
   end
end
%%  ���ƶ�λ���
  figure
  axis([-50 50 160 200]); hold on;
  scatter(A_Txyz(1,:),A_Txyz(2,:),'MarkerEdgeColor','b', 'LineWidth',1.5);hold on; 
  scatter(loc_result(1,:),loc_result(2,:),'c','MarkerEdgeColor','k','MarkerFaceColor','r'); hold on;
  xlabel('m / ��');
  ylabel('m / ��');
  set(gca,'GridColor',[0 0 0],'MinorGridColor',[0 0 0],'XMinorTick','on','YMinorTick','on','XMinorGrid','on');  % ����͸����
  title('˫ɢ���帨�����浥վ��λ���-oxy')
  legend('Ŀ��λ��','Ŀ�궨λ����λ��');
  error_min = sprintf('e:%0.1fm',Loc_error(1));
  error_15 = sprintf('e:%0.1fm',Loc_error(errorindex_15));
  text(loc_result(1,index_loc(1))-1,loc_result(2,index_loc(1))-1,error_min); hold on
  text(loc_result(1,Locindex_error15)-1,loc_result(2,Locindex_error15)-1,error_15); hold on
  grid on
%% �������뵽�㼣��ѡ��λ�õ�
color={[1 0 0],[0.8500 0.3250 0.0980],'#0072BD','#77AC30','#4DBEEE'};
for i=1:size(locresult_cell,2)
    locresult = locresult_cell{i};
  axis([-200 100 100 550]); hold on;
  scatter(locresult(1,:),locresult(2,:),'MarkerEdgeColor','w', 'MarkerFaceColor',color{i},'LineWidth',1.5);hold on;
end
xlabel('m / ��');
ylabel('m / ��');
set(gca,'GridColor',[0 0 0],'MinorGridColor',[0 0 0],'XMinorTick','on','YMinorTick','on','XMinorGrid','on');  % ����͸����
mylegend=['��1��CPI']; mylegend2=['��2��CPI']; mylegend3=['��3��CPI']; mylegend4=['��4��CPI']; mylegend5=['��5��CPI'];
legend(mylegend,mylegend2,mylegend3,mylegend4,mylegend5);
title('˫ɢ���帨�����浥վĿ��5��CPIʱ�̶�λ���-oxy')
grid on
%%  ���Ƶ㼣��ѡ
  pos_real=[15,180,5
            25,190,5
            35,200,5
            45,210,5
            55,220,5]';
  pos_trace1 = postrace_cell{1};
  pos_trace2 = postrace_cell{2};
  pos_trace3 = postrace_cell{3};
  axis([-20 70 160 250]); hold on;
  scatter(pos_real(1,:),pos_real(2,:),'MarkerEdgeColor','b', 'LineWidth',1.5);hold on;
  scatter(pos_trace1(1,:),pos_trace1(2,:),'c','MarkerEdgeColor','k','MarkerFaceColor','r'); hold on;
  scatter(pos_trace2(1,:),pos_trace2(2,:),'c','MarkerEdgeColor','k','MarkerFaceColor','#0072BD'); hold on;
  scatter(pos_trace3(1,:),pos_trace3(2,:),'c','MarkerEdgeColor','k','MarkerFaceColor','#77AC30'); hold on;
  plot(pos_real(1,:),pos_real(2,:),'-', 'LineWidth',1,'Color','k');hold on;
  
  plot(pos_trace1(1,:),pos_trace1(2,:),'-', 'LineWidth',0.3,'Color','k');hold on;
  plot(pos_trace2(1,:),pos_trace2(2,:),'-', 'LineWidth',0.3,'Color','k');hold on;
  plot(pos_trace3(1,:),pos_trace3(2,:),'-', 'LineWidth',0.3,'Color','k');hold on;
  
  text(pos_trace1(1,1)-8,pos_trace1(2,2)-8,'�켣1'); hold on
  text(pos_trace2(1,1)-7,pos_trace2(2,2)-3,'�켣2'); hold on
  text(pos_trace3(1,1)-9,pos_trace3(2,2)-9,'�켣3'); hold on
  mylegend=['��ʵĿ��켣']; mylegend2=['Ŀ�궨λ����켣1']; mylegend3=['Ŀ�궨λ����켣2']; mylegend4=['Ŀ�궨λ����켣3'];
  legend(mylegend,mylegend2,mylegend3,mylegend4);
  xlabel('m / ��');
  ylabel('m / ��');
  set(gca,'GridColor',[0 0 0],'MinorGridColor',[0 0 0],'XMinorTick','on','YMinorTick','on','XMinorGrid','on');  % ����͸����
  title('˫ɢ���帨�����浥վĿ������˲����-oxy')
     %%  Generate Array Signal: dir_signal + sca_signal + noise_sig 
    Array_sig = zeros(8,N2);
    sca_record_array = zeros(A_sca_num,N2); 
    decimation = 1;
    for i_d = 1:A_dir_num 
        %%% Generate Direct Wave %%%   
        dir_signal_I = filter(Hd,wgn(1,N+order,SNR_dir(i_d)+Pn-3,'dBm')); 
        dir_signal_Q = filter(Hd,wgn(1,N+order,SNR_dir(i_d)+Pn-3,'dBm'));
        Noise_sig_filter =filter(Hd,Noise_sig); 
        dir_signal_N = dir_signal_I(order+1:end)+1i*dir_signal_Q(order+1:end);   % generated IQ squence       length:32768*2 
        dir_signal_N2 = dir_signal_N(1:decimation:N2);                          % IQ squence decimated by 2  length:32768    
        
        tao_dir=zeros(1,8);                                                      % ��Ԫ�����ĵ��źż��ʱ��
        dir_array_sig = zeros(8,N2);           count=1;                          % direct signal wave through array
        for i = 1:2:16
            tao_dir(i) = (location(i,1)*cosd(azimuth_dir(i_d))*sind(pangle_dir(i_d))+location(i,2)*sind(azimuth_dir(i_d))*sind(pangle_dir(i_d))+location(i,3)*cosd(pangle_dir(i_d)))/A_c;
            dir_array_sig(count,:)=dir_signal_N2(1,1:N2)*exp(+1i*2*pi*A_c*tao_dir(i)/lambda);
            count = count+1;
        end  
        %%% Generate Scatter Wave %%%   
        attenuation_sca=zeros(A_dir_num,A_sca_num);                                     % attenuation factor of scatter ˥������
        sca_array_sig = zeros(8,N2);                                            % scatter signal wave through array 
        for i_s=1:A_sca_num
            sca_signal_N = zeros(1,N);                                          % current scatter wave point
            attenuation_sca(i_d,i_s)= 10^((SNR_sca(i_d,i_s)-SNR_dir(i_d))/20)*exp(-1i*(A_fc+fd_sca(i_d,i_s))*delaypoint_sca(i_d,i_s)/Scample_rate_1);          % Computer factor: 10*log10(A^2)=SNR_sca(m)-SNR_dir(m)
            tao_sca = zeros(1,8);                                               % ɢ�䲨��Ԫ�����ĵ��źż��ʱ��
            sca_array_temple = zeros(8,N2); 
         
            sca_signal_N(1+delaypoint_sca(i_d,i_s):end) = dir_signal_N(1:N-delaypoint_sca(i_d,i_s));  % gengerate scatter wave through direct wave 
            sca_signal_N2=sca_signal_N(1:decimation:N2);                                     % decimate by 2 for scatter wave   ������ȡ ʱ�ӵ�Ϊԭ��������
            sca_record_array(i_s,:)=attenuation_sca(i_d,i_s)*sca_signal_N2(1,:).*exp(1i*fd_sca(i_d,i_s)*([0:N2-1]/Scample_rate_1*2));      
            count = 0;
            for i = 1:2:16
               tao_sca(count+1) = (location(i,1)*cosd(azimuth_sca(i_s))*sind(pangle_sca(i_s))+location(i,2)*sind(azimuth_sca(i_s))*sind(pangle_sca(i_s))+location(i,3)*cosd(pangle_sca(i_s)))/A_c;
               sca_array_temple(count+1,:) = attenuation_sca(i_d,i_s)*sca_signal_N2(1,:).*exp(1i*fd_sca(i_d,i_s)*([0:N2-1]/Scample_rate_1*2)).*exp(+1i*2*pi*A_c*tao_sca(count+1)/lambda);
               count = count+1;
            end
            sca_array_sig = sca_array_sig+sca_array_temple;
        end
        Array_sig=Array_sig+dir_array_sig+sca_array_sig;   
    end
        Array_sig = Array_sig+Noise_sig;    

 %% DOA estimate 
      Rxx_doa = (1/N2)*(Array_sig*Array_sig');    % generate Covariance matrix about Signal
      [Rdoa_fv,Rdoa_fval]=eig(Rxx_doa);           % �����ֽ�
      Rdoa_fval2=diag(Rdoa_fval)';                % ����ֵ������
      Rdoa_fval2=abs(Rdoa_fval2);                 
      [Rdoa_fval3,Rdoa_I]=sort(Rdoa_fval2,'descend'); % ����ֵ�Ӵ�С����
      Rdoa_fv2=Rdoa_fv(1:end,Rdoa_I);                 % ������������     
      
      Rdoa_fval3_2 = Rdoa_fval3./(min(Rdoa_fval3));  % ����������һ��������Сֵ
      sig_div1 = zeros(1,7);                         
      for i=1:7
          sig_div1(i)= Rdoa_fval3_2(i)-Rdoa_fval3_2(i+1);
      end
      for i=1:7
          if sig_div1(i)<3
              sig_num=i-1;                           % ָ��4���Ƶ��ź�Դ��: ֱ�ﲨ����ɢ�䲨��(����ɢ����ɱ�����)
              break;
          end
      end
  %%
   Rdoa_Us = Rdoa_fv2(:,1:sig_num);              %% Us�ź��ӿռ����  ����ֱ�ﲨ��ɢ�䲨
   Rdoa_Un = Rdoa_fv2(:,sig_num+1:end);          %% Un�����ӿռ����  ֻ��������
   
   doa_azimuth =1:0.5:360;
   doa_pangle = 1:1:89;
   doa_array = zeros(size(doa_azimuth,2),size(doa_pangle,2));

   count = 0; am=zeros(8,1);
   for i=1:size(doa_azimuth,2)
       for j=1:size(doa_pangle,2)
           for k = 1:2:16
               tao_dir(i) = (location(k,1)*cosd(doa_azimuth(i))*sind(doa_pangle(j))+location(k,2)*sind(doa_azimuth(i))*sind(doa_pangle(j))+location(k,3)*cosd(doa_pangle(j)))/A_c;
               am(count+1)=exp(+1i*2*pi*A_c*tao_dir(i)/lambda);
               count = count+1;
           end
           count =0;
           doa_array(i,j)=1/(am'* (Rdoa_Un* Rdoa_Un')*am);
       end
   end
[Y,X] =meshgrid(1:89,1:0.5:360);
surf(X,Y,(abs(doa_array)/10),'Edgecolor','none')
xlabel('��λ�� / ��')
ylabel('������ / ��');
zlabel('����');
title('DOA�׷�����')
% ��������Χ
plotazimuth =0:2:360;
plotpangle = 0:1:89;
plotarray = zeros(size(plotazimuth,2),size(plotpangle,2));

count = 0; am=zeros(8,1);am_dir=zeros(8,1);tao_expectdir=zeros(8,1);
for i=1:size(plotazimuth,2)
   for j=1:size(plotpangle,2)
       for k = 1:2:16
           tao_dir(i) = (location(k,1)*cosd(plotazimuth(i))*sind(plotpangle(j))+location(k,2)*sind(plotazimuth(i))*sind(plotpangle(j))+location(k,3)*cosd(plotpangle(j)))/A_c;
           am(count+1)=exp(+1i*2*pi*A_c*tao_dir(i)/lambda);
           count = count+1;
       end
       count =0;
       plotarray(i,j)=1/(am'* (Rdoa_Un* Rdoa_Un')*am);
   end
end
figure
axis([0 360 0 89])
[Y,X] =meshgrid(0:1:89,0:2:360);       % �޸Ĵ� ����������Ĳ��������ı�
set(gca,'XTick',0:20:358);  hold on
set(gca,'YTick',0:10:89);  hold on
surf(X,Y,(20*log(abs(plotarray))/10),'Edgecolor','none')   
xlabel('��λ�� / ��')
ylabel('������ / ��');
zlabel('����');
title('DOA�׷�����')
[music,fangwei,fuyang]=peak_search(plotarray,0,0,2,1);  % �޸Ĵ� ����������Ĳ��������ı�
doa_roughsearch2 = cell(1,size(fangwei,2)); 
[~,index]=sort(music,'descend');
for i=1:size(fangwei,2)
    doa_roughsearch2{i}=[fangwei(index(i)),fuyang(index(i))];
end
doa_detailsearch2 = cell(1,size(fangwei,2)); 
for i=1:size(doa_roughsearch2,2)
    az = doa_roughsearch2{i}(1);
    pt = doa_roughsearch2{i}(2);
    az_min = az-3; az_max=az+3; pt_min = pt-1; pt_max=pt+1;
    if az<3
        az_min=1;
    elseif az>357
         az_max=360;   
    end
    if pt<1
        pt_min =1;
    elseif pt>89
        pt_max = 90;
    end
    doa_detailsearch2{i}=[az_min,az_max,pt_min,pt_max];
end
doa_EndFind = detailsearch(doa_detailsearch2,0.1,Rdoa_Un,location,1.5e9);
                                          % Doa Spectral Peak Search
cu_scale = 3;  cu_scale2= 2;
doa_roughsearch = cell(1,45*240); count =0;
doasearch_sumarea = zeros(1,45*240);
buchang =10;
 for i=1:239                               %% ��������洢 �����ֵ�洢
     for j=1:44
       doa_roughsearch{count+1} = [doa_azimuth(cu_scale*(i-1)+1:cu_scale*(i-1)+cu_scale),doa_pangle(cu_scale2*(j-1)+1:cu_scale2*(j-1)+cu_scale2)];
       doasearch_sumarea(count+1) = max(max(doa_array(cu_scale*(i-1)+1:cu_scale*(i-1)+cu_scale,cu_scale2*(j-1)+1:cu_scale2*(j-1)+cu_scale2)));  % �������ֵ����ȫ���� 
       count =count+1;
     end
 end

[doasearch_sumarea2,doa_areaIndex] = sort(doasearch_sumarea,'descend');
doa_detailsearch =cell(1,A_dir_num+A_sca_num+buchang);
for i=1:A_dir_num+A_sca_num+buchang
    doa_detailsearch{i}=doa_roughsearch{doa_areaIndex(i)};
end

 count=0;     %% detail search doa martix

doa_peak = zeros(1,(A_dir_num+A_sca_num)+buchang);                    %% End find peak
doa_endfind =cell(1,(A_dir_num+A_sca_num)+buchang);                   %% pre End find doa 
doa_endazmiuth =zeros(1,(A_dir_num+A_sca_num)+buchang);
doa_endfind2 =cell(1,(A_dir_num+A_sca_num));                          %% End find doa
for i=1:A_dir_num+A_sca_num+buchang
    doa_peak_temp = zeros(1,200);
    doa_detail = cell(1,200); 
   for j=doa_detailsearch{i}(1):0.1:doa_detailsearch{i}(cu_scale)
       for k=doa_detailsearch{i}(cu_scale+1):0.1:doa_detailsearch{i}(cu_scale+cu_scale2)
           doa_detail{count+1} =[j,k];
           count2=0;
           for e = 1:2:16
               tao_dir_temple = (location(e,1)*cosd(j)*sind(k)+location(e,2)*sind(j)*sind(k)+location(e,3)*cosd(k))/A_c;
               am(count2+1)=exp(+1i*2*pi*A_c*tao_dir_temple/lambda);
               count2 = count2+1;
           end
           doa_peak_temp(count+1)=1/(am'* (Rdoa_Un* Rdoa_Un')*am);
           count =count+1;
       end
   end
   [doa_peak_value,peak_index]=max(doa_peak_temp);
    doa_peak(i)= doa_peak_value;
    doa_endfind{i} = doa_detail{peak_index};
    doa_endazmiuth(i)=doa_detail{peak_index}(1);         %% ��ȡ�����
    count =0;
end
   for i=1:size(doa_peak,2)
       temp=doa_endazmiuth(i);
       value = doa_peak(i);
       temp_md =abs(temp-doa_endazmiuth);
       for j=1:size(doa_peak,2)
           if(temp_md(j)<=4 && temp_md(j)>0 )
               if doa_peak(j)<=value
                   doa_peak(j)=0;
                   doa_endazmiuth(j)=0;
               else
                   doa_peak(i)=0;
                   doa_endazmiuth(i)=0;
                   break;
               end
           end
       end
   end
    [~,endIndex]=sort(doa_peak,'descend');
    for i=1:7
        doa_endfind2{i}=doa_endfind{endIndex(i)};
    end

 %% �ο�ͨ�������γ� �� ���������γ� 
   sig_resource = 3;                         %% Recording the number of current signal by DOA_Estimate_argrithm 
   sig_estimate_resource =1;                 %% signal resource by DOA_estimate_algorithm
   Rxx = (1/8192)*Array_sig(:,1:8192)*Array_sig(:,1:8192)';
   [Rx_fvec,Rx_fval]=eig(Rxx);               %% Rxx:Eigenvalue Decomposition
   Rx_fval2=diag(Rx_fval)';                  %% Convert Feature value from array to vector 
   [~,I]=sort(Rx_fval2);                     %% Sort feature value and record order
   Rx_fvec2=fliplr(Rx_fvec(:,I));            %% feature vector array based the order of the value of feature value 
   Rx_Msca = Rxx+10*min(Rx_fval2)*diag(ones(1,8));  %% M��������ɢ�䲨�����γ� 
 
   Rx_Us = Rx_fvec2(:,1:A_dir_num);              %% Us�ź��ӿռ����
   Rx_Un = Rx_fvec2(:,A_dir_num+1:end);          %% Un�ź��ӿռ����
   Rx_Block =  Rx_Un/(Rx_Un'*Rx_Un)*Rx_Un';      %% �������������γɵĲ����γ�
    
   vectorA_ref = zeros(8,1);     count = 0;         %% ֱ�ﲨ����������ʸ��          
   
   %%% Generate Reference Channel SignaL  MVDR  %%%
   if (sig_resource > sig_estimate_resource)                                  % Computer Service situtation 2
       for i = 1:2:16                                                         % default 1 direct wave
           tao_dir(i) = (location(i,1)*cosd(azimuth_dir(1))*sind(pangle_dir(1))+location(i,2)*sind(azimuth_dir(1))*sind(pangle_dir(1))+location(i,3)*cosd(pangle_dir(1)))/A_c;
           vectorA_ref(count+1)=exp(+1i*2*pi*A_c*tao_dir(i)/lambda);
           count = count+1;
       end
       Wref = (Rx_Msca\vectorA_ref(:,1))/(vectorA_ref(:,1)'/Rx_Msca*vectorA_ref(:,1));
       y_ref = Wref'*Array_sig;
   elseif(sig_resource == sig_estimate_resource)                              %% Computer Service situtation 3                                                                    %% Computer Service situtation 3
       if A_dir_num>1
       [~,index_sca]=max(max(SNR_sca));
      else
       [~,index_sca]=max(SNR_sca);   
      end
       tao_sca  = zeros(1,8); count=0;
       for i=1:2:16
           tao_sca(count+1) = (location(i,1)*cosd(azimuth_sca(index_sca))*sind(pangle_sca(index_sca))+location(i,2)*sind(azimuth_sca(index_sca))*sind(pangle_sca(index_sca))+location(i,3)*cosd(pangle_sca(index_sca)))/A_c;
           count = count+1;
       end
       vectorA_ref=exp(+1i*2*pi*A_c*tao_sca'/lambda);
       Wref = (Rx_Msca\vectorA_ref(:,1))/(vectorA_ref(:,1)'/Rx_Msca*vectorA_ref(:,1));
       y_ref = Wref'*Array_sig;
   end
   
 %%% Generate 12 Sector beam  BLOCK 
   tao_sca  = zeros(1,8);
   Sector_array=[0 30 60 90 120 150 180 210 240 270 300 330;
                10 10 10 10  10  10  10  10  10  10  10  10];
   VectorA_sector = zeros(8,12);                                    %% Array vector for every sector(����)
   VectorA_sca = zeros(8,A_sca_num); 
   Wsector_array_mvdr = zeros(8,12);                                %% computer w based MVDR
   Wsector_array_block = zeros(8,12);                               %% computer w based Block array
   Wscatter_array = zeros(8,A_sca_num);
   z_sector = zeros(12,N2);
   z_sector_block = zeros(12,N2);
   for i_s =1:12
       count =0;
       for i=1:2:16
           tao_sca(count+1) = (location(i,1)*cosd(Sector_array(1,i_s))*sind(Sector_array(2,i_s))+location(i,2)*sind(Sector_array(1,i_s))*sind(Sector_array(2,i_s))+location(i,3)*cosd(Sector_array(2,i_s)))/A_c;
           count = count+1;
       end
       VectorA_sector(:,i_s) = exp(+1i*2*pi*A_c*tao_sca'./lambda);
       Wsector_array_mvdr(:,i_s) = (Rx_Msca\VectorA_sector(:,i_s))/(VectorA_sector(:,i_s)'/Rx_Msca*VectorA_sector(:,i_s));
       Wsector_array_block(:,i_s) = Rx_Block*VectorA_sector(:,i_s);
   end
   
   for i_s =1:A_sca_num
       count =0;
       for i=1:2:16
         tao_sca(count+1) = (location(i,1)*cosd(azimuth_sca(i_s))*sind(pangle_sca(i_s))+location(i,2)*sind(azimuth_sca(i_s))*sind(pangle_sca(i_s))+location(i,3)*cosd(pangle_sca(i_s)))/A_c;
         count = count+1;
       end
       VectorA_sca(:,i_s) = exp(+1i*2*pi*A_c*tao_sca'./lambda);
   end
   Wscatter_array(:,1) = (Rx_Msca\VectorA_sca(:,1))/(VectorA_sca(:,1)'/Rx_Msca*VectorA_sca(:,1));
   Wscatter_array(:,2) = (Rx_Msca\VectorA_sca(:,2))/(VectorA_sca(:,2)'/Rx_Msca*VectorA_sca(:,2));
   z1 = Wscatter_array(:,1)'*Array_sig;
   z1_2=Wscatter_array(:,2)'*Array_sig;
   
   for i=1:12
       z_sector(i,:)=Wsector_array_mvdr(:,i)'*Array_sig;                    %% Sector beamforming based MVDR
       z_sector_block(i,:)=Wsector_array_block(:,i)'*Array_sig;             %% Sector beamforming based block
   end         

%% Generate RD spectrum
   scampling =Scample_rate_1;
   if scampling ==Scample_rate_1
       l = 163; k=1;
   elseif scampling ==Scample_rate_2
       l = 82; k=2;
   elseif scampling ==Scample_rate_3
       l = 41; k=3;
   elseif scampling ==Scample_rate_4
       l = 21; k=6;
   elseif scampling ==Scample_rate_5
       l = 1;  k=113;
   end
   window_h =(0.35875*ones(1,N2)-0.48829*cos((2*pi*[1:N2])/N2)+0.1428*cos((4*pi*[1:N2])/N2)-0.01168*cos((6*pi*[1:N2])/N2));
   RD_cell=cell(1,12);
   k=1;
   for i=1:12
      Rd_array = zeros(2*l+1,2*k+1);
      count =0;
      for j=-k:k
          z_sectorw=z_sector_block(i,:).*window_h.*exp(1i*(2*pi*j*[1:N2])/(N2));
          cor_zy = xcorr(z_sectorw,y_ref);
          Rd_array(:,count+1)=cor_zy(N2-l:N2+l);
          count =count+1;
      end
      RD_cell{1,i} = Rd_array;
   end
%%
figure
xtrick = -163:1:163;
[Y,X] =meshgrid(-k:k,-l:l);
Rd_plot = RD_cell{1,1};
surf(X,Y,abs(Rd_plot),'Edgecolor','none')
xlabel('time delay / point')
ylabel('Dopple frequence / point');
zlabel('Amplitude/dB');
title('����1�����������')
set(gca,'XLim',[min(xtrick),max(xtrick)])
%% CFAR����
if scampling ==Scample_rate_1
    N_pf=200;  L_k = [163,1];
elseif scampling ==Scample_rate_2
    N_pf=150;  L_k = [82,2];
elseif scampling ==Scample_rate_3
    N_pf=70;
elseif scampling ==Scample_rate_4
    N_pf=30;
elseif scampling ==Scample_rate_5
    %l = 1;  k=113;
end
Rd_array=RD_cell{1,7};
feng = zeros(1,L_k(2));
for j=1:2*L_k(2)+1
    feng(j)=sum(abs(Rd_array(:,j)));   % ѡȡ��ֵ������
end
[~,cfar_index]=max(feng);
Rd_sector = abs(RD_cell{1,1});                                          % ȡ����һ����������
flag_noise = NoisType(Rd_sector(:,cfar_index)',0.0001);     
disp(['�������ͣ�',sprintf('%d',flag_noise)])
Rd_date = abs(Rd_array(:,cfar_index));
Pf=10e-4; l =2*163+1;  N=20;  k=floor(N*3/4);  Product_unit = 2;        % Rd_���ݱ�����������
[Order_L,T_Sn,xk]=Qin_CFAR(Pf,Rd_date',l,flag_noise,N_pf,N,k,Product_unit); % l+delay_point Ӧ����CFAR����Ķ�Ӧdelya_point��
disp(['CFAR����ֵ��',sprintf('T:%0.2f, Sn:%0.2f',T_Sn(1),T_Sn(2))])

xtrick = -163:1:163;

value =zeros(1,size(Order_L,1));
for i=1:size(Order_L,1)
    if Order_L(i)>0
        value(i)=1;
    end
end
plot(xtrick,value);
 xlabel('time delay/ point');
 ylabel('�����');
title('����7���������ݺ��龯��� �Ӳ����ͣ������ֲ�')
set(gca,'XLim',[min(xtrick),max(xtrick)],'YLim',[0,1.5],'XMinorGrid','on','XMinorTick','on');
grid on
%%  ����֡�ļ�����
frame_decoder = load('E:\�������֡2����\Mixframe2_2020_11_23_15_49_42_493_decode.mat');
frame_decoder = frame_decoder.Struct_data;
frame_decoder{20} = size(A_Sxyz,2);  % Num_Q
Num_T = 0;
frame_decoder{56} = Num_T;           % Num_T
Num_DOA =1;                                                                   % ֱ�ﲨ���� + ɢ�䲨����
frame_decoder{41} = Num_DOA;         % Num_DOA
% 2Ŀ��
% DOA = [azimuth_dir(1) pitch_dir_sit(1)                         
%        azimuth_dir(2) pitch_dir_sit(2)                                         
%        azimuth_sca(3) pitch_sca_sit(3) 
%        azimuth_sca(1) pitch_sca_sit(1) 
%        azimuth_sca(2) pitch_sca_sit(2)   
%         0     0
%         0     0 ];
% 1Ŀ��                                              % �޸�1 ��DOA���������ı�
DOA = zeros(7,2);
for i=1:Num_DOA
    DOA(i,1) = doa_endfind2{i}(1,1);
    DOA(i,2) = doa_endfind2{i}(1,2);
end

T_info = [0,0                                                   
          0,0
          0,0
          0,0];
frame_decoder{1,65} = 1;   % �ο�ɢ�����DOA���
inital = 1;
for i=1:7
    frame_decoder{1,41+inital} =  DOA(i,1);                                  % �����0-360
    frame_decoder{1,41+inital+1}= DOA(i,2);                                  % ������0-90
    inital = inital + 2;
end
%3 ɢ����                                          % �޸�2 ��ɢ�������������ı�
% Sxyz = [A_Sxyz(1,1),A_Sxyz(2,1),A_Sxyz(3,1),0,azimuth_sca(1);
%         A_Sxyz(1,2),A_Sxyz(2,2),A_Sxyz(3,2),0,azimuth_sca(2);
%         A_Sxyz(1,3) ,A_Sxyz(2,3),A_Sxyz(3,3),0,azimuth_sca(3);
%           0 , 0 , 0 , 0 ,0]';  
%2 ɢ����
Sxyz = [A_Sxyz(1,1),A_Sxyz(2,1),A_Sxyz(3,1),0,azimuth_sca(1);
       A_Sxyz(1,2),A_Sxyz(2,2),A_Sxyz(3,2),0,azimuth_sca(2);
           0 , 0 , 0, 0, 0;
          0 , 0 , 0 , 0 ,0]';  
inital =21;
for i=1:4
    frame_decoder{inital}=Sxyz(1,i);     % S_x
    frame_decoder{inital+1}=Sxyz(2,i);   % S_y
    frame_decoder{inital+2}=Sxyz(3,i);   % S_z
    frame_decoder{inital+3}=Sxyz(4,i);   % �ٶ�
    frame_decoder{inital+4}=Sxyz(5,i);   % ����
    inital = inital+5;
end
index=1;
for i=1:4                                  % ɢ������š�DOA��� 
    s_order=T_info(i,1);
    doa_order=T_info(i,2);
    frame_decoder{1,56+index} = s_order;                         
    frame_decoder{1,56+index+1} = doa_order;                      
    index = index+2;
end
for i=68:79
    frame_decoder{1,i} =RD_cell{1,i-67};   % �����������
end
Struct_data = frame_decoder;
frame_order = 7;                                    % �޸�3 ��������ŷ����ı�        
str = sprintf('E:\\�������֡2����\\��֤��������֡\\Mixframe2_FormQin2-S%d-T%d-���%d_decode',A_sca_num,A_dir_num,frame_order);
save(str,'Struct_data')

 %%  ����ͼ
     xaxi = linspace(-N2+1,N2-1,2*N2-1);   
     %%% ���������ź� ��Ӧ�Ĺ�����ͼ
     figure
     w1 = window('hamming',N2);
     fs1 = 65000000;
     xtrick = -35:5:35;
     f1 = -fs1/2:fs1/N2:fs1/2-1;           %%Ƶ�׷ֱ���
     S_fft=Array_sig(1,1:N2).* w1';
     plot(f1/1e6,20*log10(abs(fftshift(fft(S_fft)))));
     xlabel('MHZ');
     ylabel('Amplitude/dB');
     title ('8ͨ�����н����豸 �ز�Ƶ��:1.5GHZ ����:30MHZ ')
     grid on
     set(gca,'XLim',[min(xtrick),max(xtrick)],'XMinorGrid','on','XMinorTick', 'on','YMinorTick', 'on')
     set(gca,'Box','off')
     grid on
     %%% ���������ź� �����ͼ ��ֱ֤�ﲨ��ɢ�䲨�Ƿ���� ɢ�䲨��λ���Ƿ���ȷ
     figure
     cor_S_1 =20*log10(abs(xcorr(Array_sig(1,1:N2))));
     plot(xaxi,cor_S_1)
     title('���ԣ� �����ź������')
%      set(gca, 'GridAlpha', 1,'GridColor',[0 0 0],'MinorGridColor',[0 0 0],'XMinorTick','on','YMinorTick','on');  % ����͸����
     xlabel('time delay / point')
     ylabel('Amplitude/dB');
     grid on

%%
   corrcoef(dir_signal_N2(1,:),    y_ref)               %%����Э����ϵ��
   corrcoef(sca_record_array(1,:), y_ref)               %%����Э����ϵ��
%  corrcoef(sca_record_array(2,:), z1_2)                %%����Э����ϵ��
   figure
   xtrick = -35:5:35;
   subplot(2,1,1)
     w1 = window('hamming',N2);
     fs1 = 65000000;
     f1 = -fs1/2:fs1/N2:fs1/2-1;           %%Ƶ�׷ֱ���
     S_fft=dir_signal_N2(1,1:N2).* w1';
     plot(f1/1e6,20*log10(abs(fftshift(fft(S_fft)))));
     xlabel('MHZ');
     ylabel('Amplitude/dB');
     title ('8ͨ�����н����豸 ֱ�ﲨ�ź�Ƶ��ͼ ����:30MHZ ')
     set(gca,'XLim',[min(xtrick),max(xtrick)],'XMinorGrid','on','XMinorTick', 'on','YMinorTick', 'on')
     set(gca,'Box','off')
     grid on
   subplot(2,1,2)
       w1 = window('hamming',N2);
       fs1 = 65000000;
       f1 = -fs1/2:fs1/N2:fs1/2-1;           %%Ƶ�׷ֱ���
       S_fft=y_ref(1,1:N2).* w1';
       plot(f1/1e6,20*log10(abs(fftshift(fft(S_fft)))));
     xlabel('MHZ');
     ylabel('Amplitude/dB');
     title ('8ͨ�����н����豸 ֱ�ﲨ�ź�Ƶ��ͼ ����:30MHZ ')
     set(gca,'XLim',[min(xtrick),max(xtrick)],'XMinorGrid','on','XMinorTick', 'on','YMinorTick', 'on')
     set(gca,'Box','off')
     grid on
   figure
    subplot(3,1,1)
     cor_S_1 =20*log10(abs(xcorr(Array_sig(1,1:N2),y_ref)));
     plot(xaxi,cor_S_1)
     title('���ԣ� �����ź���ο�ͨ���źŻ����')
%      set(gca, 'GridAlpha', 1,'GridColor',[0 0 0],'MinorGridColor',[0 0 0],'XMinorTick','on','YMinorTick','on');  % ����͸����
     xlabel('time delay / point')
     ylabel('Amplitude/dB');
     grid on
     
    subplot(2,1,1)
     cor_S_2 =20*log10(abs(xcorr(y_ref,z_sector_block(1,:))));
     plot(xaxi,cor_S_2)
     title('�ο�ͨ���ź�������1�����γ��źŻ����')
%      set(gca, 'GridAlpha', 1,'GridColor',[0 0 0],'MinorGridColor',[0 0 0],'XMinorTick','on','YMinorTick','on');  % ����͸����
     xlabel('time delay / point')
     ylabel('Amplitude/dB');
     set(gca,'XMinorGrid','on','XMinorTick', 'on','YMinorTick', 'on')
     set(gca,'Box','off')
     grid on
    subplot(2,1,2)
     cor_S_3 =20*log10(abs(xcorr(y_ref,z_sector_block(7,:))));
     plot(xaxi,cor_S_3)
     title('�ο�ͨ���ź�������7�����γ��źŻ����')
%      set(gca, 'GridAlpha', 1,'GridColor',[0 0 0],'MinorGridColor',[0 0 0],'XMinorTick','on','YMinorTick','on');  % ����͸����
     xlabel('time delay / point')
     ylabel('Amplitude/dB');
     set(gca,'XMinorGrid','on','XMinorTick', 'on','YMinorTick', 'on')
     set(gca,'Box','off')
     grid on
     
  figure
     cor_S_3 =20*log10(abs(xcorr(y_ref,z_sector_block(10,:))));
     plot(xaxi,cor_S_3)
     title('���ԣ� �ο�ͨ���ź��벨���γɣ������ź�10�����')
%      set(gca, 'GridAlpha', 1,'GridColor',[0 0 0],'MinorGridColor',[0 0 0],'XMinorTick','on','YMinorTick','on');  % ����͸����
     xlabel('time delay / point')
     ylabel('Amplitude/dB');
     grid on
%%
   similar_sectorwave = zeros(1,12);
   for i=1:A_sca_num
       for j=1:12
           cor = corrcoef(sca_record_array(i,:), z_sector_block(j,:));                    %%����Э����ϵ��
           similar_sectorwave(i,j)=abs(cor(1,2));
       end
   end
   figure
   subplot(2,1,1)
     w1 = window('hamming',N2);
     fs1 = 16250000;
     f1 = -fs1/2:fs1/N2:fs1/2-1;           %%Ƶ�׷ֱ���
     S_fft=sca_record_array(1,1:N2).* w1';
     plot(f1,20*log10(abs(fftshift(fft(S_fft)))));
     xlabel('HZ');
     ylabel('Amplitude/dB');
     title ('8ͨ�����н����豸 ��λ��13��ɢ�䲨�ź�Ƶ��ͼ ����:10MHZ ')
     grid on
   subplot(2,1,2)
       w1 = window('hamming',N2);
       fs1 = 16250000;
       f1 = -fs1/2:fs1/N2:fs1/2-1;         %%Ƶ�׷ֱ���
       S_fft=z_sector_block(5,1:N2).* w1';
       plot(f1,20*log10(abs(fftshift(fft(S_fft)))));
       xlabel('HZ');
       ylabel('Amplitude/dB');
       title ('8ͨ�����н����豸 0������1�����γ��ź�Ƶ��ͼ ����:10MHZ ')
       grid on  
   figure
   subplot(2,1,1)
     w1 = window('hamming',N2);
     fs1 = 16250000;
     f1 = -fs1/2:fs1/N2:fs1/2-1;           %%Ƶ�׷ֱ���
     S_fft=sca_record_array(2,1:N2).* w1';
     plot(f1,20*log10(abs(fftshift(fft(S_fft)))));
     xlabel('HZ');
     ylabel('Amplitude/dB');
     title ('8ͨ�����н����豸  ��λ��170��ɢ�䲨�ź�Ƶ��ͼ ����:10MHZ ')
     grid on
   subplot(2,1,2)
       w1 = window('hamming',N2);
       fs1 = 16250000;
       f1 = -fs1/2:fs1/N2:fs1/2-1;           %%Ƶ�׷ֱ���
       S_fft=z_sector_block(7,1:N2).* w1';
       plot(f1,20*log10(abs(fftshift(fft(S_fft)))));
       xlabel('HZ');
       ylabel('Amplitude/dB');
       title ('8ͨ�����н����豸 ����7�����γ��ź�Ƶ��ͼ ����:10MHZ ')
       grid on  
   figure
   subplot(2,1,1)
     w1 = window('hamming',N2);
     fs1 = 16250000;
     f1 = -fs1/2:fs1/N2:fs1/2-1;           %%Ƶ�׷ֱ���
     S_fft=sca_record_array(3,1:N2).* w1';
     plot(f1,20*log10(abs(fftshift(fft(S_fft)))));
     xlabel('HZ');
     ylabel('Amplitude/dB');
     title ('8ͨ�����н����豸 ��λ��270��ֱ�ﲨ�ź�Ƶ��ͼ ����:10MHZ ')
     grid on
   subplot(2,1,2)
       w1 = window('hamming',N2);
       fs1 = 16250000;
       f1 = -fs1/2:fs1/N2:fs1/2-1;           %%Ƶ�׷ֱ���
       S_fft=z_sector_block(10,1:N2).* w1';
       plot(f1,20*log10(abs(fftshift(fft(S_fft)))));
       xlabel('HZ');
       ylabel('Amplitude/dB');
       title ('8ͨ�����н����豸 ����10�ο�ͨ���ź�Ƶ��ͼ ����:10MHZ ')
       grid on  