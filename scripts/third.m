clear all;

Tend = 938;
Tpast = 600;

Tend = 30;
Tpast = 20;

r = 5

#Xは各画像を1次元に変換したもの.
#YはXをhstackしたもの
Y = [];
for it = 1:Tend
	filepath = strcat('/Volumes/K2/picture_predict/input/fig',num2str(it+2),'.jpg');
	imname = filepath;
	I = imread(imname);
	[px,py,pc] = size(I);
	I = I(end:-1:1,:);
	# II = I(4:4:px,4:4:py,:);
	Y = [Y reshape(I, [px*py*pc,1])];
	figure(100);
	image(I);
endfor

clear I;

Y = double(Y);

p=10
# k= 900
K = 10
N = 20
# N = 700

A = [];
for k=1:K
    # Y_train = Y(:,1:Tpast)
    start_index = 1 + (k-1) * p;
    end_index = N + (k-1) * p;
    Y_train = Y(:,start_index:end_index);
    [U,D] = eigs(Y_train'*Y_train,r);
    V = Y_train*U;

    V_ = [];
    for i=1:size(U,2)
	    V_ = [V_ V(:,i)/norm(V(:,i))];
    endfor


    # a=V_'*Y;
    # plot(a');
    
    a = V_'*Y;
    size(a)
    
    E = [];
    for j =1:r
        A = [];
        for i =1:N-p+1
            # A = [A a(j,i:i+p-1)'];
            A = [A a(j,i:i+p-1)'];
        endfor

        # A_crの計算
        I = ones(N-p+1,1);

        # A_cr = A - A(I*I'/(I'*I));

        # B = A_cr*(A_cr');
        B = A * A';

        [W,D] = eigs(B'*B,r);


        q_prepare = A(:,size(A,2));
        q_prepare = q_prepare(1:size(q_prepare,1)-1,1);
        q_1 = [0];
        Q = vertcat(q_1, q_prepare);

        L = zeros(p,1);
        L(1,1) = 1;

        a_t1= ((L'*W)*(W'*Q))/(1 - (L'*W)*(W'*L));

        E = [E a_t1];

    endfor

endfor


