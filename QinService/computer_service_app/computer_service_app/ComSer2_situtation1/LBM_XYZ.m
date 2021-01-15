function station_xyz=LBM_XYZ(coordinate_LBH,cen_state)
% �龰һδʩ������ɢ�����˲ʱ��λ�㼣����_UCA�������תȫ�ֱ�׼վ��
% coordinate_LBH����վλ��γ�����꣬�������ͣ�����
% cen_state �ο�վ�� L0_B0_H0 1*3ά
% �д������վλ��γ��,��λ�ǻ���

shape=size(coordinate_LBH); %��ȡ����ά����shape(2)��¼����
L0=cen_state(1); B0=cen_state(2); H0=cen_state(3); 
R=6372566;  %����뾶
station_xyz=zeros(shape(1),shape(2));
for col=1:shape(2)
    LBH=coordinate_LBH(:,col);
    station_xyz(1,col)=(R+LBH(3))*cos(LBH(2))*sin(LBH(1)-L0);
    station_xyz(2,col)=(R+LBH(3))*sin(LBH(2))*cos(B0)-(R+LBH(3))*cos(LBH(2))*sin(B0)*cos(LBH(1)-L0);
    station_xyz(3,col)=(R+LBH(3))*cos(LBH(2))*cos(B0)*cos(LBH(1)-L0)+(R+LBH(3))*sin(LBH(2))*sin(B0)-R-H0;
end
