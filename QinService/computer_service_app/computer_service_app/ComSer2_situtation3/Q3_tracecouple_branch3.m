function [point_cluster_cell,is_trace]=Q3_tracecouple_branch3(pufeng_cell,T)
 %%%Ӧ�����龰3 �ͷ�����ɢ���嵫δ��⵽ɢ���壬���㼣֮��ı�����ϣ���֧1���   ����ɢ��������
 %%%pufeng_cell Ԫ��������Q>1 T>1 T-1 ���������ݣ��������=3�� ���˵�ȫ0���ݣ���֤������������ݲ�Ϊ0
 %%%pufeng_cell ���������У� TDOAʱ���Ч�����_tdoa��FDOAʱ���Ч�����_fdoa
 %%%doa_array������Ҫ��������
 %%%point_cluster_cell����϶�λ�㼣  Ԫ������Ϊ��Ӧ�Բ�ͬ���������²�ͬά����ÿ���������������
 %%%������Ͻ����TDOAʱ���Ч�����_tdoa��FDOAʱ���Ч�����_fdoa�������_ref��������_ref ɢ��������
 
 if (T-1)<=0
     point_cluster_cell=0;  %%%  ��֤�ͽ�����ɢ���嶼������Ч������
     is_trace=0;
 end
 
 if (T-1)==1
     is_trace=1;
     s1_box=pufeng_cell{1};
     shape_s1=size(s1_box);                   %%%�õ�����γ��
     point_cluster_cell=cell(1,1);            %%%ɢ����ֻ��һ�� ֻ�贴��һ���ӿռ�
     point_cluster_cell{1}=zeros(shape_s1(2),5);  
     for i=1:shape_s1(2)
         point_cluster_cell{1}(i,1:4)=(s1_box(1:4,i))';
         point_cluster_cell{1}(i,5)=s1_box(5,i);
     end
 end
 if (T-1)==2
     is_trace=1;
    s1_box=pufeng_cell{1};
    shape_s1=size(s1_box);                   %%%�õ�����γ��
    s2_box=pufeng_cell{2};
    shape_s2=size(s2_box);                   %%%�õ�����γ��
    
    point_cluster_cell=cell(1,1);            %%%ɢ�������� �������ݿռ�
    point_cluster_cell{1}=zeros(shape_s1(2)*shape_s2(2),10);  %%%�������ɢ����������ݿռ� ������������λ 10 ->12
    %row_size=shape_s1(2)+shape_s2(2);        %%%ɢ�����е�����
    %point_cluster_cell{1}=zeros(row_size,7); %%%���ɢ���嵥��������Ͽռ�   ����һ������λ 6->7
    %size_group=[shape_s1(2),shape_s2(2)];
    
%     index_1=1;
%     %%%%�ռ�M1��M2
%     for i=1:2
%         si_box=pufeng_cell{i};
%         for j=1:size_group(i)
%           point_cluster_cell{1}(index_1,1:4)=(si_box(1:4,j))';    %%%��ȡS1ɢ����һ��
%           point_cluster_cell{1}(index_1,5:6)=doa_ref;
%           point_cluster_cell{1}(index_1,7)=si_box(5,j);
%           index_1=index_1+1;
%         end 
%     end
     %%%%�ռ�M1/M2
    interlayer_1=1;
       for i=1:shape_s1(2)
          for j=1:shape_s2(2)
           point_cluster_cell{1}(interlayer_1,1:4)=(s1_box(1:4,i))';
           point_cluster_cell{1}(interlayer_1,5:8)=(s2_box(1:4,j))';
           point_cluster_cell{1}(interlayer_1,9)=s1_box(5,i);
           point_cluster_cell{1}(interlayer_1,10)=s2_box(5,j);
           interlayer_1=interlayer_1+1; 
          end
       end
         
 end
%  
 if (T-1)==3
     is_trace=1;
    s1_box=pufeng_cell{1};
    shape_s1=size(s1_box);                               %%% �õ�����γ��
    s2_box=pufeng_cell{2};
    shape_s2=size(s2_box);                               %%% �õ�����γ��
    s3_box=pufeng_cell{3};
    shape_s3=size(s3_box);                               %%% �õ�����γ��
    
    point_cluster_cell=cell(1,1);                        %%% ɢ�������� �������ݿռ�
%     row_size=shape_s1(2)+shape_s2(2)+shape_s3(2);      %%% ɢ�����е�����
%     row_size2=shape_s1(2)*shape_s2(2)+shape_s1(2)*shape_s3(2)+shape_s2(2)*shape_s3(2);
    row_size3=shape_s1(2)*shape_s2(2)*shape_s3(2);
    point_cluster_cell{1}=zeros(row_size3,15);           %%% ���ɢ���嵥��������Ͽռ�      6 ->7
%     point_cluster_cell{2}=zeros(row_size2,12);         %%% �������ɢ����������ݿռ�   10->12
%     point_cluster_cell{3}=zeros(row_size3,17);         %%% 14 ->17  
   % size_group=[shape_s1(2),shape_s2(2),shape_s3(2)];
    
          %%%%�ռ�M1/M2/M3
      interlayer_2=1;
      for i=1:shape_s1(2)
          for j=1:shape_s2(2)
              for k=1:shape_s3(2)
               point_cluster_cell{1}(interlayer_2,1:4)=(s1_box(1:4,i))';
               point_cluster_cell{1}(interlayer_2,5:8)=(s2_box(1:4,j))';
               point_cluster_cell{1}(interlayer_2,9:12)=(s3_box(1:4,k))';
               point_cluster_cell{1}(interlayer_2,13)=s1_box(5,i);
               point_cluster_cell{1}(interlayer_2,14)=s2_box(5,j);
               point_cluster_cell{1}(interlayer_2,15)=s3_box(5,k);
               interlayer_2=interlayer_2+1;
              end
          end
      end  
 end