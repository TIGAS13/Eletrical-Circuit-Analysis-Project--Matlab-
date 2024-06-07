
function [t, y] = Euler_melhorado(f, y0, h, tf)

    t = 0:h:tf;

    y = zeros(size(t));

    y(1) = y0;


    for i = 1:(length(t)-1)

        y_pred = y(i) + h * f(t(i), y(i));


        y(i+1) = y(i) + (h/2) * (f(t(i), y(i)) + f(t(i) + h, y_pred));
    end
end

