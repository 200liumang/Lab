function outputArg1 = greeting2()
%GREETING2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
outputArg1 = 'Hellow World from Ser2_situtation3';
simulation_sigframe = load('E:\�������֡2����\Mixframe2_2020_11_12_10_53_58_650_decode.mat');
simulation_sigframe =simulation_sigframe.Struct_data;
Pf =1e-4;
flag_yundong = 0;
for i=1:81
    simulation_sigframe{i} = double(simulation_sigframe{i});
end
[StructDate,UI_printInf,flag_isUsed]=Qin3_computerservice(simulation_sigframe,Pf,flag_yundong);
end

