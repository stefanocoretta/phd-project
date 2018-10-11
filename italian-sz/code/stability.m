WASL
% Load the DCM and DAT files, figure out the frames of interest
frames = [3:11];

UserData = get(gcf,'UserData');
V = UserData.tongue.V;
V = V(:,:,:,frames);
C = size(V);
meanV = mean(V(:,:,:,:),4);
stdV = std(V(:,:,:,:),1,4);
figure;
subplot(3,2,1);
image(squeeze(V(:,:,round(C(3)/2),1)));
colorbar;
subplot(3,2,2);
image(squeeze(V(round(C(1)/2),:,:,1)));
colorbar;
subplot(3,2,3);
image(squeeze(meanV(:,:,round(C(3)/2))));
colorbar;
subplot(3,2,4);
image(squeeze(meanV(round(C(1)/2),:,:)));
colorbar;
subplot(3,2,5);
image(squeeze(stdV(:,:,round(C(3)/2))));
colorbar;
subplot(3,2,6);
image(squeeze(stdV(round(C(1)/2),:,:)));
colorbar;
mean(stdV(:))
std(stdV(:))
