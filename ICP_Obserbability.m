close all
clear all

%% Load normal map
load nmap

% Generate equally divided sphere
[latGridInDegrees, longGridInDegrees] = GridSphere(2000) ;
% z = sin(latGridInDegrees/180*pi)
% x = cos(latGridInDegrees/180*pi).*cos(longGridInDegrees/180*pi)
% y = cos(latGridInDegrees/180*pi).*sin(longGridInDegrees/180*pi)
[x y z]=sph2cart(longGridInDegrees/180*pi,latGridInDegrees/180*pi,ones(length(longGridInDegrees),1));

pn=length(longGridInDegrees);
sloc = [x y z];
cnt(pn) = 0;

%% Quantize the input normal vectors into the grid
nmap3=reshape(nmap,[427*561,3]);
nmap3n(427*561,3)=0;
for i=1:length(nmap3)
    tp = nmap3(i,:);
    nmap3n(i,:) =tp; 
    if norm(tp)>0.1
        
        % Find the nearest grid and count
        diff_loc=sloc-[tp(1)*ones(pn,1) tp(2)*ones(pn,1) tp(3)*ones(pn,1)];
        sdiff_loc=diff_loc.^2;
        sumsdiff=sum(sdiff_loc')';
        dist_min_index=find(sumsdiff==min(sumsdiff));

        cnt(dist_min_index)=cnt(dist_min_index)+1;
    else
    end
end

% Visualize the result on a unit sphere

%cnt = log(log(log(cnt+1.5)+1.1)+1.1);
%cnt = log(log(cnt+1.5)+1.1);
cnt = log(cnt+1.5);


cntfmax = max(cnt);
plot(cnt);

figure
plot3(nmap3(:,1),nmap3(:,2),nmap3(:,3),'y.');
hold on
grid on
map = cool(100);
%map = colorcube(100);

% Draw the unit sphere with color
for i = 1: pn/1.5
    colindex = int16((cnt(i)/cntfmax)*100);
    if colindex==0
        colindex=1;
    end
    plot3(x(i),y(i),z(i),'o','Color',map(colindex,:))
end

