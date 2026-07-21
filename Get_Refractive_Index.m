close all;
clc
clear 

% Parameters of SnO2 core

b = 12.4; %core radius [nm]
d = 2.5; %shell thickness [nm]
n = 25e12; %planar density [m^-2]
B = 1; %magnetic flux density at sample [T]

% Effective dielectric permittivity

[wavelength,n_eff]=Refractive_Index_Simulation(b,d,n,B)

% Create excel table

wavelength_um = wavelength * 1e6;

T = table( ...
    wavelength_um(:), ...
    real(n_eff(:)), ...
    wavelength_um(:), ...
    imag(n_eff(:)), ...
    'VariableNames', ...
    {'wavelength (um)','Re(n_eff)','wl (um)','Im(n_eff)'});

writetable(T, "Refractive_Index_Output.xlsx");

% Plot

figure

plot(wavelength_um, real(n_eff), ...
    'b-', 'LineWidth', 2)

xlabel('Wavelength (\mum)')
ylabel('Re(n_{eff})')
title('Real Effective Refractive Index for SnO2')

box on
