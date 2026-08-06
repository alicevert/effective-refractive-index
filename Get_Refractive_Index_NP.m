% Last Updated: 2026-08-05 by Alice Calvert
% This is a script that simulates the wavelength-dependent effective refractive index 
% of a nanoparticle across different wavelengths using the Maxwell-Garnett theory.
% See the Refractive_Index_Simulation file for more details on the inputs.
% The effective refractive index (n_eff) and extinction coefficient (k) are formatted into an excel table and plotted.

% ------------------------------------------------------------- %
% ----------------------- Initialization ---------------------- %
% ------------------------------------------------------------- %

close all;
clc
clear 

% ---------------- Define constants & variables --------------- %

filename = input("Enter the name of the excel file:", 's');
lambda = input("Enter the range of wavelengths [m] in the format 'start:step:stop':");

% Parameters of nanoparticle

while true
    material = input('Enter the nanoparticle material ("sno2", "fe2o3", "au", or "other"):', 's');
    if strcmpi(material, 'sno2')
        break;
    elseif strcmpi(material, 'fe2o3')
        break;
    elseif strcmpi(material, 'au')
        break;
    elseif strcmpi(material, 'other')
        break;
    else
        fprintf('Invalid input. Please enter "sno2", "fe2o3", "au", or "other".\n\n');
    end
end

a = input("Enter the nanoparticle radius [nm]:");
B = input("Enter the magnitude of the magnetic flux density applied to the sample [T]:");

% ------------------------------------------------------------- %
% ----- Wavelength-dependent effective refractive index  ------ %
% ------------------------------------------------------------- %

[wavelength,n_eff]=Refractive_Index_Simulation(a,material,B,lambda);

% --------------------- Format excel table -------------------- %

wavelength_um = wavelength * 1e6;

T = table( ...
    wavelength_um(:), ...
    real(n_eff(:)), ...
    wavelength_um(:), ...
    imag(n_eff(:)), ...
    'VariableNames', ...
    {'wavelength (um)','Re(n_eff)','wl (um)','Im(n_eff)'});

writetable(T, sprintf('%s.xlsx', filename));

% -------------- Plot complex refractive index ---------------- %


figure(1)

plot(wavelength_um, real(n_eff), 'LineWidth', 2)

xlabel('Wavelength (\mum)')
ylabel('n_{eff}')
title('Real Effective Refractive Index')

box on

figure(2)

plot(wavelength_um, imag(n_eff),'LineWidth', 2)

xlabel('Wavelength (\mum)')
ylabel('k_{eff}')
title('Effective Extinction Coefficient')

box on