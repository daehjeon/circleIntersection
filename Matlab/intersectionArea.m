function intersectArea = intersectionArea (x0)

    SMALL = 1e-10;
    innerPoints = [];
    R = 1;

    %Test points for three signal coverage area
    circles(1) = struct('x',0,'y',0,'radius', R);
    circles(2) = struct('x',x0(1),'y',x0(2),'radius',R);
    circles(3) = struct('x',x0(3),'y',x0(4),'radius',R);
    
    %get all the intersection points of the circles
    intersectionPoints = getIntersectionPoints(circles);  
    intersectArea = '';
    arcArea = 0;
    polygonArea = 0;
    arcs = [];

    %filter out points that aren't included in all the circles
    for i=1:(length(intersectionPoints))
        if (containedInCircles(intersectionPoints(i), circles))
            innerPoints = [innerPoints, intersectionPoints(i)];
        end
    end 
    
    % innerPoints intersectionPoints arcArea arcs polygonArea
    
    % if we have intersection points that are within all the circles,
    % then figure out the area contained by them
    if (length(innerPoints) > 1)
        
        % sort the points by angle from the center of the polygon, which lets
        % us just iterate over points to get the edges
        ifstatement = 'a';
        center = getCenter(innerPoints);
        for i=1:(length(innerPoints))
            p = innerPoints(i);
            p.angle = atan2(p.x - center.x, p.y - center.y);
            innerPoints(i).angle = p.angle;
        end  

        %sort innerPoints
        ipFields = fieldnames(innerPoints);
        ipCell = struct2cell(innerPoints);
        sz = size(ipCell);
        ipCell = reshape(ipCell, sz(1), []);
        ipCell = ipCell';
        ipCell = sortrows(ipCell, 4, 'descend');
        ipCell = reshape(ipCell', sz);
        innerPoints = cell2struct(ipCell, ipFields, 1);
%         innerPoints(1)
%         innerPoints(2)
%         innerPoints(3)
        

        % iterate over all points, get arc between the points
        % and update the areas
        p2 = innerPoints(length(innerPoints));
        
        for i=1:(length(innerPoints))
            p1 = innerPoints(i);
            polygonArea = polygonArea + (p2.x + p1.x) * (p1.y - p2.y);
            
            % updating the arc area is a little more involved
            midPoint = struct('x', (p1.x + p2.x) / 2, 'y', (p1.y + p2.y) / 2);
            arc = 0;

            for j=1:(length(p1.parentIndex))
                 if (find(p2.parentIndex == p1.parentIndex(j)))
                     % figure out the angle halfway between the two points
                     % on the current circle
                     circle = circles(p1.parentIndex(j));
                     a1 = atan2(p1.x - circle.x, p1.y - circle.y);
                     a2 = atan2(p2.x - circle.x, p2.y - circle.y);
 
                     angleDiff = (a2 - a1);
                     if (angleDiff < 0) 
                         angleDiff = angleDiff + 2*pi;
                     end
 
                     % and use that angle to figure out the width of the
                     % arc
                     a = a2 - angleDiff/2;
                     width = distance(midPoint, struct('x', circle.x + circle.radius * sin(a), 'y', circle.y + circle.radius * cos(a)));
 
                     % pick the circle whose arc has the smallest width
                     if ((isequal(arc,0)) || (arc.width > width)) 
                         arc = struct('circle', circle, 'width', width, 'p1', p1, 'p2', p2);
                     end
                 end
            end
            arcs = [arcs, arc];
            
%             aTemp = a;
%             
%             if a < 0
%                 aTemp = pi+a;
%             end
%             
%             tCA = aTemp - (sin(aTemp)/2)
%             arcArea = arcArea + aTemp - (sin(aTemp)/2)
            
            tempCircleArea = circleArea(arc.circle.radius, arc.width);
            arcArea = arcArea + circleArea(arc.circle.radius, arc.width);
            
            p2 = p1;
        end
%     end
    else
        % no intersection points, is either disjoint - or is completely
        % overlapped. figure out which by examining the smallest circle
        ifstatement = 'b';
        smallest = circles(1);

        for i=2:(length(circles))
            if (circles(i).radius < smallest.radius)
                smallest = circles(i);
            end
        end

        % make sure the smallest circle is completely contained in all
        % the other circles
        disjoint = false;
        for i=1:length(circles)
            if (distance(circles(i), smallest) > abs(smallest.radius - circles(i).radius))
                disjoint = true;
                break
            end
        end

        if (disjoint)
            arcArea = 0;
            polygonArea = 0;

        else
            arcArea = smallest.radius * smallest.radius * pi
            arcs = [arcs, struct('circle', smallest, 'width', smallest.radius*2, 'p1', struct('x', smallest.x, 'y', smallest.y + smallest.radius), 'p2', struct('x', smallest.x - SMALL, 'y', smallest.y + smallest.radius))];
        end
    end

    polygonArea = abs(polygonArea / 2);
%     if (stats)
%         stats.area = arcArea + polygonArea;
%         stats.arcArea = arcArea;
%         stats.polygonArea = polygonArea;
%         stats.arcs = arcs;
%         stats.innerPoints = innerPoints;
%         stats.intersectionPoints = intersectionPoints;
%     end



    intersectArea = arcArea + polygonArea;
    intersectArea = 0 - intersectArea;
    end