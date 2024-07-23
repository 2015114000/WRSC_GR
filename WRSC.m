function [SigmaX,svp]=WRSC(SigmaY,C,oureps)
temp=(SigmaY-oureps).^2-4*(C-oureps*SigmaY);
ind=find (temp>0);
svp=length(ind);
temp2=diag((SigmaY(ind)+oureps).^2);
temp3=C+temp2;
SigmaX=diag(SigmaY(ind)).*(temp2./temp3);


end