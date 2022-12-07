function [y, stt] = WebRtcAgc_InitDigital(stt, agcMode, param)
    if (agcMode == param.kAgcModeFixedDigital)
    %        start at minimum to find correct gain faster
        stt.capacitorSlow = 0;
    else
    %       start out with 0 dB gain
        stt.capacitorSlow = 134217728; 
    end
        stt.capacitorFast = 0;
        stt.gain = 65536;
        stt.gatePrevious = 0;
        stt.agcMode = agcMode;
       
        stt.vadNearend = WebRtcAgc_InitVad;
        stt.vadFarend = WebRtcAgc_InitVad;
        y = 0;
end