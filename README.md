# Effective Refractive Index
This is a program that calculates the effective refractive index of a magneto-optically (gyrotropic) anisotropic material. 
The input parameters are core radius (b), shell thickness (d), and planar number density (1/m^2) of the nanoparticles, as well as the magnitude of the magnetic flux density (B) applied to the sample. 
The output is the effective refractive index at each wavelength.
The Refractive Index Simulation function is adapted from the Absorption Simulation function by Kenzie Lewis and Raaja Rajeshwari Manickam, based off algorithm by Dani et al. [1]

## Before running the simulation
Edit the Refractive Index Simulation file to suit your needs. 
Depending on whether a single wavelength (e.g., 532 nm) or a wavelength sweep (e.g., 200 to 900 nm) is being used, comment out the irrelevant parts.
Make sure the fitted parameters (for the core - SnO2) are up to date with the most recent experimental data.
Comment out the parameters for the magneto-optically (gyrotropically) anisotropic material that's not of interest (either SnO2 or Fe2O3).
All the units are SI and the angles are in radians.

## Running the simulation
Run the function in the Get Refractive Index file. This script runs the function and formats the outputs in an excel table and plot.

# References
[1] R.K. Dani, H. Wang, S.H. Bossmann, G. Wysin, and V. Chikan, “Supplemental Material for "Faraday rotation enhancement of gold coated Fe2O3 nanoparticles: Comparison of experiment and theory," ” J. Chem. Phys. 135(22), 224502 (2011). \
[2] A. Ibrahim, “Synthesis and Characterization of Magnetic Nanoparticles to Incorporate into Silicon Waveguides to be Used as Optical Isolators,” M.S. thesis, Eng. Phys., McMaster Univ., Hamilton, Ontario, 2019. [Online]. Available: https://macsphere.mcmaster.ca/bitstream/11375/24720/2/Ibrahim_Amr_E_201908_MASc.pdf 

