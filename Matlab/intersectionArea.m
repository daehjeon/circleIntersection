function [circleArea] = intersectionArea (circles, stats)

intersectionPoints = getIntersectionPoints(circles);  
innerPoints = intersectionPoints.filter(function (p) {
    return circleIntersection.containedInCircles(p, circles);
});

arcArea = 0
polygonArea = 0
arcs = []
i;

if (length(innerPoints) > 1)
    center = circleIntersection.getCenter(innerPoints);
    for i=1:(innerPoints.length)
        p = innerPoints(i);
        p.angle = Math.atan2(p.x - center.x, p.y - center.y);
    end  
    
    innerPoints.sort(function(a,b) { return b.angle - a.angle;})

    p2 = innerPoints(innerPoints.length - 1);
        for i=1:(innerPoints.length)
            p1 = innerPoints(i)
            polygonArea += (p2.x + p1.x) * (p1.y - p2.y);
            midPoint = {x : (p1.x + p2.x) / 2,
                                y : (p1.y + p2.y) / 2
            arc = ''

            for j=1:(p1.parentIndex.length)            
                if (p2.parentIndex.indexOf(p1.parentIndex[j]) > -1) {
                    circle = circles[p1.parentIndex[j]],
                    a1 = Math.atan2(p1.x - circle.x, p1.y - circle.y),
                    a2 = Math.atan2(p2.x - circle.x, p2.y - circle.y);

                    angleDiff = (a2 - a1);
                    if (angleDiff < 0) 
                        angleDiff += 2*pi;
                    end
                        
                    a = a2 - angleDiff/2,
                    width = circleIntersection.distance(midPoint, {
                        x : circle.x + circle.radius * Math.sin(a),
                        y : circle.y + circle.radius * Math.cos(a)
                    });

                    if ((arc === '') || (arc.width > width)) 
                        arc = { circle : circle,    
                                width : width,
                                p1 : p1,
                                p2 : p2};
                    end
                
                arcs = [arcs. arc]
                arcArea += circleIntersection.circleArea(arc.circle.radius, arc.width);
                p2 = p1;
                
                end
            end
        end      
else
    smallest = circles(1);
    
    for i=2:(length(circles))
        if (circles[i].radius < smallest.radius) {
            smallest = circles[i];
        end
    end
    
    disjoint = false;
    for i=1:length(circles)
        if (circleIntersection.distance(circles(i), smallest) > abs(smallest.radius - circles(i).radius))
            disjoint=true
            break
        end
    end
    
    if (disjoint)
        arcArea = 0
        polygonArea = 0

    else
        arcArea = smallest.radius * smallest.radius * pi;
        arcs.push({circle : smallest,
            p1: { x: smallest.x,        y : smallest.y + smallest.radius},
            p2: { x: smallest.x - SMALL, y : smallest.y + smallest.radius},
            width : smallest.radius * 2 });
    end
end