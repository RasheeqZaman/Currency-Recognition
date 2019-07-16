function varargout = CurrenyIndentify2(varargin)
% CURRENYINDENTIFY2 MATLAB code for CurrenyIndentify2.fig
%      CURRENYINDENTIFY2, by itself, creates a new CURRENYINDENTIFY2 or raises the existing
%      singleton*.
%
%      H = CURRENYINDENTIFY2 returns the handle to a new CURRENYINDENTIFY2 or the handle to
%      the existing singleton*.
%
%      CURRENYINDENTIFY2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CURRENYINDENTIFY2.M with the given input arguments.
%
%      CURRENYINDENTIFY2('Property','Value',...) creates a new CURRENYINDENTIFY2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CurrenyIndentify2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CurrenyIndentify2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CurrenyIndentify2

% Last Modified by GUIDE v2.5 08-Apr-2019 21:46:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CurrenyIndentify2_OpeningFcn, ...
                   'gui_OutputFcn',  @CurrenyIndentify2_OutputFcn, ...
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


% --- Executes just before CurrenyIndentify2 is made visible.
function CurrenyIndentify2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CurrenyIndentify2 (see VARARGIN)

% Choose default command line output for CurrenyIndentify2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CurrenyIndentify2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CurrenyIndentify2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelectImageButton.
function SelectImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,filepath]=uigetfile({'*.jpeg;*.jpg;*.png;*.bmp'},'Select and image');
selectedImage = imread(strcat(filepath, filename));
imshow(selectedImage);
selectedImage = imresize(selectedImage, [325 720]);

handles.testImage = selectedImage;
guidata(hObject,handles);

set(handles.FileNameText, 'String', filename);


% --- Executes on button press in TrainDataset.
function TrainDataset_Callback(hObject, eventdata, handles)
% hObject    handle to TrainDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.TrainingStatus, 'String', 'Training...');

trainingSetDir   = fullfile(pwd, 'trainingDataset');
trainingSet = imageDatastore(trainingSetDir,   'IncludeSubfolders', true, 'LabelSource', 'foldernames');

cellSize = [4 4];
img = readimage(trainingSet, 1);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',cellSize);
hogFeatureSize = length(hog_4x4);

trainingLabels = trainingSet.Labels;
numImages = numel(trainingSet.Files);
trainingFeatures  = zeros(numImages, hogFeatureSize, 'single');
for j = 1:numImages
    trainingFeatures(j,:) = extractHOGFeaturesFromImage(readimage(trainingSet, j), cellSize);
end

handles.cellSize = cellSize;
handles.classifier = fitcecoc(trainingFeatures, trainingLabels);
guidata(hObject,handles);

set(handles.TrainingStatus, 'String', 'Trained!');


% --- Executes on button press in Predict.
function Predict_Callback(hObject, eventdata, handles)
% hObject    handle to Predict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

testFeatures = extractHOGFeaturesFromImage(handles.testImage, handles.cellSize);
predictedLabels = predict(handles.classifier, testFeatures);
disp(class(predictedLabels));
set(handles.PredictedText, 'String', string(predictedLabels));