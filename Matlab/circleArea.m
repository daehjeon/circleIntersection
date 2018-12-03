function cArea = circleArea(r, width)
    cArea = circleIntegral(r, width - r) - circleIntegral(r, -r);
end