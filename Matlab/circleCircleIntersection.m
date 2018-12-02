function [data] = circleCircleIntersection (p1, p2)
    d = sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
    r1 = p1.radius
    r2 = p2.radius
    data = []
    
    %if to far away, or self contained - can't be done
    if ((d >= (r1 + r2)) || (d <= abs(r1 - r2)))
        return
    end
    
    a = (r1 * r1 - r2 * r2 + d * d) / (2 * d)
    h = sqrt(r1 * r1 - a * a)
    x0 = p1.x + a * (p2.x - p1.x) / d
    y0 = p1.y + a * (p2.y - p1.y) / d
    rx = -(p2.y - p1.y) * (h / d)
    ry = -(p2.x - p1.x) * (h / d)

    data = [struct('x',x0 + rx,'y',y0 - ry), 
        struct('x',x0 - rx,'y',y0 + ry)]