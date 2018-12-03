function center = getCenter(points)
    center = struct('x', 0, 'y', 0)
    for i = 1:length(points)
        center.x = center.x + points(i).x
        center.y = center.y + points(i).y
    end
    center.x = center.x / length(points)
    center.y = center.y / length(points)
end
