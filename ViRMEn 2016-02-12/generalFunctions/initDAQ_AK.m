function vr = initDAQ_AK(vr)
% Start the DAQ acquisition
% analog out data is sent to mvData
if ~vr.debugMode
    daqreset; %reset DAQ in case it's still in use by a previous Matlab program
    vr.ai = daq.createSession('ni');
    h1 = vr.ai.addAnalogInputChannel('dev1','ai0','Voltage');
    h1.TerminalConfig = 'SingleEnded';
    h2 = vr.ai.addAnalogInputChannel('dev1','ai1','Voltage');
    h2.TerminalConfig = 'SingleEnded';
    h3 = vr.ai.addAnalogInputChannel('dev1','ai2','Voltage');
    h3.TerminalConfig = 'SingleEnded';
    vr.ai.Rate = 1e3;
    vr.ai.NotifyWhenDataAvailableExceeds=50;
    vr.ai.IsContinuous=1;
    vr.aiListener = vr.ai.addlistener('DataAvailable', @avgMvData);
    startBackground(vr.ai),
    pause(1e-2),
    
    vr.ao = daq.createSession('ni');
    % ao0 for reward delivery
    vr.ao.addAnalogOutputChannel('dev1','ao0','Voltage');
    % ao1 for synchronizing pulses
    vr.ao.addAnalogOutputChannel('dev1','ao1','Voltage');
    vr.ao.Rate = 1e4;
end

end

function avgMvData(src,event)
    global mvData
    mvData = mean(event.Data,1);
end