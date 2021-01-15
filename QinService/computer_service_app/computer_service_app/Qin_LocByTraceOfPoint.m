function [XYZ,Target_V, trace_cell,vxyz_cell]=Qin_LocByTraceOfPoint(Loc_cell,Vmin,Vmax,Vz_min,Vz_max,detax,detay,detaz,detaT,GRADE_MAX,K,zhen_size)
%%%��CPIʱ�̵㼣��ѡ���˲�ƽ��
%%%����˵���� Loc_cell: K֡��λ��� Ԫ������ ��������  δ�����Ƿ������Ч����
%%%          Vmin��  ˮƽ�˶���С�ٶ�
%%%          Vmax��  ˮƽ�˶�����ٶ�
%%%          Vz_min�������˶���С�ٶ�
%%%          Vz_max: �����˶�����ٶ�
%%%           detax: x���겨��
%%%           detay��y���겨��
%%%           detaz: z���겨��
%%%           GRADE_MAX: Ŀ��ĳ�ʼ����
%%%           K��������С���˵���
%%%          zhen_size: ֡������
Time_nums=0;         % ��¼��ǰ���ڴ����CPIʱ��
Targets_nums=0;      % ��¼��ǰ�㼣��ʼ������

for i=1:zhen_size
  temp_loc=Loc_cell{i};
  temp_loc_size=size(temp_loc);
  Point_cpi=zeros(5,temp_loc_size(2));        %%��ǰcpiʱ�̵㼣���� һ����š�������־flag������ֵx,y,z
  Point_cpi(3:5,1:end)=temp_loc(1:3,1:end);  %%������ǰ�㼣��� ALL_points
  Point_cpi(1,1:end)=1:temp_loc_size(2);
  Time_nums=Time_nums+1;
  if Time_nums==1
      All_targets=cell(1,200);               %%����Ŀ��Ԫ������ Ĭ��Ŀ��㲻�ᳬ��200
    for j=1:temp_loc_size(2)
       All_targets{j}=cell(1,7);             %%һ�����name������ʱ��beginning �Ʒ���grade ���������nums �㼣������� �㼣�������� ��ǰʱ�̲������ĵ�����
       All_targets{j}{1}=Point_cpi(1,j);     % ���name
       All_targets{j}{2}=Time_nums;          % ��¼��ǰ�㼣��ʼ��Ľ���ʱ��beginning �������ڵڼ�֡
       All_targets{j}{3}=GRADE_MAX;          % Ŀ�����޵㼣ƥ��������ʱ��
       All_targets{j}{4}=1;                  % ��������������Ե�ǰ�㼣Ϊ��ʼ��Ĺ켣�����ĵ㼣����
       All_targets{j}{5}=zeros(1,200);       % ��������С
       All_targets{j}{6}=zeros(3,200);       % ��¼��ǰ�켣�����ĵ㼣����
       All_targets{j}{6}(:,1)=Point_cpi(3:5,j);
       All_targets{j}{7}=Point_cpi(3:5,j);   % ��ǰ�켣�����������������ĵ㣬������������벨�����ĵ��dxy
       Targets_nums=Targets_nums+1;
    end
    continue;
  end
   Dxy_mp=ones(Targets_nums,temp_loc_size(2))*9999; % Ŀ��㼣������� ������Ŀ��� �������㼣��
   for j=1:Targets_nums
       temp_tarcell=All_targets{j};     
       trace_nums=temp_tarcell{4};      % ȡ����ǰ�켣�����ĵ㼣��
       grade=temp_tarcell{3};           % ȡ���ĵ�ǰ�켣�ķ���
       center_point=temp_tarcell{7};    
     for k=1:temp_loc_size(2) 
       point_xyz=temp_loc(:,k);         %%��ǰcpi��k�е㼣���� 
       dxy=sqrt((center_point(1:2)-point_xyz(1:2))'*(center_point(1:2)-point_xyz(1:2)));
       dz=sqrt((center_point(3)-point_xyz(3))'*(center_point(3)-point_xyz(3)));
       if trace_nums==1
           N=GRADE_MAX;
           if (dxy>Vmin*detaT*(N-grade+1) && dxy<=Vmax*detaT*(N-grade+1)) && (dz>=Vz_min*detaT*(N-grade+1) && dz<=Vz_max*detaT*(N-grade+1))
               Dxy_mp(j,k)=dxy;
           end
       else
           N=min(trace_nums,K);
           x=sqrt((center_point(1)-point_xyz(1))'*(center_point(1)-point_xyz(1)));
           y=sqrt((center_point(2)-point_xyz(2))'*(center_point(2)-point_xyz(2)));
           z=sqrt((center_point(3)-point_xyz(3))'*(center_point(3)-point_xyz(3)));
           if (x<=detax*N/grade) && (y<=detay*N/grade) && (z<=detaz*N/grade)
               Dxy_mp(j,k)=dxy;
           end
       end
     end
   end
   t=zeros(1,Targets_nums);   %%������Ŀ�� �����ǵ㼣
   p=zeros(1,size(Dxy_mp,2));   %%�����ǵ㼣 ������Ŀ��
   for j=1:Targets_nums       %%��t��¼�㼣
       [value,index]=min(Dxy_mp(j,:));
       if value~=9999
       t(1,j)=index;
       end
     if (t(1,j)~=0)
       if p(1,t(1,j))==0      %%Ϊp��ź���Ŀ���
           p(1,t(1,j))=j;
       else
           dxy1=Dxy_mp(j,t(1,j));
           dxy2=Dxy_mp(p(1,t(1,j)),t(1,j));
           grade1=All_targets{j}{3};
           grade2=All_targets{p(1,t(1,j))}{3};
           if dxy1<dxy2    %%�����ɹ�
             Dxy_mp(p(1,t(1,j)),t(1,j))=9999;
             p(1,t(1,j))=j;
           elseif dxy1==dxy2
               if grade1 >grade2
                   Dxy_mp(p(1,t(1,j)),t(1,j))=9999;
                   p(1,t(1,j))=j;
               elseif grade1==grade2
                    name1=All_targets{j}{1};
                    name2=All_targets{p(1,t(1,j))}{1};
                   if name1<name2
                     Dxy_mp(p(1,t(1,j)),t(1,j))=9999;
                     p(1,t(1,j))=j;
                   end
               end
           else       %%����ʧ��
               Dxy_mp(j,t(1,j))=9999;
           end
       end
     end
   end
   t2=zeros(2,Targets_nums);
   for j=1:Targets_nums
       if t(1,j)~=0
           if p(1,t(1,j))==j
               t2(1,j)=t(1,j);
               t2(2,j)=1;
           else
               [dxy,index]=min(Dxy_mp(j,:)) ;  % ��ǰĿ���ĵ㼣�Ѿ���ȡ������DxyѰ����һ��
               if dxy~=9999
                t2(1,j)=index;
                t2(2,j)=1;   
               end
           end
       end
   end
   % ��ʼ����All_targets
   j=1; 
   while j<=Targets_nums     
      if t2(1,j)~=0
         Point_cpi(2,t2(1,j))=1;
         trace_nums=All_targets{j}{4};
         beginning=All_targets{j}{2};
         All_targets{j}{5}(1,Time_nums-beginning+1)=t2(1,j);
         All_targets{j}{6}(:,Time_nums-beginning+1)= Point_cpi(3:5,t2(1,j));
         if (Time_nums-beginning+1-trace_nums)>=2
             trace_nums=trace_nums+1;
             All_targets{j}{4}=All_targets{j}{4}+1;
             All_targets{j}{6}(:,trace_nums)= (All_targets{j}{6}(:,1)+All_targets{j}{6}(:,Time_nums-beginning+1))*0.5;
         end
         All_targets{j}{4}=All_targets{j}{4}+1;
         trace_nums=All_targets{j}{4};
         N=min(trace_nums,K);
         center_point=waituichazhi(All_targets{j}{6}(:,trace_nums-N+1:trace_nums),detaT,N); %%�������Ʋ�ֵ���㲨�����ĵ�

         All_targets{j}{7}=center_point;
         All_targets{j}{3}=All_targets{j}{3}+1;
         if All_targets{j}{3}>GRADE_MAX
             All_targets{j}{3}=GRADE_MAX;
         end
      elseif t2(1,j)==0
         trace_nums=All_targets{j}{4};
         if trace_nums==1
            All_targets{j}{3}=All_targets{j}{3}-1; 
          if All_targets{j}{3}==0
              All_targets(j)=[];     %%ɾ����j��Ŀ��
              t2(:,j)=[];
              j=j-1;
              Targets_nums=Targets_nums-1;
          end
         elseif trace_nums>1               %%nums��Ϊ1 ���ò��ŵ������һ���㼣
            All_targets{j}{6}(:,trace_nums+1)= All_targets{j}{7};
            N=min(trace_nums+1,K);
            trace_nums = trace_nums+1;
            center_point=waituichazhi(All_targets{j}{6}(:,trace_nums-N+1:trace_nums),detaT,N); %%�������Ʋ�ֵ���㲨�����ĵ�
            All_targets{j}{7}=center_point;
            All_targets{j}{4}=All_targets{j}{4}+1;
            All_targets{j}{3}=All_targets{j}{3}-1; 
          if All_targets{j}{3}==0
              All_targets(j)=[];     %%ɾ����j������
              t2(:,j)=[];
              j=j-1;
              Targets_nums=Targets_nums-1;
          end
         end
      end
      j=j+1;
   end
   flag=Point_cpi(2,:);                                   %%��������������ΪĿ���
   for j=1:temp_loc_size(2)
       if flag(j)==0
       All_targets{Targets_nums+1}=cell(1,7);             %%һ�����name������ʱ��beginning �Ʒ���grade ���������nums �㼣������� �㼣�������� ��ǰʱ�̲������ĵ�����
       All_targets{Targets_nums+1}{1}=Point_cpi(1,j);     %%���name
       All_targets{Targets_nums+1}{2}=Time_nums;          %%һ������ʱ��beginning
       All_targets{Targets_nums+1}{3}=GRADE_MAX;          %%һ���Ʒ���  Ŀ�����޵㼣ƥ��������ʱ��
       All_targets{Targets_nums+1}{4}=1;                  %%���������
       All_targets{Targets_nums+1}{5}=zeros(1,200);       %%��������С
       All_targets{Targets_nums+1}{6}=zeros(3,200);       %%���������С
       All_targets{Targets_nums+1}{6}(:,1)=Point_cpi(3:5,j);
       All_targets{Targets_nums+1}{7}=Point_cpi(3:5,j);   %%��ǰʱ�̲������ĵ�����
       Targets_nums=Targets_nums+1;   
       end
   end
   if i>=zhen_size     %%��ȡ��֡�����ڵ���Kֵ��
       break;
   end
end
% ���÷�����ƽ������ն�λ��
XYZ_cell=cell(1,Targets_nums);
Target_V_cell=cell(1,Targets_nums);
count=0;
    for i=1:Targets_nums
        targets=All_targets{i};
           trace_nums=targets{4};
        if trace_nums>=(zhen_size-1)
            count=count+1;
            trace_point=targets{6};
            [xyz,V_xyz]=fanxiangditui(trace_point,trace_nums,K,detaT);
            XYZ_cell{1,count}=xyz;
            Target_V_cell{1,count}=V_xyz;    
        end    
    end
  XYZ = zeros(3,200);
  Target_V=zeros(3,200);
  index=1; count=1;
  trace_cell={};
  vxyz_cell = {};
  for i=1:Targets_nums
      xyz = XYZ_cell{i};
      V_xyz = Target_V_cell{1,i};
      columns = size(xyz,2);
      if size(xyz,2)>0
          XYZ(:,index:index+columns-1) = xyz;
          Target_V(:,index:index+columns-1)=V_xyz;
          index = index+columns;
          trace_cell{count}= XYZ_cell{i};
          vxyz_cell{count} =  Target_V_cell{i};
          count =count+1;
      end
  end
  XYZ(:,all(XYZ==0,1))=[];
  Target_V(:,all(Target_V==0,1))=[];

end

function center_point=waituichazhi(loc,detaT,N)
     center_point=zeros(3,1);
     x=loc(1,:)';
     y=loc(2,:)'; 
     z=loc(3,:)';
     H=ones(N,2);  H(:,2)=-flipud((1:N)')*detaT;
     x2=(H'*H)\H'*x;
     y2=(H'*H)\H'*y;
     z2=(H'*H)\H'*z;
     center_point(1,1)=x2(1,1);
     center_point(2,1)=y2(1,1);
     center_point(3,1)=z2(1,1);
end

function [xyz,V_xyz]=fanxiangditui(trace_point,nums,K,detaT)
     H=zeros(K,2);
     H(1:K,1)=ones(K,1);
     H(2:K,2)=detaT*(1:K-1)';
     xyz = zeros(3,nums);
     V_xyz = zeros(3,nums);
     v_index = 0;
     for i=K:nums
        x=trace_point(1,i-K+1:i)';
        y=trace_point(2,i-K+1:i)'; 
        z=trace_point(3,i-K+1:i)';
        x2=(H'*H)\H'*x;
        y2=(H'*H)\H'*y;
        z2=(H'*H)\H'*z;
        xyz(1,i-K+1)=x2(1,1);    V_xyz(1,i-K+1)=x2(2,1);
        xyz(2,i-K+1)=y2(1,1);    V_xyz(2,i-K+1)=y2(2,1);
        xyz(3,i-K+1)=z2(1,1);    V_xyz(3,i-K+1)=z2(2,1);
        v_index = i-K+1;
     end
    for i=v_index+1:nums
        xyz(:,i) = trace_point(:,i);
        V_xyz(:,i) = V_xyz(:,i-1);
    end
end
