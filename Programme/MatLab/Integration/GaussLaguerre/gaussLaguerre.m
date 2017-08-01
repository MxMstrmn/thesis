formatSpec  = '%f';
dim         = 171 ;

Potential   = 'Coulomb' ; 

switch Potential 
    case {'Coulomb'}
        
        fcn     = 'fcn_Coulomb';
        f       = @(x) fcn_Coulomb(x) ;
        order   = n+1 ;
    
    case {'Keldysh'}
        
        fcn     = 'fcn_Keldysh';
        f       = @(x) fcn_Keldysh(x) ; 
        order   = n+1 ;
end

VC_ij       = zeros(dim+1) ;
for jj=0:dim
    for ii = 0:jj
        n           = ii;
        n1          = jj;
        setGlobaln(n)  ;
        setGlobaln1(n1) ;
        beta        = n1-n-0.5 ;
         
        
        gen_laguerre_rule(order,beta,0,1,fcn)
        
        H           = fscanf(fopen([fcn '_w.txt'],'r'),formatSpec);
        ak          = fscanf(fopen([fcn '_x.txt'],'r'),formatSpec);
        Int         = fscanf(fopen([fcn '_r.txt'],'r'),formatSpec);
        
        const       = sqrt(pi)*factorial(n)/factorial(n1);
        
        GAUSSLAGUERRE       = const*(H.'*f(ak));
        fprintf('\n GAUSSLAGUERRE = %0.4g \n',GAUSSLAGUERRE)
        
        VC_ij(ii+1,jj+1)    = GAUSSLAGUERRE ; 
        VC_ij(jj+1,ii+1)    = VC_ij(ii+1,jj+1) ; 
        
        fclose all;
    end
end




% FCN             = @(x) x.^beta.*exp(-x).*fcn(x(:)) ;
% QUAD            = const*quad(FCN,0,200) 

% % % 
% 
% Kontrolle
% 
% FCN =@(x) x.^0.5.*exp(-x).*fcn(x) ; 
% quad(FCN,0,100) ;
% 
% % % 




% % %   Mein Versuch 
% %  
% % % L   = @(n,a,x)     exp(gammaLn(n+a+1)-gammaLn(a+1)-gammaLn(n+1)).*hypgeomNum(-n,a+1,x);
% % % f   = @(n,a,x)    (L(n,a,x)).^2 ; 
% % % H   = @(N,beta,ak) exp(gammaLn(N+beta+1)-gammaLn(N+1))./((N+1)*L(N+1,beta,ak)) ; 
% % % Int = @(N,a)       linspace(0,n+a+(n-1)*sqrt(n+a),10000) ; 
% % % 
% % % n1  = 6;
% % % n   = 5 ;
% % % beta   = n1-n-0.5 ; 
% % % 
% % % N   = 30; 
% % % I   = Int(N,beta) ;
% % % i   = find(abs(L(N,beta,I))<1) ; 
% % % x0  = I(i);
% % % 
% % % 
% % % ak  = zeros(length(x0),1);
% % % for ii = 1:length(x0)
% % %     fnc   = @(x) L(N,beta,x);
% % %     ak(ii) = fzero(fnc,x0(ii));
% % % end
% % % ak  = unique(round(ak,9)); 
% % % 
% % % F   = H(N,beta,ak).' * f(n,beta+0.5,ak) ;
% % % 
% % % % for jj = 0:5
% % % %     for ii = 0:jj
% % % %         fprintf('n=%0.5g,n1=%0.5g',ii,jj)
% % % %         L(1,ii+1,jj-ii-0.5);
% % % %         disp(' ')
% % % %     end
% end
