#ifndef MAG_CALIBRATION_H
#define MAG_CALIBRATION_H

typedef struct {
    float B;             
} MagCalibration_t;

extern MagCalibration_t magcal;

void updateBValue(float B);

#endif