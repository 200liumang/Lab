function [Loc_xyz,Index]=S1S2S3S4_loc_Gaocai(s_xyz,tao_array,doa_ref)
 %%%�龰2 �ͷ�����ɢ���嵫δ��⵽ɢ���壬TDOA-DOA�����ֻ��4��TDOA�Ķ�λ����
 %%%tao_array ʱ����� �д���������ݣ�n*4�� ����ʱ����� 
 %%%������Ͻ����TDOAʱ���Ч�����_tdoa��FDOAʱ���Ч�����_fdoa�������_ref��������_ref
 %%%s_xyz�� ɢ��������: ������
 %%%Loc_xyz ���� ������������
 
 %%%���ó�ʼ����
 c=3e8;
 d1=sqrt(s_xyz(:,1)'*s_xyz(:,1));
 d2=sqrt(s_xyz(:,2)'*s_xyz(:,2));
 d3=sqrt(s_xyz(:,3)'*s_xyz(:,3));
 d4=sqrt(s_xyz(:,4)'*s_xyz(:,4));
 
 X1=zeros(3,1);         %%%���ó�ʼ����Ŀ������
 dis=20;               %%%���ó�ʼOT���߳���
 G=zeros(4,1);         %%%��ʼG
 tdoa_size=size(tao_array);
 Loc_xyz=zeros(3,200);
 Index=zeros(1,200); index=0;
 
 if (doa_ref(1)>=0 &&doa_ref(1)<=90) || (doa_ref(1)>=270 &&doa_ref(1)<=360)
     X1(1)=dis/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
     X1(2)=(dis*tan(doa_ref(1)*pi/180))/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
 else
     X1(1)=-dis/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
     X1(2)=-(dis*tan(doa_ref(1)*pi/180))/sqrt((1+tan(doa_ref(1)*pi/180)^2)*(1+tan(doa_ref(2)*pi/180)^2));
 end
     X1(3)=(dis*tan(doa_ref(2)*pi/180))/sqrt((1+tan(doa_ref(2)*pi/180)^2));

     X1=[60,-50,2.1]';
count=0;   I=diag([1,1,1]);
for i=1:tdoa_size(1)
X=X1; detaX=6; v=1;
  %%%%����λ�����%%%%
for n=1:20
    G(1)=sqrt((X-s_xyz(:,1))'*(X-s_xyz(:,1)))-sqrt(X'*X)+d1-c*tao_array(i,1);    %%%����G
    G(2)=sqrt((X-s_xyz(:,2))'*(X-s_xyz(:,2)))-sqrt(X'*X)+d2-c*tao_array(i,2);
    G(3)=sqrt((X-s_xyz(:,3))'*(X-s_xyz(:,3)))-sqrt(X'*X)+d3-c*tao_array(i,3);
    G(4)=sqrt((X-s_xyz(:,4))'*(X-s_xyz(:,4)))-sqrt(X'*X)+d4-c*tao_array(i,4);
    X_s1_dis=(X-s_xyz(:,1))'*(X-s_xyz(:,1));
    X_s2_dis=(X-s_xyz(:,2))'*(X-s_xyz(:,2));
    X_s3_dis=(X-s_xyz(:,3))'*(X-s_xyz(:,3));
    X_s4_dis=(X-s_xyz(:,4))'*(X-s_xyz(:,4));
    X_dis=X'*X;
    %X_xy=X(1:2)'*X(1:2);
    Lst=sqrt(X_s1_dis);
    Lst2=sqrt(X_s2_dis);
    Lst3=sqrt(X_s3_dis);
    Lst4=sqrt(X_s4_dis);
    Lt=sqrt(X_dis);
    %Ltxy=sqrt(X_xy);
    A=[(X(1)-s_xyz(1,1))/Lst-X(1)/Lt,(X(2)-s_xyz(2,1))/Lst-X(2)/Lt,(X(3)-s_xyz(3,1))/Lst-X(3)/Lt;
        (X(1)-s_xyz(1,2))/Lst2-X(1)/Lt,(X(2)-s_xyz(2,2))/Lst2-X(2)/Lt,(X(3)-s_xyz(3,2))/Lst2-X(3)/Lt;
        (X(1)-s_xyz(1,3))/Lst3-X(1)/Lt,(X(2)-s_xyz(2,3))/Lst3-X(2)/Lt,(X(3)-s_xyz(3,3))/Lst3-X(3)/Lt;
        (X(1)-s_xyz(1,4))/Lst4-X(1)/Lt,(X(2)-s_xyz(2,4))/Lst3-X(2)/Lt,(X(3)-s_xyz(3,4))/Lst4-X(3)/Lt];  %%%����A
    An=(A'*A);    %%%%��������ϵ��lamda%%%
    if n<=1
         Max=max(An); ajj=Max(1);
         lamda=5*ajj;
    end
    X_pre=X; detaX_pre=detaX;                  %%��¼��һ��X_pre
    detaX=(An+lamda*I)\(-A'*G);
    X=X+detaX;     %%ͨ����С�����㷨���Xn+1  �����G�൱��f ������
    %%%%������С���˵���������Q����
    G_pre=G; F=0.5*(G_pre'*G_pre);
    G(1)=sqrt((X-s_xyz(:,1))'*(X-s_xyz(:,1)))-sqrt(X'*X)+d1-c*tao_array(i,1);    %%%����G
    G(2)=sqrt((X-s_xyz(:,2))'*(X-s_xyz(:,2)))-sqrt(X'*X)+d2-c*tao_array(i,2);
    G(3)=sqrt((X-s_xyz(:,3))'*(X-s_xyz(:,3)))-sqrt(X'*X)+d3-c*tao_array(i,3);
    G(4)=sqrt((X-s_xyz(:,4))'*(X-s_xyz(:,4)))-sqrt(X'*X)+d4-c*tao_array(i,4);
    F_2=0.5*(G'*G);   L_cha=0.5*detaX'*(lamda*detaX-A'*G);
    Q=(F-F_2)/L_cha;
  if(Q>0)
      lamda=max([1/3,1-(2*Q-1)^3]);
      v=2;
  else
      X=X_pre; detaX=detaX_pre;
      lamda=lamda*v;   v=2*v;
  end
    detax=sqrt(detaX'*detaX);
   if detax<=2.2
        doa_res=zeros(1,2);
        doa_res(1)=atan(X(2)/X(1))*180/pi;
        doa_res(1)=trans360(X,doa_res(1));    %%�Ƕ�ת��λ0-360
        doa_res(2)=atan(X(3)/sqrt(X(1)^2+X(2)^2))*180/pi;
        ddoa=sqrt((doa_res-doa_ref)*(doa_res-doa_ref)');
        if (doa_ref(2)>=0 && X(3)>=0) || (doa_ref(2)<0 && X(3)<0)
           if ddoa<=7
            count=count+1;
            Index(index+1)=i;   index=index+1;
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