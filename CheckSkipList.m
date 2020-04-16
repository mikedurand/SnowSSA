function OnSkipList=CheckSkipList(fname,SkipList)

OnSkipList=false;

for i=1:length(SkipList)
    if strcmpi(fname.name,SkipList{i})
        OnSkipList=true;
        disp(['Skipping ' fname.name '...']);
    end
end

return

