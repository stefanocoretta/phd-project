% set(gcf,'Toolbar','figure');

% Then select the surface
% t = gco;

% X = t.XData;
% Y = t.YData;
% Z = t.ZData;

X = UserData.trace{1}.surface{10}.x;
Y = UserData.trace{1}.surface{10}.y;
Z = UserData.trace{1}.surface{10}.z;

data = [X(:), Y(:), Z(:)];
data = data(find(~isnan(data(:,3))),:);
csvwrite('20181011121440_10.csv', data)

%%%%% Read traces from cl

x = traces{1}.surface{10}.x;
y = traces{1}.surface{10}.y;
z = traces{1}.surface{10}.z;