% [CalData, SampleData]=ReadIceCubeFile(fname)
%    by Mike, Spring 2020
%
% This reads output from the A2 photonics IceCube SSA app, formatted with tab separation

function [CalData,SampleData]=ReadIceCubeFile(fname)

fid=fopen(fname);

i=0;
CalRead=false;
SampleData='';

while ~feof(fid)
    fline=fgetl(fid);
    
    if length(fline)>=16 && strcmp(fline,'----------------')  && ~CalRead
        i=i+1;
        fline=fgetl(fid);        
        if length(fline)>= 16 && strcmp(fline,'Calibration data')
            CalData=ReadCalibration(fid);
            CalRead=true;
        end
    end    
    
    if length(fline)>=16 && strcmp(fline,'----------------')        
        i=i+1;
        fline=fgetl(fid);
        if length(fline)>= 16 && strcmp(fline,'Acquisition data')
            SampleData=ReadSample(fid);
        end
    end
        
end

fclose(fid);


return

function CalData=ReadCalibration(fid)

DataRead=false;

while ~DataRead
    fline=fgetl(fid);

    if length(fline) >= 10 && strcmp(fline(1:10),'Standard #')
        for i=1:6
            fline=fgetl(fid);
            data=regexp(fline,'\t','split');
            CalData.ObsV(i)=str2double(data{2});
            CalData.Ref(i)=str2double(data{3});
        end
        fline=fgetl(fid); fline=fgetl(fid);
        CalQualityLine=fgetl(fid);
        data=regexp(CalQualityLine,'\t','split');
        CalData.Quality=data{2};
        DataRead=true;
    end
end
    
return

function SampleData=ReadSample(fid)

k=0;

while ~feof(fid)
    fline=fgetl(fid);

    if length(fline) >= 13 && strcmp(fline(1:13),'Sample number')
        data=regexp(fline,'\t','split');
        SampleData.nFields=length(data);       
        
        for i=1:SampleData.nFields
           FieldNames{i}=replace(data{i},' ','_');
           FieldNames{i}=replace(FieldNames{i},'(','');
           FieldNames{i}=replace(FieldNames{i},')','');
           eval(['SampleData.' FieldNames{i} '=[];'])
        end
        
        continue
        
    end
    
    if isempty(fline)
        continue
    end
        
    k=k+1;
    data=regexp(fline,'\t','split');
    for j=1:SampleData.nFields
        if strcmp(FieldNames{j},'Comment')
            continue
        end
        eval(['SampleData.' FieldNames{j} '(k)=[' data{j} '];'])
    end    
        
end
    
return