function out = fcn(x)
%   Mein Versuch, gut bis n ~ 20
% % L   = @(n,a,x)     exp(gammaLn(n+a+1)-gammaLn(a+1)-gammaLn(n+1)).*hypgeomNum(-n,a+1,x);
% 
L   = @(n,a,x)    lf_function(length(x),n,a,x(:));
f   = @(n,a,x)    (L(n,a,x)).^2 ;

% n   = getGlobal n  ; 
% n1  = getGlobal n1 ; 
n  = getGlobalx ;
n1 = 5 ; 
out = f(n,n1-n,x);
% lf_function gibt die Werte für alle Ordnungen der Laguerre Pol aus
out = out(:,n);
end

% FCN =@(x) x.^0.5.*exp(-x).*fcn(x)
% quad(FCNfcn,0,100)