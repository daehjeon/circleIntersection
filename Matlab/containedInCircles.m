function p_inner = containedInCircles (point, circles)
    p_inner = true;
        
    for j = 1:length(circles)
        d = distance(point, circles(j));
        if d > circles(j).radius
            p_inner = false;
        end
    end
end