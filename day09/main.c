#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

/** Returns the number of files to place on the disk */
size_t num_files(size_t input_size);

/** Returns the size of the file with the given ID */
size_t file_size(char *input, size_t file_id);

/** Returns the size of the empty space after the file with the given ID */
size_t empty_size(char *input, size_t file_id);

/** Returns the amount of bytes that are consumed by the disk once compacted */
size_t calculate_disk_size(char *input);

/** Fill the disk with file IDs */
void fill_disk(char *input, size_t num_files, size_t *disk);

/** Perform the given check-sum on the disk */
size_t disk_checksum(size_t *disk, size_t disk_size);

int main(void) {
  char *input;
  size_t buf_size;
  size_t buf_len = getline(&input, &buf_size, stdin);

  if (buf_len < 0) {
    fprintf(stderr, "Failed to read input, getline returned %zu\n", buf_len);
    exit(1);
  }

  size_t disk_size = calculate_disk_size(input);

  // printf("Num files: %zu\n", num_files(buf_len));
  // for (size_t i = 0; i < num_files(buf_len); i++) {
  //   printf("File %zu: %zu bytes\n", i, file_size(input, i));
  // }
  // printf("Requires %zu bytes total\n", disk_size);

  size_t *disk = malloc(sizeof(size_t) * disk_size);

  fill_disk(input, num_files(buf_len), disk);

  size_t checksum = disk_checksum(disk, disk_size);

  printf("Part 1: %zu\n", checksum);

  free(input);
  free(disk);
  return 0;
}

size_t num_files(size_t input_size) { return input_size / 2; }

size_t file_size(char *input, size_t file_id) {
  return input[file_id * 2] - '0';
}

size_t empty_size(char *input, size_t file_id) {
  return input[file_id * 2 + 1] - '0';
}

size_t calculate_disk_size(char *input) {
  size_t total = 0;
  for (size_t i = 0;
       // Check for newline and null zero, in case of trailing blank space on
       // the disk
       input[i] != '\n' && input[i] != '\0';
       // Advance by 2 bytes at a time to skip over the empty space
       i += 2) {
    // Add on the space used by this file
    total += input[i] - '0';
  }

  return total;
}

void fill_disk(char *input, size_t num_files, size_t *disk) {
  size_t lower_file = 0;
  size_t upper_file = num_files - 1;
  size_t upper_bytes_written = 0;

  // Index within the disk that we're up to
  size_t disk_index = 0;

  while (lower_file < upper_file) {
    // Write the full lower file to disk
    for (size_t i = 0; i < file_size(input, lower_file); i++) {
      disk[disk_index + i] = lower_file;
    }
    disk_index += file_size(input, lower_file);
    // Now for the remaining space, write the upper file
    for (size_t i = 0; i < empty_size(input, lower_file); i++) {
      disk[disk_index + i] = upper_file;
      upper_bytes_written++;
      if (upper_bytes_written >= file_size(input, upper_file)) {
        upper_file--;
        upper_bytes_written = 0;
        // Quit early if we wrote the final data
        if (upper_file == lower_file) {
          break;
        }
      }
    }
    disk_index += empty_size(input, lower_file);
    lower_file++;
  }

  // If any space is remaining for the final byte, write that too
  for (size_t i = 0; upper_bytes_written + i < file_size(input, upper_file);
       i++) {
    disk[disk_index + i] = upper_file;
  }
}

size_t disk_checksum(size_t *disk, size_t disk_size) {
  size_t sum = 0;
  for (size_t i = 0; i < disk_size; i++) {
    sum += i * disk[i];
  }
  return sum;
}
