function point_cluster_cell=pro_trace_couple(point_cluster,T,flag_caiyang)
 %%%Ӧ�����龰2 �ͷ�����ɢ���嵫δ��⵽ɢ���壬ɸѡ�㼣�ı������
 %%%point_cluster����϶�λ�㼣  Ԫ������Ϊ��Ӧ�Բ�ͬ���������²�ͬά����ÿ���������������
 %%%������Ͻ����TDOAʱ���Ч�����_tdoa��FDOAʱ���Ч�����_fdoa�������_ref��������_ref
 %%%T OS-CFAR����ֵ  S LOG-t CFAR����ֵ   ÿ���Ӳ�����ֻ������һ������ֵ
 %%%flag_caiyang 1: �߲���  0���Ͳ���
 %%%point_cluster_cell ÿ��Ԫ���� ��������
 
cell_size=size(point_cluster);
gate_limit = 1.6*T-1;
if cell_size(2)==1
    point_cluster_cell=cell(1,1);
    trace1=point_cluster{1};
    array_size=size(trace1);     %%%�������
    for i=1:array_size(1)
        if flag_caiyang==1
            SNR_T=trace1(i,2);
            if SNR_T<gate_limit
                trace1(i,:)=zeros(1,size(trace1,2));   %%%%��Ϊ����ɢ�����������Ҫ�޸�   Qin2 =7
            end                                                                      %% Qin3 ��������ʱ�Ӳ����ſ�����ɶ�λ
        else
           SNR_f=trace1(i,4);
            if SNR_f<gate_limit 
                trace1(i,:)=zeros(1,size(trace1,2));
            end  
        end
    end
    trace1(all(trace1==0,2),:)=[];
    shape=size(trace1);   row=shape(1);
    if row>0
    point_cluster_cell{1}=trace1;
    else
    point_cluster_cell{1}=-1;
    end
end

if cell_size(2)==2
    point_cluster_cell=cell(1,2);
    trace1=point_cluster{1};
    trace2=point_cluster{2};
    array1_size=size(trace1);     %%%�������
    array2_size=size(trace2);     %%%�������
    
     for i=1:array1_size(1)
        if flag_caiyang==1
            SNR_T=trace1(i,2);
            if SNR_T<gate_limit
                trace1(i,:)=zeros(1,7);
            end
        else
           SNR_f=trace1(i,4);
            if SNR_f<gate_limit
                trace1(i,:)=zeros(1,7);
            end  
        end
     end
    trace1(all(trace1==0,2),:)=[];
    shape=size(trace1);   row=shape(1);
    if row>0
    point_cluster_cell{1}=trace1;
    else
    point_cluster_cell{1}=-1;
    end
    
    %%%%����˫�����
    for i=1:array2_size(1)
        if flag_caiyang==1
            SNR_T=[trace2(i,2),trace2(i,6)];
            SNR_ave=sum(SNR_T)/2;
            if SNR_ave<gate_limit
                trace2(i,:)=zeros(1,12);
            end
        else
           SNR_f=[trace2(i,4),trace2(i,8)];
           SNR_fave=sum(SNR_f)/2;
            if SNR_fave<gate_limit
                trace2(i,:)=zeros(1,12);
            end  
        end
    end
    trace2(all(trace2==0,2),:)=[];
    shape=size(trace2);   row=shape(1);
    if row>0
    point_cluster_cell{2}=trace2;
    else
    point_cluster_cell{2}=-1;
    end
    
end

if cell_size(2)==3
    point_cluster_cell=cell(1,3);
    trace1=point_cluster{1};
    trace2=point_cluster{2};
    trace3=point_cluster{3};
    array1_size=size(trace1);     %%%�������
    array2_size=size(trace2);     %%%�������
    array3_size=size(trace3);     %%%�������
    
     for i=1:array1_size(1)
        if flag_caiyang==1
            SNR_T=trace1(i,2);
            if SNR_T<gate_limit 
                trace1(i,:)=zeros(1,7);
            end
        else
           SNR_f=trace1(i,4);
            if SNR_f<gate_limit
                trace1(i,:)=zeros(1,7);
            end  
        end
    end
    trace1(all(trace1==0,2),:)=[];
    shape=size(trace1);   row=shape(1);
    if row>0
    point_cluster_cell{1}=trace1;
    else
    point_cluster_cell{1}=-1;
    end
    
    %%%%����˫�����
    for i=1:array2_size(1)
        if flag_caiyang==1
            SNR_T=[trace2(i,2),trace2(i,6)];
            SNR_ave=sum(SNR_T)/2;
            if SNR_ave<gate_limit
                trace2(i,:)=zeros(1,12);
            end
        else
           SNR_f=[trace2(i,4),trace2(i,8)];
           SNR_fave=sum(SNR_f)/2;
            if SNR_fave<gate_limit
                trace2(i,:)=zeros(1,12);
            end  
        end
    end
    trace2(all(trace2==0,2),:)=[];
    shape=size(trace2);   row=shape(1);
    if row>0
    point_cluster_cell{2}=trace2;
    else
    point_cluster_cell{2}=-1;
    end
    
    %%%%�����������
    for i=1:array3_size(1)
        if flag_caiyang==1
            SNR_T=[trace3(i,2),trace3(i,6),trace3(i,10)];
            SNR_ave=sum(SNR_T)/3;
            if SNR_ave<gate_limit
                trace3(i,:)=zeros(1,17);
            end
        else
           SNR_f=[trace3(i,4),trace3(i,8),trace3(i,12)];
           SNR_fave=sum(SNR_f)/3;
            if SNR_fave<gate_limit
                trace3(i,:)=zeros(1,17);
            end  
        end
    end
    trace3(all(trace3==0,2),:)=[];
    shape=size(trace3);   row=shape(1);
    if row>0
    point_cluster_cell{3}=trace3;
    else
    point_cluster_cell{3}=-1;
    end
    
end

if cell_size(2)==4
    point_cluster_cell=cell(1,4);
    trace1=point_cluster{1};
    trace2=point_cluster{2};
    trace3=point_cluster{3};
    trace4=point_cluster{4};
    array1_size=size(trace1);     %%%�������
    array2_size=size(trace2);     %%%�������
    array3_size=size(trace3);     %%%�������
    array4_size=size(trace4);     %%%�������
    
     for i=1:array1_size(1)
        if flag_caiyang==1
            SNR_T=trace1(i,2);
            if SNR_T<gate_limit
                trace1(i,:)=zeros(1,7);
            end
        else
           SNR_f=trace1(i,4);
            if SNR_f<gate_limit
                trace1(i,:)=zeros(1,7);
            end  
        end
    end
    trace1(all(trace1==0,2),:)=[];
    shape=size(trace1);   row=shape(1);
    if row>0
    point_cluster_cell{1}=trace1;
    else
    point_cluster_cell{1}=-1;
    end
    
    %%%%����˫�����
    for i=1:array2_size(1)
        if flag_caiyang==1
            SNR_T=[trace2(i,2),trace2(i,6)];
            SNR_ave=sum(SNR_T)/2;
            if SNR_ave<gate_limit
                trace2(i,:)=zeros(1,12);
            end
        else
           SNR_f=[trace2(i,4),trace2(i,8)];
           SNR_fave=sum(SNR_f)/2;
            if SNR_fave<gate_limit
                trace2(i,:)=zeros(1,12);
            end  
        end
    end
    trace2(all(trace2==0,2),:)=[];
    shape=size(trace2);   row=shape(1);
    if row>0
    point_cluster_cell{2}=trace2;
    else
    point_cluster_cell{2}=-1;
    end
    
    %%%%�����������
    for i=1:array3_size(1)
        if flag_caiyang==1
            SNR_T=[trace3(i,2),trace3(i,6),trace3(i,10)];
            SNR_ave=sum(SNR_T)/3;
            if SNR_ave<gate_limit
                trace3(i,:)=zeros(1,17);
            end
        else
           SNR_f=[trace3(i,4),trace3(i,8),trace3(i,12)];
           SNR_fave=sum(SNR_f)/3;
            if SNR_fave<gate_limit
                trace3(i,:)=zeros(1,17);
            end  
        end
    end
    trace3(all(trace3==0,2),:)=[];
    shape=size(trace3);   row=shape(1);
    if row>0
    point_cluster_cell{3}=trace3;
    else
    point_cluster_cell{3}=-1;
    end
  
    %%%%����4վ���
    for i=1:array4_size(1)
        if flag_caiyang==1
            SNR_T=[trace4(i,2),trace4(i,6),trace4(i,10),trace4(i,14)];
            SNR_ave=sum(SNR_T)/4;
            if SNR_ave<gate_limit
                trace4(i,:)=zeros(1,18);
            end
        else
           SNR_f=[trace4(i,4),trace4(i,8),trace4(i,12),trace4(i,16)];
           SNR_fave=sum(SNR_f)/4;
            if SNR_fave<gate_limit
                trace4(i,:)=zeros(1,18);
            end  
        end
    end
    trace4(all(trace4==0,2),:)=[];
    shape=size(trace4);   row=shape(1);
    if row>0
    point_cluster_cell{4}=trace4;
    else
    point_cluster_cell{4}=-1;
    end
end