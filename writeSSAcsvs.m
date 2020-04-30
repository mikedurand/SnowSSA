% Data = writeSSAcsvs(SSADataset,WriteDataDirectory)
%   by Mike, Spring 2020
%
% This function writes the SnowEx SSA formatted csv files
function writeSSAcsvs(SSADataset,WriteDataDirectory)

for i=1:length(SSADataset)
    fname=[WriteDataDirectory SSADataset(i).FileName];
    
    disp(['Writing ' fname '...']);
    
    for k=1:length(SSADataset(i).HdrLines)
        SSADataset(i).HdrLines{k}=strip(SSADataset(i).HdrLines{k},',');
    end
    
    DataToWrite=[SSADataset(i).HdrLines]';
    
    j=length(DataToWrite);
    
    j=j+1;  DataToWrite{j}='#';
    j=j+1;  DataToWrite{j}='# Sample signal (mV), Reflectance (%), Specific surface area (SSA), Height (cm), Do (mm), Comments';    
             
    for k=1:length(SSADataset(i).SSA)
        DataLine=[SSADataset(i).Voltage(k) SSADataset(i).Reflectance(k) SSADataset(i).SSA(k) SSADataset(i).Depth(k) SSADataset(i).Do(k)];
        
        j=j+1;
        DataToWrite(j)={sprintf('%.1f,%.2f,%.0f,%.1f,%f',DataLine)};
        if ~isempty(SSADataset(i).Comments{k})
            DataToWrite(j)={[DataToWrite{j} ',' SSADataset(i).Comments{k}]};
        end
    end
    writecell(DataToWrite,fname,'QuoteStrings',false);
end

disp(['Done. Wrote ' num2str(length(SSADataset)) ' files.'])

end