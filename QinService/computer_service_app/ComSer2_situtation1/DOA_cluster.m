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