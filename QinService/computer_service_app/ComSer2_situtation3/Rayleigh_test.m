function flag_noise=Rayleigh_test(sample_array,a)
 %%%Ӧ�����龰2���龰3 �ͷ�����ɢ���壬�����Ӳ����ͼ���
 %%%sample_array ����������,������ a������������ˮƽ
 %%%flag_noise=1 ֤������ɹ��� 0������ʧ��
 shape=size(sample_array);               %%��ȡγ��
 N=shape(2);
 sigma=sum(sample_array)/N*sqrt(2/pi);   %%�����ֲ�������� 
 u_pre=(sample_array.^2)./(2*sigma^2);
 u=ones(1,shape(2))-exp(-u_pre);         %%�����ۼƺ���
 sample_2=norminv(u,0,1);                %%���뵽�ֲ������ķ�������
 
 %%%����ƫ��
 m_1=sum(sample_2)/shape(2);
 m_2pre=(sample_2-m_1).^2;
 m_2=sum(m_2pre)/shape(2);
 m_3pre=(sample_2-m_1).^3;
 m_3=sum(m_3pre)/shape(2);
 beta=(m_3-3*m_2*m_1+2*m_1^3)/(m_2-m_1)^(2/3);   %%ƫ��ֵ
 
sigma2_2=6*(shape(2)-2)/((shape(2)+1)*(shape(2)+3));
u_new=beta/sqrt(sigma2_2);
z=abs(norminv(a/2,0,1));
if abs(u_new)>=z
    flag_noise=0;
else
    flag_noise=1;
end