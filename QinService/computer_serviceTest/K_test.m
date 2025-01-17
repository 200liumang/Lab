function flag_noise=K_test(sample_array,a)
 %%%应用于情景2、情景3 释放升空散射体，K分布杂波类型检验
 %%%sample_array 是样本矩阵,行数据 a是置信显著性水平
 %%%flag_noise=4 证明检验成功， 0：检验失败
 shape=size(sample_array);               %%获取纬度度
 m2_pre=sample_array.^2;
 m2=sum(m2_pre)/shape(2);
 m4_pre=sample_array.^4;
 m4=sum(m4_pre)/shape(2);
 v=(m4/(2*m2^2)-1)\1;
 c=2*sqrt(v/m2);
 gam=gamma(v);
 bess2=bessely(v,c*sample_array);
 com=(sample_array*c/2).^v;
 u=1-(bess2.*com)*2/gam;
 sample_2=norminv(u,0,1);                %%带入到分布函数的反函数中
 
 %%%计算偏度
 m_1=sum(sample_2)/shape(2);
 m_2pre=(sample_2-m_1).^2;
 m_2=sum(m_2pre)/shape(2);
 m_3pre=(sample_2-m_1).^3;
 m_3=sum(m_3pre)/shape(2);
 beta=(m_3-3*m_2*m_1+2*m_1^3)/(m_2-m_1)^(2/3);   %%偏度值
 
sigma2_2=6*(shape(2)-2)/((shape(2)+1)*(shape(2)+3));
u_new=beta/sqrt(sigma2_2);
z=abs(norminv(a/2,0,1));
if abs(u_new)>=z
    flag_noise=0;
else
    flag_noise=4;
end