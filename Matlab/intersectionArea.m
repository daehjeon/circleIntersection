function [ifstatement, intersectArea, innerPoints, intersectionPoints, arcArea, arcs, polygonArea] = intersectionArea (circles)

    SMALL = 1e-10;
    innerPoints = []
    intersectionPoints = getIntersectionPoints(circles);  
    intersectArea = ''
    arcArea = 0
    polygonArea = 0
    arcs = []

    for i=1:(length(intersectionPoints))
        if (containedInCircles(intersectionPoints(i), circles))
            innerPoints = [innerPoints, intersectionPoints(i)]
        end
    end 
    
    % innerPoints intersectionPoints arcArea arcs polygonArea
    
    if (length(innerPoints) > 1)
        ifstatement = 'a'
        center = getCenter(innerPoints);
        for i=1:(length(innerPoints))
            p = innerPoints(i);
            p.angle = atan2(p.x - center.x, p.y - center.y);
        end  

        %does not seem to matter
        %innerPoints.sort(function(a,b) { return b.angle - a.angle;})

        p2 = innerPoints(length(innerPoints))
        for i=1:(length(innerPoints))
            p1 = innerPoints(i)
            polygonArea = polygonArea + (p2.x + p1.x) * (p1.y - p2.y)
            midPoint = struct('x', (p1.x + p2.x) / 2, 'y', (p1.y + p2.y) / 2)
            arc = 0

            for j=1:(length(p1.parentIndex))
                 if (find(p2.parentIndex == p1.parentIndex(j)))
                     circle = circles(p1.parentIndex(j))
                     a1 = atan2(p1.x - circle.x, p1.y - circle.y)
                     a2 = atan2(p2.x - circle.x, p2.y - circle.y)
 
                     angleDiff = (a2 - a1);
                     if (angleDiff < 0) 
                         angleDiff = angleDiff + 2*pi;
                     end
 
                     a = a2 - angleDiff/2,
                     width = distance(midPoint, struct('x', circle.x + circle.radius * sin(a), 'y', circle.y + circle.radius * cos(a)))
 
                     if ((isequal(arc,0)) || (arc.width > width)) 
                         arc = struct('circle', circle, 'width', width, 'p1', p1, 'p2', p2)
                     end
                 end
            end
            arcs = [arcs, arc]
            tempCircleArea = circleArea(arc.circle.radius, arc.width);
            arcArea = arcArea + circleArea(arc.circle.radius, arc.width)
            p2 = p1;
        end
    
    else
        ifstatement = 'b'
        smallest = circles(1);

        for i=2:(length(circles))
            if (circles(i).radius < smallest.radius)
                smallest = circles(i);
            end
        end

        disjoint = false;
        for i=1:length(circles)
            if (distance(circles(i), smallest) > abs(smallest.radius - circles(i).radius))
                disjoint = true
                break
            end
        end

        if (disjoint)
            arcArea = 0
            polygonArea = 0

        else
            arcArea = smallest.radius * smallest.radius * pi;        
            arcs = [arcs, struct('circle', smallest, 'width', smallest.radius*2, 'p1', struct('x', smallest.x, 'y', smallest.y + smallest.radius), 'p2', struct('x', smallest.x - SMALL, 'y', smallest.y + smallest.radius))]
        end
    end

    polygonArea = polygonArea / 2;
%     if (stats)
%         stats.area = arcArea + polygonArea;
%         stats.arcArea = arcArea;
%         stats.polygonArea = polygonArea;
%         stats.arcs = arcs;
%         stats.innerPoints = innerPoints;
%         stats.intersectionPoints = intersectionPoints;
%     end

    intersectArea = arcArea + polygonArea;
    end