function [loc_shunshi,couple_array]=LMS_traceloc(point_cluster,S_xyz,S_varray,f_array,doa_ref,flag_caiyang,flag_yundong)
 %%%Ӧ�����龰2 �ͷ�����ɢ���嵫δ��⵽ɢ���壬��С���˷�����TDOA-DOA��λ  FDOA-DOA��λ
 %%%point_cluster ��Q��ɢ����õ������п��ܶ�λ�㼣,��Ԫ���� ����������
 %%%������Ͻ����TDOAʱ���Ч�����_tdoa��FDOAʱ���Ч�����_fdoa�������_ref��������_ref ɢ��������
 %%%S_xyz ��ת��������ɢ�������꣬ ��Ч+��Ч  ��������
 %%%S_varray ɢ������ٶȣ� ��������
 %%%doa_ref��1*2 �ο�ͨ��doa����   fla_caiyang:  1: �߲���   0�� �Ͳ���   
 %%%flag_yundong 0: �������ٶ� 1�������ٶ�
 %%%loc_shunshi ��λ����㣬 couple_array ��Ч�Ķ�λ��� Ԫ������ ��������
 
 shape=size(point_cluster);
 num=shape(2);                %%%�õ���Ԫ������

 if num==1
     Index=-1;
      if flag_caiyang==1          %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         si_box=point_cluster{1}; 
       if si_box(1,1)~=-1              %%%���ɢ�����ڵڶ���ɸѡ�����Ч��
         tao_array=si_box(:,1);
         tao_array(:,2)=si_box(:,7);
         s_xyz=S_xyz;   %%%��ȡ����Ӧɢ��������
         [loc_shun,Index]=S1_loc_Gaocai(s_xyz,tao_array,doa_ref);   %%%����˲ʱ��λ�� ���������
       else
         loc_shun=-1; 
       end 
      else
         si_box=point_cluster{1};
         if size(si_box,1)~=0
             fd_array=si_box(:,3);
             fd_array(:,2)=si_box(:,7);
             s_xyz=S_xyz;   %%%������ɢ��������
             f=f_array;
             s_v=S_varray;
             [loc_shun,Index]=S1_loc_Dicaij(s_xyz,s_v,fd_array,doa_ref,f);   %%%����˲ʱ��λ�� ���������
         else
          loc_shun=-1;     %%%%������=0�����  -1 ����LSMû���ҵ���Ч��λ��
         end
      end 

     if loc_shun(1,1)~=-1
         value2=size(Index);
         loc_shunshi=loc_shun;
         couple_array=cell(1,1);     %%%��������ռ�   ��������
         couple_array{1}=zeros(7,value2(2));
         for i=1:value2(2)
            couple_array{1}(:,i)=si_box(Index(i),:)';   %%% ��¼�����Ķ�λ�������õ���ϲ���
         end
     else
     loc_shunshi=-1;
     couple_array=-1;
     end
 end
 
 if num==2
     si_box=point_cluster{1};
     sisi_box=point_cluster{2};
     loc_shun1=-1;  loc_shun2=-1;
   if si_box(1,1) ~=-1
     if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=si_box(:,1);
         tao_array(:,2)=si_box(:,7);
         s_xyz=S_xyz;   %%%������ɢ��������
         [loc_shun1,Index]=S1_loc_Gaocai(s_xyz,tao_array,doa_ref);   %%%����˲ʱ��λ�� ���������   
     else
         fd_array=si_box(:,3);
         fd_array(:,2)=si_box(:,7);
         s_xyz=S_xyz;   %%%������ɢ��������
         f=f_array;
         s_v=S_varray;
         if (flag_yundong==0)
         [loc_shun1,Index]=S1_loc_Dicaij(s_xyz,s_v,fd_array,doa_ref,f);   %%%����˲ʱ��λ�� ���������
         else
          %%%%%�˶�Ŀ��ɢ����
         end
     end
   else
      loc_shun1=-1;
   end
   
   if sisi_box(1,1)~=-1
       if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=sisi_box(:,1);
         tao_array(:,2)=sisi_box(:,5);
         tao_array(:,3:4)=sisi_box(:,11:12);
         s_xyz=S_xyz;   %%%������ɢ��������
         [loc_shun2,Index2]=S1S2_loc_Gaocai(s_xyz,tao_array,doa_ref);   %%%����˲ʱ��λ�� ���������   
      else
         fd_array=sisi_box(:,3);
         fd_array(:,2)=sisi_box(:,7);
         fd_array(:,3:4)=sisi_box(:,11:12);
         s_xyz=S_xyz;   %%%������ɢ��������
         f=f_array;
         s_v=S_varray;
         [loc_shun2,Index2]=S1S2_loc_Dicaij(s_xyz,s_v,fd_array,doa_ref,f);   %%%����˲ʱ��λ�� ���������
      end
   else
       loc_shun2=-1;
   end
   
    couple_array=cell(1,2);              %%��������ռ�
    couple_array{1}=0;  
    couple_array{2}=0; 
   if loc_shun1(1,1)~=-1 && loc_shun2(1,1)~=-1
     value1=size(Index);   value2=size(Index2);
     loc_shunshi=[loc_shun1 loc_shun2];
     couple_array{1}=zeros(7,value1(2));
     couple_array{2}=zeros(12,value2(2));
         for i=1:value1(2)
            couple_array{1}(:,i)=si_box(Index(i),:)';
         end
         for i=1:value2(2)
            couple_array{2}(:,i)=sisi_box(Index2(i),:)';
         end
   elseif loc_shun1(1,1)~=-1
     value1=size(Index);  
       couple_array{1}=zeros(7,value1(2));
       value1=size(Index); 
       loc_shunshi=loc_shun1;
         for i=1:value1(2)
            couple_array{1}(:,i)=si_box(Index(i),:)';
         end
   elseif loc_shun2(1,1)~=-1
       value2=size(Index2);
       loc_shunshi=loc_shun2;
       couple_array{2}=zeros(12,value2(2));
         for i=1:value2(2)
            couple_array{2}(:,i)=sisi_box(Index2(i),:)';
         end
   else
       loc_shunshi=-1;
       couple_array=-1;
   end
     
 end
 
 if num==3
     si_box=point_cluster{1};                   %% ��������������� ��������
     sisi_box=point_cluster{2};
     sisisi_box=point_cluster{3};
 
     
   if si_box(1,1) ~=-1
     if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=si_box(:,1);
         tao_array(:,2)=si_box(:,7);
         s_xyz=S_xyz;   %%%������ɢ��������
         [loc_shun1,Index1]=S1_loc_Gaocai(s_xyz,tao_array,doa_ref);   %%%����˲ʱ��λ�� ���������   
     else
         fd_array=si_box(:,3);
         fd_array(:,2)=si_box(:,7);
         s_xyz=S_xyz;   %%%������ɢ��������
         f=f_array;
         s_v=S_varray;
         [loc_shun1,Index1]=S1_loc_Dicaij(s_xyz,s_v,fd_array,doa_ref,f);   %%%����˲ʱ��λ�� ���������
     end
   else
      loc_shun1=-1;
   end
   
   if sisi_box(1,1)~=-1
       if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=sisi_box(:,1);
         tao_array(:,2)=sisi_box(:,5);
         tao_array(:,3:4)=sisi_box(:,11:12);
         s_xyz=S_xyz;   %%%������ɢ��������
         [loc_shun2,Index2]=S1S2_loc_Gaocai(s_xyz,tao_array,doa_ref);   %%%����˲ʱ��λ�� ���������   
      else
         fd_array=sisi_box(:,3);
         fd_array(:,2)=sisi_box(:,7);
         fd_array(:,3:4)=sisi_box(:,11:12);
         s_xyz=S_xyz;   %%%������ɢ��������
         f=f_array;
         s_v=S_varray;
         [loc_shun2,Index2]=S1S2_loc_Dicaij(s_xyz,s_v,fd_array,doa_ref,f);   %%%����˲ʱ��λ�� ���������
      end
   else
       loc_shun2=-1;
   end

    if sisisi_box(1,1)~=-1
       if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=sisisi_box(:,1);
         tao_array(:,2)=sisisi_box(:,5);
         tao_array(:,3)=sisisi_box(:,9);
         tao_array(:,4:6)=sisisi_box(:,15:17);
         s_xyz=S_xyz;   %%%������ɢ��������
         [loc_shun3,Index3]=S1S2S3_loc_Gaocai(s_xyz,tao_array,doa_ref);   %%%����˲ʱ��λ�� ���������   
      else
         fd_array=sisisi_box(:,3);
         fd_array(:,2)=sisisi_box(:,7);
         fd_array(:,3)=sisisi_box(:,11);
         fd_array(:,4:6)=sisisi_box(:,15:17);
         s_xyz=S_xyz;   %%%������ɢ��������
         f=f_array;
         s_v=S_varray;
         [loc_shun3,Index3]=S1S2S3_loc_Dicaij(s_xyz,s_v,fd_array,doa_ref,f);   %%%����˲ʱ��λ�� ���������
      end
   else
       loc_shun3=-1;
   end

loc_shunshi=zeros(3,1);   
couple_array=cell(1,3);
couple_array{1}=0;   
couple_array{2}=0;  
couple_array{3}=0;
if loc_shun1(1,1)~=-1
    value1=size(Index1); 
   loc_shunshi=[loc_shunshi loc_shun1];
   couple_array{1}=zeros(7,value1(2));     %%�ռ�����
     for i=1:value1(2)
        couple_array{1}(:,i)=si_box(Index1(i),:)';
     end
end
if loc_shun2(1,1)~=-1
   value2=size(Index2); 
   loc_shunshi=[loc_shunshi loc_shun2];
      couple_array{2}=zeros(12,value2(2));     %%�ռ�����
     for i=1:value2(2)
        couple_array{2}(:,i)=sisi_box(Index2(i),:)';
     end
end
if loc_shun3(1,1)~=-1
    value3=size(Index3); 
   loc_shunshi=[loc_shunshi loc_shun3];
   couple_array{3}=zeros(17,value3(2));     %%�ռ�����
     for i=1:value3(2)
        couple_array{3}(:,i)=sisisi_box(Index3(i),:)';
     end
end
col=size(loc_shunshi);
if col(2)>1
  loc_shunshi(:,1)=[];
else
  loc_shunshi=-1;
  couple_array=-1;
end

 end
 
 if num==4
     si_box=point_cluster{1};
     sisi_box=point_cluster{2};
     sisisi_box=point_cluster{3};
     sisisisi_box=point_cluster{4};
    
   if si_box(1,1) ~=-1
     if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=si_box(:,1);
         tao_array(:,2)=si_box(:,7);
         s_xyz=S_xyz;   %%%������ɢ��������
         [loc_shun1,Index1]=S1_loc_Gaocai(s_xyz,tao_array,doa_ref);   %%%����˲ʱ��λ�� ���������   
     else
         fd_array=si_box(:,3);
         fd_array(:,2)=si_box(:,7);
         s_xyz=S_xyz;   %%%������ɢ��������
         f=f_array;
         s_v=S_varray;
         [loc_shun1,Index1]=S1_loc_Dicaij(s_xyz,s_v,fd_array,doa_ref,f);   %%%����˲ʱ��λ�� ���������
     end
   else
      loc_shun1=-1;
   end
   
   if sisi_box(1,1)~=-1
       if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=sisi_box(:,1);
         tao_array(:,2)=sisi_box(:,5);
         tao_array(:,3:4)=sisi_box(:,11:12);
         s_xyz=S_xyz;   %%%������ɢ��������
         [loc_shun2,Index2]=S1S2_loc_Gaocai(s_xyz,tao_array,doa_ref);   %%%����˲ʱ��λ�� ���������   
      else
         fd_array=sisi_box(:,3);
         fd_array(:,2)=sisi_box(:,7);
         fd_array(:,3:4)=sisi_box(:,11:12);
         s_xyz=S_xyz;   %%%������ɢ��������
         f=f_array;
         s_v=S_varray;
         [loc_shun2,Index2]=S1S2_loc_Dicaij(s_xyz,s_v,fd_array,doa_ref,f);   %%%����˲ʱ��λ�� ���������
      end
   else
       loc_shun2=-1;
   end

    if sisisi_box(1,1)~=-1
       if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=sisisi_box(:,1);
         tao_array(:,2)=sisisi_box(:,5);
         tao_array(:,3)=sisisi_box(:,9);
         tao_array(:,4:6)=sisisi_box(:,15:17);
         s_xyz=S_xyz;   %%%������ɢ��������
         [loc_shun3,Index3]=S1S2S3_loc_Gaocai(s_xyz,tao_array,doa_ref);   %%%����˲ʱ��λ�� ���������   
      else
         fd_array=sisisi_box(:,3);
         fd_array(:,2)=sisisi_box(:,7);
         fd_array(:,3)=sisisi_box(:,11);
         fd_array(:,4:6)=sisisi_box(:,15:17);
         s_xyz=S_xyz;   %%%������ɢ��������
         f=f_array;
         s_v=S_varray;
         [loc_shun3,Index3]=S1S2S3_loc_Dicaij(s_xyz,s_v,fd_array,doa_ref,f);   %%%����˲ʱ��λ�� ���������
      end
   else
       loc_shun3=-1;
   end

  if sisisisi_box(1,1)~=-1
       if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=sisisi_box(:,1);
         tao_array(:,2)=sisisi_box(:,5);
         tao_array(:,3)=sisisi_box(:,9);
         tao_array(:,4)=sisisi_box(:,13);
         s_xyz=S_xyz;   %%%������ɢ��������
         [loc_shun4,Index4]=S1S2S3S4_loc_Gaocai(s_xyz,tao_array,doa_ref);   %%%����˲ʱ��λ�� ���������   
      else
         fd_array=sisisi_box(:,3);
         fd_array(:,2)=sisisi_box(:,7);
         fd_array(:,3)=sisisi_box(:,11);
         fd_array(:,4)=sisisi_box(:,15);
         s_xyz=S_xyz;   %%%������ɢ��������
         f=f_array;
         s_v=S_varray;
         [loc_shun4,Index4]=S1S2S3S4_loc_Dicaij(s_xyz,s_v,fd_array,doa_ref,f);   %%%����˲ʱ��λ�� ���������
      end
   else
       loc_shun4=-1;
   end

loc_shunshi=zeros(3,1);
couple_array=cell(1,4);
couple_array{1}=0;   couple_array{2}=0;  couple_array{3}=0; couple_array{4}=0;
if loc_shun1(1,1)~=-1
    value1=size(Index1); 
   loc_shunshi=[loc_shunshi loc_shun1];
      couple_array{1}=zeros(7,value1(2));     %%�ռ�����
     for i=1:value1(2)
        couple_array{1}(:,i)=si_box(Index1(i),:);
     end
end
if loc_shun2(1,1)~=-1
   value2=size(Index2); 
   loc_shunshi=[loc_shunshi loc_shun2];
      couple_array{2}=zeros(12,value2(2));     %%�ռ�����
     for i=1:value2(2)
        couple_array{2}(:,i)=sisi_box(Index2(i),:)';
     end
end
if loc_shun3(1,1)~=-1
   value3=size(Index3); 
   loc_shunshi=[loc_shunshi loc_shun3];
   couple_array{3}=zeros(17,value3(2));     %%�ռ�����
     for i=1:value3(2)
        couple_array{3}(:,i)=sisisi_box(Index3(i),:)';
     end
end
if loc_shun4(1,1)~=-1
   value4=size(Index4); 
   loc_shunshi=[loc_shunshi loc_shun4];
      couple_array{4}=zeros(18,value4(2));     %%�ռ�����
     for i=1:value4(2)
        couple_array{4}(:,i)=sisisisi_box(Index4(i),1:18)';
     end
end
col=size(loc_shunshi);
if col(2)>1
  loc_shunshi(:,1)=[];
else
  loc_shunshi=-1;
  couple_array=-1;
end
     
end
 