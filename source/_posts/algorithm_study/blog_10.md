---
title: 算法中的输入输出处理
categories: 算法学习
tags:
  - algorithm
order: 9
---

## 算法中的输入输出处理

```c++
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <streambuf>


int main(void) {
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);

    std::stringstream ss;
    ss << std::cin.rdbuf();

    // int n = 0;
    // ss >> n;
    // std::vector<int> arr(n);

    // for(int i = 0; i < n; i++) {
    //     ss >> arr[i];
    // }

    int n = 0;
    ss >> n;

    ss.ignore();
    std::vector<std::string> arr(n);
    for(int i = 0; i < n; i++) {
        getline(ss, arr[i]);
    }

    return 0;
}
```

```c++
vector<string> split(const string& str, char delim) {
    vector<string> res;
    stringstream ss(str);
    string temp;
    while (getline(ss, temp, delim)) {
        res.push_back(temp);
    }
    return res;
}
```

## 递归和master公式

递归就是一个问题可以分成与自身相似的子问题，并且问题本身与子问题都可以用同一个流程就行解决，最后随着子问题解决，问题也被解决了。

master公式

1. 所有子问题规模相同的递归才能用master公式，T(n) = a \* T(n/b) + O(n^c)，a、b、c都是常数
2. 如果log(b,a) < c，复杂度为：O(n^c)
3. 如果log(b,a) > c，复杂度为：O(n^log(b,a))
4. 如果log(b,a) == c，复杂度为：O(n^c \* logn)

一个补充
T(n) = 2 \* T(n/2) + O(n \* logn)，时间复杂度是O(n \* ((logn)的平方))，证明过程比较复杂，记住即可

**使用递归返回数组最值**

```c++
int max(int a, int b) {
    return a > b ? a : b;
}

// 采用了分治思想
int get_max(int* arr, int l, int r) {
    if(l > r) return INT_MIN;

    int mid = l + ((r - l) >> 1);

    int left_max = get_max(arr, l, mid - 1);
    int right_max = get_max(arr, mid + 1, r);

    return max(max(left_max, right_max), arr[mid]);
}
```
