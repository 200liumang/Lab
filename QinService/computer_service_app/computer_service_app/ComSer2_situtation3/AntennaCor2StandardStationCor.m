function [sta_fw,sta_fy,alph,beta] = AntennaCor2StandardStationCor(H,fw,fy,ant_fw,ant_fy)

% ���ݵ�ǰ���������ڵ�xyz�ų���������ƫ�ǡ��������Ϣ����������doa���Ƶõ��ĽǶ�
% ��Ϣת��Ϊ��׼վ������ϵ�µķ�λ�Ǻ͸����ǡ�����Ķ�λ�����ڱ�׼վ������ϵ�½��е�

% H�����ų�������(Hx,Hy,Hz)1*3�ķ���
% fw����ƫ�ǣ��Ƕȣ���y��нǣ��ش�N����
% fy������ǣ��Ƕȣ���xoy��ļн�
% ant_fw������������ϵ�еķ�λ�ǣ��Ƕ�
% ant_fy������������ϵ�еĸ����ǣ��Ƕ�
% 
% sta_fw��վ������ϵ�ķ�λ�ǣ��Ƕ�
% sta_fy��վ������ϵ�ĸ����ǣ��Ƕ�

H_value = sqrt(H*H');
x1 = [H_value*cosd(fw)*cosd(fy);H_value*sind(fw)*cosd(fy);H_value*sind(fy)];
x2 = H';
A = (x1*x2')*(x2*x2')^(-1);
beta = acosd(H_value*sind(fy)/sqrt(H(1:2)*H(1:2)')) + atand(H(1)/H(3));
alph = acosd(H_value*cosd(fy)*sind(fw)/sqrt((H(1,1)*cosd(beta) - H(1,3)*sind(beta))^2 + H(1,2)^2)) - atand(H(1,3)/(H(1,1)*cosd(beta) - H(1,3)*sind(beta)));
ant = [cosd(ant_fy)*cosd(ant_fw);cosd(ant_fy)*sind(ant_fw);sind(ant_fy)];
sta = A*ant;
sta_fw = atand(sta(2,1)/sta(1,1));
sta_fy = asind(sta(3,1));


end

