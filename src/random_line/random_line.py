#!/usr/bin/env python3
# coding: utf–8

import os
import struct
import sys


def build_index(input_file, index_file):
    with open(input_file, 'r', encoding='utf-8') as infile, open(index_file, 'wb') as indexfile:
        offsets = []
        offset = 0
        for line in infile:
            offsets.append(offset)
            offset += len(line.encode('utf-8'))

        for offset_value in offsets:
            indexfile.write(struct.pack('Q', offset_value))


def read_line_from_index(input_file, index_file, line_index):
    with open(index_file, 'rb') as indexfile:
        indexfile.seek(line_index * struct.calcsize('Q'))
        offset_value = struct.unpack('Q', indexfile.read(struct.calcsize('Q')))[0]

    with open(input_file, 'r', encoding='utf-8') as infile:
        infile.seek(offset_value)
        return infile.readline().rstrip('\n')


def main():
    if len(sys.argv) != 3:
        print("Please specify input file and index")
        sys.exit(1)

    input_file_path = sys.argv[1]
    index_file_path = input_file_path + ".index"
    line_index = int(sys.argv[2])

    # Check index file
    if not os.path.exists(index_file_path):
        build_index(input_file_path, index_file_path)

    result_line = read_line_from_index(input_file_path, index_file_path, line_index)
    print(result_line)


if __name__ == "__main__":
    main()
