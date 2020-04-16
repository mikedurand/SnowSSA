function CalData=ReadIceCubeFile(fname)

fid=fopen(fname);

i=0;

while ~feof(fid)
    fline=fgetl(fid);
    
    if length(fline)>=16 && strcmp(fline,'----------------')        
        i=i+1;
        fline=fgetl(fid);        
        if length(fline)>= 16 && strcmp(fline,'Calibration data')
            CalData=ReadCalibration(fid);
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
        DataRead=true;
    end
end
    
return