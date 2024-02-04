#include <hls_stream.h>
#include "stdio.h"
#include <fstream>
#include <vector>

#include "filter_hls.h"

struct ppm_image {
    int width;
    int height;
    int depth;
    std::vector<pixel_t> pixels;

    ppm_image() {}

    ppm_image(int width, int height):
        width(width),
        height(height),
        depth(255)
    {
        pixels.resize(width * height);
    }

    void read(const char *filename) {
        std::ifstream f(filename);

        // Check the magic string.
        std::string magic;
        f >> magic;
        if (magic != "P6") {
            std::cerr << "image " << filename << " is not a binary PPM\n";
            exit(1);
        }

        // Parse width, height, and color depth.
        f >> width >> height >> depth;
        if (depth != 255) {
            std::cerr << "image " << filename << " has invalid depth " << depth << "\n";
            exit(1);
        }

        // Skip trailing whitespace.
        if (f.peek() == '\n')
            f.get();

        // Read the image.
        pixels.reserve(width * height);
        for (size_t i = 0; i < width * height; ++i) {
            uint8_t c[3];
            f.read((char*)c, sizeof(c));
            pixels.push_back((pixel_t){
                (double)c[0],
                (double)c[1],
                (double)c[2]
            });
        }

        std::cout << "Loaded " << pixels.size() << " pixels from " << filename << "\n";
    }

    void write(const char *filename) {
        std::ofstream f(filename);
        f << "P6\n";
        f << width << " " << height << "\n";
        f << depth << "\n";
        for (size_t i = 0; i < pixels.size(); ++i) {
            uint8_t c[3];
            c[0] = (double)pixels[i].r;
            c[1] = (double)pixels[i].g;
            c[2] = (double)pixels[i].b;
            f.write((char*)c, sizeof(c));
        }

        std::cout << "Stored " << pixels.size() << " pixels to " << filename << "\n";
    }
};

int main() {
    // Read the input image.
    ppm_image input;
    input.read("../../../../../simvectors/stim.ppm");

    // Prepare space for the output image.
    ppm_image output(input.width, input.height);

    // Process the frame.
    std::cout << "Starting filter\n";
    std::cout.flush();
    filter_hls(&input.pixels[0], &output.pixels[0]);
    std::cout << "Filter terminated\n";
    std::cout.flush();

    // Write the PPM output image.
    output.write("../../actual.ppm");

    return 0;
}
