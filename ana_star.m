close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% CALCUL AUTOCORRELATION %%%%%%%%%%%%%%%%%%%%
%a=imread('global_25.5N_27.0E_crop.pgm');
%a=imread('global_25.5N_27.0E_crop.jpg');
%b=load('global_25.5N_27.0E_crop_crest.txt');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%a=imread('trans1.jpg');
a=imread('linear_dune.jpg');
a1=im2double(rgb2gray(a));

ll=size(a1);

%b=load('trans1_crest.txt');
b=load('linear_dune_crest.txt');

%b=im2double(rgb2gray(a));
%
%
%
%c=smooth2(b,5);
%d=xcorr2((c-mean(c(:))));
%

s=size(a);
ys=s(1);
xs=s(2);
b=b(find(b(:,2)>3 | b(:,4)>3),:);
b=b(find(b(:,2)<ys-2 | b(:,4)<ys-2),:);
b=b(find(b(:,1)>3 | b(:,3)>3),:);
b=b(find(b(:,1)<xs-2 | b(:,3)<xs-2),:);
%b=b(find(b(:,5)>=3));
lb=length(b);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Download the result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%d=load('autocorrel_2d_crest_crop.txt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure('PaperType','A4','PaperUnits','normalized', ...
'PaperPosition',[0 0 1 1],'PaperOrientation', 'landscape', 'visible','on')
%subplot(211)
imagesc(a)
%colormap gray
%axis xy
hold on
%subplot(212)
for i=1:lb
%plot(b(i,1:2:3),b(i,2:2:4),'b-')
plot(b(i,1:2:3),b(i,2:2:4),'b-','linewidth',1)
%hold on
end
%set(gca,'plotboxaspectratio',[1200 644 1],'xtick',[],'ytick',[])
%subplot(2,2,2)
%imagesc(b)
%set(gca,'plotboxaspectratio',[1200 644 1],'xtick',[],'ytick',[])
%%subplot(2,2,3)
axis image
axis off
print -dpng map_line_auto_linear.png
%print -dpng map_line_auto_trans.png

figure('PaperType','A4','PaperUnits','normalized', ...
'PaperPosition',[0 0 1 1],'PaperOrientation', 'landscape', 'visible','on')
pcolor(flipud(a1))
shading interp
view(0,90)
hold on
for i=1:lb
plot(b(i,1:2:3),ll(1)-b(i,2:2:4),'b-')
%plot(b(i,1),ll(1)-b(i,2),'r')
%hold on
end

%ang1=atan((b(:,4)-b(:,2))./(b(:,3)-b(:,1)));
ang1=atan2(b(:,2)-b(:,4),b(:,3)-b(:,1));

ang=ang1;
ang(find(ang1<0))=pi+ang1(find(ang1<0));
anga=ang*180/pi;
%anga(find(anga>=120))=[];

lon=sqrt((b(:,4)-b(:,2)).^2+(b(:,3)-b(:,1)).^2);

figure('PaperType','A4','PaperUnits','normalized', ...
'PaperPosition',[0 0 1 1],'PaperOrientation', 'landscape', 'visible','on')
%hist(ang*180/pi,180)
hist(anga)

ref=[0:1:180];
ll=length(ref);

bb=[];

for ii=1:ll
%fa=find(round(ang*180/pi)==ref(ii));
fa=find(round(anga)==ref(ii));
qa(ii,1)=ref(ii);
qa(ii,2)=length(fa);
qa(ii,3)=sum(lon(fa));
if qa(ii,2)~=0
bb=[bb;ones(floor(10000*qa(ii,3)./sum(lon)),1)*qa(ii,1);ones(floor(10000*qa(ii,3)./sum(lon)),1)*(qa(ii,1)+180)];
end
end


figure('PaperType','A4','PaperUnits','normalized',...
'PaperPosition',[0 0 1 1],'PaperOrientation','portrait');
%all_wind_rose(bb,ones(length(bb),1),'n',32,'legtype',0,'ci',[2 5 8]);
all_wind_rose(bb,ones(length(bb),1),'n',32,'legtype',0,'ci',[5 15 25]);
set(gca,'color','none')

print -dpdf linear_dune_crest.pdf
%print -dpdf trans_dune_crest.pdf

% The mean orientation using an offset and without weighted average

shi=140;

fprintf('\n ----------------------------------------------------------\n')
fprintf('\n The mean orientation without weighted average = %8.5f degree \n',...
mod(mean(mod(ang*180/pi-shi,180))+shi,180))
fprintf('\n ----------------------------------------------------------\n\n')

% The mean orientation using a weighted average

mo=mod(sum(mod(ang*180/pi-shi,180).*lon)/sum(lon)+shi,180);

fprintf('\n ----------------------------------------------------------\n')
fprintf('\n The mean orientation with weighted average = %8.5f degree \n',mo)
fprintf('\n ----------------------------------------------------------\n\n')

ang1=abs(mod(ang*180/pi-mo,180));
ii=find(ang1>90);
ang1(ii)=180-ang1(ii);

st=sqrt(sum(ang1.^2.*lon)/sum(lon));
fprintf('\n ----------------------------------------------------------\n')
fprintf('\n The standard deviation of dune orientation = %8.5f degree \n',st)
fprintf('\n ----------------------------------------------------------\n\n')


