%% ���ļ����������������½�
%% ���ֳ���������� ��ֵ��Χ��̫����Ԥ��

clc;clear;close all;

f0 = 77e6; % Ƶ��
c = 3e8; % ����
lambda = c / f0; % ����
d = 0.5 * lambda; % ��Ԫ���

M = 8; % ��Ԫ��Ŀ
P = 5; % �ź�Դ��Ŀ
thetas = [-30 5 10 30 50]; % �ź�Դ����
u = [5 15 25 35 45]'; % ��Ƶб��

a = [0 : M-1]'; % ��Ԫ���
snr_set = 0:30; % �����
snap = 100; % ������
fs = 1000; % ����Ƶ��
t = 1 / fs * (0:snap-1);  % ʱ��
s = exp(-1j * 2 * pi * (repmat(f0*t, P, 1) + 1 / 2 * u(1:P) * t .^ 2)); % �����ź�

atheta = exp(-1j * a * 2 * pi * d / lambda * sind(thetas(1:P))); % ����ʸ��
dtheta = zeros(M, P); % ����ʸ����
for i = 1 :length(thetas)
    dtheta(:, i) = -1j * 2 * pi * cosd(thetas(i)) * diag(a) * exp(-1j * a * 2 * pi * d / lambda * sind(thetas(i))); % ����
end

crbMatrix = zeros(1, length(snr_set));
for j = 1 : length(snr_set)
   snr = snr_set(j); % �����
   X0 = atheta * s; % �ز��ź�
   X = awgn(X0, snr, 'measured'); % ���������ź�
   
   sigma2 = X * X' / snap - X0 * X0' / snap;
   sigma2 = trace(sigma2)/M;
   
   H = dtheta(:,1:P)' * (eye(M) - atheta * (atheta' * atheta)^(-1) * atheta') * dtheta(:,1:P);

   out = 0;
   for snap_id = 1 : snap
       out = out + real(diag(s(:, snap_id))' * H * diag(s(:, snap_id)));
   end
   CRB = out^(-1) / 2 * sigma2;
   crbMatrix(j) = sum(diag(CRB));
end
plot(snr_set, crbMatrix);
xlabel('\fontname{Times New Roman}SNR(dB)');ylabel('\fontname{Times New Roman}CRB');

