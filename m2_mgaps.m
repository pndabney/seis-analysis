function varargout=m2_mgaps(sd,num,d)
% [C,pmis,SData]=M2_MGAPS(sd,num,d)
%
% Takes a time series and creates synthetic gaps
%
% INPUT:
%
% sd               Seismic data array (1-D)
% num              Number of gaps to create
% d                Distribution of gaps
%                  'rgaps' uniformly random distributed gaps
%                  'egaps' evenly distributed gaps
%
% OUTPUT:
%
% C                Cell array of the remaining segments
% pmis             Percentage of missing data
%
% EXAMPLE:
%
% sd = rand(1028,1); num = randi(10); d = 'rgaps';
% [C,pmis,~]=m2_mgaps(sd,num,d);
%
% Last modified by pdabney@princeton.edu 04/10/21

if isstr(d) & d=='rgaps'
    ng = sort(randi([1 length(sd)],1,2*num));
elseif isstr(d) & dist=='egaps'
    % ensure t consists of integers
    ng = round(linspace(1,length(sd),2*num));
end
% Reshape into pairs
g= reshape(ng',2,[])';

% Replace values in of ranges g pairs with NaN
SData = sd;
for k=1:num
    SData(g(k,1):g(k,2))=NaN;
end

% Save data in a cell array
% first segment
C{1} = SData(1:ng(1)-1);
for index = 1:num-1
    C{index+1} = SData(ng(2*index)+1:ng(2*index+1)-1);
end
% last segment
C{num+1} = SData(ng(end)+1:length(sd));
   
% Data check
% difer(nansum(SData)-sum(cat(1,C{:})));

% Calculate the percent of data missing
pmis = ((length(sd)-sum(abs(~isnan(SData))))/length(sd)) * 100;
 

% Create plot
plot(SData);
axis tight;
xlabel('Time (s)');
title('Segmented Data');

% Optional output
varns={C,pmis,SData};
varargout=varns(1:nargout);
end
