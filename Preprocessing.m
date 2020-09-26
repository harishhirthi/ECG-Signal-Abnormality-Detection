clc;
close all;
clear all;
load('219m.mat');
sig=(val(1,:));
t = 1:length(sig) ;
fs = 360;
t1 = 1*(0:1/fs:(length(sig))/fs);
ecgl = detrend(sig);
ecgl = sgolayfilt(ecgl,7,27);

%wn=0.0001; %lowpass 10Hz for ppg
%[b,a] = butter(5,wn,'high'); 
%ecgl = filter(b,a,ecgl);


%%
     %           Low Pass Filter
b=1/32*[1 0 0 0 0 0 -2 0 0 0 0 0 1];
a=[1 -2 1];
sigL=filter(b,a,sig);

%%
     %           High Pass Filter
b=[-1/32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1/32];
a=[1 -1];
sigH=filter(b,a,sigL);
%ecgl = sigH;
%ecgl = sig;

%Detecting R_wave
[R1,locs_Rwave] = findpeaks(ecgl,'MinPeakHeight',100,'MinPeakDistance',100);

maxIndices = t1(locs_Rwave);
msPerBeat = mean(diff(maxIndices));
heartRate = 60*(1/msPerBeat)

%Detecting S_wave
for i=1:length(locs_Rwave)
    
pos = locs_Rwave(1,i);

    for j=pos:length(ecgl)
        minofr=ecgl(j);
            if (minofr < ecgl(j+1))
            locs_Swave(i)=j;
            dataofr(i)=minofr;
            break 
            end
      end 
end

%Detecting Q_wave
for i=1:length(locs_Rwave)
    
pos = locs_Rwave(1,i);
j = pos;
    while(j > 1)
        minofr=ecgl(j);
        if (minofr < ecgl(j-1))
            locs_Qwave(i)=j;
            dataofr(i)=minofr;
            break 
        end
        j = j-1;      
    end 
end

fs = 360;
duration_sec = length(sig) / fs;
duration_min = duration_sec / 60;
bpm = length(locs_Rwave) / duration_min;


 last = length(R1);
 Ratio1 = locs_Rwave(last - 3) / locs_Rwave(last - 2);
 Ratio2 = locs_Rwave(last - 1) / locs_Rwave(last - 2);
 RRm = [locs_Rwave(last - 3), locs_Rwave(last - 2), locs_Rwave(last - 1)]; 
 RRm = mean(RRm);
 Ratio3 = RRm / locs_Rwave(last - 2);
 
 avg_R = mean(R1) * 0.001;
 avg_Q = abs(mean(ecgl(locs_Qwave))) * 0.001;
 avg_S = abs(mean(ecgl(locs_Swave))) * 0.001;
 avg_riseTime = mean((locs_Rwave)-(locs_Qwave)) * (10000 / 3600); % Average Rise time
 avg_fallTime = mean((locs_Swave)-(locs_Rwave)) * (10000 / 3600); % Average Fall time
 avg_riseLevel = mean(R1-ecgl(locs_Qwave));  % Average Rise Level
 avg_fallLevel = mean(R1-ecgl(locs_Swave));  % Average Fall Leve
 
% final1 = [avg_R avg_Q avg_S avg_riseTime  avg_fallTime avg_riseLevel avg_fallLevel Ratio1 Ratio2 Ratio3 heartRate];
% dlmwrite('final_new.csv',final1,'-append');


figure
subplot(2,1,1);
plot(sig);
xlabel('Samples')
ylabel('Amplitude(mv)')
title('Original Signal')
grid on
subplot(2,1,2);
plot(ecgl);
xlabel('Samples')
ylabel('Amplitude(mv)')
title('Filtered Signal')
grid on
figure
hold on 
plot(t,ecgl)
plot(locs_Rwave,ecgl(locs_Rwave),'rv','MarkerFaceColor','r')
plot(locs_Swave,ecgl(locs_Swave),'rs','MarkerFaceColor','b')
plot(locs_Qwave,ecgl(locs_Qwave),'rs','MarkerFaceColor','g')
legend('ECG', 'R', 'S', 'Q')
xlabel('Samples')
ylabel('Amplitude(mv)')
title('QRS Complex Detection')
%axis([0 4000 -550 600])
grid on


