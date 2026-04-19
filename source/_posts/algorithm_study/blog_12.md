---
title: 异或操作
categories: 算法学习
tags:
  - algorithm
---

## 异或操作

1）异或运算就是无进位相加
2）异或运算满足交换律、结合律，也就是同一批数字，不管异或顺序是什么，最终的结果都是一个
3）0 ^ n = n，n ^ n=0
4）整体异或和如果是x，整体中某个部分的异或和如果是y，那么剩下部分的异或和是x^y

测试链接: [两个数的最大值](https://www.nowcoder.com/practice/d2707eaf98124f1e8f1d9c18ad487f76)

```c++
 int get_max(int a, int b) {
    int sign_a = (a >> 31) & 1;
    int sign_b = (b >> 31) & 1;

    if(sign_a ^ sign_b) {
        return sign_a ? b : a;
    }

    if(sign_a) {
        a = ~a + 1;
        b = ~b + 1;

        int ans = a;
        for(int i = 30; i >= 0; i--) {
            int bit_a = (a >> i) & 1;
            int bit_b = (b >> i) & 1;
            if(bit_a ^ bit_b) {
                ans = bit_a ? b : a;
                break;
            }
        }

        return ~ans + 1;
    }

    int ans = a;
    for(int i = 30; i >=0; i--) {
        int bit_a = (a >> i) & 1;
        int bit_b = (b >> i) & 1;
        if(bit_a ^ bit_b) {
            ans = bit_a ? a : b;
            break;
        }
    }

    return ans;
}
```

测试链接: [找到缺失的数字](https://leetcode.cn/problems/missing-number/)

```c++
int missing_number(vector<int>& nums) {
    int n = nums.size();
    int temp = 0;
    for(int i = 0; i <= n; i++) {
        temp ^= i;
    }

    int ans = 0;
    for(int i = 0; i < n; i++) {
        ans ^= nums[i];
    }

    return ans ^ temp;
}
```

数组中1种数出现了奇数次，其他的数都出现了偶数次
返回出现了奇数次的数
[测试链接](https://leetcode.cn/problems/single-number/)

```c++
int single_number(vector<int>& nums) {
    int ans = 0;

    for(int& v : nums){
        ans ^= v;
    }

    return ans;
}
```

数组中有2种数出现了奇数次，其他的数都出现了偶数次
返回这2种出现了奇数次的数
[测试链接](https://leetcode.cn/problems/single-number-iii/)

```c++
vector<int> single_two_number(vector<int>& nums) {
    int temp_1 = single_number(nums);

    // Brian Kernighan算法
	// 提取出二进制里最右侧的1
    int right_one = temp_1 & (-temp_1);

    int temp_2 = 0;
    for(int& n : nums) {
        if(n & right_one == 0) {
            temp_2 ^= n;
        }
    }

    return {temp_2, temp_1 ^ temp_2};
}
```

数组中只有1种数出现次数少于m次，其他数都出现了m次
返回出现次数小于m次的那个数
[测试链接](https://leetcode.cn/problems/single-number-ii/)

```c++
int less_m_number(vector<int>& nums) {
    return find(nums, 3);
}

int find(vector<int>& nums, int m) {
    vector<int> cnts(32, 0);
    for(int n : nums) {
        for(int i = 0; i < 32; i++) {
            cnts[i] += (n >> i) & 1;
        }
    }

    int ans = 0;
    for(int i = 0; i < 32; i++) {
        if(cnts[i] % m != 0) {
            ans |= 1 << i;
        }
    }

    return ans;
}
```
