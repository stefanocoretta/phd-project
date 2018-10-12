set(gcf,'Toolbar','figure');
% Then select the surface
t = gco;
Z = t.ZData;
X = t.XData;
Y = t.YData;
data = [X(:), Y(:), Z(:)];
data = data(find(~isnan(data(:,3))),:);
