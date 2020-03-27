function Data=ReadSSAFile(fname)

fid=fopen(fname,'r');
Data.FileName=''; %annoying. should switch to class to avoid initializing
Data.Hdr=ReadHeader(fid);

l=0;
while ~feof(fid)
    l=l+1;
    
    if l==19
        stop=1;
    end
    [Data.Voltage(l),Data.Reflectance(l),Data.SSA(l),Data.Depth(l),Data.Do(l),Data.Comments{l}]=ReadDataLine(fid);
end

fclose(fid);

return

function Hdr=ReadHeader(fid)

%note: this relies on the order of data and number of lines in the header staying the same. 

% the CommaTrim commands can be removed if these are all removed from the
% .csv files

Hdr.t=ReadDateAndTime(fid);
temp=strsplit(fgetl(fid),':'); Hdr.FieldCampaignName=strtrim(temp{2}); Hdr.FieldCampaignName=CommaTrim(Hdr.FieldCampaignName);
temp=strsplit(fgetl(fid),':'); Hdr.PitID=strtrim(temp{2}); Hdr.PitID=CommaTrim(Hdr.PitID);
temp=strsplit(fgetl(fid),':'); Hdr.UTMN=str2double(temp{2}); 
temp=strsplit(fgetl(fid),':'); Hdr.UTME=str2double(temp{2});
temp=strsplit(fgetl(fid),':'); Hdr.UTMZone=strtrim(temp{2}); Hdr.UTMZone=CommaTrim(Hdr.UTMZone);
temp=strsplit(fgetl(fid),':'); Hdr.Instrument=strtrim(temp{2}); Hdr.Instrument=CommaTrim(Hdr.Instrument);
temp=strsplit(fgetl(fid),':'); Hdr.Operator=strtrim(temp{2}); Hdr.Operator=CommaTrim(Hdr.Operator);
temp=strsplit(fgetl(fid),':'); Hdr.Timing=strtrim(temp{2}); Hdr.Timing=CommaTrim(Hdr.Timing);
temp=strsplit(fgetl(fid),':'); Hdr.Notes=strtrim(temp{2});  Hdr.Notes=CommaTrim(Hdr.Notes);
temp=strsplit(fgetl(fid),':'); Hdr.SnowDepth_cm=str2double(temp{2});

fgetl(fid); fgetl(fid); 

return

function t=ReadDateAndTime(fid)

temp=strsplit(fgetl(fid),':');
DateString=strcat(temp{end-1}, temp{end});
temp=strsplit(DateString,'T');
temp{1}=strtrim(temp{1});
year=str2double(temp{1}(1:4));
day=str2double(temp{1}(6:7));
mon=str2double(temp{1}(9:10));
hour=str2double(temp{2}(1:2));
minute=str2double(temp{2}(3:4));
t=datenum(year,day,mon,hour,minute,0);

return

function [Voltage,Reflectance,SSA,Depth,Do,Comments]=ReadDataLine(fid)

temp=strsplit(fgetl(fid),',');
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
    
str=strc;
while strcmp(str(end),',')
    str=str(1:end-1);
end

return