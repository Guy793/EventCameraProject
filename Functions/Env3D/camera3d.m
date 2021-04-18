classdef camera3d
    properties
        h(1,1)=512; %amount of pixels in y direction
        w(1,1)=512; %amount of pixels in x direction
        fx(1,1)=512; %1 meter length in 1 meter disatnce will apear as fx pixels
        fy(1,1)=512; %1 meter length in 1 meter disatnce will apear as fx pixels
        px(1,1)=0; %displacement of image center from image corner in x direction
        py(1,1)=0; %displacement of image center from image corner in y direction
        K(3,3)=zeros(3,3); %intrinsic matrix
        position(3,1); %[x,y,z]' in world coordinates
        orientation(3,1); %{roll,pitch,yaw]' in world
        poseMatrix(4,4);
        
        cameraSize(1,1)=0.1;
        worldAxes(1,1)=gobjects(1,1);
        imagePlaneFig(1,1)=gobjects(1,1);
        imagePlaneAxes(1,1)=gobjects(1,1);
        graphicHandle(1,1)=gobjects(1,1);
    end
    methods
        function obj=camera3d(position,orientation,worldAxes) %constructor
%             if nargin<4 %worldAxes not provided
%                 worldAxes=gca;
%             end
            
%             obj.worldAxes=worldAxes; 
            obj.position=position;
            obj.orientation=orientation;
            
            obj.py=obj.h/2;
            obj.px=obj.w/2;
            obj.K=computeK(obj);
            
            computePose(obj);
        end
        function computePose(obj)
            %Systems: 0(world) -> 1(x->target) -> 2(roll)
            Rctw=eul2rotm(obj.orientation');
            
            t=obj.position;
            obj.poseMatrix=[Rctw,t;...
                [0 0 0 1]];
        end
        function plot(obj)
            computePose(obj); %recompute pose in case that user changed properties
            plotpose=rigid3d(obj.poseMatrix');
            
            if isvalid(obj.graphicHandle) &&...
                    isa(obj.graphicHandle,'vision.graphics.Camera') %only update
                obj.graphicHandle.AbsolutePose=plotpose;
            else
                hold(obj.worldAxes,'on');
                obj.graphicHandle=plotCamera(...
                    'Parent',obj.worldAxes,...
                    'AbsolutePose',plotpose,...
                    'size',obj.cameraSize);
                hold(obj.worldAxes,'off');
            end
        end
        function image=getframe(obj,varargin)
            if isvalid(obj.imagePlaneFig) &&... %if imagePlane existed, clear it
                    isa(obj.imagePlaneFig,'matlab.ui.Figure')
                cla(obj.imagePlaneAxes);
            else %else.. create a new window
            obj.imagePlaneFig=figure('color',[1,1,1]); %open new figure
            obj.imagePlaneAxes=axes('parent',obj.imagePlaneFig,...
                'view',[0 90],...
                'XLim',[0,obj.w],...
                'YLim',[0,obj.h]);
            axis(obj.imagePlaneAxes,'manual'); %mode - manual, style - image
            end
            
            K=obj.computeK; %Method
            Rwtc=obj.pose(1:3,1:3)';
            O=obj.pose(1:3,4);
            for ii=1:length(varargin)          
                P=varargin{ii}.P;
                m=size(P,1); %number of points
                X=[P'; %transpose here so X is [x;y;z;1]
                    ones(1,m)];
                x=K*[Rwtc,-Rwtc*O]*X;
                x=(x./(x(3,:)+eps));
                u=x(1,:);
                v=x(2,:);
                
%                 ind=convhull(u,v);
%                 u=u(ind);
%                 v=v(ind);
                
                patch(obj.imagePlaneAxes,'XData',u,'YData',v,...
                    'FaceColor',varargin{ii}.graphicHandle.FaceColor,...
                    'EdgeColor',varargin{ii}.graphicHandle.EdgeColor,...
                    'FaceAlpha',varargin{ii}.graphicHandle.FaceAlpha);
            end
            
%             F = getframe(obj.figureHandle);% Grab the rendered frame
%             image=F.cdata;
        end
        function K=computeK(obj)
          K=[obj.fx,0,obj.px;
               0,obj.fy,obj.py;
               0,0,1];
        end
        function delete(obj) %destructor
            delete(obj.graphicHandle);
        end
    end
end