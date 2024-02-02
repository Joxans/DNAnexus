#!/usr/bin/env python3
# coding: utf–8

import sys


def search(arr, x):
    low = 0
    high = len(arr) - 1

    while low <= high:
        mid = (low + high) // 2

        if arr[mid] < x:
            low = mid + 1
        elif arr[mid] >= x:
            high = mid - 1

    if low < len(arr) and arr[low] >= x:
        return low
    return -1


def main():
    if len(sys.argv) != 3:
        print("Please specify array and value to search")
        sys.exit(1)

    arr = list(map(int, sys.argv[1].split(',')))
    x = int(sys.argv[2])

    result = search(arr, x)

    if result != -1:
        print(f"Index: {result}")
    else:
        print("The value is out of range.")


if __name__ == "__main__":
    main()