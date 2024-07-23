
function  [XX] =  WRSC_GR( Y, C, NSig, m, par )
    [U,SigmaY,V] =   svd(full(Y),'econ');    
    PatNum       = size(Y,2);
    TempC  = C*sqrt(PatNum)*2*NSig^2;
    [SigmaX,svp] = WRSC(SigmaY,TempC,eps);   
    X =  U(:,1:svp)*SigmaX*V(:,1:svp)' + m; 

    
    NSig_new =par.lamada*sqrt(abs(NSig^2-mean((X(:,1)-Y(:,1)-m(:,1)).^2)));
    QG =(par.mu*NSig_new^2*(Y+m) + par.nSig^2*X)/ (par.mu* NSig_new^2 + par.nSig^2+ eps);         
    K_rec=similar_matrix(QG,par.hp);
    [SA,~] = scaling_sp(K_rec,1e-1); % Fast Sinkhorn Algorithm to get diag(C^{-1/2})
     SA(isnan(SA))=0;
    Kernell = sparse(1:PatNum, 1:PatNum, SA, PatNum, PatNum, numel(SA)); clear SA; % Diagonal matrix C^{-1/2}
    K_rec = Kernell*K_rec*Kernell; % Creating Filtering matrix  
    NL_QG =QG*K_rec;   
    XX            =      GR( double(QG), double(NL_QG), par.c1, NSig_new,0.2);
 

return;
