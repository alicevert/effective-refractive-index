%% Last updated: 2026-07-21 by Alice Calvert
%% This is a program to calculate the effective refractive index of a magneto-optic (gyrotropic) anisotropic material.
%% The inputs are the core size (b), shell thickness (d), and planar number density [1/m^2] of the nanoparticles, as well as the magnetic flux density (B).
%% The output is the effective refractive index at each wavelength.
%% The simulation is adapted from the Absorption Simulation function by Kenzie Lewis and Raaja Rajeshwari Manickam, based off algorithm by Dani et al. [2]
%% Make sure fitted parameters are up to date with the most recent experimental data.
%% All units are SI except the absorption coefficient (cm^-1). Angles are in rads.

%% -------------------------------------------------------------------------- %%
%% ------------------------------- References ------------------------------- %%
%% -------------------------------------------------------------------------- %%
%% [1] T.K. Xia, P.M. Hui, and D. Stroud, "Theory of Faraday rotation in granular magnetic materials," Journal of Applied Physics 67(6), 2736–2741 (1990).
%% [2] R.K. Dani et al., “Supplemental Material for "Faraday rotation enhancement 
%%     of gold coated Fe2O3 nanoparticles: Comparison of experiment and theory” "
%%     J. Chem. Phys, vol. 135, no. 224502, 2011. 
%% [2] A. Ibrahim, “Synthesis and Characterization of Magnetic Nanoparticles 
%%     to Incorporate into Silicon Waveguides to be Used as Optical Isolators,” 
%%     M.S. thesis, Eng. Phys., McMaster Univ., Hamilton, Ontario, 2019. [Online]. Available: https://macsphere.mcmaster.ca/bitstream/11375/24720/2/Ibrahim_Amr_E_201908_MASc.pdf 

%% -------------------------------------------------------------------------- %%
%% ----------------------- Refractive Index Function ------------------------ %%
%% -------------------------------------------------------------------------- %%
function [wavelength,n_eff]=Refractive_Index_Simulation(core_radius,shell_thickness,planar_density,magnetic_flux) 

%The program will starting timing the run.
%tic

%% General Parameters & Constants

c = 3e8;
T=20+273.15;                       % temperature
kb=1.38064852e-23;                 % Boltzmann constant
me=9.10938356e-31;                 % effective mass of electron
e=1.60217662e-19;                  % elementary charge
mu0=4*pi*1e-7;                     % vacuum permeability
Bz=magnetic_flux;                  % applied magnetic field along z [T] 
B=magnetic_flux;                   % applied magnetic field [T] 

b=core_radius*1e-9;                % core radius  
d=shell_thickness*1e-9;            % shell thickness
a=b+d;                             % particle radius
c_Vs=(4/3)*pi*b^3;                 % core volume
ns=planar_density/(2*a);           % number density
Vs=(4/3)*pi*a^3;                   % particle volume
fs=ns*Vs;                          % volume fraction of particles in medium

wavelength = 200e-9:1e-9:900e-9;     % sweep (comment out fixed wavelength)
% wavelength = 532e-9;               % fixed (comment out wavelength sweep and wavelength-dependent permittivity below)
n_eff = zeros(length(wavelength),1);


%% ------------ Parameters of magneto-optically active material ------------- %%

%% Option 1: SnO2 (comment out Fe2O3 parameters) [2]

Keff=5e3;                                   % effective anisotropy constant, 5-9e3 [2]
Ms=250e3;                                   % saturation magnetization, 250-300e3 [2]
c_wp=0;                                     % plasma frequency
vf =1.4e6;                                  % Fermi velocity of gold
c_gammap = (2.75e14 / (0.347e-15)) + vf / b;        % damping frequency, CHANGE
c_g0=1.2e15;                                % fitted parameter for tin oxide absorption 
c_w0=6.7e15;                                % fitted parameter for tin oxide absorption 
c_gamma0=9e15;                              % fitted parameter for tin oxide absorption  

%% Option 2: Fe2O3 (comment out SnO2 parameters) [1]

% Keff=4700;%9e3;                           % effective anisotropy constant, 5-9e3
% Ms=414e3;%250e3;                          % saturation magnetization, 250-300e3
% c_wp=0;                                   % plasma frequency
% c_gammap=1/(0.347e-15)+vf/b;              % damping frequency
% c_g0=5.2e15;                              % fitted parameter for iron oxide absorption [1]
% c_w0=5.06e15;                             % fitted parameter for iron oxide absorption [1]
% c_gamma0=2.89e15;                         % fitted parameter for iron oxide absorption [1]

%% All Options (do not comment out)
Bzint=(((2/9)*mu0*c_Vs*Ms^2)/(kb*T))*B;     % internal magnetic field
c_wB=(e*Bzint)/(me);                        % cyclotron frequency, assuming bulk effective mass of 9.5me^2 

%% -------------------- Permittivity tensor calculation --------------------- %%
% Based off Maxwell-Garnet Theory [1]

for i = 1:length(wavelength)

    lambda = wavelength(i);
    w=(2*pi*c)/lambda;             	    % optical frequency

    eps_L= 1-(c_g0^2)/(w^2-c_w0^2+1i*c_gamma0*w-w*c_wB); % dielectric function, left polarization
    eps_R= 1-(c_g0^2)/(w^2-c_w0^2+1i*c_gamma0*w+w*c_wB); % dielectric function, right polarization

    eps_eff = 0.5*(eps_R+eps_L);
    n_eff(i) = sqrt(eps_eff);

    %The program will stop timing the run
    %toc 
end
end
