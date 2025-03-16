#include "magcalibration.h"

MagCalibration_t magcal;

void updateBValue(float B) {
    magcal.B = B;
}