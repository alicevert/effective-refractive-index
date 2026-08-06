%% Last updated: 2026-08-05 by Alice Calvert
%% This is a program to calculate the effective refractive index of a nanoparticle using Maxwell-Garnett theory.
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
%% [3] A. Ibrahim, “Synthesis and Characterization of Magnetic Nanoparticles 
%%     to Incorporate into Silicon Waveguides to be Used as Optical Isolators,” 
%%     M.S. thesis, Eng. Phys., McMaster Univ., Hamilton, Ontario, 2019. [Online]. Available: https://macsphere.mcmaster.ca/bitstream/11375/24720/2/Ibrahim_Amr_E_201908_MASc.pdf 

%% -------------------------------------------------------------------------- %%
%% ----------------------- Refractive Index Function ------------------------ %%
%% -------------------------------------------------------------------------- %%
function [wavelength,n_eff]=Refractive_Index_Simulation(np_radius,np_material,magnetic_flux,wavelength)

tic %start timing run

%% General Parameters & Constants

c = 3e8;
T=20+273.15;                       % temperature
kb=1.38064852e-23;                 % Boltzmann constant
me=9.10938356e-31;                 % effective mass of electron
e=1.60217662e-19;                  % elementary charge
mu0=4*pi*1e-7;                     % vacuum permeability 
B=magnetic_flux;                   % applied magnetic field [T] 

a=np_radius*1e-9;                % np radius  
Vs=(4/3)*pi*a^3;                 % np volume

n_eff = zeros(length(wavelength),1);

%% ------------------ Parameters of nanoparticle material ------------------- %%

if strcmpi(np_material, 'sno2')
    %% Option 1: SnO2 [3]
    tau=0.347e-15;                          % scattering time
    vf=0;                                   % Fermi velocity
    wp=0;                                   % plasma frequency
    gammap=1/tau+vf/b;                      % damping frequency
    Ms=250e3;                               % saturation magnetization, 250-300e3 [3]
    g0=1.2e15;                              % fitted parameter for tin oxide absorption 
    w0=6.7e15;                              % fitted parameter for tin oxide absorption 
    gamma0=9e15;                            % fitted parameter for tin oxide absorption  

elseif strcmpi(np_material, 'fe2o3')
    %% Option 2: Fe2O3 [2]
    tau=0.347e-15;                          % scattering time
    vf=0;                                   % Fermi velocity
    wp=0;                                   % plasma frequency
    gammap=1/tau+vf/b;                      % damping frequency
    Ms=414e3;%250e3;                        % saturation magnetization, 250-300e3 [2]
    g0=5.2e15;                              % fitted parameter for iron oxide absorption [2]
    w0=5.06e15;                             % fitted parameter for iron oxide absorption [2]
    gamma0=2.89e15;                         % fitted parameter for iron oxide absorption [2]

elseif strcmpi(np_material, 'au')
    %% Option 3: Au, based off Drude-Sommerfeld Theory [2] (fitted using 17 nm diameter gold NPs in water; interband transitions are neglected)
    tau=9.1e-15;                            % scattering time
    vf=1.4e6;                               % Fermi velocity
    wp=1.37e16;                             % plasma frequency
    gammap=1/tau+vf/b;                    % damping frequency
    Ms=0;                                   % saturation magnetization
    g0=4.43e15;                             % fitted parameter for gold absorption [2], CHANGE
    w0=3.86e15;                             % fitted parameter for gold absorption [2], CHANGE
    gamma0=6.22e14;                         % fitted parameter for gold absorption [2], CHANGE

elseif strcmpi(np_material, 'other')
    %% Option 4: Other materials

    confirmed = false;
    while ~confirmed
        tau = input('Enter the scattering time [s] of the free electrons:');
        vf = input('Enter the Fermi velocity [m/s] of the free electrons:');
        wp = input('Enter the plasma frequency [rad/s] of the free electrons:');
        gammap = (1/tau)+(vf/a);
        Ms = input('Enter the saturation magnetization [A/m]:');
        g0 = input('Enter the oscillator strength of bound electrons:');
        w0 = input('Enter the binding frequency [Hz] of bound electrons:');
        gamma0 = input('Enter the damping frequency [Hz] of bound electrons:');
        
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

Bzint=(((2/9)*mu0*Vs*Ms^2)/(kb*T))*B;     % internal magnetic field
wB=(e*Bzint)/(me);                        % cyclotron frequency, assuming bulk effective mass of 9.5me^2 

%% -------------------- Permittivity tensor calculation --------------------- %%
% Based off Maxwell-Garnett Theory [1]

for i = 1:length(wavelength)

    lambda = wavelength(i);
    w=(2*pi*c)/lambda;             	    % optical frequency

    eps_L= 1-(g0^2)/(w^2-w0^2+1i*gamma0*w-w*wB)-(wp^2)/(w^2+1i*gammap*w-w*wB);  % dielectric function, left polarization
    eps_R= 1-(g0^2)/(w^2-w0^2+1i*gamma0*w+w*wB)-(wp^2)/(w^2+1i*gammap*w+w*wB);  % dielectric function, right polarization

    eps_eff = 0.5*(eps_R+eps_L);
    n_eff(i) = sqrt(eps_eff);

end

toc %stop timing run

end