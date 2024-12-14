#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/** Empty section of the disk */
#define EMPTY SIZE_MAX

/** Convert the input string to an array of file sizes */
uint8_t *input_to_disk_map(char *input, size_t input_size);

/** Returns the number of files to place on the disk */
size_t num_files(size_t input_size);

/** Returns the size of the file with the given ID */
size_t file_size(uint8_t *map, size_t file_id);

/** Returns the size of the empty space after the file with the given ID */
size_t empty_size(uint8_t *map, size_t file_id);

/** Returns the amount of bytes that are consumed by the disk once compacted */
size_t calculate_part_1_disk_size(uint8_t *map, size_t map_length);

/** Returns the number of bytes that are consumed by the disk in part 2 */
size_t calculate_part_2_disk_size(uint8_t *map, size_t map_length);

/** Debug: show disk content */
void show_disk(size_t *disk, size_t disk_size);

/** Fill the disk with file IDs */
void defrag_part_1(uint8_t *map, size_t num_files, size_t *disk,
                   size_t disk_size);

/**
 * Finds the write-head index for the first area of empty space that fits a
 * file of the given size, or `EMPTY` if no earlier space is found.
 */
size_t find_space_for_file(size_t *disk, size_t disk_size, size_t f_size,
                           size_t current_position);

/** Fill the disk with file IDs */
void defrag_part_2(uint8_t *map, size_t num_files, size_t *disk,
                   size_t disk_size);

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

  size_t map_size = buf_len - 1;

  uint8_t *map = input_to_disk_map(input, buf_len);

  size_t part_1_disk_size = calculate_part_1_disk_size(map, map_size);
  size_t *part_1_disk = malloc(sizeof(size_t) * part_1_disk_size);
  defrag_part_1(map, num_files(buf_len), part_1_disk, part_1_disk_size);
  size_t checksum_1 = disk_checksum(part_1_disk, part_1_disk_size);
  printf("Part 1: %zu\n", checksum_1);

  size_t part_2_disk_size = calculate_part_2_disk_size(map, map_size);
  size_t *part_2_disk = malloc(sizeof(size_t) * part_2_disk_size);
  defrag_part_2(map, num_files(buf_len), part_2_disk, part_2_disk_size);
  size_t checksum_2 = disk_checksum(part_2_disk, part_2_disk_size);
  printf("Part 2: %zu\n", checksum_2);

  free(input);
  free(map);
  free(part_1_disk);
  free(part_2_disk);
  return 0;
}

uint8_t *input_to_disk_map(char *input, size_t map_size) {
  // Get rid of trailing newline (null zero isn't included)
  uint8_t *map = malloc(sizeof(uint8_t) * map_size);

  for (size_t i = 0; i < map_size; i++) {
    map[i] = input[i] - '0';
  }
  return map;
}

size_t num_files(size_t input_size) { return input_size / 2; }

size_t file_size(uint8_t *map, size_t file_id) { return map[file_id * 2]; }

size_t empty_size(uint8_t *map, size_t file_id) { return map[file_id * 2 + 1]; }

size_t calculate_part_1_disk_size(uint8_t *map, size_t map_length) {
  size_t total = 0;
  // Advance by 2 bytes at a time to skip over the empty space
  for (size_t i = 0; i < map_length; i += 2) {
    // Add on the space used by this file
    total += map[i];
  }

  return total;
}

size_t calculate_part_2_disk_size(uint8_t *map, size_t map_length) {
  size_t total = 0;
  // Only advance by one byte at a time, since we need to consider the
  // empty space this time
  for (size_t i = 0; i < map_length; i++) {
    // Add on the space used by this file (or empty space)
    total += map[i];
  }

  return total;
}

void show_disk(size_t *disk, size_t disk_size) {
  printf("[");
  for (size_t i = 0; i < disk_size - 1; i++) {
    if (disk[i] == EMPTY) {
      printf("-, ");
    } else {
      printf("%zu, ", disk[i]);
    }
  }
  if (disk[disk_size - 1] == EMPTY) {
    printf("-]\n");
  } else {
    printf("%zu]\n", disk[disk_size - 1]);
  }
}

void defrag_part_1(uint8_t *map, size_t num_files, size_t *disk,
                   size_t disk_size) {
  size_t lower_file = 0;
  size_t upper_file = num_files - 1;
  size_t upper_bytes_written = 0;

  // Index within the disk that we're up to
  size_t write_head = 0;

  while (lower_file < upper_file) {
    // Write the full lower file to disk
    for (size_t i = 0; i < file_size(map, lower_file); i++) {
      disk[write_head + i] = lower_file;
    }
    write_head += file_size(map, lower_file);
    // Now for the remaining space, write the upper file
    for (size_t i = 0; i < empty_size(map, lower_file); i++) {
      disk[write_head + i] = upper_file;
      upper_bytes_written++;
      if (upper_bytes_written >= file_size(map, upper_file)) {
        upper_file--;
        upper_bytes_written = 0;
        // Quit early if we wrote the final data
        if (upper_file == lower_file) {
          break;
        }
      }
    }
    write_head += empty_size(map, lower_file);
    lower_file++;
  }

  // If any space is remaining for the final byte, write that too
  // But only if the file hasn't been fully written yet (otherwise we'll write
  // the same file twice)
  if (upper_file == lower_file) {
    for (size_t i = 0; upper_bytes_written + i < file_size(map, upper_file);
         i++) {
      disk[write_head + i] = upper_file;
    }
  }
}

size_t find_space_for_file(size_t *disk, size_t disk_size, size_t f_size,
                           size_t current_position) {
  size_t empty_start = 0;
  bool in_empty_section = false;
  for (size_t i = 0; i < current_position; i++) {
    if (disk[i] == EMPTY) {
      if (!in_empty_section) {
        in_empty_section = true;
        empty_start = i;
      }
      if (i - empty_start + 1 >= f_size) {
        // Found sufficiently large empty section
        return empty_start;
      }
    } else if (in_empty_section) {
      in_empty_section = false;
    }
  }
  // No matches found
  return EMPTY;
}

void defrag_part_2(uint8_t *map, size_t num_files, size_t *disk,
                   size_t disk_size) {
  /** Table of file IDs to their positions within the table */
  size_t *files_table = malloc(sizeof(size_t) * num_files);

  // Write all files
  size_t write_head = 0;
  for (size_t i = 0; i < num_files; i++) {
    // File
    for (size_t j = 0; j < file_size(map, i); j++) {
      disk[write_head + j] = i;
    }
    files_table[i] = write_head;
    // Also add to write table
    write_head += file_size(map, i);
    // Empty space, except for last file
    if (i < num_files - 1) {
      // show_disk(disk, disk_size);
      for (size_t j = 0; j < empty_size(map, i); j++) {
        disk[write_head + j] = EMPTY;
      }
      write_head += empty_size(map, i);
    }
  }

  for (size_t i = num_files - 1; i > 0; i--) {
    // Attempt to bring file back
    size_t new_pos =
        find_space_for_file(disk, disk_size, file_size(map, i), files_table[i]);
    if (new_pos == EMPTY) {
      // If no space was found, skip it
      continue;
    }
    size_t old_pos = files_table[i];
    // Otherwise, remove it from the table
    for (size_t j = 0; j < file_size(map, i); j++) {
      disk[old_pos + j] = EMPTY;
    }
    // Then write it in the new position
    for (size_t j = 0; j < file_size(map, i); j++) {
      disk[new_pos + j] = i;
    }
    files_table[i] = new_pos;
  }

  // Zero all empty sections of the disk
  for (size_t write_head = 0; write_head < disk_size; write_head++) {
    if (disk[write_head] == EMPTY) {
      disk[write_head] = 0;
    }
  }

  free(files_table);
}

size_t disk_checksum(size_t *disk, size_t disk_size) {
  size_t sum = 0;
  for (size_t i = 0; i < disk_size; i++) {
    sum += i * disk[i];
  }
  return sum;
}
