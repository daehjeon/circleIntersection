function cIntegral = circleIntegral(r, x)
    y = sqrt(r * r - x * x);
    cIntegral = x * y + r * r * atan2(x, y);
end