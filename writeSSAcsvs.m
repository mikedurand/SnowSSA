% Data = writeSSAcsvs(SSADataset,WriteDataDirectory)
%   by Mike, Spring 2020
%
% This function writes the SnowEx SSA formatted csv files
function writeSSAcsvs(SSADataset,WriteDataDirectory,Format)

for i=1:length(SSADataset)
    fname=[WriteDataDirectory SSADataset(i).FileName];
    
    disp(['Writing ' fname '...']);
    
    for k=1:length(SSADataset(i).HdrLines)
        SSADataset(i).HdrLines{k}=strip(SSADataset(i).HdrLines{k},',');
    end
    
    switch Format
        case '2017'
            DataToWrite=[SSADataset(i).HdrLines]';

            j=length(DataToWrite);

            j=j+1;  DataToWrite{j}='#';
            j=j+1;  DataToWrite{j}='# Sample signal (mV), Reflectance (%), Specific surface area (SSA), Height (cm), Do (mm), Comments';    

            for k=1:length(SSADataset(i).SSA)
                DataLine=[SSADataset(i).Voltage(k) SSADataset(i).Reflectance(k) SSADataset(i).SSA(k) SSADataset(i).Depth(k) SSADataset(i).Do(k)];

                j=j+1;
                %First 5: 1) signal (mv); 2) reflectance; 3) SSA; 4) Height 5) Do
                DataToWrite(j)={sprintf('%.1f,%.2f,%.2f,%.0f,%.4f',DataLine)};
                if ~isempty(SSADataset(i).Comments{k})
                    DataToWrite(j)={[DataToWrite{j} ',' SSADataset(i).Comments{k}]};
                end
            end            
        case '2020'
            
            data=regexp(fname,'/','split');
            
            if strcmp(data{3}(1:6),'SnowEx')
                %then data are in 2020 format already
                ProfileID=SSADataset(i).Hdr.ProfileID;
            else
                %then data are in 2017 format 
                fname17=fname;
                fname=fname17to20(fname17);                
                ProfileID=strtrim(SSADataset(i).Hdr.SampleID(length(SSADataset(i).Hdr.PitID)+1:end));

                if isempty(ProfileID)
                    ProfileID='N/A';
                end                
            end
                

        %     HdrLinesWrite=[SSADataset(i).HdrLines]';
            HdrLinesWrite{1}='# Location,Grand Mesa';
            HdrLinesWrite{2}=['# Site,' SSADataset(i).Hdr.PitID];
            HdrLinesWrite{3}=['# PitID,COGM' SSADataset(i).Hdr.PitID '_' datestr(SSADataset(i).Hdr.t,'yyyymmDD') ];
            HdrLinesWrite{4}=['# Date/Time,' datestr(SSADataset(i).Hdr.t,'yyyy-mm-DD-HH:MM')]; %2020-01-31-11:07
            HdrLinesWrite{5}=['# UTM Zone,12N'];
            if ~isnan(SSADataset(i).Hdr.UTME)
                HdrLinesWrite{6}=['# Easting [m],' num2str(SSADataset(i).Hdr.UTME,'%.f')];
            else
                HdrLinesWrite{6}='# UTME, N/A';
            end
            if ~isnan(SSADataset(i).Hdr.UTMN)
                HdrLinesWrite{7}=['# Northing [m],' num2str(SSADataset(i).Hdr.UTMN,'%.f')];
            else
                HdrLinesWrite{7}='# UTMN, N/A';
            end
            HdrLinesWrite{8}=['# Instrument,' SSADataset(i).Hdr.Instrument];
            HdrLinesWrite{9}=['# Profile ID,' ProfileID];
            HdrLinesWrite{10}=['# Operator,' SSADataset(i).Hdr.Operator];
            HdrLinesWrite{11}=['# Timing,' SSADataset(i).Hdr.Timing]; 
            HdrLinesWrite{12}=strrep(SSADataset(i).HdrLines{10},':',','); %notes
            HdrLinesWrite{13}=strrep(SSADataset(i).HdrLines{11},':',','); %total snow depth

            DataToWrite=HdrLinesWrite';

            j=length(DataToWrite);

            j=j+1;  DataToWrite{j}='#';
            j=j+1;  DataToWrite{j}='# Sample signal (mV), Reflectance (%), Specific surface area (m^2/kg), Sample Top Height (cm), Deq (mm), Comments';    

            for k=1:length(SSADataset(i).SSA)
                DataLine=[SSADataset(i).Voltage(k) SSADataset(i).Reflectance(k) SSADataset(i).SSA(k) SSADataset(i).Depth(k) SSADataset(i).Do(k)];

                j=j+1;
                %First 5: 1) signal (mv); 2) reflectance; 3) SSA; 4) Height 5) Do
                DataToWrite(j)={sprintf('%.1f,%.2f,%.2f,%.0f,%.4f',DataLine)};
                if ~isempty(SSADataset(i).Comments{k})
                    DataToWrite(j)={[DataToWrite{j} ',' SSADataset(i).Comments{k}]};
                end
            end
    end %switch 
    writecell(DataToWrite,fname,'QuoteStrings',false);
end

disp(['Done. Wrote ' num2str(length(SSADataset)) ' files.'])

end

function [fullname20]=fname17to20(fullname17)

%function to convert the 2017 filename convention to the 2020 version
filedata=regexp(fullname17,'/','split');
namedata=regexp(filedata{3},'_','split');

instrument=namedata{end}(1:end-4);
pitID=namedata{2};

if strcmpi(namedata{3}(1),'r')
    MultipleProfiles=true;
else
    MultipleProfiles=false;
end

switch MultipleProfiles
    case true
        datedata=regexp(namedata{4},'T','split');
        fname20=['SnowEx20_SSA_GM_' datedata{1} '_' pitID '_' namedata{3} '_' instrument '_v01.csv'];
    case false
        datedata=regexp(namedata{3},'T','split');
        fname20=['SnowEx20_SSA_GM_' datedata{1} '_' pitID '_' instrument '_v01.csv'];
end

 



fullname20=[filedata{1} '/' filedata{2} '/' fname20];

end