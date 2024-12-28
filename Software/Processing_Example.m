clear variables
close all

%% Read in and plot data files, calculate mean spectra
LOCB_18oct_tot{1} = Avantes_ReadAscii('okee_2024-10-18_locb_raw_a.txt', 'pathlength_m',0.010, 'minmax_wave_nm',[390 750]);
LOCB_18oct_tot{2} = Avantes_ReadAscii('okee_2024-10-18_locb_raw_b.txt', 'pathlength_m',0.010, 'minmax_wave_nm',[390 750]);
LOCB_18oct_tot{3} = Avantes_ReadAscii('okee_2024-10-18_locb_raw_c.txt', 'pathlength_m',0.010, 'minmax_wave_nm',[390 750]);

Wave = LOCB_18oct_tot{1}.Wave;

LOCB_18oct_tot_Beamc = mean([LOCB_18oct_tot{1}.Beamc LOCB_18oct_tot{2}.Beamc LOCB_18oct_tot{3}.Beamc],2); 

figure, box on, hold on
colors = get(gca,'ColorOrder');
plot(Wave, LOCB_18oct_tot{1}.Beamc, '--', 'Color',colors(1,:))
plot(Wave, LOCB_18oct_tot{2}.Beamc, '--', 'Color',colors(1,:))
plot(Wave, LOCB_18oct_tot{3}.Beamc, '--', 'Color',colors(1,:))
plot(Wave, LOCB_18oct_tot_Beamc, '-', 'Color',colors(2,:))

set(gca,'FontSize',12)
title('Lake Okeechobee 2024-10-18 LOCB', 'FontSize',14)
xlabel('Wavelength [nm]', 'FontSize',14)
ylabel('Beam Attenuation, c_{pg} [1/m]', 'FontSize',14)
