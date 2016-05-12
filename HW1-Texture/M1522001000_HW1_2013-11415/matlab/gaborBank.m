function [filters] = gaborBank(S, K, U_h, U_l, W, filterSize)
% Take parameters and make gabor filter bank with gaborFilter function.
% S: the total number of scales.
% K: the total number of orientations.
% W: constant detrermining the freq bandwith of the filters.
% size: kernel size
    a = (U_h / U_l) ^ (1/(S-1));
    alpha = (a + 1) / (a - 1);
    sigma_x = (1/(2*pi)) * alpha * (sqrt(2*log(2)))/U_h;
    sigma_y = (1/(2*pi)) * (tan(pi/(2*K)) * (1/(2*pi)) * sqrt((alpha^2 - 1)/sigma_x^2)) ^ (-1);
    
    filters = cell(S, K);
    
    for m=0:S-1
        for n=0:K-1
            theta = n * pi / K;
            for x=1:filterSize
                tmp = zeros(filterSize, 1);
                for y=1:filterSize
                    x_prime = a^(-m) * ((x - (filterSize + 1) / 2) * cos(theta) + (y - (filterSize + 1) / 2) * sin(theta));
                    y_prime = a^(-m) * ((-(x - (filterSize + 1) / 2)) * sin(theta) + (y - (filterSize + 1) / 2) * cos(theta));
                    tmp(y, 1) = a^(-m) * gaborFilter(x_prime, y_prime, sigma_x, sigma_y, W);             
                end
                filters{m+1, n+1} = [filters{m+1, n+1}, tmp];
            end
        end
    end