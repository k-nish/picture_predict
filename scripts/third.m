clear all;

Tend = 940;
Tpast = 600;

Tend = 30;
Tpast = 20;

r = 5

#Xは各画像を1次元に変換したもの.
#YはXをhstackしたもの
Y = [];
for it = 3:Tend
	filepath = strcat('/Volumes/K2/picture_predict/input/fig',num2str(it),'.jpg');
	imname = filepath;
	I = imread(imname);
	[px,py,pc] = size(I);
	I = I(end:-1:1,:);
	# II = I(4:4:px,4:4:py,:);
	Y = [Y reshape(I, [px*py*pc,1])];
	figure(100);
	image(I);
	# Y = reshape(II,[px*py*pc/16,1]);	
endfor

clear I;

Y = double(Y);

p=10
# k= 900
K = 10
N = 20

A = []
for k=1:K
    # Y_train = Y(:,1:Tpast)
    start_index = 1 + (k-1) * p
    end_index = N + (k-1) * p
    Y_train = Y(:,start_index:end_index)
    [U,D] = eigs(Y_train'*Y_train,r);
    V = Y_train*U;

    V_ = [];
    for i=1:size(U,2)
	    V_ = [V_ V(:,i)/norm(V(:,i))];
    endfor

    # V1 = reshape(V_(:,1),px,py,pc);
    # imagesc(V1)

    # (4):a(j,t)の作成
    # a=V_'*Y;
    # plot(a');

    for tt = 1:p
        a = V_'*Y;
    endfor
    
    A = [A a]
endfor

# p26
I = ones(N-p+1,1)

A_cr = A - A(I*I'/(I'*I))

B = A_cr * (A_cr')


