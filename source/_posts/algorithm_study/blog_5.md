---
title: 二分搜索
categories: 算法学习
tags:
  - 算法学习
---

## 二分搜索

目的：在一个有序数组中确定 target 是否存在

```c++
bool binary_search(std::vector<int> arr, int target){
    std::sort(arr.begin(), arr.end());

    int left = 0, right = arr.size() - 1, mid = (left + right) >> 1;

    while(left <= right) {
        if(arr[mid] == target) {
            return true;
        } else if(arr[mid] > target) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }

        mid = (left + right) >> 1;
    }

    return false;
}
```

二分搜索不一定发生在有序数组上

峰值元素是指其值严格大于左右相邻值的元素
给你一个整数数组 nums，已知任何两个相邻的值都不相等
找到峰值元素并返回其索引
数组可能包含多个峰值，在这种情况下，返回 任何一个峰值 所在位置即可。
你可以假设 nums[-1] = nums[n] = 无穷小
你必须实现时间复杂度为 O(log n) 的算法来解决此问题。
测试链接 : [寻找峰值](https://leetcode.cn/problems/find-peak-element/)

```c++
int findPeakElement(vector<int>& nums) {
    if(nums.size() == 1) return 0;
    if(nums[0] > nums[1]) return 0;
    int len = nums.size() - 1;
    if(nums[len] > nums[len - 1]) return len;

    int left = 0, right = len, mid = (left + right) >> 1;

    while(left <= right) {
        if(nums[mid] > nums[mid - 1] && nums[mid] > nums[mid + 1]) {
            return mid;
        } else if(nums[mid] > nums[mid - 1]) {
            left = mid;
        } else if(nums[mid] > nums[mid + 1]) {
            right = mid;
        } else {
            left = mid + 1;
        }

        mid = (left + right) >> 1;
    }

    return -1;
}
```
