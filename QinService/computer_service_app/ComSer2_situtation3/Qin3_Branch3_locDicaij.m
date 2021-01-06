function [Loc_xyz,Index]=Qin3_Branch3_locDicaij(S_xyz,S_ref,S_varray,S_vref,fd_array,doa_ref,f_array,Ts)
 %%%�龰3 �ͷ�����ɢ���嵫��⵽ɢ���壬Q>1 T>1 ��֮3 �Ͳ�
 %%%fd_array Ƶ����� �д���������ݣ�����ɢ�����ǵ��� n*3
 %%%S_ref �ο���ɢ����  S_vref �ο�ɢ�����ٶ�  Qs:��Ч��ɢ��������
 %%%s_xyz�� ɢ��������: ������  S_varray: ������  f_array�Ǹ���ɢ���崦��Ƶ��
 %%%Loc_xyz ���� ������������
 
 %%%���ó�ʼ����
 c=3e8;

 X1=zeros(3,1);         %%%���ó�ʼ����Ŀ������
 dis=20;               %%%���ó�ʼOT���߳���
 G=zeros(3,1);         %%%��ʼG
 fdoa_size=size(fd_array);
 Loc_xyz=zeros(3,200);
 Index=zeros(1,200);  index=0; v=1;

 
 if (doa_ref(1)>=0 &&doa_ref(1)<=90) || (doa_ref(1)>=270 &&doa_ref(1)<=360)   %%%��ʼXֵ
     X1(1)=dis/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
     X1(2)=(dis*tan(doa_ref(1)*pi/180))/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
 else
     X1(1)=-dis/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
     X1(2)=-(dis*tan(doa_ref(1)*pi/180))/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
 end
     X1(3)=(dis*tan(doa_ref(2)*pi/180))/sqrt((1+tan(doa_ref(2)*pi/180)^2));
  
  if (Ts-1)==1
    s_xyz=zeros(3,1);
    s_varray=zeros(3,1);
    count=0;    I=diag([1,1,1]);
    for i=1:fdoa_size(1)
    X=X1;  detaX=6;
    s1_index=fd_array(i,4);

    s_xyz(:,1)=S_xyz(:,s1_index);
    s_varray(:,1)=S_varray(:,s1_index); 
     d1=sqrt(s_xyz(:,1)'*s_xyz(:,1));
     d_ref=sqrt(S_ref(:,1)'*S_ref(:,1));
     lamda1=c/f_array(s1_index);


      %%%%����λ�����%%%%
    for n=1:20
        X_s1_dis=(X-s_xyz(:,1))'*(X-s_xyz(:,1));
        X_sref_dis=(X-S_ref(:,1))'*(X-S_ref(:,1));
        %X_dis=X'*X;
        Lst=sqrt(X_s1_dis);
        Lst_ref=sqrt(X_sref_dis);
        
        g_ref=((X-S_ref(:,1))'*S_vref(:,1)/Lst_ref-S_ref(:,1)'*S_vref(:,1)/d_ref)/lamda1;
        g_1=((X-s_xyz(:,1))'*s_varray(:,1)/Lst-s_xyz(:,1)'*s_varray(:,1)/d1)/lamda1;
        G(1)=g_ref-g_1-fd_array(i,1); %%%����G
     
        Afx_ref=(S_vref(1,1)*Lst_ref^2-(X(1)-S_ref(1,1))*(X-S_ref(:,1))'*S_vref(:,1))/(lamda1*Lst_ref^3);
        Afy_ref=(S_vref(2,1)*Lst_ref^2-(X(2)-S_ref(2,1))*(X-S_ref(:,1))'*S_vref(:,1))/(lamda1*Lst_ref^3);
        Afz_ref=(S_vref(3,1)*Lst_ref^2-(X(3)-S_ref(3,1))*(X-S_ref(:,1))'*S_vref(:,1))/(lamda1*Lst_ref^3);
        
        Afx1=(s_varray(1,1)*Lst^2-(X(1)-s_xyz(1,1))*(X-s_xyz(:,1))'*s_varray(:,1))/(lamda1*Lst^3);
        Afy1=(s_varray(2,1)*Lst^2-(X(2)-s_xyz(2,1))*(X-s_xyz(:,1))'*s_varray(:,1))/(lamda1*Lst^3);
        Afz1=(s_varray(3,1)*Lst^2-(X(3)-s_xyz(3,1))*(X-s_xyz(:,1))'*s_varray(:,1))/(lamda1*Lst^3);
       
        A=[Afx_ref-Afx1,Afy_ref-Afy1,Afz_ref-Afz1;
           ];                %%%����X
        An=(A'*A);
    %%%%��������ϵ��lamda%%%
        if n<=1
             Max=max(An); ajj=Max(1);
             lamda=5*ajj;
        end
        X_pre=X; detaX_pre=detaX;                  %%��¼��һ��X_pre
        detaX=(An+lamda*I)\(-A'*G);
        X=X+detaX;     %%ͨ����С�����㷨���Xn+1  �����G�൱��f ������
        %%%%������С���˵���������Q����
        G_pre=G; F=0.5*(G_pre'*G_pre);
        g_ref=((X-S_ref(:,1))'*S_vref(:,1)/Lst_ref-S_ref(:,1)'*S_vref(:,1)/d_ref)/lamda1;
        g_1=((X-s_xyz(:,1))'*s_varray(:,1)/Lst-s_xyz(:,1)'*s_varray(:,1)/d1)/lamda1;
        G(1)=g_ref-g_1-fd_array(i,1); %%%����G
        F_2=0.5*(G'*G);  
        L_cha=0.5*detaX'*(lamda*detaX-A'*G);
        Q=(F-F_2)/L_cha;
      if(Q>0)
          lamda=max([1/3,1-(2*Q-1)^3]);
          v=2;
      else
          X=X_pre; detaX=detaX_pre;
          lamda=lamda*v;   v=2*v;
      end
        detax=sqrt(detaX'*detaX);
        if detax<=5.2
            if (doa_ref(2)>=0 && X(3)>=0) || (doa_ref(2)<0 && X(3)<0)
                count=count+1;
                Index(index+1)=i;  index=index+1;
                Loc_xyz(:,count)=X;
                break;
            end
        end
    end
    end
 end   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if (Ts-1)==2
    s_xyz=zeros(3,2);
    s_varray=zeros(3,2);
    count=0;    I=diag([1,1,1]);
    for i=1:fdoa_size(1)
    X=X1;  detaX=6;
    s1_index=fd_array(i,4);
    s2_index=fd_array(i,5);

    s_xyz(:,1)=S_xyz(:,s1_index);s_xyz(:,2)=S_xyz(:,s2_index);
    s_varray(:,1)=S_varray(:,s1_index); s_varray(:,2)=S_varray(:,s2_index); 
     d1=sqrt(s_xyz(:,1)'*s_xyz(:,1));
     d2=sqrt(s_xyz(:,2)'*s_xyz(:,2));
     d_ref=sqrt(S_ref(:,1)'*S_ref(:,1));
     lamda1=c/f_array(s1_index);
     lamda2=c/f_array(s2_index);

      %%%%����λ�����%%%%
    for n=1:20
        X_s1_dis=(X-s_xyz(:,1))'*(X-s_xyz(:,1));
        X_s2_dis=(X-s_xyz(:,2))'*(X-s_xyz(:,2));
        X_sref_dis=(X-S_ref(:,1))'*(X-S_ref(:,1));
        %X_dis=X'*X;
        Lst=sqrt(X_s1_dis);
        Lst2=sqrt(X_s2_dis);
        Lst_ref=sqrt(X_sref_dis);
        
        g_ref=((X-S_ref(:,1))'*S_vref(:,1)/Lst_ref-S_ref(:,1)'*S_vref(:,1)/d_ref)/lamda1;
        g_1=((X-s_xyz(:,1))'*s_varray(:,1)/Lst-s_xyz(:,1)'*s_varray(:,1)/d1)/lamda1;
        g_2=((X-s_xyz(:,2))'*s_varray(:,2)/Lst2-s_xyz(:,2)'*s_varray(:,2)/d2)/lamda2;
        G(1)=g_ref-g_1-fd_array(i,1); %%%����G
        G(2)=g_ref-g_2-fd_array(i,2);

        
        Afx_ref=(S_vref(1,1)*Lst_ref^2-(X(1)-S_ref(1,1))*(X-S_ref(:,1))'*S_vref(:,1))/(lamda1*Lst_ref^3);
        Afy_ref=(S_vref(2,1)*Lst_ref^2-(X(2)-S_ref(2,1))*(X-S_ref(:,1))'*S_vref(:,1))/(lamda1*Lst_ref^3);
        Afz_ref=(S_vref(3,1)*Lst_ref^2-(X(3)-S_ref(3,1))*(X-S_ref(:,1))'*S_vref(:,1))/(lamda1*Lst_ref^3);
        
        Afx1=(s_varray(1,1)*Lst^2-(X(1)-s_xyz(1,1))*(X-s_xyz(:,1))'*s_varray(:,1))/(lamda1*Lst^3);
        Afy1=(s_varray(2,1)*Lst^2-(X(2)-s_xyz(2,1))*(X-s_xyz(:,1))'*s_varray(:,1))/(lamda1*Lst^3);
        Afz1=(s_varray(3,1)*Lst^2-(X(3)-s_xyz(3,1))*(X-s_xyz(:,1))'*s_varray(:,1))/(lamda1*Lst^3);
        
        Afx2=(s_varray(1,2)*Lst2^2-(X(1)-s_xyz(1,2))*(X-s_xyz(:,2))'*s_varray(:,2))/(lamda2*Lst2^3);
        Afy2=(s_varray(2,2)*Lst2^2-(X(2)-s_xyz(2,2))*(X-s_xyz(:,2))'*s_varray(:,2))/(lamda2*Lst2^3);
        Afz2=(s_varray(3,2)*Lst2^2-(X(3)-s_xyz(3,2))*(X-s_xyz(:,2))'*s_varray(:,2))/(lamda2*Lst2^3);

        A=[Afx_ref-Afx1,Afy_ref-Afy1,Afz_ref-Afz1;
            Afx_ref-Afx2,Afy_ref-Afy2,Afz_ref-Afz2;
           ];                %%%����X
        An=(A'*A);
    %%%%��������ϵ��lamda%%%
        if n<=1
             Max=max(An); ajj=Max(1);
             lamda=5*ajj;
        end
        X_pre=X; detaX_pre=detaX;                  %%��¼��һ��X_pre
        detaX=(An+lamda*I)\(-A'*G);
        X=X+detaX;     %%ͨ����С�����㷨���Xn+1  �����G�൱��f ������
        %%%%������С���˵���������Q����
        G_pre=G; F=0.5*(G_pre'*G_pre);
        g_ref=((X-S_ref(:,1))'*S_vref(:,1)/Lst_ref-S_ref(:,1)'*S_vref(:,1)/d_ref)/lamda1;
        g_1=((X-s_xyz(:,1))'*s_varray(:,1)/Lst-s_xyz(:,1)'*s_varray(:,1)/d1)/lamda1;
        g_2=((X-s_xyz(:,2))'*s_varray(:,2)/Lst2-s_xyz(:,2)'*s_varray(:,2)/d2)/lamda2;
        G(1)=g_ref-g_1-fd_array(i,1); %%%����G
        G(2)=g_ref-g_2-fd_array(i,2);
        
        F_2=0.5*(G'*G);   L_cha=0.5*detaX'*(lamda*detaX-A'*G);
        Q=(F-F_2)/L_cha;
      if(Q>0)
          lamda=lamda*max([1/3,1-(2*Q-1)^3]);
          v=2;
      else
          X=X_pre; detaX=detaX_pre;
          lamda=lamda*v;   v=2*v;
      end
        %detax=sqrt(detaX'*detaX);
        if F_2<=1.2
            if (doa_ref(2)>=0 && X(3)>=0) || (doa_ref(2)<0 && X(3)<0)
                count=count+1;
                Index(index+1)=i;  index=index+1;
                Loc_xyz(:,count)=X;
                break;
            end
        end
    end
    end
end

if (Ts-1)==3
    s_xyz=zeros(3,3);
    s_varray=zeros(3,3);
    count=0;    I=diag([1,1,1]);
    for i=1:fdoa_size(1)
    X=X1;  detaX=6;
    s1_index=fd_array(i,4);
    s2_index=fd_array(i,5);
    s3_index=fd_array(i,6);
    s_xyz(:,1)=S_xyz(:,s1_index);s_xyz(:,2)=S_xyz(:,s2_index);s_xyz(:,3)=S_xyz(:,s3_index);
    s_varray(:,1)=S_varray(:,s1_index); s_varray(:,2)=S_varray(:,s2_index); s_varray(:,3)=S_varray(:,s3_index);
     d1=sqrt(s_xyz(:,1)'*s_xyz(:,1));
     d2=sqrt(s_xyz(:,2)'*s_xyz(:,2));
     d3=sqrt(s_xyz(:,3)'*s_xyz(:,3));
     d_ref=sqrt(S_ref(:,1)'*S_ref(:,1));
     lamda1=c/f_array(s1_index);
     lamda2=c/f_array(s2_index);
     lamda3=c/f_array(s3_index);
      %%%%����λ�����%%%%
    for n=1:20
        X_s1_dis=(X-s_xyz(:,1))'*(X-s_xyz(:,1));
        X_s2_dis=(X-s_xyz(:,2))'*(X-s_xyz(:,2));
        X_s3_dis=(X-s_xyz(:,3))'*(X-s_xyz(:,3));
        X_sref_dis=(X-S_ref(:,1))'*(X-S_ref(:,1));
     
        Lst=sqrt(X_s1_dis);
        Lst2=sqrt(X_s2_dis);
        Lst3=sqrt(X_s3_dis);
        Lst_ref=sqrt(X_sref_dis);
        
        g_ref=((X-S_ref(:,1))'*S_vref(:,1)/Lst_ref-S_ref(:,1)'*S_vref(:,1)/d_ref)/lamda1;
        g_1=((X-s_xyz(:,1))'*s_varray(:,1)/Lst-s_xyz(:,1)'*s_varray(:,1)/d1)/lamda1;
        g_2=((X-s_xyz(:,2))'*s_varray(:,2)/Lst2-s_xyz(:,2)'*s_varray(:,2)/d2)/lamda2;
        g_3=((X-s_xyz(:,3))'*s_varray(:,3)/Lst3-s_xyz(:,3)'*s_varray(:,3)/d3)/lamda3;
        G(1)=g_ref-g_1-fd_array(i,1); %%%����G
        G(2)=g_ref-g_2-fd_array(i,2);
        G(3)=g_ref-g_3-fd_array(i,3);
        
        Afx_ref=(S_vref(1,1)*Lst_ref^2-(X(1)-S_ref(1,1))*(X-S_ref(:,1))'*S_vref(:,1))/(lamda1*Lst_ref^3);
        Afy_ref=(S_vref(2,1)*Lst_ref^2-(X(2)-S_ref(2,1))*(X-S_ref(:,1))'*S_vref(:,1))/(lamda1*Lst_ref^3);
        Afz_ref=(S_vref(3,1)*Lst_ref^2-(X(3)-S_ref(3,1))*(X-S_ref(:,1))'*S_vref(:,1))/(lamda1*Lst_ref^3);
        
        Afx1=(s_varray(1,1)*Lst^2-(X(1)-s_xyz(1,1))*(X-s_xyz(:,1))'*s_varray(:,1))/(lamda1*Lst^3);
        Afy1=(s_varray(2,1)*Lst^2-(X(2)-s_xyz(2,1))*(X-s_xyz(:,1))'*s_varray(:,1))/(lamda1*Lst^3);
        Afz1=(s_varray(3,1)*Lst^2-(X(3)-s_xyz(3,1))*(X-s_xyz(:,1))'*s_varray(:,1))/(lamda1*Lst^3);
        
        Afx2=(s_varray(1,2)*Lst2^2-(X(1)-s_xyz(1,2))*(X-s_xyz(:,2))'*s_varray(:,2))/(lamda2*Lst2^3);
        Afy2=(s_varray(2,2)*Lst2^2-(X(2)-s_xyz(2,2))*(X-s_xyz(:,2))'*s_varray(:,2))/(lamda2*Lst2^3);
        Afz2=(s_varray(3,2)*Lst2^2-(X(3)-s_xyz(3,2))*(X-s_xyz(:,2))'*s_varray(:,2))/(lamda2*Lst2^3);
        %%%
        Afx3=(s_varray(1,3)*Lst3^2-(X(1)-s_xyz(1,3))*(X-s_xyz(:,3))'*s_varray(:,3))/(lamda3*Lst3^3);
        Afy3=(s_varray(2,3)*Lst3^2-(X(2)-s_xyz(2,3))*(X-s_xyz(:,3))'*s_varray(:,3))/(lamda3*Lst3^3);
        Afz3=(s_varray(3,3)*Lst3^2-(X(3)-s_xyz(3,3))*(X-s_xyz(:,3))'*s_varray(:,3))/(lamda3*Lst3^3);
        A=[Afx_ref-Afx1,Afy_ref-Afy1,Afz_ref-Afz1;
            Afx_ref-Afx2,Afy_ref-Afy2,Afz_ref-Afz2;
             Afx_ref-Afx3,Afy_ref-Afy3,Afz_ref-Afz3;
           ];                %%%����X
        An=(A'*A);
    %%%%��������ϵ��lamda%%%
        if n<=1
             Max=max(An); ajj=Max(1);
             lamda=5*ajj;
        end
        X_pre=X; detaX_pre=detaX;                  %%��¼��һ��X_pre
        detaX=(An+lamda*I)\(-A'*G);
        X=X+detaX;     %%ͨ����С�����㷨���Xn+1  �����G�൱��f ������
        %%%%������С���˵���������Q����
        G_pre=G; F=0.5*(G_pre'*G_pre);
        g_ref=((X-S_ref(:,1))'*S_vref(:,1)/Lst_ref-S_ref(:,1)'*S_vref(:,1)/d_ref)/lamda1;
        g_1=((X-s_xyz(:,1))'*s_varray(:,1)/Lst-s_xyz(:,1)'*s_varray(:,1)/d1)/lamda1;
        g_2=((X-s_xyz(:,2))'*s_varray(:,2)/Lst2-s_xyz(:,2)'*s_varray(:,2)/d2)/lamda2;
        g_3=((X-s_xyz(:,3))'*s_varray(:,3)/Lst3-s_xyz(:,3)'*s_varray(:,3)/d3)/lamda3;
        G(1)=g_ref-g_1-fd_array(i,1); %%%����G
        G(2)=g_ref-g_2-fd_array(i,2);
        G(3)=g_ref-g_3-fd_array(i,3);
        
        F_2=0.5*(G'*G);   L_cha=0.5*detaX'*(lamda*detaX-A'*G);
        Q=(F-F_2)/L_cha;
      if(Q>0)
          lamda=max([1/3,1-(2*Q-1)^3]);
          v=2;
      else
          X=X_pre; detaX=detaX_pre;
          lamda=lamda*v;   v=2*v;
      end
        %detax=sqrt(detaX'*detaX);
        if F_2<=1.2
            if (doa_ref(2)>=0 && X(3)>=0) || (doa_ref(2)<0 && X(3)<0)
                count=count+1;
                Index(index+1)=i;  index=index+1;
                Loc_xyz(:,count)=X;
                break;
            end
        end
    end
    end
end

Loc_xyz(:,all(Loc_xyz==0,1))=[];     %%�������
if size(Loc_xyz,2)<1
    Loc_xyz = -1;
end
Index(:,all(Index==0,1))=[];     %%�������