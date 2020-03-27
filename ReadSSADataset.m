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

function SkipMe=DoSkipChecks(fname,SkipList)

    IamHidden=CheckHiddenStatus(fname);
    OnSkipList=CheckSkipList(fname,SkipList);

    if IamHidden || OnSkipList
        SkipMe=true;
    else
        SkipMe=false;
    end
    
return

function IAmHidden=CheckHiddenStatus(fname)

IAmHidden=strcmp(fname.name(1),'.');

return

function OnSkipList=CheckSkipList(fname,SkipList)

OnSkipList=false;

for i=1:length(SkipList)
    if strcmpi(fname.name,SkipList{i})
        OnSkipList=true;
        disp(['Skipping ' fname.name '...']);
    end
end

return

