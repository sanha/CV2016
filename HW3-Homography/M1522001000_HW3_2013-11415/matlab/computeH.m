function [H] = computeH(t1, t2)
%compute homography matrix H using least squre ||At - 0||
% output homography's Frobenius norm would be 0.
% t1, t2: 2XN matrix holding pairs of points.
    N = size(t1, 2);
    t1_add1 = [t1; ones(1, N)];
    % contsructing front of A
    A_f = zeros(2*N,6);
    for i=1:N
        t1_tmp = t1_add1(:,i)';
        A_f(2*i-1:2*i,:) = [t1_tmp, 0, 0, 0 ; 0, 0, 0, t1_tmp];
    end
    % constructing tail of A
    A_tmp = zeros(2*N, N);
    for i=1:N
        A_tmp(2*i-1:2*i,i) = t2(:,i);
    end
    A_t = -(A_tmp * t1_add1');
    % calculate eigenvector of A'A having smallest eigenvalue magnitude
    A = [A_f, A_t];
    target = A'*A;
    [h_hat d] = eigs(target, 1, 'sm');
    % normalization to have 0 frobenius norm
    H = reshape(h_hat, [3,3])';
    normf = norm(H, 'fro');
    if normf ~= 0
        H = H / norm(H, 'fro');
    end
end

