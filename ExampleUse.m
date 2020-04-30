%Example Use of the SnowSSA scripts. Note this requires all SSA .csv data files be
%first placed in the folder listed in the "DataDirectory" variable. Note
%the SSA data files are not distributed here. 

DataDirectory='./ssa_data/';
SkipList={''};
SSADataset=ReadSSADataset(DataDirectory,SkipList);
NODATA=-9999;
for i=1:length(SSADataset)     
  plotSSA(SSADataset(i),NODATA)        
end