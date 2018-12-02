function p_inner = containedInCircles (p_intersect, circles)
    p_inner = struct('x',{},'y',{});
    num_of_inner = 1;
    inner_flag = 1;
    
    for i = 1:length(p_intersect)
        inner_flag = 1;
        
        for j = 1:length(circles)
            d = distance(p_intersect(i), circles(j));
            if d > circles(j).r
                inner_flag = 0;
            end
        end
        
        if inner_flag == 1
            p_inner(num_of_inner) = p_intersect(i);
            num_of_inner = num_of_inner + 1;
        end
    end 
end