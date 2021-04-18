%% stillBall Image
imageSize=[512,512,3];
I=ones(imageSize);
x=imageSize(1)/2;
y=imageSize(2)/2;
R=mean(imageSize(1:2))/10;
stillBall = insertShape(I,'FilledCircle',[x,y,R],'Color','red');
clear imageSize I x y R