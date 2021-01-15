function [Loc_xyz,Index,Tv]=S1S2S3S4_loc_DicaiD(s_xyz,S_varray,T_v,fd_array,doa_ref,f_array)
 %%%�龰2 �ͷ�����ɢ���嵫δ��⵽ɢ���壬 FDOA-DOA�����ֻ��һ��FDOA�Ķ�λ����  Ŀ���˶� ������4��ɢ����
 %%%fd_array Ƶ����� �д���������ݣ�����ɢ�����ǵ��� n*4
 %%%������Ͻ����TDOAʱ���Ч�����_tdoa��FDOAʱ���Ч�����_fdoa�������_ref��������_ref
 %%%s_xyz�� ɢ��������: ������  S_varray: ������  f_array�Ǹ���ɢ���崦��Ƶ��  T_v��Ŀ��ɢ�����ٶ�
 %%%Loc_xyz ���� ������������
 
 %%%���ó�ʼ����
 c=3e8;
 d1=sqrt(s_xyz(:,1)'*s_xyz(:,1));
 d2=sqrt(s_xyz(:,2)'*s_xyz(:,2));
 d3=sqrt(s_xyz(:,3)'*s_xyz(:,3));
 d4=sqrt(s_xyz(:,4)'*s_xyz(:,4));
 X1=zeros(6,1);         %%%���ó�ʼ����Ŀ������ Я���ٶ�
 dis=20;               %%%���ó�ʼOT���߳���
 G=zeros(6,1);         %%%��ʼG
 fdoa_size=size(fd_array);
 Loc_xyz=zeros(3,200);
 Tv=zeros(3,200);     count_tv=0;
 Index=zeros(1,200);  index=0;
 
 lamda1=c/f_array(1);
 lamda2=c/f_array(2);
 lamda3=c/f_array(3);
 lamda4=c/f_array(4);  v=1;
 
 if (doa_ref(1)>=0 &&doa_ref(1)<=90) || (doa_ref(1)>=270 &&doa_ref(1)<=360)   %%%��ʼXֵ
     X1(1)=dis/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
     X1(2)=(dis*tan(doa_ref(1)*pi/180))/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
 else
     X1(1)=-dis/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
     X1(2)=-(dis*tan(doa_ref(1)*pi/180))/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
 end
     X1(3)=(dis*tan(doa_ref(2)*pi/180))/sqrt((1+tan(doa_ref(2)*pi/180)^2));

     
count=0;  I=diag([1,1,1,1,1,1]);
for i=1:fdoa_size(1)
X=X1; detaX=6;
  %%%%����λ�����%%%%
for n=1:20
    X_s1_dis=(X(1:3)-s_xyz(:,1))'*(X(1:3)-s_xyz(:,1));
    X_s2_dis=(X(1:3)-s_xyz(:,2))'*(X(1:3)-s_xyz(:,2));
    X_s3_dis=(X(1:3)-s_xyz(:,3))'*(X(1:3)-s_xyz(:,3));
    X_s4_dis=(X(1:3)-s_xyz(:,4))'*(X(1:3)-s_xyz(:,4));
    %X_dis=X'*X;
    X_xy=X(1:2)'*X(1:2);
    Lst=sqrt(X_s1_dis);
    Lst2=sqrt(X_s2_dis);
    Lst3=sqrt(X_s3_dis);
    Lst4=sqrt(X_s4_dis);
    Lt=sqrt(X_dis);
    Ltxy=sqrt(X_xy);
    
    G(1)=((X(1:3)-s_xyz(:,1))'*(S_varray(:,1)-T_v)/Lst-s_xyz(:,1)'*S_varray(:,1)/d1+X(1:3)'*T_v/Lt)/lamda1-fd_array(i,1); %%%����G
    G(2)=((X(1:3)-s_xyz(:,2))'*(S_varray(:,2)-T_v)/Lst2-s_xyz(:,2)'*S_varray(:,2)/d2+X(1:3)'*T_v/Lt)/lamda2-fd_array(i,2);
    G(3)=((X(1:3)-s_xyz(:,3))'*(S_varray(:,3)-T_v)/Lst3-s_xyz(:,3)'*S_varray(:,3)/d3+X(1:3)'*T_v/Lt)/lamda3-fd_array(i,3);
    G(4)=((X(1:3)-s_xyz(:,4))'*(S_varray(:,4)-T_v)/Lst4-s_xyz(:,4)'*S_varray(:,4)/d4+X(1:3)'*T_v/Lt)/lamda4-fd_array(i,4);
    G(5)=X(2)/X(1)-tan(doa_ref(1)*pi/180);
    G(6)=X(3)/sqrt(X(1:2)'*X(1:2))-tan(doa_ref(2)*pi/180);
  
    A1=((S_varray(1,1)-T_v(1))*Lst^2-(X(1)-s_xyz(1,1))*(X(1:3)-s_xyz(:,1))'*(S_varray(:,1)-T_v))/(lamda1*Lst^3)+(T_v(1)*Lt^2-X(1)*X(1:3)'*T_v)/(lamda*Lt^3);
    B1=((S_varray(2,1)-T_v(2))*Lst^2-(X(2)-s_xyz(2,1))*(X(1:3)-s_xyz(:,1))'*(S_varray(:,1)-T_v))/(lamda1*Lst^3)+(T_v(2)*Lt^2-X(2)*X(1:3)'*T_v)/(lamda*Lt^3);
    C1=((S_varray(3,1)-T_v(3))*Lst^2-(X(3)-s_xyz(3,1))*(X(1:3)-s_xyz(:,1))'*(S_varray(:,1)-T_v))/(lamda1*Lst^3)+(T_v(3)*Lt^2-X(3)*X(1:3)'*T_v)/(lamda*Lt^3);
    D1=X(1)/lamda1*Lt-(X(1)-s_xyz(1,1))/(lamda1*Lst);
    E1=X(2)/lamda1*Lt-(X(2)-s_xyz(2,1))/(lamda1*Lst);
    F1=X(3)/lamda1*Lt-(X(3)-s_xyz(3,1))/(lamda1*Lst);
    
    A2=((S_varray(1,2)-T_v(1))*Lst2^2-(X(1)-s_xyz(1,2))*(X(1:3)-s_xyz(:,2))'*(S_varray(:,2)-T_v))/(lamda2*Lst2^3)+(T_v(1)*Lt^2-X(1)*X(1:3)'*T_v)/(lamda2*Lt^3);
    B2=((S_varray(2,2)-T_v(2))*Lst2^2-(X(2)-s_xyz(2,2))*(X(1:3)-s_xyz(:,2))'*(S_varray(:,2)-T_v))/(lamda2*Lst2^3)+(T_v(2)*Lt^2-X(2)*X(1:3)'*T_v)/(lamda2*Lt^3);
    C2=((S_varray(3,2)-T_v(3))*Lst2^2-(X(3)-s_xyz(3,2))*(X(1:3)-s_xyz(:,2))'*(S_varray(:,2)-T_v))/(lamda2*Lst2^3)+(T_v(3)*Lt^2-X(3)*X(1:3)'*T_v)/(lamda2*Lt^3);
    D2=X(1)/lamda2*Lt-(X(1)-s_xyz(1,2))/(lamda2*Lst2);
    E2=X(2)/lamda2*Lt-(X(2)-s_xyz(2,2))/(lamda2*Lst2);
    F2=X(3)/lamda2*Lt-(X(3)-s_xyz(3,2))/(lamda2*Lst2);
    %%%
    A3=((S_varray(1,3)-T_v(1))*Lst3^2-(X(1)-s_xyz(1,3))*(X(1:3)-s_xyz(:,3))'*(S_varray(:,3)-T_v))/(lamda3*Lst3^3)+(T_v(1)*Lt^2-X(1)*X(1:3)'*T_v)/(lamda3*Lt^3);
    B3=((S_varray(2,3)-T_v(2))*Lst3^2-(X(2)-s_xyz(2,3))*(X(1:3)-s_xyz(:,3))'*(S_varray(:,3)-T_v))/(lamda3*Lst3^3)+(T_v(2)*Lt^2-X(2)*X(1:3)'*T_v)/(lamda3*Lt^3);
    C3=((S_varray(3,3)-T_v(3))*Lst3^2-(X(3)-s_xyz(3,3))*(X(1:3)-s_xyz(:,3))'*(S_varray(:,3)-T_v))/(lamda3*Lst3^3)+(T_v(3)*Lt^2-X(3)*X(1:3)'*T_v)/(lamda3*Lt^3);
    D3=X(1)/lamda3*Lt-(X(1)-s_xyz(1,3))/(lamda3*Lst3);
    E3=X(2)/lamda3*Lt-(X(2)-s_xyz(2,3))/(lamda3*Lst3);
    F3=X(3)/lamda3*Lt-(X(3)-s_xyz(3,3))/(lamda3*Lst3);
    %%%
    A4=((S_varray(1,4)-T_v(1))*Lts4^2-(X(1)-s_xyz(1,4))*(X(1:3)-s_xyz(:,4))'*(S_varray(:,4)-T_v))/(lamda4*Lst4^3)+(T_v(1)*Lt^2-X(1)*X(1:3)'*T_v)/(lamda4*Lt^3);
    B4=((S_varray(2,4)-T_v(2))*Lts4^2-(X(2)-s_xyz(2,4))*(X(1:3)-s_xyz(:,4))'*(S_varray(:,4)-T_v))/(lamda4*Lst4^3)+(T_v(2)*Lt^2-X(2)*X(1:3)'*T_v)/(lamda4*Lt^3);
    C4=((S_varray(3,4)-T_v(3))*Lts4^2-(X(3)-s_xyz(3,4))*(X(1:3)-s_xyz(:,4))'*(S_varray(:,4)-T_v))/(lamda4*Lst4^3)+(T_v(3)*Lt^2-X(3)*X(1:3)'*T_v)/(lamda4*Lt^3);
    D4=X(1)/lamda4*Lt-(X(1)-s_xyz(1,4))/(lamda4*Lst4);
    E4=X(2)/lamda4*Lt-(X(2)-s_xyz(2,4))/(lamda4*Lst4);
    F4=X(3)/lamda4*Lt-(X(3)-s_xyz(3,4))/(lamda4*Lst4);
    A=[  A1,B1,C1,D1,E1,F1;
         A2,B2,C2,D2,E2,F2;
         A3,B3,C3,D3,E3,F3;
         A4,B4,C4,D4,E4,F4;
        -X(2)/X(1)^2,1/X(1),0,0,0,0;
         -X(1)*X(3)/Ltxy^3,-X(2)*X(3)/Ltxy^3,1/Ltxy,0,0,0];                %%%����X
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
    G(1)=((X(1:3)-s_xyz(:,1))'*(S_varray(:,1)-T_v)/Lst-s_xyz(:,1)'*S_varray(:,1)/d1+X(1:3)'*T_v/Lt)/lamda1-fd_array(i,1); %%%����G
    G(2)=((X(1:3)-s_xyz(:,2))'*(S_varray(:,2)-T_v)/Lst2-s_xyz(:,2)'*S_varray(:,2)/d2+X(1:3)'*T_v/Lt)/lamda2-fd_array(i,2);
    G(3)=((X(1:3)-s_xyz(:,3))'*(S_varray(:,3)-T_v)/Lst3-s_xyz(:,3)'*S_varray(:,3)/d3+X(1:3)'*T_v/Lt)/lamda3-fd_array(i,3);
    G(4)=((X(1:3)-s_xyz(:,4))'*(S_varray(:,4)-T_v)/Lst4-s_xyz(:,4)'*S_varray(:,4)/d4+X(1:3)'*T_v/Lt)/lamda4-fd_array(i,4);
    G(5)=X(2)/X(1)-tan(doa_ref(1)*pi/180);
    G(6)=X(3)/sqrt(X(1:2)'*X(1:2))-tan(doa_ref(2)*pi/180);
    F_2=0.5*(G'*G);   L_cha=0.5*detaX'*(lamda*detaX-A'*G);
    Q=(F-F_2)/L_cha;
  if(Q>0)
      lamda=max([1/3,1-(2*Q-1)^3]);
      v=2;
  else
      X=X_pre; detaX=detaX_pre;
      lamda=lamda*v;   v=2*v;
  end
    detax=sqrt(detaX(1:3)'*detaX(1:3));
    if detax<=5.2
        if (doa_ref(2)>=0 && X(3)>=0) || (doa_ref(2)<0 && X(3)<0)
            count=count+1;
            count_tv=count_tv+1;
            Loc_xyz(:,count)=X(1:3);   %%%6ά ������ٶ�
            Tv(:,count_tv)=X(4:6);
            Index(index+1)=i;  index=index+1;
            break;
        end
    end
end
end
Loc_xyz(:,all(Loc_xyz==0,1))=[];     %%�������
if size(Loc_xyz,2)<1
    Loc_xyz = -1;
end
Tv(:,all(Tv==0,1))=[];     %%�������
Index(:,all(Index==0,1))=[];     %%�������