%Esta funcion calcula la matriz para cálculo de filtros FIR de fase lineal
%simétricos 
function [A] = A(M_filtro)
	if mod(M_filtro,2) == 0
		for n=0:M_filtro/2 - 1
			for k=0:M_filtro/2 -1
				wk=2*pi*k/M_filtro;
				A(k+1,n+1) = 2*cos(((M_filtro-1)/2 - n)*wk);
			end
		end
	else
		for n=0:(M_filtro-1)/2
			for k=0:(M_filtro-1)/2
				wk=2*pi*k/M_filtro;
				if n==(M_filtro-1)/2
					A(k+1,n+1)=1;
				else
					A(k+1,n+1) = 2*cos(((M_filtro-1)/2 - n)*wk);
				end
			end
		end
	end
	A;
end