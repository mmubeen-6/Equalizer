function varargout = Equalizer(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Equalizer_OpeningFcn, ...
                   'gui_OutputFcn',  @Equalizer_OutputFcn, ...
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


% --- Executes just before Equalizer is made visible.
function Equalizer_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Equalizer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Equalizer_OutputFcn(hObject, eventdata, handles) 
    global G;
    G = [0 0 0 0 0 0 0 0 0 0];
    set(handles.text8,'String',strcat(num2str(G(1)),' dB'))
    set(handles.text10,'String',strcat(num2str(G(2)),' dB'))
    set(handles.text12,'String',strcat(num2str(G(3)),' dB'))
    set(handles.text14,'String',strcat(num2str(G(4)),' dB'))
    set(handles.text16,'String',strcat(num2str(G(5)),' dB'))
    set(handles.text18,'String',strcat(num2str(G(6)),' dB'))
    set(handles.text20,'String',strcat(num2str(G(7)),' dB'))
    set(handles.text22,'String',strcat(num2str(G(8)),' dB'))
    set(handles.text24,'String',strcat(num2str(G(9)),' dB'))
    set(handles.text26,'String',strcat(num2str(G(10)),' dB'))
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;


function playFile_Callback(hObject, eventdata, handles)
    global Fs hafr hap volume stopPlaying G b_eq a_eq;
    stopPlaying = false;
    
    count = 0;
    
    while ~isDone(hafr)
        count = count + 1;
        if(stopPlaying == true)
            break
        end
        
        %Getting Gains
        G(1) = get(handles.freq1, 'value');
        G(2) = get(handles.slider3, 'value');
        G(3) = get(handles.slider4, 'value');
        G(4) = get(handles.slider5, 'value');
        G(5) = get(handles.slider6, 'value');
        G(6) = get(handles.slider7, 'value');
        G(7) = get(handles.slider8, 'value');
        G(8) = get(handles.slider9, 'value');
        G(9) = get(handles.slider10, 'value');
        G(10) = get(handles.slider11, 'value');

        audio = step(hafr);
    
        %Seperating the channals of audio
        audio_leftchannel = audio(:, 1);
        audio_rightchannel = audio(:, 2);

        %Getting Filter coeffecients
        [b_filter1, a_filter1] = filter_1(G(1), 60, Fs); 
        [b_filter2, a_filter2] = peaking(G(2), 170, Fs);
        [b_filter3, a_filter3] = peaking(G(3), 310, Fs);
        [b_filter4, a_filter4] = peaking(G(4), 600, Fs);
        [b_filter5, a_filter5] = peaking(G(5), 1000, Fs);
        [b_filter6, a_filter6] = peaking(G(6), 3000, Fs);
        [b_filter7, a_filter7] = peaking(G(7), 6000, Fs);
        [b_filter8, a_filter8] = peaking(G(8), 12000, Fs);
        [b_filter9, a_filter9] = peaking(G(9), 14000, Fs);
        [b_filter10, a_filter10] = filter_10(G(10), 16000, Fs);
        
        b_eq = [];
        b_eq = conv(b_filter1,b_filter2);
        b_eq = conv(b_eq,b_filter3);
        b_eq = conv(b_eq,b_filter4);
        b_eq = conv(b_eq,b_filter5);
        b_eq = conv(b_eq,b_filter6);
        b_eq = conv(b_eq,b_filter7);
        b_eq = conv(b_eq,b_filter8);
        b_eq = conv(b_eq,b_filter9);
        b_eq = conv(b_eq,b_filter10);
        
        a_eq = [];
        a_eq = conv(a_filter1,a_filter2);
        a_eq = conv(a_eq,a_filter3);
        a_eq = conv(a_eq,a_filter4);
        a_eq = conv(a_eq,a_filter5);
        a_eq = conv(a_eq,a_filter6);
        a_eq = conv(a_eq,a_filter7);
        a_eq = conv(a_eq,a_filter8);
        a_eq = conv(a_eq,a_filter9);
        a_eq = conv(a_eq,a_filter10);
        
        if (G(1) ~= 0)
            left_apply1 = filter(b_filter1, a_filter1, audio_leftchannel);
            right_apply1 = filter(b_filter1, a_filter1, audio_rightchannel);
        else
            left_apply1 = audio_leftchannel;
            right_apply1 = audio_rightchannel;
        end
        
        if (G(2) ~= 0)
            left_apply2 = filter(b_filter2, a_filter2, left_apply1);
            right_apply2 = filter(b_filter2, a_filter2, right_apply1);
        else
            left_apply2 = left_apply1;
            right_apply2 = right_apply1;
        end
        
        if (G(3) ~= 0)
            left_apply3 = filter(b_filter3, a_filter3, left_apply2);
            right_apply3 = filter(b_filter3, a_filter3, right_apply2);
        else
            left_apply3 = left_apply2;
            right_apply3 = right_apply2;
        end
        
        if (G(4) ~= 0)
            left_apply4 = filter(b_filter4, a_filter4, left_apply3);
            right_apply4 = filter(b_filter4, a_filter4, right_apply3);
        else
            left_apply4 = left_apply3;
            right_apply4 = right_apply3;
        end
        
        if (G(5) ~= 0)
            left_apply5 = filter(b_filter5, a_filter5, left_apply4);
            right_apply5 = filter(b_filter5, a_filter5, right_apply4);
        else
            left_apply5 = left_apply4;
            right_apply5 = right_apply4;
        end
        
        if (G(6) ~= 0)
            left_apply6 = filter(b_filter6, a_filter6, left_apply5);
            right_apply6 = filter(b_filter6, a_filter6, right_apply5);
        else
            left_apply6 = left_apply5;
            right_apply6 = right_apply5;
        end
        
        if (G(7) ~= 0)
            left_apply7 = filter(b_filter7, a_filter7, left_apply6);
            right_apply7 = filter(b_filter7, a_filter7, right_apply6);
        else
            left_apply7 = left_apply6;
            right_apply7 = right_apply6;
        end
        
        if (G(8) ~= 0)
            left_apply8 = filter(b_filter8, a_filter8, left_apply7);
            right_apply8 = filter(b_filter8, a_filter8, right_apply7);
        else
            left_apply8 = left_apply7;
            right_apply8 = right_apply7;
        end
        
        if (G(9) ~= 0)
            left_apply9 = filter(b_filter9, a_filter9, left_apply8);
            right_apply9 = filter(b_filter9, a_filter9, right_apply8);
        else
            left_apply9 = left_apply8;
            right_apply9 = right_apply8;
        end
        
        if (G(10) ~= 0)
            left_apply10 = filter(b_filter10, a_filter10, left_apply9);
            right_apply10 = filter(b_filter10, a_filter10, right_apply9);
        else
            left_apply10 = left_apply9;
            right_apply10 = right_apply9;
        end
        
        volume = get(handles.volumeSet,'Value');
        set(handles.volumeSet,'string',num2str(volume,3));
        
        audio_mod = [left_apply10 right_apply10];
        audio_mod = audio_mod * volume;
        step(hap,audio_mod);
        
        if(mod(count,1) == 0)
            axes(handles.time_axis);
            t = linspace(0,0.0001,length(audio_mod));
            plot(t,audio_mod(:,1));
            grid on
            xlim([t(1) t(end)])
            title('Time Plot');	 	 
            xlabel('time (s)')	 	 
            ylabel('Audio Signal');
            
            axes(handles.freq_axis);
            NFFT=1024;	 	 
            X = fftshift(fft(audio_mod,NFFT));	 	 
            fVals = Fs*(-NFFT/2:NFFT/2-1)/NFFT;
            plot(fVals,abs(X),'b');
            xlim([0 18000])
            ylim auto
            grid on
            title('Single Sided FFT');	 	 
            xlabel('Frequency (Hz)')	 	 
            ylabel('|DFT Values|');
            
            set(handles.text27,'Visible', 'off')
            set(handles.text28,'Visible', 'off')
            
        end
        pause(0.0001);
    end  
   
  

function stopFile_Callback(hObject, eventdata, handles)
	global stopPlaying
    stopPlaying = true;
    

function clearFile_Callback(hObject, eventdata, handles)
    clear all
    set(handles.text2,'String','No File Loaded')
    



function loadFile_Callback(hObject, eventdata, handles)
    global FileName Fs hafr hap
    [FileName,PathName] = uigetfile('.wav');
    [y,Fs] = audioread(FileName);
    hafr = dsp.AudioFileReader('Filename',FileName,'SamplesPerFrame',65536);
    hap = dsp.AudioPlayer('SampleRate',Fs);
    set(handles.text2,'String',strcat(FileName,' loaded.'))


 
% --- Executes on slider movement.
function volumeSet_Callback(hObject, eventdata, handles)
    global y
    val = get(hObject,'value');
    y = y*val;
    a=get(hObject,'Value');
    set(handles.text5,'string',num2str(a,3));

% --- Executes during object creation, after setting all properties.
function volumeSet_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function freq1_Callback(hObject, eventdata, handles)
    a = get(hObject,'Value');
    set(handles.text8,'string',strcat(num2str(a,3),' dB'));


% --- Executes during object creation, after setting all properties.
function freq1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
    a = get(hObject,'Value');
    set(handles.text10,'string',strcat(num2str(a,3),' dB'));

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
    a = get(hObject,'Value');
    set(handles.text12,'string',strcat(num2str(a,3),' dB'));

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
    a = get(hObject,'Value');
    set(handles.text14,'string',strcat(num2str(a,3),' dB'));


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
    a = get(hObject,'Value');
    set(handles.text16,'string',strcat(num2str(a,3),' dB'));


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
    a = get(hObject,'Value');
    set(handles.text18,'string',strcat(num2str(a,3),' dB'));


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
    a = get(hObject,'Value');
    set(handles.text20,'string',strcat(num2str(a,3),' dB'));

   
% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
    a = get(hObject,'Value');
    set(handles.text22,'string',strcat(num2str(a,3),' dB'));


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
    a = get(hObject,'Value');
    set(handles.text24,'string',strcat(num2str(a,3),' dB'));


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
    a = get(hObject,'Value');
    set(handles.text26,'string',strcat(num2str(a,3),' dB'));

    
% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 


% --- Executes on button press in pop.
function pop_Callback(hObject, eventdata, handles)
    G = [-1.5 -1.2 0 1.7 4 4 1.7 0 -1.3 -1.4];
    
    set(handles.freq1, 'value',G(1));
    set(handles.slider3, 'value',G(2));
    set(handles.slider4, 'value',G(3));
    set(handles.slider5, 'value',G(4));
    set(handles.slider6, 'value',G(5));
    set(handles.slider7, 'value',G(6));
    set(handles.slider8, 'value',G(7));
    set(handles.slider9, 'value',G(8));
    set(handles.slider10, 'value',G(9));
    set(handles.slider11, 'value',G(10));

    set(handles.text8,'String',strcat(num2str(G(1)),' dB'))
    set(handles.text10,'String',strcat(num2str(G(2)),' dB'))
    set(handles.text12,'String',strcat(num2str(G(3)),' dB'))
    set(handles.text14,'String',strcat(num2str(G(4)),' dB'))
    set(handles.text16,'String',strcat(num2str(G(5)),' dB'))
    set(handles.text18,'String',strcat(num2str(G(6)),' dB'))
    set(handles.text20,'String',strcat(num2str(G(7)),' dB'))
    set(handles.text22,'String',strcat(num2str(G(8)),' dB'))
    set(handles.text24,'String',strcat(num2str(G(9)),' dB'))
    set(handles.text26,'String',strcat(num2str(G(10)),' dB'))
        


% --- Executes on button press in rock.
function rock_Callback(hObject, eventdata, handles)
    G = [4.6 4.4 2.9 1.3 -1.1 -1.2 0.5 2 3.5 4.3];

    set(handles.freq1, 'value',G(1));
    set(handles.slider3, 'value',G(2));
    set(handles.slider4, 'value',G(3));
    set(handles.slider5, 'value',G(4));
    set(handles.slider6, 'value',G(5));
    set(handles.slider7, 'value',G(6));
    set(handles.slider8, 'value',G(7));
    set(handles.slider9, 'value',G(8));
    set(handles.slider10, 'value',G(9));
    set(handles.slider11, 'value',G(10));

    set(handles.text8,'String',strcat(num2str(G(1)),' dB'))
    set(handles.text10,'String',strcat(num2str(G(2)),' dB'))
    set(handles.text12,'String',strcat(num2str(G(3)),' dB'))
    set(handles.text14,'String',strcat(num2str(G(4)),' dB'))
    set(handles.text16,'String',strcat(num2str(G(5)),' dB'))
    set(handles.text18,'String',strcat(num2str(G(6)),' dB'))
    set(handles.text20,'String',strcat(num2str(G(7)),' dB'))
    set(handles.text22,'String',strcat(num2str(G(8)),' dB'))
    set(handles.text24,'String',strcat(num2str(G(9)),' dB'))
    set(handles.text26,'String',strcat(num2str(G(10)),' dB'))
        


% --- Executes on button press in bass.
function bass_Callback(hObject, eventdata, handles)
    G = [5.7 4.3 3.1 2.9 1.3 0 0 0 0 0];

    set(handles.freq1, 'value',G(1));
    set(handles.slider3, 'value',G(2));
    set(handles.slider4, 'value',G(3));
    set(handles.slider5, 'value',G(4));
    set(handles.slider6, 'value',G(5));
    set(handles.slider7, 'value',G(6));
    set(handles.slider8, 'value',G(7));
    set(handles.slider9, 'value',G(8));
    set(handles.slider10, 'value',G(9));
    set(handles.slider11, 'value',G(10));

    set(handles.text8,'String',strcat(num2str(G(1)),' dB'))
    set(handles.text10,'String',strcat(num2str(G(2)),' dB'))
    set(handles.text12,'String',strcat(num2str(G(3)),' dB'))
    set(handles.text14,'String',strcat(num2str(G(4)),' dB'))
    set(handles.text16,'String',strcat(num2str(G(5)),' dB'))
    set(handles.text18,'String',strcat(num2str(G(6)),' dB'))
    set(handles.text20,'String',strcat(num2str(G(7)),' dB'))
    set(handles.text22,'String',strcat(num2str(G(8)),' dB'))
    set(handles.text24,'String',strcat(num2str(G(9)),' dB'))
    set(handles.text26,'String',strcat(num2str(G(10)),' dB'))
        


% --- Executes on button press in treble.
function treble_Callback(hObject, eventdata, handles)
    G = [0,0,0,0,0,0,0,0,0,0];

    set(handles.freq1, 'value',G(1));
    set(handles.slider3, 'value',G(2));
    set(handles.slider4, 'value',G(3));
    set(handles.slider5, 'value',G(4));
    set(handles.slider6, 'value',G(5));
    set(handles.slider7, 'value',G(6));
    set(handles.slider8, 'value',G(7));
    set(handles.slider9, 'value',G(8));
    set(handles.slider10, 'value',G(9));
    set(handles.slider11, 'value',G(10));

    set(handles.text8,'String',strcat(num2str(G(1)),' dB'))
    set(handles.text10,'String',strcat(num2str(G(2)),' dB'))
    set(handles.text12,'String',strcat(num2str(G(3)),' dB'))
    set(handles.text14,'String',strcat(num2str(G(4)),' dB'))
    set(handles.text16,'String',strcat(num2str(G(5)),' dB'))
    set(handles.text18,'String',strcat(num2str(G(6)),' dB'))
    set(handles.text20,'String',strcat(num2str(G(7)),' dB'))
    set(handles.text22,'String',strcat(num2str(G(8)),' dB'))
    set(handles.text24,'String',strcat(num2str(G(9)),' dB'))
    set(handles.text26,'String',strcat(num2str(G(10)),' dB'))
        


% --- Executes on button press in jazz.
function jazz_Callback(hObject, eventdata, handles)
    G = [4 2.7 1.4 1.9 -1.5 -1.5 0 1.5 3 3.7];
    set(handles.freq1, 'value',G(1));
    set(handles.slider3, 'value',G(2));
    set(handles.slider4, 'value',G(3));
    set(handles.slider5, 'value',G(4));
    set(handles.slider6, 'value',G(5));
    set(handles.slider7, 'value',G(6));
    set(handles.slider8, 'value',G(7));
    set(handles.slider9, 'value',G(8));
    set(handles.slider10, 'value',G(9));
    set(handles.slider11, 'value',G(10));

    set(handles.text8,'String',strcat(num2str(G(1)),' dB'))
    set(handles.text10,'String',strcat(num2str(G(2)),' dB'))
    set(handles.text12,'String',strcat(num2str(G(3)),' dB'))
    set(handles.text14,'String',strcat(num2str(G(4)),' dB'))
    set(handles.text16,'String',strcat(num2str(G(5)),' dB'))
    set(handles.text18,'String',strcat(num2str(G(6)),' dB'))
    set(handles.text20,'String',strcat(num2str(G(7)),' dB'))
    set(handles.text22,'String',strcat(num2str(G(8)),' dB'))
    set(handles.text24,'String',strcat(num2str(G(9)),' dB'))
    set(handles.text26,'String',strcat(num2str(G(10)),' dB'))
        


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
    G = [0,0,0,0,0,0,0,0,0,0];
    set(handles.freq1, 'value',G(1));
    set(handles.slider3, 'value',G(2));
    set(handles.slider4, 'value',G(3));
    set(handles.slider5, 'value',G(4));
    set(handles.slider6, 'value',G(5));
    set(handles.slider7, 'value',G(6));
    set(handles.slider8, 'value',G(7));
    set(handles.slider9, 'value',G(8));
    set(handles.slider10, 'value',G(9));
    set(handles.slider11, 'value',G(10));

    set(handles.text8,'String',strcat(num2str(G(1)),' dB'))
    set(handles.text10,'String',strcat(num2str(G(2)),' dB'))
    set(handles.text12,'String',strcat(num2str(G(3)),' dB'))
    set(handles.text14,'String',strcat(num2str(G(4)),' dB'))
    set(handles.text16,'String',strcat(num2str(G(5)),' dB'))
    set(handles.text18,'String',strcat(num2str(G(6)),' dB'))
    set(handles.text20,'String',strcat(num2str(G(7)),' dB'))
    set(handles.text22,'String',strcat(num2str(G(8)),' dB'))
    set(handles.text24,'String',strcat(num2str(G(9)),' dB'))
    set(handles.text26,'String',strcat(num2str(G(10)),' dB'))
        


% --- Executes on button press in plotResponse.
function plotResponse_Callback(hObject, eventdata, handles)
    global b_eq a_eq Fs
    b_eq;
    a_eq;
    fh = figure();
    [h,w] = freqz(b_eq,a_eq);
    w = linspace(0,16000,length(w));
    plot(w,20*log10(abs(h)))
    ylim([-30 30]);
    title('Impulse Response of Filter')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
    
%     freqz(b_eq,a_eq)
