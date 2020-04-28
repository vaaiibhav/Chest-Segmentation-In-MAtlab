function varargout = lungseg(varargin)
% LUNGSEG MATLAB code for lungseg.fig
%      LUNGSEG, by itself, creates a new LUNGSEG or raises the existing
%      singleton*.
%
%      H = LUNGSEG returns the handle to a new LUNGSEG or the handle to
%      the existing singleton*.
%
%      LUNGSEG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LUNGSEG.M with the given input arguments.
%
%      LUNGSEG('Property','Value',...) creates a new LUNGSEG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lungseg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lungseg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lungseg

% Last Modified by GUIDE v2.5 22-Oct-2013 19:45:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lungseg_OpeningFcn, ...
                   'gui_OutputFcn',  @lungseg_OutputFcn, ...
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


% --- Executes just before lungseg is made visible.
function lungseg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lungseg (see VARARGIN)

% Choose default command line output for lungseg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lungseg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lungseg_OutputFcn(hObject, eventdata, handles) 
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

[fname,dire]=uigetfile('*.bmp;*.jpg;*.gif;*.dcm;*.png');

if strfind (fname ,'.dcm')
    info = dicominfo([dire,fname]);
    Y = dicomread(info);
    Y = uint8((Y));
else
    Y=imread([dire,fname]); 
    Y=rgb2gray(Y);

end
    handles.currentdata1=Y;
    axes(handles.axes1)
    imshow(Y)
    title('Input Image');
    H1=findobj('Tag','pushbutton2');
    set(H1,'userdata',Y);
    H2=findobj('Tag','pushbutton3');
    set(H2,'userdata',Y);
    H4=findobj('Tag','pushbutton5');
    set(H4,'userdata',Y);
 


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off
clc;
H1=findobj('Tag','pushbutton2');
Img=get(H1,'userdata');
[r,c] = find(Img<=25);     
rc = [r c]; 
rsize = size(r,1);
csize = size(c,1);
[sx sy]=size(rc); 
 n1=zeros(rsize,sy);  
for i=1:sx 
    x1=rc(i,1); 
    y1=rc(i,2); 
    n1(x1,y1)=255; 
end 
im1=medfilt2((~n1));
BW = edge(im1,'canny'); 
msk=[0 0 0 0 0; 
     0 1 1 1 0; 
     0 1 1 1 0; 
     0 1 1 1 0; 
     0 0 0 0 0;]; 
B=conv2(double(BW),msk); 
CC = bwconncomp(logical(B));
L = labelmatrix(CC);
L2 = bwlabel(BW,8);
se1 = strel('line', 3, 90);
se2 = strel('line', 3, 0);
Imgdi = imdilate(L2, [se1 se2]);
Imgfill = imfill(Imgdi, 'holes');
    handles.currentdata2=Imgfill;
    axes(handles.axes2)
    imshow(Imgfill),title('bronchial');
 



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off
H2=findobj('Tag','pushbutton3');
Img=get(H2,'userdata');
[r,c] = find(Img<=50 & Img>=30);     
rc = [r c]; 
[sx sy]=size(rc); 
n1=zeros(r,c);  
for i=1:sx 
    x1=rc(i,1); 
    y1=rc(i,2); 
    n1(x1,y1)=255; 
end 
im1=medfilt2((~n1));
BW = edge(im1,'canny'); 
msk=[0 0 0 0 0; 
     0 1 1 1 0; 
     0 1 1 1 0; 
     0 1 1 1 0; 
     0 0 0 0 0;]; 
B=conv2(double(BW),msk); 
CC = bwconncomp(logical(B));
L = labelmatrix(CC);
L2 = bwlabel(BW,8);
se1 = strel('line', 3, 90);
se2 = strel('line', 3, 0);
Imgdi = imdilate(L2, [se1 se2]);
Imgfill = imfill(Imgdi, 'holes');
    handles.currentdata3=Imgfill;
    axes(handles.axes3)
    imshow(Imgfill),title('vessels');
  H3=findobj('Tag','pushbutton4');
  set(H3,'userdata',Imgfill);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
H4=findobj('Tag','pushbutton4');
Img=get(H4,'userdata');
    handles.currentdata4=Img;
    axes(handles.axes4)
    imshow(~Img),title('fissures');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gradmag;
global ImgFore;
H4=findobj('Tag','pushbutton5');
Img=get(H4,'userdata');
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(Img), hy, 'replicate');
Ix = imfilter(double(Img), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
im0=double(Img);
im0=im0-min(im0(:));
im0=im0/max(im0(:));
im1=im0>graythresh(im0);
im2=imfilter(double(im1),fspecial('gaussian',7,2)); 
idx=im0<=0.5;
ImgFore=zeros(size(im0)); 
ImgBack=zeros(size(im0)); 
ImgFore(idx)=(((0.5-im2(idx))/0.5).^1)/2+0.5;
ImgBack(idx)=1-ImgFore(idx);
    handles.currentdata5=ImgFore;
    axes(handles.axes5)
    imshow(ImgFore) 
%     handles.currentdata6=ImgBack;
%     axes(handles.axes6)
%     imshow(ImgBack)
%  H6=findobj('Tag','pushbutton6');
%   set(H6,'userdata',ImgFore);
%  H7=findobj('Tag','pushbutton6');
%   set(H7,'userdata',gradmag);
 
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% H6=findobj('Tag','pushbutton6');
% ImgFore=get(H6,'userdata');
% H7=findobj('Tag','pushbutton6');
% gradmag=get(H7,'userdata');
global gradmag;
global ImgFore;
E = strel('arbitrary',eye(5));
Imger = imerode(ImgFore,E);
D = bwdist(Imger);
DL = watershed(D);
bgm = DL == 0;
gradmag2 = imimposemin(gradmag, bgm | Imger);
L = watershed(gradmag2);
Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
    handles.currentdata6=Lrgb;
    axes(handles.axes6)
    imshow(Lrgb),title('Colored watershed ')
createColorHistograms(Lrgb);
meanvalue=mean(Lrgb);
meancreateColorHistograms(meanvalue);



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
