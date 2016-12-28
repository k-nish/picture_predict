clear all;

Tend = 938;
Tpast = 100;

# Tend = 30;
# Tpast = 20;

r = 5

#Xは各画像を1次元に変換したもの.
#YはXをhstackしたもの
Y = [];
for it = 1:Tend
	filepath = strcat('/Volumes/K2/picture_predict/input/fig',num2str(it+2),'.jpg');
	imname = filepath;
	I = imread(imname);
    size(I)
	[px,py,pc] = size(I);
	# I = I(end:-1:1,:);
    I = I(end:-1:1,1:1:end,1:3);
    size(I)
    I = I(1:4:end,1:4:end,1:3);
    size(I)
    [px,py,pc] = size(I);
	Y = [Y reshape(I, [px*py*pc,1])];
	figure(1000);
	image(I);
endfor

clear I;

Y = double(Y);

p=3;
K = 290
N = 50
# N = 700
# M = 100
M = 20

A = [];
for k=1:K
    start_index = 1 + (k-1)*p;
    end_index = N + (k-1)*p;
    Y_train = Y(:,start_index:end_index);
    [U,D] = eigs(Y_train'*Y_train,r);
    V = Y_train*U;

    V_ = [];
    for i=1:size(U,2)
	    V_ = [V_ V(:,i)/norm(V(:,i))];
    endfor

    a = V_'*Y;
    size(a)
    b = a;
    
    E = [];
    for j =1:r
        A = [];
        for i = N-M+1:-1:1
            A = [a(j,i+M-1:-1:i)' A ];
        endfor

        B = A * A';

        [W,D] = eigs(B,r);

        q_prepare = A(1:M-1,N-M+1);
        for it = 1:p
            q_1 = [0];
            Q = vertcat(q_1, q_prepare);
            L = zeros(M,1);
            L(1,1) = 1;
            a_t1= ((L'*W)*(W'*Q))/(1 - (L'*W)*(W'*L));
            q_prepare = [a_t1; q_prepare(1:M-2)];

            E(j,it) = a_t1;
        endfor
    endfor
    
    X_new = V*E;
    for it=1:p
        S = X_new(:,it);
        ImageP = reshape(S,px,py,pc);
        ImageP = ImageP/max(max(max(ImageP)));
        # ImageP(ImageP<0)=0;
        # ImageP(ImageP>1)=1;
        # real_picture=Y()
        figure(it);
        # image(ImageP);
        figure(1);
        # image(reshape(Y(:,end_index),px,py,pc))
        image_o = (reshape(Y(:,end_index + it),px,py,pc));
        image_o = image_o/max(max(max(image_o)));
        imagesc([image_o,ImageP]);
    endfor
endfor
