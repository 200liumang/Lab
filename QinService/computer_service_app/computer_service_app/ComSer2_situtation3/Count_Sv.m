function S_vxyz=Count_Sv(S_xyz,vsi_array,fai_array,v_uca)
% �龰2 ʩ������ɢ���� ����ɢ����˲ʱ�ٶ�
% S_xyz����վλ���ռ����꣬�������ͣ�����  �У�����ά
% vsi_array ���ݽ��֡���صĸ���ɢ�����˲ʱ�ٶ�
% fai_array ���ݽ��֡���صĸ���ɢ�����˲ʱ�����   ��λ�Ƕ�

shape=size(S_xyz); %��ȡ����ά����shape(2)��¼����
S_vxyz=zeros(3,shape(2));
for col=1:shape(2)
    S_vxyz(1,col)=vsi_array(col)*sin(fai_array(col)*pi/180)-v_uca(1);
    S_vxyz(2,col)=vsi_array(col)*cos(fai_array(col)*pi/180)-v_uca(2);
    v2_xy=S_vxyz(1,col)^2+S_vxyz(2,col)^2;
    S_vxyz(3,col)=sqrt(vsi_array(col)^2-v2_xy);      %%��Ҫ���ʱ��ſ��Լ����Z�ٶ�
end
