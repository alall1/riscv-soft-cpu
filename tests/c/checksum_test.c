#include <stdint.h>

// simple data-processing checksum test

int32_t checksum_filter(const int32_t *arr, int32_t n, int32_t threshold, int32_t *out_count) {
    int32_t checksum = 0;
    int32_t count = 0;

    for (int32_t i = 0; i < n; i++) {
        int32_t v = arr[i];

        if (v < threshold) {
            count++;
        }

        if (v & 1) {
            checksum = checksum ^ (v << 1);
        } else {
            checksum = checksum + (v >> 1);
        }
    }

    *out_count = count;
    return checksum;
}

int main(void) {
    int32_t arr[6] = {12, -7, 25, 4, -16, 33};
    int32_t count = 0;

    int32_t checksum = checksum_filter(arr, 6, 10, &count);

    return 0;
}
