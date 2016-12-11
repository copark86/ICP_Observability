close all
clear all

%% Image load and Camera intrinsic
k = [518.857901 0.000000 284.582449; 0.000000 519.469611 208.736166 ;0.000000 0.000000 1.000000 ];
img =imread('NYU0004.png');
[sx sy]=size(img);

%% Depth recover from depth image
xyz(sx,sy,3)=0;
for xx = 1: sx
    for yy = 1:sy
        xyz(xx,yy,:) = double(img(xx,yy))*inv(k)*[xx yy 1]';
    end
end
xyz3=reshape(xyz,[427*561,3]);

display = 0;
plot3(xyz3(:,1),xyz3(:,2),xyz3(:,3),'.');
hold on

%% Normal map calculation

% Distance for calculate vector
diffsize = 10;%unit: pixel
;% subsampling step
subsample = 10
% For display only
vecsize = 10000;
nmap(sx,sy,3)=0;
for xx = 1:subsample: sx-diffsize
    for yy = 1:subsample:sy-diffsize
        % Center
        v00 = xyz(xx,yy,:);
        % Vector 1
        v10 = xyz(xx+diffsize,yy,:);
        % Vector 2
        v01 = xyz(xx,yy+diffsize,:);
        % Cross product
        n = cross(v01-v00,v10-v00);
        % Normalize
        n = n/sqrt(n(1,1,1)^2+n(1,1,2)^2+n(1,1,3)^2);
        nmap(xx,yy,:)=n;
                 
        %         plot3(v00(1,1,1),v00(1,1,2),v00(1,1,3),'o');
        %            hold on
        %            grid on
        %         plot3(v10(1,1,1),v10(1,1,2),v10(1,1,3),'o');
        %         plot3(v01(1,1,1),v01(1,1,2),v01(1,1,3),'o');
        if display==1
                quiver3(v00(1,1,1),v00(1,1,2),v00(1,1,3),n(1,1,1)*vecsize,n(1,1,2)*vecsize,n(1,1,3)*vecsize);
        end
    end
end

xlabel('x')
ylabel('y')
zlabel('z')

save nmap nmap