function varargout = AVIN(varargin)
% AVIN MATLAB code for AVIN.fig
%      AVIN, by itself, creates a new AVIN or raises the existing
%      singleton*.
%
%      H = AVIN returns the handle to a new AVIN or the handle to
%      the existing singleton*.
%
%      AVIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AVIN.M with the given input arguments.
%
%      AVIN('Property','Value',...) creates a new AVIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AVIN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AVIN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AVIN

% Last Modified by GUIDE v2.5 18-Aug-2016 19:05:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AVIN_OpeningFcn, ...
                   'gui_OutputFcn',  @AVIN_OutputFcn, ...
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


% --- Executes just before AVIN is made visible.
function AVIN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AVIN (see VARARGIN)

% Choose default command line output for AVIN
handles.output = hObject;

g = imread('Assets/initialIcon.jpg');
imshow(g)
learning
assignin('base','Theta1',Theta1);
assignin('base','Theta2',Theta2);
handles.Theta1 = Theta1;
handles.Theta2 = Theta2;
            
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AVIN wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AVIN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(gcf, 'units','normalized','outerposition',[0 0 1 1]); %To full screen the GUI

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadImageButton.
function loadImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' },'mytitle')
handles.filename = filename;
handles.pathname = pathname;
assignin('base','filename',strcat(pathname,filename))
g = imread(strcat(pathname,filename));
imshow(g);
imageMatrix = imageProcess(strcat(pathname,filename));
handles.imageMatrix = imageMatrix;
assignin('base','imageMatrix',imageMatrix);


% --- Executes on button press in detectNumberPlateButton.
function detectNumberPlateButton_Callback(hObject, eventdata, handles)
% hObject    handle to detectNumberPlateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Theta1 = evalin('base','Theta1');
Theta2 = evalin('base','Theta2');
imageMatrix = evalin('base','imageMatrix');
outputMatrix = predict(Theta1,Theta2,imageMatrix);
handles.outputMatrix = outputMatrix;
assignin('base','outputMatrix',outputMatrix);
finalString = stringGenerator(outputMatrix);
assignin('base','finalString',finalString);
set(handles.outputText, 'String', finalString);



% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
