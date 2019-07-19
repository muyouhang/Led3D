function ret = dep(data, size_x, size_y)
    x = data(:,1);
    y = data(:,2);
    z = data(:,3);
   
    max_x = max(x);
    min_x = min(x);
    max_y = max(y);
    min_y = min(y);
    min_z = min(z);
    max_z = max(z);
    range_x = max_x - min_x;
    range_y = max_y - min_y;
    ret = zeros(size_x, size_y);
    ret(:,:) = min_z;
    len = size(x, 1);
    min_z = 999;
    for i = 1:len
        X = floor((x(i)- min_x) / range_x * (size_x-1))+1;
        Y = floor((y(i)- min_y) / range_y * (size_y-1))+1;
        ret(X, Y) = max(ret(X, Y), z(i));
        min_z = min(min_z, ret(X, Y));
    end
    range_z = max_z - min_z;
    ret = max(ret, min_z);
    
    ret = round((ret - min_z) / range_z * 255);
end
