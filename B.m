function [B] = B(M)
	if mod(M,2) == 0
		for n=0:M/2 - 1
			for k=1:M/2
				wk=2*pi*(k)/M;
				B(k,n+1) = 2*sin(((M-1)/2 - n)*wk);
			end
		end
	else
		for n=0:((M-3)/2)
			for k=1:((M-1)/2)
				wk=2*pi*(k)/M;
				B(k,n+1) = 2*sin(((M-1)/2 - n)*wk);
			end
		end
	end
	B;
end