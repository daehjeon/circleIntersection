function [ret] = getIntersectionPoints (circles)
    ret = [];
    for i=1:(length(circles))
        for j=i+1:(length(circles))
            intersect = circleCircleIntersection(circles(i), circles(j));
            for k=1:(length(intersect))
                p = intersect(k);
                p.parentIndex = [i,j];
                ret = [ret, p];
            end
        end    
    end   