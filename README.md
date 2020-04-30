# SnowSSA
Scripts to process SnowEx SSA datasets

The SnowEx SSA dataset for 2017 is described at NSIDC here: https://nsidc.org/data/SNEX17_SSA/versions/1#data-acquisition. 

SnowEx 2020 SSA datasets are forthcoming. 

These scripts are all in Matlab. Main usage envisioned is to read all .csv files into a Matlab object for easy data exploration.

Example use: plot all data vertical profiles, including  reflectance, SSA, and equivalent grain diameter:

DataDirectory='./ssa_data/';
SkipList={''};
SSADataset=ReadSSADataset(DataDirectory,SkipList);
NODATA=-9999;
for i=1:length(SSADataset)     
  plotSSA(SSADataset(i),NODATA)        
end
