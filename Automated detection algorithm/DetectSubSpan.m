function subspan=DetectSubSpan(span_i,fd,bound)

%FUNCTION: DETECT SUBSPAN OF REDUCED DELTA WITHIN SPAN
%INPUTS:
% span_i=[minute seccond minute second] start and end time of a span

% fd     Structure array of spectral variables. 
%===========================================================
% Field         Values
% fd.ms        time in form [minute second]
% fd.g         gamma power
% fd.fg        fractional gamma
% fd.lowfreq   delta power 

% bound   Structure array of spectral limits
%============================================================
% Field            Values
% bound.fg         fractiona gamma
% bound.lowfreq    delta power
% bound.g          gamma power


%%extract delta power per slide window within the span
[~,d1]=ismember(span_i(1:2),fd.ms,'rows');
[~,d2]=ismember(span_i(3:4),fd.ms,'rows');


%%detect onset of subspan (cortical switch)
sw=[];
for d=d1:d2
    if fd.lowfreq(d)<bound.lowfreq && fd.lowfreq(d)<fd.lowfreq(d-1)
        sw=fd.ms(d,:);
        break;
    end
end

termi=[];
if ~isempty(sw)
    termi=span_i(3:4);
    [~,d1]=ismember(sw,fd.ms,'rows');
    [~,d2]=ismember(span_i(3:4),fd.ms,'rows');
    lowfreq=fd.lowfreq(d1:d2);
    ms=fd.ms(d1:d2,:);
    for i=2:length(lowfreq)
      if prod(lowfreq(i:end)>bound.lowfreq)
          termi=ms(i-1,:);
          break;
      end
    end
end

subspan=[sw,termi];








    
