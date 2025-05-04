function fd=SpectralVariable(S,params)
%CALCULATE SPECTRAL VARIABLES
%INPUTS:
%S             (spectrogram in form time x frequency)
%params        (parameters for each model)
%OUTPUTS:
%fd            (structure array of spectral variables)
%fd.ms         (time in form [minute second])
%fd.fg         (fractional gamma)
%fd.lowfreq    (delta power)
%fd.g          (gamma power)
%fd.theta      (theta frequency)
%fd.theta amp  (theta amplitude)

fd.ms=transtime(0:size(S,1)-1);
fd.fg=FractionalGamma(S);
fd.lowfreq=DeltaPower(S);

[theta_f,theta_amp]=getTheta(S);
fd.theta=smooth(theta_f,3);
fd.theta_amp=theta_amp;
fd.g=smooth(GammaPower(S,params),3);






