function flag_noise=Lognormal_test(sample_array,a)
 %%%Ӧ�����龰2���龰3 �ͷ�����ɢ���壬Lognormal�Ӳ����ͼ��� ������̬�ֲ�
 %%%sample_array ����������,������ a������������ˮƽ
 %%%flag_noise=3 ֤������ɹ��� 0������ʧ��
 shape=size(sample_array);               %%��ȡά��
 ln_sample=log(sample_array);            %%����������
 mu=sum(ln_sample)/shape(2);
 msigma2_pre=(ln_sample-mu).^2/shape(2);
 sample_2=(ln_sample-mu)/sqrt( msigma2_pre);
 
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
    flag_noise=3;
end