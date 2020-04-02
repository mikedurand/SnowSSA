function SkipMe=DoSkipChecks(fname,SkipList)

    IamHidden=CheckHiddenStatus(fname);
    OnSkipList=CheckSkipList(fname,SkipList);

    if IamHidden || OnSkipList
        SkipMe=true;
    else
        SkipMe=false;
    end
    
return
