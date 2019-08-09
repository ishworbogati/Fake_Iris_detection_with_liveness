function varargout = live(varargin)
% LIVE MATLAB code for live.fig
%      LIVE, by itself, creates a new LIVE or raises the existing
%      singleton*.
%
%      H = LIVE returns the handle to a new LIVE or the handle to
%      the existing singleton*.
%
%      LIVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIVE.M with the given input arguments.
%
%      LIVE('Property','Value',...) creates a new LIVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before live_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to live_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help live

% Last Modified by GUIDE v2.5 23-Jul-2019 12:00:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @live_OpeningFcn, ...
                   'gui_OutputFcn',  @live_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before live is made visible.
function live_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to live (see VARARGIN)

% Choose default command line output for live
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes live wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = live_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = VideoReader('irisavi.avi');
x1=0;
yes=0;
y1=0;
a=0;
count=0;
NumberOfFrames = obj.NumberOfFrames;
% 
la_imagen=read(obj,10);
filas=size(la_imagen,1);
columnas=size(la_imagen,2);
% Center
%centro_fila=round(filas/2);
%centro_columna=round(columnas/2);

for cnt = 1:NumberOfFrames       
    la_imagen=read(obj,cnt);
    if size(la_imagen,3)==3
        la_imagen=rgb2gray(la_imagen);
    end

    %subplot(212)
    piel=~im2bw(la_imagen,0.19);
    %     --
    piel=bwmorph(piel,'close');
    piel=bwmorph(piel,'open');
    piel=bwareaopen(piel,200);
    piel=imfill(piel,'holes');
    imagesc(piel);
    % Tagged objects in BW image
    L=bwlabel(piel);
    % Get areas and tracking rectangle
    out_a=regionprops(L);
    % Count the number of objects
    N=size(out_a,1);
    if N < 1 || isempty(out_a) 
        solo_cara=[ ];
        continue
    end
    % ---
    % Select larger area
    areas=[out_a.Area];
    disp(out_a)
    
    [area_max pam]=max(areas);
 
    plot(211)
    imagesc(la_imagen);
    colormap gray
    hold on
    rectangle('Position',out_a(pam).BoundingBox,'EdgeColor',[1 0 0],...
        'Curvature', [1,1],'LineWidth',2)
    centro=round(out_a(pam).Centroid);
    disp(out_a(pam).BoundingBox(3))
    disp(out_a(pam).BoundingBox(4))
    area=out_a(pam).BoundingBox(3)*out_a(pam).BoundingBox(4);
    disp(area)
    X=centro(1);
    Y=centro(2);
    disp(X)
    try
       % if (((X~=x1) || (Y~=y1))&&(areas~=a))
         if (abs(area-a)>=20)
            plot(X,Y,'g+')
            title('live')
            count=count+1;
            location=pwd;
            l=strcat(location,'\raw\','*.bmp');
            a1=dir(l);
            out=size(a1,1);
            b=out+1;
            filename=strcat('temp',num2str(b));
            loc=[location,'\raw\',filename,'.bmp'];
            output_img=imresize(la_imagen,[240 320]);
            imwrite(output_img,loc);
            x1=X;
            y1=Y;
            a=area;
        end
    catch
        continue
    end
    if(count==30)
        yes=1;
       break
    end
    hold off
     %--
    drawnow;
end
if (yes==1)
   close
    %run('Index2.mlapp')
else
    close
end
