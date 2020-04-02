function SSADataset=ReadSSADataset(DataDirectory,SkipList)

Files=dir(DataDirectory);

NumProfiles=0;
for i=1:length(Files)
    
    if i==12
        stop=1;
    end

    SkipThisFile=DoSkipChecks(Files(i),SkipList);
    
    if ~SkipThisFile
        NumProfiles=NumProfiles+1;
        Name=[DataDirectory Files(i).name];
        disp(['Reading ' Files(i).name '...']);
        SSADataset(NumProfiles)=ReadSSAFile(Name);
        SSADataset(NumProfiles).FileName=Files(i).name;
    end
end

disp(['Done. Read ' num2str(NumProfiles) ' files.'])

return

