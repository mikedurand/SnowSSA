function writeSSAcsvs(SSADataset,WriteDataDirectory)

for i=1:length(SSADataset)
    fname=[WriteDataDirectory SSADataset(i).FileName];
    
    DataToWrite=[SSADataset(i).HdrLines]';
    
    j=length(DataToWrite);
    
    j=j+1;  DataToWrite{j}='#,,,,,';
    j=j+1;  DataToWrite{j}='# Sample signal (mV), Reflectance (%), Specific surface area (SSA), Top Depth (cm), Do (mm), Comments';
    
%     DataToWrite=[DataToWrite;
%                  [SSADataset(i).DataLines]';]; %next step: replace the "datalines" with actual dataset
             
    for k=1:length(SSADataset(i).SSA)
        DataLine=[SSADataset(i).Voltage(k) SSADataset(i).Reflectance(k) SSADataset(i).SSA(k) SSADataset(i).Do(k)];
        
        j=j+1;
        DataToWrite(j)={sprintf('%.1f,%.2f,%.0f,%f',DataLine)};
    end
    writecell(DataToWrite,fname,'QuoteStrings',false);
end

end