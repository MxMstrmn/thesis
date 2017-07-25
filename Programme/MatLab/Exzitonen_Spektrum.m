c                   = constants ; 
C                   = - (c.e^2)/(8*pi^2*c.eps0) ; 
me                  = 0.46*c.me ;
mh                  = 0.41*c.me ; 
mu                  = (me*mh)/(me+mh) ;
eps                 = 4.508 ; 
C                   = - (c.e^2)/(8*pi^2*c.eps0*eps) ; 
% Dimension der k Matrix und Stützstellen für das phi-Intergral
I                   = [0 0.5 6 20 100 1000 10000]; 
N_k                 = [30 30 20 10 10 10];
% Der Energiewert konvergiert schon mit [20 20 20 10 10], aber für die
% Plots sind etwas mehr Stützstellen schäner anzusehen
N_phi               = [50];

[k,g_k]             = integrate(I,N_k,4) ;
[phi, g_phi]        = integrate([-pi pi],N_phi,6) ;
dim                 = length(k) ; 
% Erzeugen des 3D Gitters (k',k,phi)
% Es muss ein solches Gitter erstellt werden, da die Faltung des Potentials
% mit der Wellenfunktion 
[K1,K,PHI]          = meshgrid(k,k,phi);
 KK1                = K1(:,:,1) ; 
 KK                 =  K(:,:,1) ;
weight_k            = repmat(g_k',[dim, 1]) ;

% Integration über Phi für beliebige Funnktionen F(k,k',phi)
weight_phi          = permute(repmat(g_phi,[1,dim,dim]),[3,2,1]) ;
int_phi             = @(k,k1,phi,fcn)  sum((fcn(k,k1,phi) .* weight_phi), 3) ;

% g_c               : Konvergenzfaktor g(k,k')
% veff              : Integrand in Veff(k,k'); Veff(k,k') = veff dphi in [0,2pi] 
% veff_ii           : Integrand in Diagonalelementen
% veff_ij           : Integrand in Nicht-Diagonalelementen
% t_ii              : Funktion für kinetische Energie 
g_c                 = @(k,k1)       4*k.^4 ./    (k.^2 +k1.^2).^2 ;
veff                = @(k,k1,phi)  (C*k1   ./sqrt(k.^2 +k1.^2-2*k.*k1.*cos(phi))).*(k~=k1); 
veff_ii             = @(k,k1,phi)   g_c(k,k1) .*  veff(k,k1,phi) ;        
veff_ij             =               veff ; 
t_ii                = @(k,k1)       1/2/mu*(c.hbar*k).^2.*eq(k,k1); 

% Erstellen der verschiedenen Anteile der Hamiltionmatrix
T_ii                = t_ii(KK,KK1); 
V_ii                = 12.0015*C*(KK==KK1).*KK - diag(int_phi(K,K1,PHI,veff_ii)*g_k);
V_ij                = int_phi(K,K1,PHI,veff_ij) .* weight_k;

% Hamiltonmatrix zusammenfügen
H = T_ii + V_ij + V_ii ; 

%%
% Bestimmung der Eigenwerte (eig_val) samt Normierung der Wellenfunktionen
% (states). Beides beginnend mit dem Grundzustand (sort).  
[states, eig_val]   = eig(H,'vector'); 
[eig_val, idx]      = sort(eig_val);
states              = states(:,idx);
norm = sqrt(2*pi*(states.^2)'*(k.*g_k));
for i=1:dim; states(:,i) = states(:,i)*1/norm(i)*sign(states(1,i)); end

% Anzeigen der Grundzustandsenergie 
disp(eig_val(1))

%%
Spektrum            = 1;
X                   = [] ; 
E = -580 ; 
for E = -700:1:10
omega               = E/c.hbar;
Gamma               = 10;
switch Spektrum
    case{1}
        E_G = 0 ; 
        H_const = (E_G - c.hbar*omega - 1i*Gamma)*(KK==KK1) ; 
end

A                   = H + H_const ;
b                   = ones(dim,1) ;
x_k                 = linsolve(A,b) ; 

x                   = 1/(2*pi)*g_k'*(k.*x_k);
X                   = [X x] ;                    
end           
