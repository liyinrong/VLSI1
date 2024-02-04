#include "filter_hls.h"

// The kernel used to compute the color of a single pixel. The window passed to
// the function is centered around the output pixel, i.e. it represents a
// KERNEL_SIZE neighborhood around the output pixel.
pixel_t pixel_kernel(pixel_t window[KERNEL_SIZE][KERNEL_SIZE]) {
    #pragma HLS inline

    // Simple implementation which inverts the image.
    pixel_t result;
//    result.r = 255 - window[KERNEL_SIZE/2][KERNEL_SIZE/2].r;
//    result.g = 255 - window[KERNEL_SIZE/2][KERNEL_SIZE/2].g;
//    result.b = 255 - window[KERNEL_SIZE/2][KERNEL_SIZE/2].b;
    DATA_TYPE sum_r = FILTER_BIAS;
    DATA_TYPE sum_g = FILTER_BIAS;
    DATA_TYPE sum_b = FILTER_BIAS;
    for (int i = 0; i < KERNEL_SIZE; i++) {
		for (int j = 0; j < KERNEL_SIZE; j++) {
			sum_r += window[i][j].r * FILTER_COEF[i][j];
			sum_g += window[i][j].g * FILTER_COEF[i][j];
			sum_b += window[i][j].b * FILTER_COEF[i][j];
		}
	}
    if (sum_r < 0)
    	sum_r = 0;
    else if (sum_r > 255)
    	sum_r = 255;
    if (sum_g < 0)
    	sum_g = 0;
    else if (sum_g > 255)
    	sum_g = 255;
    if (sum_b < 0)
    	sum_b = 0;
    else if (sum_b > 255)
    	sum_b = 255;
    result.r = sum_r;
    result.g = sum_g;
    result.b = sum_b;
    return result;
}

void filter_hls(const pixel_t *data_in, pixel_t *data_out) {
    #pragma HLS INTERFACE axis port=data_in
    #pragma HLS INTERFACE axis port=data_out

    #pragma HLS data_pack variable=data_in
    #pragma HLS data_pack variable=data_out

    static pixel_t lines[KERNEL_SIZE-1][X_RESOLUTION];
    static pixel_t window[KERNEL_SIZE][KERNEL_SIZE];

    const int KERNEL_OFFSET = (KERNEL_SIZE-1)/2;

    y_loop: for (int y = 0; y < Y_RESOLUTION + KERNEL_OFFSET; ++y) {
        x_loop: for (int x = 0; x < X_RESOLUTION + KERNEL_OFFSET; ++x) {
#pragma HLS PIPELINE II=1
            // Shift the processing window to the left.
            for (int v = 0; v < KERNEL_SIZE; ++v)
                for (int u = 0; u < KERNEL_SIZE-1; ++u)
                    window[v][u] = window[v][u+1];

            if (x < X_RESOLUTION) {
                // Copy pixels from the line buffer into the window.
                for (int v = 0; v < KERNEL_SIZE-1; ++v)
                    window[v][KERNEL_SIZE-1] = lines[v][x];

                // Shift the line buffer up by one pixel.
                for (int v = 0; v < KERNEL_SIZE-2; ++v)
                    lines[v][x] = lines[v+1][x];
            } else {
                for (int v = 0; v < KERNEL_SIZE-1; ++v)
                    window[v][KERNEL_SIZE-1] = (pixel_t){0,0,0};
            }

            // Read next input pixel into the window and line buffer.
            if (x < X_RESOLUTION && y < Y_RESOLUTION) {
                pixel_t input = data_in[y*X_RESOLUTION+x];
                window[KERNEL_SIZE-1][KERNEL_SIZE-1] = input;
                lines[KERNEL_SIZE-2][x] = input;
            } else {
                window[KERNEL_SIZE-1][KERNEL_SIZE-1] = (pixel_t){0,0,0};
            }

            // Compute the next output pixel.
            if (x >= KERNEL_OFFSET && y >= KERNEL_OFFSET) {
                pixel_t output = pixel_kernel(window);
                data_out[(y-KERNEL_OFFSET)*X_RESOLUTION+(x-KERNEL_OFFSET)] = output;
            }
        }
    }
}
