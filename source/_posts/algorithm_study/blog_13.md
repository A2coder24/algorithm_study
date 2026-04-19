---
title: 位运算操作
categories: 算法学习
tags:
  - algorithm
---

## 位运算操作

判断一个整数是不是2的幂
[测试链接](https://leetcode.cn/problems/power-of-two/)

```c++
bool is_power_of_two(int n) {
    return (n > 0 && n == (n & -n)) ? true : false;
}
```

判断一个整数是不是3的幂
[测试链接](https://leetcode.cn/problems/power-of-three/)

```c++
bool is_power_of_three(int n) {
  // 计算出数值n范围内最大的3次幂值
  // int val = 1;
  // while(val < INT_MAX) {
  //   cout << val;
  //   val *= 3;
  // }

  return (n > 0) && (1162261467 % n == 0);
}
```

已知n是非负数
返回大于等于n的最小的2某次方
如果int范围内不存在这样的数，返回整数最小值

```c++
int near_2_power(int n) {
  if(n <= 0) return 1;

  n--;
  n |= n >> 1;
  n |= n >> 2;
  n |= n >> 4;
  n |= n >> 8;
  n |= n >> 16;

  return n + 1;
}
```

给你两个整数 left 和 right ，表示区间 [left, right]
返回此区间内所有数字 & 的结果
包含 left 、right 端点
[测试链接](https://leetcode.cn/problems/bitwise-and-of-numbers-range/)

```c++
int range_bit_wise_and(int left, int right){
  while(left < right) {
    right -= right & (-right);
  }

  return right;
}
```

测试链接: [逆序二进制的状态](https://leetcode.cn/problems/reverse-bits/)

```c++
int reverse_bits(int n) {
  int ans = 0;
  for(int i = 0; i < 32; i++) {
    ans = (ans << 1) + ((n >> i) & 1);
  }

  return ans;
}

int reverse_bits(int n) {
  n = ((n & 0xaaaaaaaa) >> 1) | ((n & 0x55555555) << 1);
  n = ((n & 0xcccccccc) >> 2) | ((n & 0x33333333) << 2);
  n = ((n & 0xf0f0f0f0) >> 4) | ((n & 0x0f0f0f0f) << 4);
  n = ((n & 0xff00ff00) >> 8) | ((n & 0x00ff00ff) << 8);
  n = (n >> 16) | (n << 16);

  return n;
}
```

返回n的二进制中有几个1
两个整数之间的 汉明距离 指的是这两个数字对应二进制位不同的位置的数目。
给你两个整数 x 和 y，计算并返回它们之间的汉明距离
[测试链接](https://leetcode.cn/problems/hamming-distance/)

```c++
int hamming_distance(int x, int y) {
  int cnt = 0;
  for(int i = 0; i < 32; i++) {
    cnt += ((x >> i) & 1) ^ ((y >> i) & 1) ? 1 : 0;
  }

  return cnt;
}


int cnt_ones(int n) {
  n = (n & 0x55555555) + ((n >> 1) & 0x55555555);
  n = (n & 0x33333333) + ((n >> 2) & 0x33333333);
  n = (n & 0x0f0f0f0f) + ((n >> 4) & 0x0f0f0f0f);
  n = (n & 0x00ff00ff) + ((n >> 8) & 0x00ff00ff);
  n = (n & 0x0000ffff) + ((n >> 16) & 0x0000ffff);
  return n;
}

int hamming_distance(int x, int y) {
  return cnt_ones(x ^ y);
}
```
