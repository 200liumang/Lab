function is=isvaild_n(station_xyz,ref_xyz)
% �龰һδʩ������ɢ�����˲ʱ��λ�㼣����_��n����Чվλʵʱ�ж�
% station_xyz����վλ�ռ����꣬�������ͣ���ǰվλ����
%ref_xyz ��ǰ��n������µĲο�վ
% ��Ч�ж�ԭ�򣺵�ǰվ����һվ������������20m ���ж�Ϊ��Ч is=0��Ч is=1 ��Ч

    pre=station_xyz-ref_xyz;
    dis=sqrt(pre'*pre);     %
    if dis>=20
        is=1;
    else
        is=0;
    end
end