function varargout = iris_system(varargin)
% IRIS_SYSTEM MATLAB code for iris_system.fig
%      IRIS_SYSTEM, by itself, creates a new IRIS_SYSTEM or raises the existing
%      singleton*.
%
%      H = IRIS_SYSTEM returns the handle to a new IRIS_SYSTEM or the handle to
%      the existing singleton*.
%
%      IRIS_SYSTEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IRIS_SYSTEM.M with the given input arguments.
%
%      IRIS_SYSTEM('Property','Value',...) creates a new IRIS_SYSTEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before iris_system_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to iris_system_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help iris_system

% Last Modified by GUIDE v2.5 03-Jul-2019 09:23:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @iris_system_OpeningFcn, ...
                   'gui_OutputFcn',  @iris_system_OutputFcn, ...
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


% --- Executes just before iris_system is made visible.
function iris_system_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to iris_system (see VARARGIN)

% Choose default command line output for iris_system
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes iris_system wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = iris_system_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadimg.
function loadimg_Callback(hObject, eventdata, handles)
% hObject    handle to loadimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uigetfile('*.*','Choose an image');
fig=imread(strcat(pathname,filename));
setappdata(handles.figure1,'IrisImg',fig);
subplot(1,2,2),imshow(fig);


% --- Executes on button press in localiseimg.
function localiseimg_Callback(hObject, eventdata, handles)
% hObject    handle to localiseimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig=getappdata(handles.figure1,'IrisImg');
[local xc yc time]=localisation2(fig,0.2);
[ci cp out time]=thresh(local,50,200);
setappdata(handles.figure1,'localImg',local);
setappdata(handles.figure1,'IrisParam',ci);
setappdata(handles.figure1,'PupilParam',cp);
subplot(1,2,2),imshow(out);



% --- Executes on button press in normaliseimg.
function normaliseimg_Callback(hObject, eventdata, handles)
% hObject    handle to normaliseimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=getappdata(handles.figure1,'localImg');
ci=getappdata(handles.figure1,'IrisParam');
cp=getappdata(handles.figure1,'PupilParam');
[ring,parr]=normaliseiris(img,ci(2),ci(1),ci(3),cp(2),cp(1),cp(3),'normal.bmp',100,300);
parr=adapthisteq(parr);
setappdata(handles.figure1,'normalImg',parr);
subplot(1,2,2);imshow(parr);


% --- Executes on button press in gen_template.
function gen_template_Callback(hObject, eventdata, handles)
% hObject    handle to gen_template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
norm=getappdata(handles.figure1,'normalImg');
[temp th tv]=gen_templateVVV(norm);
[n m k] = size(temp);
key=keyGen(n*m);
%key = [149,120,105,134,227,246,246,121,30,77,195,13,243,221,118,70,54,115,81,2,179,201,50,194,52,109,61,42,237,181,7,161,48,101,7,85,57,64,58,161,153,109,99,154,79,197,246,25,99,52,11,150,44,198,220,7,80,62,3,156,85,129,250,156,61,228,113,132,70,65,158,96,17,6,155,80,51,183,31,172,227,26,8,166,225,5,187,59,153,163,3,24,209,189,221,82,65,21,186,52,165,147,73,169,5,214,143,121,40,74,34,33,249,64,121,183,222,81,18,58,213,144,4,184,95,47,174,154,194,6,158,172,127,52,201,56,35,17,132,0,11,107,141,148,62,128,70,209,21,11,252,144,52,85,188,173,195,115,71,14,22,45,69,83,149,50,124,141,31,60,192,160,189,31,144,39,48,186,36,173,118,1,197,130,249,216,219,142,158,42,203,225,39,240,7,192,141,175,113,68,250,44,129,25,43,66,165,174,89,192,95,89,61,43,0,86,164,182,128,227,231,181,112,100,80,94,251,240,110,214,130,205,13,171,3,16,77,129,42,231,246,152,58,248,34,240,236,254,56,115,59,103,236,239,78,43,0,233,88,209,182,203,138,254,74,167,172,36,128,10,84,70,196,213,165,32,131,152,52,176,169,35,236,199,185,250,40,152,189,39,104,120,89,241,126,184,10,192,81,83,165,142,203,104,235,36,186,176,176,158,211,238,125,57,85,21,35,225,67,227,25,209,43,198,153,48,222,161,193,248,63,213,170,166,55,90,166,163,210,86,208,248,237,236,98,78,194,115,119,248,185,245,125,52,37,255,208,100,92,142,160,117,117,112,89,152,103,217,29,190,190,138,5,107,61,75,190,107,182,183,255,11,123,60,235,117,8,76,188,33,64,104,145,186,187,159,200,52,111,192,171,127,48,166,196,168,151,66,120,183,198,241,18,252,14,63,37,130,178,24,241,51,172,226,234,182,29,7,169,192,15,33,74,140,95,45,210,104,155,125,185,93,180,252,219,68,149,20,253,48];
EncImg = imageProcess(temp,key);
a=dir('E:\New folder\test\Templates\*.bmp');
out=size(a,1);
b=out+1;
if(out==0)
     filename=strcat('temp',num2str(b));
     location=['E:\New folder\test\Templates\',filename,'.bmp'];
     imwrite(EncImg,location);
     subplot(1,2,2);imshow(EncImg);
else
    for k = 1:out
        filename=strcat('temp',num2str(b));
        filename1=strcat('temp',num2str(k));
        location1=['E:\New folder\test\Templates\',filename1,'.bmp'];
        temp2=imread(strcat(location1));
        hd=hammingdist(EncImg, temp2);
        disp(hd)
        if(hd>0.2)
            location=['E:\New folder\test\Templates\',filename,'.bmp'];
            imwrite(EncImg,location);
            subplot(1,2,2);imshow(EncImg);
        else
            disp('Already present !!!')
        end
    end
end

% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
run('index.m')