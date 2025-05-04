function bound=SpectralLimit(fd,intrachannel)

%CALCULATE SPECTRAL LIMITS
%INPUTS:
%fd             (spectral variables)
%intrachannel   (timepoints containing intra channel artifacts)

%OUTPUTs:
%bound          (structure array of spectral limits)
%bound.fg       (fractional gamma first limit)
%bound.fg2      (fractional gamma second limit)
%bound.lowfreq  (delta limit)
%bound.g        (gamma limit)


%mute timepoints containing intra channel artifacts
fd.fg(intrachannel)=[];
fd.g(intrachannel)=[];
fd.lowfreq(intrachannel)=[];

bound.fg=nanmean(fd.fg);
bound.fg2=nanmean(fd.fg)+mad(fd.fg);
bound.lowfreq=min([1.5,nanmean(fd.lowfreq)]);
bound.g=max([0,nanmean(fd.g)+1]);
if bound.g>2.5
    bound.g=2.5;
end
































