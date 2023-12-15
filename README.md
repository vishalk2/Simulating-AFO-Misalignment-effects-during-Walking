# Modeling Ankle Joint Alignments effects in Ankle Foot Orthosis (AFO)


### Contents
- [ABOUT](#about)
- [KEYWORDS](#keywords)
- [REPO FILES](#repo-files)

<br>
<hr>

### ABOUT
This Research Work involves -
- Study of "Misalignment effects" between the lower-limb (shank and foot) and an Ankle Foot Orthosis (AFO) for an AFO-user.
- 2D Link-segment Mathematical model used to simulate relative motion between the lower-limb and the AFO during walking, most common daily life activity.
- Statistical analysis of relative motions calculated for 5 test subjects.
- Estimation of Calf Band Travel / Orthosis Strap Movement.
- Prediction of Pressure Points on the shank and the foot.

<br>
<hr>

### KEYWORDS
- orthosis
- ankle-joint
- biomechanics
- exoskeleton
- pistoning
- misalignments
- pressure points

<br>
<hr>

### REPO FILES
AFO_Analysis.xlsx
   * MS Excel file for simulating Gait Analysis on both the legs based on the data of 5 able-bodied individuals.
   * Provides UI-based dashboard for analysis as well as visually comprehending the misalignment effects.
   * Feel free to experiment with the dashboard.

<br>

AFO_Main.m
   * MATLAB Program to analyze the ankle-joint misalignment effects in AFOs during Walking motion and perform Gait Analysis (based on 5 Gait cycles) on both the legs for user-picked misalignment cases.
   * The data considered is based on the data from 5 able-bodied individuals.
   * The file is directly runnable and is fully UI-based. The program is capable of prompting the user for 'graphically picked misalignments' as well as 'manually typed misalignments'.
   * The Gait data chosen

<br>

AFO_Main_4Cases.m
   * MATLAB Program analyze the ankle-joint misalignment effects in AFOs during Walking motion and perform Gait Analysis (based on 5 Gait cycles) on both the legs for default (and practically feasible) misalignment cases.
   * The data considered is based on the data from 5 able-bodied individuals.
   * The file is directly runnable and is UI-based.

<br>

Preferred_Walking.xlsx
   * Filtered and modified data applied on the model for "Walking motion".
   * The data consists of 2 trials each for about 5 able-bodied individuals.
   * Originally published data for the 5 individuals can be found here: 

<br>





