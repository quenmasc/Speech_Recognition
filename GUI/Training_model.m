function varargout = Training_model(varargin)
% TRAINING_MODEL MATLAB code for Training_model.fig
%      TRAINING_MODEL, by itself, creates a new TRAINING_MODEL or raises the existing
%      singleton*.
%
%      H = TRAINING_MODEL returns the handle to a new TRAINING_MODEL or the handle to
%      the existing singleton*.
%
%      TRAINING_MODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAINING_MODEL.M with the given input arguments.
%
%      TRAINING_MODEL('Property','Value',...) creates a new TRAINING_MODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Training_model_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Training_model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Training_model

% Last Modified by GUIDE v2.5 28-Mar-2017 10:47:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Training_model_OpeningFcn, ...
                   'gui_OutputFcn',  @Training_model_OutputFcn, ...
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


% --- Executes just before Training_model is made visible.
function Training_model_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Training_model (see VARARGIN)

% Choose default command line output for Training_model

handles.output = hObject;
ps=get(handles.menu_word_list,'String');
pv=get(handles.menu_word_list,'Value');
set(handles.textbox_current_word,'String',ps(pv));
set(handles.textbox_next_word,'String',ps(pv+1));
set(handles.textbox_repetition_2,'String',get(handles.textbox_number_repetition,'String'));
set(handles.textbox_repetition_1,'String',get(handles.textbox_number_repetition,'String'));
set(handles.textbox_instructions,'String','Enter a name in Input Parameters, Please');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Training_model wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Training_model_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_record.
function button_record_Callback(hObject, eventdata, handles)
% hObject    handle to button_record (see GCBO)
%% addpath

global segments Signal Limits Init fs word name test_number features features_w data flag; 
flag=0;
addpath('../Vocal_Activity_Detection_Algorithm');
addpath('../Feature_Extraction');
psp=get(handles.menu_word_list,'String');
pve=get(handles.menu_word_list,'Value');
word =psp(pve);
name=get(handles.textbox_name,'String');
test_number=num2str(-str2double(get(handles.textbox_repetition_1,'String'))+str2double(get(handles.textbox_number_repetition,'String'))+1);
set(handles.textbox_instructions,'String','No speak, I analyze your environment');
[Init]=environment_analysis();
set(handles.textbox_instructions,'String','End of environment recording');
pause(1);
set(handles.textbox_instructions,'String',strcat('Say:~',word,'.'));
[segments,Signal,Limits,fs]=Vocal_algorithm_dectection(Init,str2double(get(handles.textbox_recording_time,'String')),str2double(get(handles.textbox_sample_rate,'String')));
set(handles.textbox_instructions,'String','End of recording');
pause(0.5);
set(handles.textbox_instructions,'String','Begin analysis');
set(handles.textbox_number_segment,'String',num2str(length(segments)));
data=repmat(struct('gender',[],'name',[],'word',[],'test',[],'nature',[],'phoneme',[],'feature',[],'feature_w',[],'segments',[],'classe',[]),1,length(segments));

features=zeros(length(segments),150*39);
features_w=zeros(length(segments),150*39);
for i=1:length(segments)
    [features(i,:),features_w(i,:)]=SetFeactureExtraction(cell2mat(segments(i)),fs,15,5);
end
set(handles.textbox_segment_data,'String',num2str(1));
%%
    time = 0:1/fs:(length(Signal)-1) / fs;
    for i=1:length(segments)
        hold off;
        P1 = plot(time, Signal); set(P1, 'Color', [0.7 0.7 0.7]);    
        hold on;
        for j=1:length(segments)
            if (i~=j)
                timeTemp = Limits(1,j)/fs:1/fs:Limits(2,j)/fs;
                P = plot(timeTemp, segments{j});
                set(P, 'Color', [0.4 0.1 0.1]);
            end
        end
        timeTemp = Limits(1,i)/fs:1/fs:Limits(2,i)/fs;
        P = plot(timeTemp, segments{i});
        set(P, 'Color', [0.9 0.0 0.0]);
        axis([0 time(end) min(Signal) max(Signal)]);
        sound(segments{i}, fs);
        pause(2) ;
    end
    clc
    hold off;
    P1 = plot(time, Signal); set(P1, 'Color', [0.7 0.7 0.7]);    
    hold on;    
    for i=1:length(segments)
        for j=1:length(segments)
            if (i~=j)
                timeTemp = Limits(1,j)/fs:1/fs:Limits(2,j)/fs;
                P = plot(timeTemp, segments{j});
                set(P, 'Color', [0.4 0.1 0.1]);
            end
        end
        axis([0 time(end) min(Signal) max(Signal)]);
    end
    title('Signal vs Segments');
guidata(hObject,handles);
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function textbox_instruction_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_instruction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_instruction as text
%        str2double(get(hObject,'String')) returns contents of textbox_instruction as a double


% --- Executes during object creation, after setting all properties.
function textbox_instruction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_instruction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textbox_current_word_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_current_word (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of textbox_current_word as text
%        str2double(get(hObject,'String')) returns contents of textbox_current_word as a double


% --- Executes during object creation, after setting all properties.
function textbox_current_word_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_current_word (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in button_reset.
function button_reset_Callback(hObject, eventdata, handles)
% hObject    handle to button_reset (see GCBO)
 set(handles.textbox_recording_time,'String',num2str(2));
 set(handles.textbox_sample_rate,'String',num2str(16000));
 set(handles.menu_female_male,'Value',1);
 set(handles.textbox_number_repetition,'String',get(handles.textbox_number_repetition,'String'));
 set(handles.textbox_repetition_1,'String',get(handles.textbox_number_repetition,'String'));
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   



function textbox_recording_time_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_recording_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_recording_time as text
%        str2double(get(hObject,'String')) returns contents of textbox_recording_time as a double


% --- Executes during object creation, after setting all properties.
function textbox_recording_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_recording_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textbox_sample_rate_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_sample_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fs
fs=str2double(get(handles.textbox_sample_rate,'String'));
% Hints: get(hObject,'String') returns contents of textbox_sample_rate as text
%        str2double(get(hObject,'String')) returns contents of textbox_sample_rate as a double


% --- Executes during object creation, after setting all properties.
function textbox_sample_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_sample_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_female_male.
function menu_female_male_Callback(hObject, eventdata, handles)
% hObject    handle to menu_female_male (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_female_male contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_female_male


% --- Executes during object creation, after setting all properties.
function menu_female_male_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_female_male (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textbox_done_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_done as text
%        str2double(get(hObject,'String')) returns contents of textbox_done as a double


% --- Executes during object creation, after setting all properties.
function textbox_done_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_word_list.
function menu_word_list_Callback(hObject, eventdata, handles)
% hObject    handle to menu_word_list (see GCBO)

psge=get(handles.menu_word_list,'String');
pvle=get(handles.menu_word_list,'Value');
set(handles.textbox_current_word,'String',psge(pvle));
if(pvle<length(get(handles.menu_word_list,'String')))
    set(handles.textbox_next_word,'String',psge(pvle+1));
else
    set(handles.textbox_next_word,'String',' ');
end

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_word_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_word_list


% --- Executes during object creation, after setting all properties.
function menu_word_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_word_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textbox_next_word_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_next_word (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_next_word as text
%        str2double(get(hObject,'String')) returns contents of textbox_next_word as a double


% --- Executes during object creation, after setting all properties.
function textbox_next_word_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_next_word (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textbox_repetition_1_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_repetition_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_repetition_1 as text
%        str2double(get(hObject,'String')) returns contents of textbox_repetition_1 as a double


% --- Executes during object creation, after setting all properties.
function textbox_repetition_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_repetition_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textbox_repetition_2_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_repetition_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of textbox_repetition_2 as text
%        str2double(get(hObject,'String')) returns contents of textbox_repetition_2 as a double


% --- Executes during object creation, after setting all properties.
function textbox_repetition_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_repetition_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textbox_number_repetition_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_number_repetition (see GCBO)
set(handles.textbox_repetition_2,'String',get(handles.textbox_number_repetition,'String'));
set(handles.textbox_repetition_1,'String',get(handles.textbox_number_repetition,'String'));
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'String') returns contents of textbox_number_repetition as text
%        str2double(get(hObject,'String')) returns contents of textbox_number_repetition as a double


% --- Executes during object creation, after setting all properties.
function textbox_number_repetition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_number_repetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_play.
function button_play_Callback(hObject, eventdata, handles)
% hObject    handle to button_play (see GCBO)
global fs Signal
fs=str2double(get(handles.textbox_sample_rate,'String'));
soundsc(Signal,fs);
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function textbox_instructions_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_instructions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_instructions as text
%        str2double(get(hObject,'String')) returns contents of textbox_instructions as a double


% --- Executes during object creation, after setting all properties.
function textbox_instructions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_instructions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_stop.
function button_stop_Callback(hObject, eventdata, handles)
% hObject    handle to button_stop (see GCBO)
 clear sound;
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function textbox_number_segment_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_number_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_number_segment as text
%        str2double(get(hObject,'String')) returns contents of textbox_number_segment as a double


% --- Executes during object creation, after setting all properties.
function textbox_number_segment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_number_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_play_segment.
function button_play_segment_Callback(hObject, eventdata, handles)
% hObject    handle to button_play_segment (see GCBO)
global fs segments n ;
n=str2double(get(handles.textbox_current_segment,'String'));
fs=str2double(get(handles.textbox_sample_rate,'String'));
soundsc(cell2mat(segments(n)),fs);
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function textbox_current_segment_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_current_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_current_segment as text
%        str2double(get(hObject,'String')) returns contents of textbox_current_segment as a double


% --- Executes during object creation, after setting all properties.
function textbox_current_segment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_current_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_next.
function button_next_Callback(hObject, eventdata, handles)
% hObject    handle to button_next (see GCBO)
global current segments;
current =str2double( get(handles.textbox_current_segment,'String'));
if ( current < length(segments))
    new=current+1;
    set(handles.textbox_current_segment,'String',num2str(new));
end
    
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_back.
function button_back_Callback(hObject, eventdata, handles)
% hObject    handle to button_back (see GCBO)
global current ;
current =str2double( get(handles.textbox_current_segment,'String'));
if ( current >1)
    new=current-1;
    set(handles.textbox_current_segment,'String',num2str(new));
end
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function textbox_click_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_click as text
%        str2double(get(hObject,'String')) returns contents of textbox_click as a double


% --- Executes during object creation, after setting all properties.
function textbox_click_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_data.
function button_data_Callback(hObject, eventdata, handles)
% hObject    handle to button_data (see GCBO)
    global Signal fs  data name test_number word segments flag;
    set(handles.textbox_instructions,'String','Signal backup is in progress');
    pause(0.5);
    
    a=strcat('../Data/sound/all_speech/',name,'_test_',test_number,'_',strjoin(word),'.wav');
    fn=fullfile('../Data/sound/all_speech/');
    if ~exist(fn,'dir')
        mkdir(fn);
    end
    audiowrite([a],Signal,fs,'BitsPerSample',16);
    set(handles.textbox_instructions,'String','Signal saved');
    pause(0.5);
    set(handles.textbox_instructions,'String','Segments backup is in progress');
    pause(1);
    for i=1:length(segments)
        local_feature=data(i).feature;
        local_feature_w=data(i).feature_w;
        local_classe=data(i).classe;
        local_gender=data(i).gender;
        switch data(i).nature
            case 'Voice'
        a=strcat('../Data/sound/',data(i).name,'/',strjoin(data(i).word),'/',data(i).phoneme,'/',data(i).name,'_test_',data(i).test,'_',data(i).phoneme,'.wav');
        %% check folder
        fn=fullfile(strcat('../Data/sound/',data(i).name,'/',strjoin(data(i).word),'/',data(i).phoneme));
        if ~exist(fn)
            mkdir(fn) ;
        end
        
        %% save
        audiowrite([a],cell2mat(data(i).segments),fs,'BitsPerSample',16);
        
        %% save segments
        b=strcat('../Data/features/features_saved/',data(i).name,'/',strjoin(data(i).word),'/',data(i).phoneme,'/',data(i).name,'_test_',data(i).test,'_',data(i).phoneme,'.mat');
        c=strcat('../Data/features/features_saved/ALL/',data(i).name,'_test_',data(i).test,'_',data(i).phoneme,'.mat');
        e=strcat('../Data/features/features_filtered/',data(i).name,'/',strjoin(data(i).word),'/',data(i).phoneme,'/',data(i).name,'_test_',data(i).test,'_',data(i).phoneme,'.mat');
        f=strcat('../Data/features/features_filtered/ALL/',data(i).name,'_test_',data(i).test,'_',data(i).phoneme,'.mat');
        %% check if folders exist
        fn=fullfile(strcat('../Data/features/features_saved/',data(i).name,'/',strjoin(data(i).word),'/',data(i).phoneme));
        if ~exist(fn,'dir')
            mkdir (fn);
        end
        fn=fullfile(strcat('../Data/features/features_saved/ALL'));
        if ~exist(fn,'dir')
            mkdir (fn);
        end
        fn=fullfile(strcat('../Data/features/features_filtered/',data(i).name,'/',strjoin(data(i).word),'/',data(i).phoneme));
        if ~exist(fn,'dir')
            mkdir (fn);
        end
        fn=fullfile(strcat('../Data/features/features_filtered/ALL'));
        if ~exist(fn,'dir')
            mkdir (fn);
        end
        %% back up
        save([b],'local_feature','local_classe','local_gender');
        save([c],'local_feature','local_classe','local_gender');
        save([e],'local_feature_w','local_classe','local_gender');
        save([f],'local_feature_w','local_classe','local_gender');
            case 'Noise'
        a=strcat('../Data/sound/',data(i).name,'/Noise/',data(i).phoneme,'/',name,'_test_',test_number,'_',data(i).phoneme,'.wav');
        %% check folder
        fn=fullfile(strcat('../Data/sound/',data(i).name,'/Noise/',data(i).phoneme));
        if ~exist(fn)
            mkdir (fn) ;
        end
        %% save 
        audiowrite(a,cell2mat(data(i).segments),fs,'BitsPerSample',16);
        b=strcat('../Data/features/features_saved/',data(i).name,'/Noise/',data(i).phoneme,'/',name,'_test_',test_number,'_',strjoin(data(i).word),'_',data(i).phoneme,'.mat');
        c=strcat('../Data/features/features_saved/ALL/',data(i).name,'_test_',data(i).test,'_',strjoin(data(i).word),'_',data(i).phoneme,'.mat');
        e=strcat('../Data/features/features_filtered/',data(i).name,'/Noise/',data(i).phoneme,'/',name,'_test_',test_number,'_',strjoin(data(i).word),'_',data(i).phoneme,'.mat');
        f=strcat('../Data/features/features_filtered/ALL/',data(i).name,'_test_',data(i).test,'_',strjoin(data(i).word),'_',data(i).phoneme,'.mat');
       
        %% check if folders exist
        fn=fullfile(strcat('../Data/features/features_saved/',data(i).name,'/Noise/',data(i).phoneme));
        if ~exist(fn)
            mkdir (fn) ;
        end
        fn =fullfile(strcat('../Data/features/features_saved/ALL'));
        if ~exist(fn)
            mkdir(fn);
        end
        fn=fullfile(strcat('../Data/features/features_filtered/',data(i).name,'/Noise/',data(i).phoneme));
        if ~exist(fn)
            mkdir (fn) ;
        end
        fn =fullfile(strcat('../Data/features/features_filtered/ALL'));
        if ~exist(fn)
            mkdir(fn);
        end
        %% back up
        save([b],'local_feature','local_classe','local_gender');
        save([c],'local_feature','local_classe','local_gender');
        save([e],'local_feature_w','local_classe','local_gender');
        save([f],'local_feature_w','local_classe','local_gender');
        end 
        set(handles.textbox_instructions,'String',strcat('Segments~',num2str(i),' done'));
        pause(0.5);
    end
    set(handles.textbox_instructions,'String',strcat('All segments saved, you can do another test'));
    remaining=str2double(get(handles.textbox_repetition_1,'String'));
    word_num=get(handles.menu_word_list,'Value');
    if(remaining>1)
        set(handles.textbox_repetition_1,'String',num2str(remaining-1));
    else
        pop_value=get(handles.menu_word_list,'Value');
        if (pop_value==length(get(handles.menu_word_list,'String')))
            set(handles.textbox_instructions,'String','End of training, thank you !!');
            set(handles.button_data,'Visible','Off');
            display(pop_value);
            return ;
        else
            set(handles.textbox_repetition_1,'String',get(handles.textbox_repetition_2,'String'));
            set(handles.menu_word_list,'Value',word_num+1);
            pop_string=get(handles.menu_word_list,'String');
            set(handles.textbox_current_word,'String',pop_string(pop_value));
            set(handles.textbox_next_word,'String',pop_string(pop_value+1));
        end
    end
    set(handles.button_data,'Visible','Off');
    set(handles.button_record,'BackgroundColor','red');

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function textbox_segment_data_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_segment_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        
% Hints: get(hObject,'String') returns contents of textbox_segment_data as text
%        str2double(get(hObject,'String')) returns contents of textbox_segment_data as a double


% --- Executes during object creation, after setting all properties.
function textbox_segment_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_segment_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_nature.
function menu_nature_Callback(hObject, eventdata, handles)
% hObject    handle to menu_nature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_nature contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_nature


% --- Executes during object creation, after setting all properties.
function menu_nature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_nature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_voice_noise.
function menu_voice_noise_Callback(hObject, eventdata, handles)
% hObject    handle to menu_voice_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    pop_string=get(handles.menu_word_list,'String');
    pop_value=get(handles.menu_word_list,'Value');
    worde =strjoin(pop_string(pop_value));
    pop_s=get(handles.menu_voice_noise,'String');
    pop_v=get(handles.menu_voice_noise,'Value');
    if (pop_v~=0 && pop_v<=length(pop_s))
        labele=strjoin(pop_s(pop_v));
    else
        labele=strjoin(pop_s(length(pop_s)));
    end
    switch labele 
        case 'Choose'
            set(handles.menu_label,'Value',1);
            set(handles.menu_label,'String',{'Choose nature'});
        case 'Noise'
            set(handles.menu_label,'Value',1);
            set(handles.menu_label,'String',{'Background noise';'Clip'});
        case 'Voice'
            switch worde
                case 'BACKWARD'
                    set(handles.menu_label,'Value',1);
                    set(handles.menu_label,'String',{'BACK';'WARD';'DE';'BACKWARD';'OTHER'});
                case 'FORWARD'
                    set(handles.menu_label,'Value',1);
                    set(handles.menu_label,'String',{'FOR';'WARD';'DE';'FORWARD';'OTHER'});
                case 'GOTO'
                    set(handles.menu_label,'Value',1);
                    set(handles.menu_label,'String',{'GO';'TO';'GOTO';'OTHER'});
                case 'LEFT'
                    set(handles.menu_label,'Value',1);
                    set(handles.menu_label,'String',{'LEF';'FT';'LEFT';'OTHER'});
                case 'RIGHT'
                    set(handles.menu_label,'Value',1);
                    set(handles.menu_label,'String',{'RI';'GHT';'RIGHT';'OTHER'});
                case 'READY'
                    set(handles.menu_label,'Value',1);
                    set(handles.menu_label,'String',{'READ';'DY';'READY';'OTHER'});
                case 'MODE'
                    set(handles.menu_label,'Value',1);
                    set(handles.menu_label,'String',{'MOD';'DE';'MODE';'OTHER'});    
                otherwise 
                    set(handles.menu_label,'Value',1);
                    set(handles.menu_label,'String','Choose');  
            end  
        otherwise 
            set(handles.menu_label,'Value',1);
            set(handles.menu_label,'String','Choose');
            
    end

% Hints: contents = cellstr(get(hObject,'String')) returns menu_voice_noise contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_voice_noise


% --- Executes during object creation, after setting all properties.
function menu_voice_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_voice_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_label.
function menu_label_Callback(hObject, eventdata, handles)
% hObject    handle to menu_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%
    pop_string=get(handles.menu_label,'String');
    pop_value=get(handles.menu_label,'Value');
    other =strjoin(pop_string(pop_value));
    switch other
        case 'OTHER'
            set(handles.textbox_other_label,'Visible','On');
            set(handles.text40,'Visible','On');
        otherwise
            set(handles.textbox_other_label,'Visible','Off');
            set(handles.text40,'Visible','Off');
    end
%% 
% Hints: contents = cellstr(get(hObject,'String')) returns menu_label contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_label


% --- Executes during object creation, after setting all properties.
function menu_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textbox_other_label_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_other_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

       
% Hints: get(hObject,'String') returns contents of textbox_other_label as text
%        str2double(get(hObject,'String')) returns contents of textbox_other_label as a double


% --- Executes during object creation, after setting all properties.
function textbox_other_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_other_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_next_data.
function button_back_data_Callback(hObject, eventdata, handles)
% hObject    handle to button_next_data (see GCBO)
    current =str2double( get(handles.textbox_segment_data,'String'));
    if ( current >1)
        new=current-1;
        set(handles.textbox_segment_data,'String',num2str(new));
    end
    set(handles.menu_voice_noise,'Value',1);
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_back_data.
function button_next_data_Callback(hObject, eventdata, handles)
% hObject    handle to button_back_data (see GCBO)
    global segments name word test_number data features features_w ;
    pop_s=get(handles.menu_voice_noise,'String');
    pop_v=get(handles.menu_voice_noise,'Value');
    noise_voice=strjoin(pop_s(pop_v));
    pop_string=get(handles.menu_label,'String');
    pop_value=get(handles.menu_label,'Value');
    phoneme=strjoin(pop_string(pop_value));
    pop_f_m_s=get(handles.menu_female_male,'String');
    pop_f_m_v=get(handles.menu_female_male,'Value');
    fem_mal=strjoin(pop_f_m_s(pop_f_m_v));
    curent =str2double( get(handles.textbox_segment_data,'String'));
    if(curent==length(segments))
         set(handles.button_data,'Visible','On');
         set(handles.menu_voice_noise,'Value',1);
    end
    if ( curent <length(segments))
        new=curent+1;
        set(handles.textbox_segment_data,'String',num2str(new));
        set(handles.menu_voice_noise,'Value',1);
    end
    switch phoneme
        case 'BACK'
            classe=1;
        case 'WARD'
            classe=2;
        case 'BACKWARD'
            classe=3;
        case 'FOR'
            classe=4;
        case 'FORWARD'
            classe=5;
        case 'LEF'
            classe=6;
        case 'FT'
            classe=7;
        case 'LEFT'
            classe=8;
        case 'RI'
            classe=9;
        case 'GHT'
            classe=10;
        case 'RIGHT'
            classe=11;
        case 'REA'
            classe=12;
        case 'DY'
            classe=13;
        case 'READY'
            classe=14;
        case 'MOD'
            classe=15;
        case 'DE'
            classe=16;
        case 'MODE'
            classe=17;
        case 'Background noise'
            classe=18;
        case 'clip'
            classe=19;
        case 'GO'
            classe=21;
        case 'TO'
            classe=22;
        case 'GOTO'
            classe=23;
        otherwise
            classe=20;
    end
    switch fem_mal
        case 'Female'
            gen=1;
        case 'Male'
            gen=2;
        otherwise 
            gen=3;
    end
    data(curent).gender=gen;
    data(curent).name=name;
    data(curent).word=word;
    data(curent).test=test_number;
    data(curent).nature=noise_voice;
    data(curent).phoneme=phoneme;
    data(curent).feature=features(curent,:);
    data(curent).feature_w=features_w(curent,:);
    data(curent).segments=segments(curent);
    data(curent).classe=classe;

    
    guidata(hObject,handles);
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function textbox_name_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    a=get(handles.textbox_name,'String');
    switch a
        case 'enter a name ...'
            set(handles.textbox_instructions,'String','No name, try again');
        otherwise
            set(handles.textbox_instructions,'String','You can record now');
            set(handles.button_record,'Visible','On');
    end
% Hints: get(hObject,'String') returns contents of textbox_name as text
%        str2double(get(hObject,'String')) returns contents of textbox_name as a double


% --- Executes during object creation, after setting all properties.
function textbox_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_leave.
function button_leave_Callback(hObject, eventdata, handles)
% hObject    handle to button_leave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close all;
