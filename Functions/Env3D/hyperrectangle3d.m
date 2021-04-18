classdef hyperrectangle3d < handle
    properties
        Faces(6,4)=[1,2,3,4;
            5,6,7,8;
            1,2,6,5;
            2,3,7,6;
            3,4,8,7;
            1,4,8,5];
        Vertices(8,3);
        
        worldAxes(1,1)=gobjects(1,1);
        graphicHandle(1,1)=gobjects(1,1);
    end
    methods
        function obj=hyperrectangle3d(lengths,center,worldAxes) %constructor
            if nargin<3 %worldAxes not provided
                worldAxes=gca;
            end
            
            X=([0,1,1,0,0,1,1,0]-0.5)*lengths(1)+center(1);
            Y=([0,0,1,1,0,0,1,1]-0.5)*lengths(2)+center(2);
            Z=([0,0,0,0,1,1,1,1]-0.5)*lengths(3)+center(3);
            
            V=[X;Y;Z]';
            
            obj.Vertices=V;
            obj.worldAxes=worldAxes;
        end
        function delete(obj) %destructor
            delete(obj.graphicHandle);
        end
        function plot(obj,varargin)
            if isvalid(obj.graphicHandle) &&...
                    isa(obj.graphicHandle,'matlab.graphics.Patch') %only update
                set(obj.graphicHandle,...
                    'Faces',obj.Faces,...
                    'Vertices',obj.Vertices,...
                    varargin{:});
            else %create new object
                hold(obj.worldAxes,'on');
                obj.graphicHandle=patch(...
                    'Parent',obj.worldAxes,...
                    'Faces',obj.Faces,...
                    'Vertices',obj.Vertices,...
                    varargin{:});
                hold(obj.worldAxes,'off');
            end
        end
    end
end