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
TitleStr=['SnowEx 2020.  PitID: ' SSAData.Hdr.PitID '.  ' datestr(SSAData.Hdr.t,'dd mmm') '.'];
title(TitleStr)

subplot(133)
plot(SSAData.Do,SSAData.Depth,'LineWidth',2)
set(gca,'FontSize',12)
grid on
xlabel('Equivalent diameter [mm]')
ylabel('Height [cm]')  

return