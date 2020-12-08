-module(tarea).
-export([reverse/1,palindromo/1,myflatten/1,compress/1,pack/1,encode/1,encode_modified/1,
run_length/1,encode_direct/1,dupli/1,repli/2,drop/2,split/2,slice/3,rotate/2,remove_at/2,
insert_at/3,range/2,rnd_select/2,element_at/2,lotto_select/2,rnd_permu/1,combination/2,lsort/1,
is_prime/1,mcd/2,coprimos/2,totient_phi/1,factores_primos/1,prime_factors_mult/1]).

%p05

reverse([])->[];
reverse([H|T])-> reverse(T)++[H].

%p06
palindromo([])->true;
palindromo(A)->reverse(A)=:=A.

%p07
myflatten([])->[];
myflatten(L)-> lists:flatten(L).

%p08
compress([])->[];
compress([H,H|T])-> compress([H|T]);
compress([H|T])-> [H]++compress(T).


%p09
pack([])-> [];
pack([H,H|T])->pack([H,H],T);
pack([H|T])->[[H]]++ pack(T).

pack(L,[])->[L];
pack([H|P],[H|T])-> pack([H|P]++[H],T);
pack(L,[H|T])-> [L]++ pack([H],T).

%p10
encode([])-> [];
encode([H,H|T])-> encode({2,H},T);
encode([H|T])->[{1,H}]++ encode(T).

encode(L,[])->[L];
encode({N,H},[H|T])-> encode({N+1,H},T);
encode({F,P},[H|T])-> [{F,P}]++ encode({1,H},T).

%p11
encode_modified([])-> [];
encode_modified([H,H|T])-> encode_modified({2,H},T);
encode_modified([H|T])->  encode_modified(H,T).

encode_modified(L,[])->[L];
encode_modified({N,H},[H|T])-> encode_modified({N+1,H},T);
encode_modified({F,P},[H|T])-> [{F,P}]++ encode_modified(H,T);
encode_modified(H,[H|T])-> encode_modified({2,H},T);
encode_modified(F,[H|T])-> [F]++ encode_modified(H,T).

%p12
run_length([])->[];
run_length([{N,H}|T])->lists:duplicate(N,H) ++ run_length(T);
run_length([H|T])-> [H]++ run_length(T).


%p13
encode_direct(L)->encode_modified(L).

%p14
dupli([])->[];
dupli([H|T])-> [H,H]++dupli(T).

%p15
repli(_N,[])->[];
repli(N,L)->myflatten([lists:duplicate(N,X)||X<-L]).

%p16


drop([],_N)->[];
drop([_H|T],1)-> drop(T,3);
drop([H|T],N)-> [H] ++ drop(T,N-1).


%p17


split([],_N)->[];
split([H|T],N)-> split([H],T,N-1).

split(_L,[],_N)->[];
split(L,[H|T],1)->[L++[H]|T];
split(L,[H|T],N)-> split(L++[H],T,N-1).

%p18

slice([],_I,_F)->[];
slice(L,I,F)-> remove_at(split(cut(L,F),I-1),1).

cut(_L,0)->[];
cut([H|_T],1)->[H];
cut([H|T],N)->[H]++cut(T,N-1).

%p19

rotate([],_N)->[];
rotate(L,N)->remove_at(split(L,N),1)++cut(L,N).

%p20

remove_at([],_N)->[];
remove_at([_H|T],1)-> T;
remove_at([H|T],N)-> [H] ++ remove_at(T,N-1).


%p21


insert_at(_P,[],_N)->[];
insert_at(P,[H|T],1)-> [P]++[H]++T;
insert_at(P,[H|T],N)-> [H] ++ insert_at(P,T,N-1).
 
 
 %p22
 
 range(I,F)->lists:seq(I,F).
 
 %p23
element_at([],_N)->[];
element_at([H|_T],1)-> [H];
element_at([_H|T],N)-> element_at(T,N-1).
 
rnd_select_aux([],_N,_P)->[];
rnd_select_aux(L,N,1)-> element_at(L,N);
rnd_select_aux(L,N,P)-> element_at(L,N)++ 
                        rnd_select_aux(remove_at(L,N),
						rand:uniform(length(remove_at(L,N))),
						P-1).
						
 
 rnd_select([],_N)->[];
 rnd_select(L,N)-> rnd_select_aux(L,rand:uniform(length(L)),N).
 
 %p24
 
 lotto_select(N,P)->rnd_select(range(1,P),N).
 
 %p25
 
rnd_permu([])->[];
rnd_permu(L)-> rnd_select(L,length(L)).

 %p26
 
combination(_L,0)->[[]];
combination(L,N)when length(L) =:= N->[L];
combination([H|T], N)-> [[H|Comb] || Comb <- combination(T,N-1)]++combination(T,N).



%p28


lsort([])->[];
lsort([Piv|T])-> lsort([X||X<-T,length(X) =< length(Piv)])++[Piv]++lsort([X||X<-T, X>Piv]).


%31
is_prime(2)->true;
is_prime(3)->true;
is_prime(N)->is_prime_aux(N,trunc(math:sqrt(N))).

is_prime_aux(_N,1)->true;
is_prime_aux(N,P)when N rem P == 0 ->false;
is_prime_aux(N,P)->is_prime_aux(N,P-1).


%p32

mcd(0,P)->P;
mcd(N,P)when N rem P == 0-> P;
mcd(N,P)when N > P->mcd( P , N rem P );
mcd(N,P)->mcd(P,P rem N).

%p33

coprimos(N,P)->mcd(N,P)==1.

%p34

totient_phi(N)->  length([X||X<-[coprimos(N,X)||X<- lists:seq(1,N)],X=:=true]).


%35

factores_primos_l(N)->[X||X<- [X||X<- lists:seq(2,N),is_prime(X)],N rem X == 0].
factores_primos(_N,[])->[];
factores_primos(0,_L)->[];
factores_primos(N,[H|T])when N rem H == 0->[H]++ factores_primos(N div H,[H|T]);
factores_primos(N,[_H|T])-> factores_primos(N,T).


factores_primos(N)-> factores_primos(N,factores_primos_l(N)).

%36

prime_factors_mult(N)-> encode(factores_primos(N)).



 