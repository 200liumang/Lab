function [loc_shunshi,couple_array]=Qin3_LMStraceloc(point_cluster,S_xyz,S_ref,S_varray,S_vref,f_array,doa_ref,flag_caiyang,flag_branch,Q,T)
 %%%Ӧ�����龰2 �ͷ�����ɢ���嵫δ��⵽ɢ���壬��С���˷�����TDOA-DOA��λ  FDOA-DOA��λ
 %%%point_cluster ��Q��ɢ����õ������п��ܶ�λ�㼣,��Ԫ���� ����������
 %%%������Ͻ����TDOAʱ���Ч�����_tdoa��FDOAʱ���Ч�����_fdoa�������_ref��������_ref ɢ��������
 %%%S_xyz ��ת��������ɢ�������꣬ ��Ч+��Ч  ��������
 %%%S_varray ɢ������ٶȣ� ��������
 %%%doa_ref��1*2 �ο�ͨ��doa����   fla_caiyang:  1: �߲���   0�� �Ͳ���   
 %%%flag_yundong 0: �������ٶ� 1�������ٶ�
 %%%loc_shunshi ��λ����㣬 couple_array ��Ч�Ķ�λ��� Ԫ������ ��������
 
 %%%%%%%%%%��֧1%%%%%%%%%%%%
 if flag_branch==1
     branch1_box=point_cluster{1};       %%%�ڷ�֧һ��Ԫ����ֻ����һ������
    if branch1_box(1,1) ~=-1
       doa_rd=branch1_box(:,5:6);
     if flag_caiyang==1                  %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=branch1_box(:,1);
         tao_array(:,2)=branch1_box(:,7);
         [loc_shun1,Index1]=Qin3_branch1_locGaocai(S_ref(:,1),tao_array,doa_rd);   %%%����˲ʱ��λ�� ���������   
     else
         fd_array=branch1_box(:,3);
         fd_array(:,2)=branch1_box(:,7);
         f=f_array;
         [loc_shun1,Index1]=Qin3_branch1_locDicaij(S_ref(:,1),S_vref(:,1),fd_array,doa_rd,f);   %%%����˲ʱ��λ�� ���������
     end
   else
      loc_shun1=-1;
   end
       
    loc_shunshi=zeros(3,1);   
    value1=size(Index1);  
    couple_array=cell(1,1);
    couple_array{1}=0;  
    if loc_shun1(1,1)~=-1
       loc_shunshi=[loc_shunshi loc_shun1];
       couple_array{1}=zeros(size(branch1_box,2),value1(2));     %%�ռ�����
         for i=1:value1(2)
            couple_array{1}(:,i)=branch1_box(value1(i),:)';
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
 %%%%%%%%%%%%%%%%%%%%%%��֧2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if flag_branch==2
     
     branch1_box=point_cluster{1};
     branch2_box=point_cluster{2}; 
   if size(branch1_box,2)>=6
       doa_rd=branch1_box(:,5:6);
     if flag_caiyang==1       
         tao_array=branch1_box(:,1);
         tao_array(:,2)=branch1_box(:,7);
         [loc_shun1,Index1]=Qin3_branch1_locGaocai(S_ref(:,1),tao_array,doa_rd);   %%%����˲ʱ��λ�� ���������   
     else
         fd_array=branch1_box(:,3);
         fd_array(:,2)=branch1_box(:,7);
         f=f_array;
         [loc_shun1,Index1]=Qin3_branch1_locDicaij(S_ref(:,1),S_vref(:,1),fd_array,doa_rd,f);   %%%����˲ʱ��λ�� ���������
     end
   else
      loc_shun1=-1;
   end
   
   if branch2_box(1,1) ~=-1
       if (Q-1)==1
         tao_array=branch2_box(:,1);
         tao_array(:,2)=branch2_box(:,5);
         fd_array=branch2_box(:,3);
         fd_array(:,2)=branch2_box(:,5);
       elseif (Q-1)==2
         tao_array=branch2_box(:,1);
         tao_array(:,2)=branch2_box(:,5);
         tao_array(:,3:4)=branch2_box(:,9:10);   
         
         fd_array=branch2_box(:,3);
         fd_array(:,2)=branch2_box(:,7);
         fd_array(:,3:4)=branch2_box(:,9:10);   
       elseif (Q-1)==3
         tao_array=branch2_box(:,1);
         tao_array(:,2)=branch2_box(:,5);
         tao_array(:,3)=branch2_box(:,9);  
         tao_array(:,4:6)=branch2_box(:,13:15);  
         
         fd_array=branch2_box(:,3);
         fd_array(:,2)=branch2_box(:,7);
         fd_array(:,3)=branch2_box(:,11); 
         fd_array(:,4:6)=branch2_box(:,13:15);
       end
       if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         s_xyz=S_xyz;   %%%������ɢ��������
         [loc_shun2,Index2]=Qin3_branch2_locGaocai(s_xyz,S_ref(:,1),tao_array,doa_ref,Q);   %%%����˲ʱ��λ�� ���������   
       else
         s_xyz=S_xyz;   %%%������ɢ��������  ���˲ο�ɢ����
         f=f_array;
         s_v=S_varray;
         [loc_shun2,Index2]=Qin3_Branch2_locDicaij(s_xyz,S_ref(:,1),s_v,S_vref(:,1),fd_array,doa_ref,f,Q);   %%%����˲ʱ��λ�� ���������
      end
   else
       loc_shun2=-1;
   end

loc_shunshi=zeros(3,1);   
value1=size(Index1); value2=size(Index2); 
couple_array=cell(1,3);
couple_array{1}=0;   couple_array{2}=0;  
if loc_shun1(1,1)~=-1
   loc_shunshi=[loc_shunshi loc_shun1];
   couple_array{1}=zeros(size(branch1_box,2),value1(2));     %%�ռ�����
     for i=1:value1(2)
        couple_array{1}(:,i)=branch1_box(Index1(i),:)';
     end
end
if loc_shun2(1,1)~=-1
   loc_shunshi=[loc_shunshi loc_shun2];
   if (Q-1)==2
      couple_array{2}=zeros(size(branch2_box,2),value2(2));     %%�ռ�����
   elseif (Q-1)==3
      couple_array{2}=zeros(size(branch2_box,2),value2(2));     %%�ռ�����
   end
     for i=1:value2(2)
        couple_array{2}(:,i)=branch2_box(Index2(i),:)';
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
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%��֧3%%%%%%%%%%%%%%%%%%%%%
 if flag_branch==3
     
     branch1_box=point_cluster{1};
     branch2_box=point_cluster{2};
     branch3_box=point_cluster{3};
     
   if size(branch1_box,2) >=6 
       doa_rd=branch1_box(:,5:6);
     if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         tao_array=branch1_box(:,1);
         tao_array(:,2)=branch1_box(:,7);
         [loc_shun1,Index1]=Qin3_branch1_locGaocai(S_ref(:,1),tao_array,doa_rd);   %%%����˲ʱ��λ�� ���������   
     else
         fd_array=branch1_box(:,3);
         fd_array(:,2)=branch1_box(:,7);
         f=f_array;
         [loc_shun1,Index1]=Qin3_Branch1_locDicaij(S_ref(:,1),S_vref(:,1),fd_array,doa_rd,f);   %%%����˲ʱ��λ�� ���������
     end
   else
      loc_shun1=-1;
   end
   
   if branch2_box(1,1) ~=-1
       if (Q-1)==1
         tao_array=branch2_box(:,1);
         tao_array(:,2)=branch2_box(:,5);
         
         fd_array=branch2_box(:,3);
         fd_array(:,2)=branch2_box(:,5);
       elseif (Q-1)==2
         tao_array=branch2_box(:,1);
         tao_array(:,2)=branch2_box(:,5);
         tao_array(:,3:4)=branch2_box(:,9:10);   
         
         fd_array=branch2_box(:,3);
         fd_array(:,2)=branch2_box(:,7);
         fd_array(:,3:4)=branch2_box(:,9:10);   
       elseif (Q-1)==3
         tao_array=branch2_box(:,1);
         tao_array(:,2)=branch2_box(:,5);
         tao_array(:,3)=branch2_box(:,9);  
         tao_array(:,4:6)=branch2_box(:,13:15);  
         
         fd_array=branch2_box(:,3);
         fd_array(:,2)=branch2_box(:,7);
         fd_array(:,3)=branch2_box(:,11); 
         fd_array(:,4:6)=branch2_box(:,13:15);
       end
       if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         s_xyz=S_xyz;   %%%������ɢ�������� ��ȥ�ο�ɢ����
         [loc_shun2,Index2]=Qin3_branch2_locGaocai(s_xyz,S_ref(:,1),tao_array,doa_ref,Q);   %%%����˲ʱ��λ�� ���������   
       else
         s_xyz=S_xyz;   %%%������ɢ�������� ��ȥ�ο�ɢ����
         f=f_array;
         s_v=S_varray;
         [loc_shun2,Index2]=Qin3_Branch2_locDicaij(s_xyz,S_ref(:,1),s_v,S_vref(:,1),fd_array,doa_ref,f,Q);   %%%����˲ʱ��λ�� ���������
      end
   else
       loc_shun2=-1;
   end

    if branch3_box(1,1) ~=-1
        if (T-1)==1
         tao_array=branch3_box(:,1);
         tao_array(:,2)=branch3_box(:,5);
         
         fd_array=branch3_box(:,3);
         fd_array(:,2)=branch3_box(:,5);
       elseif (T-1)==2
         tao_array=branch3_box(:,1);
         tao_array(:,2)=branch3_box(:,5);
         tao_array(:,3:4)=branch3_box(:,9:10);   
         
         fd_array=branch3_box(:,3);
         fd_array(:,2)=branch3_box(:,7);
         fd_array(:,3:4)=branch3_box(:,9:10);   
       elseif (T-1)==3
         tao_array=branch3_box(:,1);
         tao_array(:,2)=branch3_box(:,5);
         tao_array(:,3)=branch3_box(:,9);  
         tao_array(:,4:6)=branch3_box(:,13:15);  
         
         fd_array=branch2_box(:,3);
         fd_array(:,2)=branch2_box(:,7);
         fd_array(:,3)=branch2_box(:,11); 
         fd_array(:,4:6)=branch2_box(:,13:15);
        end
       s_xyz=S_xyz;   %%%������ɢ�������� ��ȥ�ο�ɢ����
       if flag_caiyang==1       %%%��Ϊ�߲��� �Ͳ��� ��ͬ��λ��ʽ
         [loc_shun3,Index3]=Qin3_branch3_locGaocai(s_xyz,S_ref(:,1),tao_array,doa_ref,T);   %%%����˲ʱ��λ�� ���������   
       else
         f=f_array;
         [loc_shun3,Index3]=Qin3_Branch3_locDicaij(s_xyz,S_ref(:,1),S_vref(:,2:end),S_vref(:,1),fd_array,doa_ref,f,T);   %%%����˲ʱ��λ�� ���������
      end
   else
       loc_shun3=-1;
   end

loc_shunshi=zeros(3,1);   

couple_array=cell(1,3);
couple_array{1}=0;   couple_array{2}=0;  couple_array{3}=0;
if loc_shun1(1,1)~=-1
   loc_shunshi=[loc_shunshi loc_shun1];
   value1=size(Index1); 
   couple_array{1}=zeros(7,value1(2));     %%�ռ�����
     for i=1:value1(2)
        couple_array{1}(:,i)=branch1_box(Index1(i),:)';
     end
end
if loc_shun2(1,1)~=-1
   loc_shunshi=[loc_shunshi loc_shun2];
   value2=size(Index2);
   if (Q-1)==2
      couple_array{2}=zeros(size(branch2_box,2),value2(2));     %%�ռ�����
   else
      couple_array{2}=zeros(size(branch2_box,2),value2(2));     %%�ռ�����
   end
     for i=1:value2(2)
        couple_array{2}(:,i)=branch2_box(Index2(i),:)';
     end
end
if loc_shun3(1,1)~=-1
   loc_shunshi=[loc_shunshi loc_shun3];
   value3=size(Index3); 
   if (T-1)==2
      couple_array{3}=zeros(size(branch3_box,2),value3(2));     %%�ռ�����
   else 
      couple_array{3}=zeros(size(branch3_box,2),value3(2));     %%�ռ�����
   end
     for i=1:value3(2)
        couple_array{3}(:,i)=branch3_box(Index3(i),:)';
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
 
