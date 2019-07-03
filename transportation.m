%%%% Função da Questão 2.1
%%
%% Problema de transporte onde a quantidade total disponível nas m fontes
%% é IGUAL à quantidade total demandada nos n destinos.
%%
%%%%

function [ x ] = transportation(w, s, d)
  % Problema de transporte
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   s -> vetor com a disponibilidade das m fontes
  %   d -> vetor com a demanda dos n destinos
  %   w -> matriz m x n com os custos wij
  %
  % Outputs:
  %   x -> matriz m x n com as unidades transportadas entre as fontes e
  %        os destinos
  %
  % %%%%%%%%%%%%%%%%%

  % Transformando a matriz de custos em um vetor
  w = w(:)';
  % Concatenando as restrições das disponibilidade das fontes com a demanda
  % dos detinos
  b = vertcat(s', d')';

  N_s = length(s); % Número de fontes
  N_d = length(d); % Número de destinos

  % Criação da matrix A baseado no número de fontes e destinos
  A = zeros(N_s + N_d, N_s*N_d);
  c = 0; % Variável de controle
  for i = 1:N_s
    A(i, 1+c:N_d+c) = 1;
    A(N_s+1:N_s+N_d, 1+c:i*N_d) = eye(N_d);
    c += N_d;
  endfor

  % Fazendo calculo do minimo usando programação linear
  lb = zeros(1,N_s*N_d);
  ub = [];
  [ xmax, fmax ] = lp (w, A, b, lb, ub);

  % Transformando vetor x em uma matrix m x n
  x = reshape(xmax, N_d, []).';

endfunction

function [ xmax, fmax ] = lp (f, A, b, lb, ub)
  % Programação Linear
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   f  -> vetor de n elementos com os coeficientes da função objetivo
  %   A  -> matriz m x n que multiplica as variáveis nas desigualdades de restrições
  %   b  -> vetor de m elementos que indica as m restrições
  %   lb ->
  %   ub ->
  %
  % Outputs:
  %   xmax -> vetor x que maximiza a função alvo
  %   fmax -> o valor da função alvo no ponto máximo
  %
  % %%%%%%%%%%%%%%%%%

  ctype   = char(ones(1,length(b))*"S"); % Define o tipo de inequação: S : =
  vartype = char(ones(1,length(f))*"I"); % Define o tipo das variaveis: I : Int
  s       = 1;                           % Sense = 1 significa minimização

  param.msglev = 0;     % Não retorna mensagens de erros ou warnings
  param.itlim  = 1000;  % Limite de iterações

  [xmax, fmax, status, extra] = ...
      glpk (f, A, b, lb, ub, ctype, vartype, s, param);

endfunction