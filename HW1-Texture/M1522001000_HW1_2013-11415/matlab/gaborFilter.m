function magnitude = gaborFilter(x, y, sigma_x, sigma_y, W)
% gabor filter function. 
    constant = 1 / (2 * pi * sigma_x * sigma_y);
    complex = constant * exp(-(1/2) * (x^2 / sigma_x^2 + y^2 / sigma_y^2) + (2 * i * pi * W * x));
    magnitude = abs(complex);