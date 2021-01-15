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