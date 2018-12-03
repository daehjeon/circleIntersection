function p_inner = containedInCircles (point, circles)
    p_inner = true;
        
    for i = 1:length(circles)
        d = distance(point, circles(i));
        if d > circles(i).radius
            p_inner = false;
        end
    end
end