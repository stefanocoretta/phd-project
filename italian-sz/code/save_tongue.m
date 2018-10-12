set(gcf,'Toolbar','figure');

% Then select the surface
t = gco;

X = t.XData;
Y = t.YData;
Z = t.ZData;

data = [X(:), Y(:), Z(:)];
data = data(find(~isnan(data(:,3))),:);
csvwrite('s5.csv', data)