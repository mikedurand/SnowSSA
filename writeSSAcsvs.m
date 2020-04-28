function writeSSAcsvs(SSADataset,WriteDataDirectory)

for i=1:length(SSADataset)
    fname=[WriteDataDirectory SSADataset(i).FileName];
    
    disp(['Writing ' fname '...']);
    
    DataToWrite=[SSADataset(i).HdrLines]';
    
    j=length(DataToWrite);
    
    j=j+1;  DataToWrite{j}='#,,,,,';
    j=j+1;  DataToWrite{j}='# Sample signal (mV), Reflectance (%), Specific surface area (SSA), Top Depth (cm), Do (mm), Comments';    
             
    for k=1:length(SSADataset(i).SSA)
        DataLine=[SSADataset(i).Voltage(k) SSADataset(i).Reflectance(k) SSADataset(i).SSA(k) SSADataset(i).Depth(k) SSADataset(i).Do(k)];
        
        j=j+1;
        DataToWrite(j)={sprintf('%.1f,%.2f,%.0f,%.1f,%f',DataLine)};
    end
    writecell(DataToWrite,fname,'QuoteStrings',false);
end

disp(['Done. Read ' num2str(length(SSADataset)) ' files.'])

end