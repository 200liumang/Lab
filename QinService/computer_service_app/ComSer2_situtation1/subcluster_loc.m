function location_shun=subcluster_loc(loc_array,M,ya,yb,k_up, k_down,r)
% �龰һδʩ������ɢ�����˲ʱ��λ�㼣����_��������ɹѡ��Ϊ��
% loc_array����Ч��վ����,������λ����xy��������ζȺ��� �������� 4*M����
% MΪ��Чվλ��
%location_shun ��Ԫ������ cell��4*n xy���꣬������ζȣ�������
% ע�⣺ ya yb k_up k_down r ��Ҫ���ж������
% ya=5.5; yb=8.25; k_up=0.55; k_down=0.3; r=6.5;

global aalag_while_subcluster;    %ȷ���ڳ���ִ��ʱ�ú����ڵ�while(1)ִ������
aalag_while_subcluster=0;
xy=loc_array(1:2,:); %��ȡ��������λ������
shape=size(loc_array); col=shape(2);
D=zeros(1,col);             %����������λ����ܶ�ָ��

%%%%%%Ѱ�ҵ�һ�����ĵ�
for i=1:col
    X=xy(:,i);
    Euler_pre=(xy-X);     
    Euler_pre2=sum(Euler_pre.^2);         %sum�����󣩶������ sum������2���������
    Euler=(sqrt(Euler_pre2))./(0.5*ya)^2; %����e��ָ������
    D(i)=sum(exp(-Euler));
end
[D_c1,index]=max(D);
sub_cen=zeros(2,100);      sub_col=1;      %�������ļ�¼����
location_pre=cell(1,100);  loc_col=1;      %��ž�����
location_shun=cell(1,100);
sub_cen(:,1)=xy(:,index);   %�ȼ�¼��һ�����ĵ�

    %%%%��ʼѰ�����������
    D_ck=D_c1;
while(1)
    Euler_pre=(xy-sub_cen(:,sub_col));     
    Euler_pre2=sum(Euler_pre.^2);         %sum�����󣩶������ sum������2���������
    Euler=(sqrt(Euler_pre2))./(0.5*yb)^2; %����e��ָ������
    D=D-D_ck.*exp(-Euler);                %�õ��µ�һ�ֵ��ܶ�ָ��
    
   while(1)
       [D_ck,index]=max(D);                  %�õ��µ����ֵ������λ
    if (D_ck<k_down*D_c1)
        flag=-1;
    elseif (D_ck>k_up*D_c1)
        sub_cen(:,sub_col+1)=xy(:,index);
        sub_col=sub_col+1;
        flag=1;
    else
        d=sub_cen-xy(:,index);
        d2=sum(d.^2);
        d_min=min(sqrt(d2));
        if (d_min/ya+D_ck/sqrt(xy(:,index)'*xy(:,index)))>=1
              sub_cen(:,sub_col+1)=xy(:,index);
              sub_col=sub_col+1;
              flag=1;
        else
            D(index)=0;
            flag=0;
            continue;
        end
    end
    if (flag==-1 || flag==1)
        break;   %������ѭ��
    end
   end
   if flag==-1
       aalag_while_subcluster=1;
       break;   %%������ѭ��
   elseif flag ==1
       flag=0;
       continue;
   end
end

for i=1:sub_col               %%%��ʼ�������ĵ㹹������
    cen=sub_cen(:,i);
    dist_pre=sum((xy-cen).^2);
    dist=sqrt(dist_pre);
    for j=1:col
        if (dist(j)<=r)       %%r��Ҫ�Լ�����
            location_pre{i}(:,loc_col)=loc_array(:,j);
            loc_col=loc_col+1;
        end
    end
    loc_col=1;
end
loc_col=1;                   %%location_shun����ʹ��

for i=1:sub_col              %%ɾ�����ݹ��ٵľ���
    cel=location_pre{i};
    num=size(cel);
    if num(2)>=(M*2/3)
        location_shun{loc_col}=cel;
        loc_col=loc_col+1;
    end
end
location_shun(loc_col:end)=[];     %%ɾ���վ���
end