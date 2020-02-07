function [x, res, h, t] = explicit(a, b, N, d, E)
  h = (b - a) / N;
  ts = min(0.1, h^2 / (2 * q(b))) ;
  x = a:h:b;
  K = 0;
  while true
    for i=1:N+1
      n1(i) = abs(u(x(i), (K-1)*ts) - sin(e^x(i)));
      n2(i) = sin(e^x(i));
    endfor
    if norm(n1, h, N) / norm(n2, h, N) < d
      break;
    endif
    K += 1;
  endwhile
  T = ts*K;
  t = linspace(0, T, K+1);
  
  %  задаём начальные условия
  for i = 1: N + 1
    y(i, 1) = u(x(i), 0);
  endfor
  
  %  сама схема
  for n=2:K+1
    for i = 2:N
      %  заполняем внутренние точки
      tmp = (y(i+1, n-1) - 2.*y(i,n-1) + y(i-1,n-1)) / h.^2;
      y(i, n) = y(i, n - 1) + ts .* (f(x(i), t(n-1)) + q(x(i)).*tmp);
    endfor
    %  задаём точки на границе
    y(1, n) = (mu_a(t(n), a) + (4*y(2, n) - y(3, n))/2/h)/(1 + 3/2/h);;
    y(N+1, n) = (mu_b(t(n), b) + (4*y(N, n) - y(N-1, n))/2/h)/(1 + 3/2/h);
  endfor 
  res = y;
 