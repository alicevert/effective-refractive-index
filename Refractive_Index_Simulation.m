%% Last updated: 2026-07-29 by Alice Calvert
%% This is a program to calculate the effective refractive index of a magneto-optic (gyrotropic) anisotropic nanoparticle using Maxwell-Garnett theory.
%% The inputs are the nanoparticle radius (b) [nm] and material, magnitude of magnetic flux density (B) [T] applied to nanoparticles, and the range of wavelengths.
%% The output is the effective refractive index and extinction coefficient at each wavelength. [1]
%% The simulation is adapted from the Absorption Simulation function by Kenzie Lewis and Raaja Rajeshwari Manickam, based off algorithm by Dani et al. [2]
%% Make sure fitted parameters are up to date with the most recent experimental data.
%% All units are SI.

%% -------------------------------------------------------------------------- %%
%% ------------------------------- References ------------------------------- %%
%% -------------------------------------------------------------------------- %%
%% [1] D. Griffiths, Introduction to Electrodynamics, 4th Edition ed. (2017).
%% [2] R.K. Dani et al., “Supplemental Material for "Faraday rotation enhancement 
%%     of gold coated Fe2O3 nanoparticles: Comparison of experiment and theory” "
%%     J. Chem. Phys, vol. 135, no. 224502, 2011. 
%% [2] A. Ibrahim, “Synthesis and Characterization of Magnetic Nanoparticles 
%%     to Incorporate into Silicon Waveguides to be Used as Optical Isolators,” 
%%     M.S. thesis, Eng. Phys., McMaster Univ., Hamilton, Ontario, 2019. [Online]. Available: https://macsphere.mcmaster.ca/bitstream/11375/24720/2/Ibrahim_Amr_E_201908_MASc.pdf 

%% -------------------------------------------------------------------------- %%
%% ----------------------- Refractive Index Function ------------------------ %%
%% -------------------------------------------------------------------------- %%
function [wavelength,n_eff]=Refractive_Index_Simulation(core_radius,core_material,magnetic_flux,wavelength)

tic %start timing run

%% General Parameters & Constants

c = 3e8;
T=20+273.15;                       % temperature
kb=1.38064852e-23;                 % Boltzmann constant
me=9.10938356e-31;                 % effective mass of electron
e=1.60217662e-19;                  % elementary charge
mu0=4*pi*1e-7;                     % vacuum permeability 
B=magnetic_flux;                   % applied magnetic field [T] 

b=core_radius*1e-9;                % core radius  
c_Vs=(4/3)*pi*b^3;                 % core volume

n_eff = zeros(length(wavelength),1);

%% ------------ Parameters of magneto-optically active material ------------- %%

if strcmpi(core_material, 'sno2')
    %% Option 1: SnO2 [3]
    Ms=250e3;                                   % saturation magnetization, 250-300e3 [3]
    c_g0=1.2e15;                                % fitted parameter for tin oxide absorption 
    c_w0=6.7e15;                                % fitted parameter for tin oxide absorption 
    c_gamma0=9e15;                              % fitted parameter for tin oxide absorption  

elseif strcmpi(core_material, 'fe2o3')
    %% Option 2: Fe2O3 [2]
    Ms=414e3;%250e3;                          % saturation magnetization, 250-300e3
    c_g0=5.2e15;                              % fitted parameter for iron oxide absorption [2]
    c_w0=5.06e15;                             % fitted parameter for iron oxide absorption [2]
    c_gamma0=2.89e15;                         % fitted parameter for iron oxide absorption [2]

elseif strcmpi(core_material, 'other')
    %% Option 3: Other materials

    confirmed = false;
    while ~confirmed

        Ms = input('Enter the saturation magnetization [A/m]:');
        c_g0 = input('Enter the oscillator strength of bound electrons:');
        c_w0 = input('Enter the binding frequency [Hz] of bound electrons:');
        c_gamma0 = input('Enter the damping frequency [Hz] of bound electrons:');
        
        while true

            should_continue = input('Proceed with entered values? ("yes" or "no"):','s');
    
            if strcmpi(should_continue, 'yes')
                confirmed = true;
                break;
            elseif strcmpi(should_continue, 'no')
                fprintf('Proceeding to re-enter values.\n\n')
                break;
            else
                fprintf('Invalid input. Please enter "yes" or "no".\n\n');
            end

        end

    end

end

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

end

toc %stop timing run

end