function du=trans360(xyz,du)
%%%%�龰һ��������ͨ�� ���ڽ��нǶ�ת��
%%%%s_xyz  ĳ��ɢ����Ŀռ����� ������
%%%%index_Rd ��������

if du<0 && xyz(1)>0
    du=du+360;
elseif du<0 && xyz(1)<0
    du=du+180;
elseif du>0 && xyz(1)<0
    du=du+180;
end