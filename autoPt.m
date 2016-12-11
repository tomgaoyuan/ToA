%data formatting
X = [6:18]';
err10 = rand(length(X),3);
err67 = rand(length(X),3);
err80 = rand(length(X),3);
svar = rand(length(X),3);
PN7 = 500 * rand(length(X), 2);
PN8 = 500 * rand(length(X),3);
PN9 = 500 * rand(length(X),3);
%const 
iGreen = [0 0.5 0];
iBlue =  [0.08 0.17 0.55];
iCyan = [0 0.75 0.75];
%figure
close all
figure('Position',[200 200 800 600]);
subplot(3,1,1)

h1 = plot(X, [ err67 err80]);
set(h1([1 4]),'Color','r');
set(h1([2 5]),'Color',iGreen);
set(h1([3 6]),'Color','b');
set(h1([1 2 3]),'LineStyle','-');
set(h1([1 2 3]),'Marker','o')
set(h1([4 5 6]),'LineStyle','--');
set(h1([4 5 6]),'Marker','d')
AX = axis;
axis([5 19 AX(3) AX(4)]);
hold on;
hLg = plot(repmat([0 1].',1,5));
set(hLg,'Visible','off');
set(hLg(1),'Color','r');
set(hLg(2),'Color',iGreen);
set(hLg(3),'Color','b');
set(hLg([4 5]),'Color','k');
set(hLg(4),'LineStyle','-');
set(hLg(4),'Marker','o')
set(hLg(5),'LineStyle','--');
set(hLg(5),'Marker','d')
legend(hLg,'correlation','two-step','iterative','err@67%','err@80%',...
    'Location', 'northwest', 'Orientation','horizontal');
legend('boxoff');
clear hLg;
xlabel('SINR/dB');
ylabel('T_s','Rotation',0);
grid on

subplot(3,1,2)
h2 = bar(X-0.2,[ PN7(:,2) PN8(:,2) PN9(:,2)], 0.3,'stack');
set(h2(1),'FaceColor',iBlue);
set(h2(2),'FaceColor',iCyan);
set(h2(3),'FaceColor','y')
hold on;
h3 = bar(X+0.2,[ PN7(:,1) PN8(:,1) PN9(:,1)], 0.3,'stack');
set(h3(1),'FaceColor',iBlue);
set(h3(2),'FaceColor',iCyan);
set(h3(3),'FaceColor','y');
set(h3,'EdgeColor','r');
axis([5 19 0 1200]);
hLg=zeros(5,1);
for i=1:5
    hLg(i) = bar(1);
end
set(hLg,'Visible','off');
set(hLg(1),'FaceColor',iBlue);
set(hLg(2),'FaceColor',iCyan);
set(hLg(3),'FaceColor','y');
set(hLg([1 2 3]),'EdgeColor','w');
set(hLg([4 5]),'FaceColor','w');
set(hLg(4),'EdgeColor','k');
set(hLg(5),'EdgeColor','r');
legend(hLg,'7','8','9','two-step','iterative',...
    'Location', 'northwest', 'Orientation','horizontal');
legend('boxoff');
clear hLg;
xlabel('SINR/dB');
grid on

subplot(3,1,3)
h4 = plot(X, svar,'-s');
AX = axis;
axis([5 19 AX(3) AX(4)])
grid on
legend('correlation','two-step','iterative',...
    'Location', 'northwest', 'Orientation','horizontal');
legend('boxoff');
xlabel('SINR/dB');
ylabel('T_s^2','Rotation',0);