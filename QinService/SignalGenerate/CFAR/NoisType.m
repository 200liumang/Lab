function flag_noise=NoisType(sample_array,a)
 %%%Ӧ�����龰2���龰3 �ͷ�����ɢ���壬�Ӳ����ͼ��麯��
 %%%sample_array ����������,������ a������������ˮƽ
 %%%flag_noise=1 ����  2��webuill 3��lognormal 4:K�ֲ��� 0������ʧ��
 factor=0.1;   %% ����ˮƽ�½����ӣ���ÿ�μ���ʧ�ܣ� ����ˮƽ�½�����
 while(true)
     flag_noise=Rayleigh_test(sample_array,a);
     if flag_noise==1
         break;
     end
     flag_noise=Weibull_test(sample_array,a);
       if flag_noise==2
         break;
       end
     flag_noise=Lognormal_test(sample_array,a);
       if flag_noise==3
         break;
       end
     flag_noise=K_test(sample_array,a) ;
       if flag_noise==4
         break;
       end
     a=a/factor;
 end