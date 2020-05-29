% Data = ReadSSAFile(fname)
%   by Mike, Spring 2020
%
% This function reads the SnowEx SSA formatted csv files

function Data=ReadSSAFile(fname,Format)

fid=fopen(fname,'r');
Data.FileName=''; %annoying. should switch to class to avoid initializing
[Data.Hdr,Data.HdrLines]=ReadHeader(fid,Format);

l=0;
while ~feof(fid)
    l=l+1;    
    [Data.Voltage(l),Data.Reflectance(l),Data.SSA(l),Data.Depth(l),Data.Do(l),Data.Comments{l},Data.DataLines{l}]=ReadDataLine(fid);
end

fclose(fid);

return

function [Hdr,Lines]=ReadHeader(fid,Format)

%note: this relies on the order of data and number of lines in the header staying the same. 

% the CommaTrim commands can be removed if these are all removed from the
% .csv files

switch Format
    case '2017'
        Lines={};

        i=1; [Hdr.t,Lines{i}]=ReadDateAndTime(fid,Format);
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},':'); Hdr.FieldCampaignName=strtrim(temp{2}); Hdr.FieldCampaignName=CommaTrim(Hdr.FieldCampaignName);
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},':'); Hdr.SampleID=strtrim(temp{2}); Hdr.SampleID=CommaTrim(Hdr.SampleID);

        a=strsplit(Hdr.SampleID,' '); Hdr.PitID=a{1}; Hdr.PitID=CommaTrim(Hdr.PitID);

        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},':'); Hdr.UTMN=str2double(temp{2}); 
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},':'); Hdr.UTME=str2double(temp{2});
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},':'); Hdr.UTMZone=strtrim(temp{2}); Hdr.UTMZone=CommaTrim(Hdr.UTMZone);
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},':'); Hdr.Instrument=strtrim(temp{2}); Hdr.Instrument=CommaTrim(Hdr.Instrument);
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},':'); Hdr.Operator=strtrim(temp{2}); Hdr.Operator=CommaTrim(Hdr.Operator);
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},':'); Hdr.Timing=strtrim(temp{2}); Hdr.Timing=CommaTrim(Hdr.Timing);
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},':'); Hdr.Notes=strtrim(temp{2});  Hdr.Notes=CommaTrim(Hdr.Notes);
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},':'); Hdr.SnowDepth_cm=str2double(temp{2});

        fgetl(fid); fgetl(fid); 
    case '2020'
        Lines={};

        i=1;   Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.Location=temp{2};
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.PitID=temp{2}; %called "location" in the SnowEx format
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.LongPitID=temp{2}; %called "location" in the SnowEx format
        i=1+1; [Hdr.t,Lines{i}]=ReadDateAndTime(fid,Format);
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.UTMZone=temp{2}; 
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.UTME=str2double(temp{2});
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.UTMN=str2double(temp{2});
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.Instrument=temp{2}; 
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.ProfileID=temp{2}; 
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.Operator=temp{2}; 
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.Timing=temp{2}; 
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.Notes=temp{2}; 
        i=i+1; Lines{i}=fgetl(fid); temp=strsplit(Lines{i},','); Hdr.SnowDepth_cm=str2double(temp{2});
        
        fgetl(fid); fgetl(fid); 
    otherwise
        disp('Format not recognized! Header not read...')
        return
end %switch

return

function [t,Line]=ReadDateAndTime(fid,Format)

switch Format
    case '2017'
        Line=fgetl(fid);

        temp=strsplit(Line,':');
        DateString=strcat(temp{end-1}, temp{end});
        temp=strsplit(DateString,'T');
        temp{1}=strtrim(temp{1});
        year=str2double(temp{1}(1:4));
        day=str2double(temp{1}(6:7));
        mon=str2double(temp{1}(9:10));
        hour=str2double(temp{2}(1:2));
        minute=str2double(temp{2}(3:4));
        t=datenum(year,day,mon,hour,minute,0);
    case '2020'        
        Line=fgetl(fid);
        temp=strsplit(Line,',');
        t=datenum(temp{2});
    otherwise
        disp('Format not recognized! Header not read...')
        return        
end
return

function [Voltage,Reflectance,SSA,Depth,Do,Comments,Line]=ReadDataLine(fid)

Line=fgetl(fid);

temp=strsplit(Line,',');
Voltage=str2double(temp{1});
Reflectance=str2double(temp{2});
SSA=str2double(temp{3});
Depth=str2double(temp{4});
Do=str2double(temp{5});
if length(temp)>5
    Comments=strtrim(temp{6}); 
else
    Comments='';
end

return

function str=CommaTrim(strc)

if isempty(strc)
    str='';
    return
else
    str=strc;
end

while strcmp(str(end),',')
    str=str(1:end-1);
end

return