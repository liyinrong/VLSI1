#pragma once
#include <hls_stream.h>
#include <ap_fixed.h>

// Video signal dimensions.
const int X_RESOLUTION = 1920;
const int Y_RESOLUTION = 1080;

// Bits per pixel channel. Three channels make up a pixel.
const int BITS_PER_CHANNEL = 8;

// Type of a pixel channel.
typedef ap_uint<BITS_PER_CHANNEL> channel_t;

// Intermediate accumulator type.
const int ACCU_INT_BITS  = BITS_PER_CHANNEL + 10;
const int ACCU_FRAC_BITS = 10;
typedef ap_fixed<ACCU_INT_BITS+ACCU_FRAC_BITS, ACCU_INT_BITS> DATA_TYPE;

// Color of a pixel.
typedef struct {
    channel_t r;
    channel_t g;
    channel_t b;
} pixel_t;

// HDMI metadata for a pixel.
typedef struct {
    ap_uint<1> hsync;
    ap_uint<1> vsync;
    ap_uint<1> vde;
} hdmi_meta_t;

// HDMI pixel together with its metadata.
typedef struct {
    pixel_t pixel;
    ap_uint<1> hsync;
    ap_uint<1> vsync;
    ap_uint<1> vde;
} hdmi_pixel_t;

// A stream of pixels. Used as inputs and outputs to the filter.
typedef hls::stream<hdmi_pixel_t> hdmi_pixel_stream_t;

// This function computes an entire image frame.
void filter_hls(const pixel_t *data_in, pixel_t *data_out);


// The following are some filter kernels that you may want to comment/uncomment.

// // 5x5 identity filter.
// const int KERNEL_SIZE = 5;
// const DATA_TYPE FILTER_BIAS = 0;
// const DATA_TYPE FILTER_COEF[5][5] = {
//     0,  0,  0,  0,  0,
//     0,  0,  0,  0,  0,
//     0,  0,  1,  0,  0,
//     0,  0,  0,  0,  0,
//     0,  0,  0,  0,  0
// };

// // 3x3 identity filter.
// const int KERNEL_SIZE = 3;
// const DATA_TYPE FILTER_BIAS = 0;
// const DATA_TYPE FILTER_COEF[3][3] = {
//     0, 0, 0,
//     0, 1, 0,
//     0, 0, 0
// };

 // 3x3 Discrete Laplace Operator.
 const int KERNEL_SIZE = 3;
 const DATA_TYPE FILTER_BIAS = 127;
 const DATA_TYPE FILTER_COEF[3][3] = {
     0.125,  0.250, 0.125,
     0.250, -1.500, 0.250,
     0.125,  0.250, 0.125
 };

// // 7x7 box blur filter.
// const int KERNEL_SIZE = 7;
// const DATA_TYPE FILTER_BIAS = 0;
// const DATA_TYPE FILTER_COEF[7][7] = {
//     0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02,
//     0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02,
//     0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02,
//     0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02,
//     0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02,
//     0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02,
//     0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02
// };

// // 5x5 box blur filter.
// const int KERNEL_SIZE = 5;
// const DATA_TYPE FILTER_BIAS = 0;
// const DATA_TYPE FILTER_COEF[5][5] = {
//     0.04, 0.04, 0.04, 0.04, 0.04,
//     0.04, 0.04, 0.04, 0.04, 0.04,
//     0.04, 0.04, 0.04, 0.04, 0.04,
//     0.04, 0.04, 0.04, 0.04, 0.04,
//     0.04, 0.04, 0.04, 0.04, 0.04
// };

// // 3x3 box blur filter.
// const int KERNEL_SIZE = 3;
// const DATA_TYPE FILTER_BIAS = 0;
// const DATA_TYPE FILTER_COEF[3][3] = {
//     0.11, 0.11, 0.11,
//     0.11, 0.11, 0.11,
//     0.11, 0.11, 0.11
// };

//// 3x3 inversion filter.
//const int KERNEL_SIZE = 3;
//const DATA_TYPE FILTER_BIAS = 255;
//const DATA_TYPE FILTER_COEF[3][3] = {
//    0,  0,  0,
//    0, -1,  0,
//    0,  0,  0
//};
