function plotSSA(SSAData,NODATA)

SSAData.SSA(SSAData.SSA==NODATA)=nan;
SSAData.Reflectance(SSAData.Reflectance==NODATA)=nan;
SSAData.Do(SSAData.Do==NODATA)=nan;
SSAData.Depth(SSAData.Depth==NODATA)=nan;

subplot(131)
plot(SSAData.Reflectance,SSAData.Depth,'LineWidth',2)
set(gca,'FontSize',12)
grid on
xlabel('Reflectance [%]')
ylabel('Height [cm]')  

subplot(132)
plot(SSAData.SSA,SSAData.Depth,'LineWidth',2)
set(gca,'FontSize',12)
grid on
xlabel('SSA [kg/m^2]')
ylabel('Height [cm]')  

if strcmpi(SSAData.Hdr.ProfileID,'n/a')
   TitleStr=['SnowEx 2020.  ' SSAData.Hdr.PitID '.  ' SSAData.Hdr.Instrument '. ' datestr(SSAData.Hdr.t,'dd mmm') '.'];
else
   TitleStr=['SnowEx 2020.  ' SSAData.Hdr.PitID '.  ' SSAData.Hdr.Instrument '. ' SSAData.Hdr.ProfileID '. ' datestr(SSAData.Hdr.t,'dd mmm') '.'];
end


title(TitleStr)

subplot(133)
plot(SSAData.Do,SSAData.Depth,'LineWidth',2)
set(gca,'FontSize',12)
grid on
xlabel('Equivalent diameter [mm]')
ylabel('Height [cm]')  

return