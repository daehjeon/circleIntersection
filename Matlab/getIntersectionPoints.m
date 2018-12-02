function [ret] = getIntersectionPoints (circles)
    ret = [];
    for i=1:(circles.length)
        for j=i+1:(circles.length)
            intersect = circleCircleIntersection(circles(i), circles(j));
            for k=1:(intersect.length)
                p = intersect(k);
                p.parentIndex = [i,j];
                ret = [rect, p];
            end
        end    
    end   