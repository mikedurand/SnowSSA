function SSADataset=ReadSSADataset(DataDirectory,SkipList,Format)

Files=dir(DataDirectory);

NumProfiles=0;
for i=1:length(Files)
        
    SkipThisFile=DoSkipChecks(Files(i),SkipList);
    
    if i==107
        stop=1;
    end
        
    if ~SkipThisFile
        
        NumProfiles=NumProfiles+1;
        Name=[DataDirectory Files(i).name];
        disp(['Reading ' Files(i).name '...']);
        SSADataset(NumProfiles)=ReadSSAFile(Name,Format);
        SSADataset(NumProfiles).FileName=Files(i).name;
    end
end

disp(['Done. Read ' num2str(NumProfiles) ' files.'])

return

