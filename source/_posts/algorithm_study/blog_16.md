---
title: 最大公约数与同余原理
categories: 算法学习
tags:
  - algorithm
---

求最大公约数、最小公倍数

```c++
int gcd(int a, int b) {
    return b == 0 ? a : gcd(b, a % b);
}

int lcm(int a, int b) {
    return a / gcd(a, b) * b;
}
```

一个正整数如果能被 a 或 b 整除，那么它是神奇的。
给定三个整数 n , a , b ，返回第 n 个神奇的数字。
因为答案可能很大，所以返回答案 对 1000000007 取模
[测试链接](https://leetcode.cn/problems/nth-magical-number/)

```c++
class Solution {
public:
    int gcd(int a, int b) { return b == 0 ? a : gcd(b, a % b); }

    int lcm(int a, int b) { return a / gcd(a, b) * b; }
    int nthMagicalNumber(int n, int a, int b) {
        long val = lcm(a, b);
        long ans = 0;

        for(long l = 0, r = (long)n * min(a, b), m = 0; l <= r;) {
            m = l + (r - l) / 2;
            if(m / a + m / b - m / val >= n) {
                ans = m;
                r = m - 1;
            } else {
                l = m + 1;
            }
        }

        return ans % 1000000007;
    }
};
```

加法同余原理: (a + b) % c == ((a % c) + (b % c)) % c
减法同余原理: (a - b) % c == ((a % c) - (b % c) + c) % c
乘法同余原理：(a \* b) % c == ((a % c) \* (b % c)) % c
幂运算同余原理：(a ^ b) % c == ((a % c) ^ b) % c
