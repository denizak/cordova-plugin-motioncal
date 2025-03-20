#ifndef MOTION_CALIBRATION_H
#define MOTION_CALIBRATION_H

typedef struct {
    float B;             
} MotionCalibration_t;

extern MotionCalibration_t motioncal;

void updateBValue(float B);

#endif
// we could remove the whole file later, as this just a sample