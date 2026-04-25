---
title: 算法中的输入输出处理
categories: 算法学习
tags:
  - algorithm
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

**小和问题**

测试链接 : [小和问题](https://www.nowcoder.com/practice/edfe05a1d45c4ea89101d936cac32469)

```c++
#define N 100005

int arr[N];
int temp[N];

long merge(int* arr, int l, int m, int r) {
    long ans = 0;
    for(int i = l, j = m + 1, sum = 0; j <= r; j++) {
        while(i <= m && arr[i] <= arr[j]) {
            sum += arr[i++];
        }
        ans += sum;
    }

    int i = l, j = m + 1, k = l;
    while(i <= m && j<= r) {
        if(arr[i] <= arr[j]) {
            temp[k] = arr[i++];
        } else {
            temp[k] = arr[j++];
        }

        k++;
    }

    while(i <= m) {
        temp[k++] = arr[i++];
    }

    while(j <= r) {
        temp[k++] = arr[j++];
    }

    while(l <= r) {
        arr[l] = temp[l];
        l++;
    }

    return ans;
}

long merge_sort(int* arr, int l, int r) {
    if(l == r) return 0;

    int mid = l + ((r - l) >> 1);

    long left = merge_sort(arr, l, mid);
    long right = merge_sort(arr, mid + 1, r);

    long cross = merge(arr, l, mid, r);

    return left + right + cross;
}

void small_sum(void) {
    stringstream ss;
    ss << cin.rdbuf();

    int n = 0;
    ss >> n;


    for(int i = 0; i < n; i++) {
        ss >> arr[i];
    }

    cout << merge_sort(arr, 0, n - 1);

}
```

**翻转对**

测试链接: [翻转对](https://leetcode.cn/problems/reverse-pairs/)

```c++
int temp[50005] = {0};

int merge(vector<int>& arr, int l, int m, int r) {
    int ans = 0;

    for(int i = l, j = m + 1, sum = 0; i <= m; i++) {
        while(j <= r && arr[i] > (long)arr[j] << 1){
            sum += 1;
            j++;
        }

        ans += sum;
    }

    int i = l, j = m + 1, k = l;
    while(i <= m && j<= r) {
        if(arr[i] <= arr[j]) {
            temp[k] = arr[i++];
        } else {
            temp[k] = arr[j++];
        }

        k++;
    }
    while(i <= m) {
        temp[k++] = arr[i++];
    }

    while(j <= r) {
        temp[k++] = arr[j++];
    }

    while(l <= r) {
        arr[l] = temp[l];
        l++;
    }

    return ans;
}

int merge_sort(vector<int>& arr, int l, int r) {
    if(l == r) return 0;

    int mid = (l + r) >> 1;

    int left = merge_sort(arr, l, mid);
    int right = merge_sort(arr, mid + 1, r);
    int cross = merge(arr, l, mid, r);

    return left + right + cross;
}

int reverse_pairs(vector<int>& num) {
    int n = num.size();


    return merge_sort(num, 0, n - 1);
}
```

字符串的全部子序列
子序列本身是可以有重复的，只是这个题目要求去重
[测试链接](https://www.nowcoder.com/practice/92e6247998294f2c933906fdedbc6e6a)

```c++
class Solution {
  public:
    vector<string> generatePermutation(string s) {
        f(s, 0, "");

        return ans;
    }

    void f(const string& s, int idx, string str) {
        ans.push_back(str);

        unordered_set<char> set;
        for (int i = idx; i < s.size(); i++) {
            if (set.find(s[i]) != set.end()) {
                continue;
            }

            set.insert(s[i]);
            f(s, i + 1, str + s[i]);

        }
    }

  private:
    vector<string> ans;
};
```

给你一个整数数组 nums ，其中可能包含重复元素，请你返回该数组所有可能的组合
答案 不能 包含重复的组合。返回的答案中，组合可以按 任意顺序 排列
注意其实要求返回的不是子集，因为子集一定是不包含相同元素的，要返回的其实是不重复的组合
[测试链接](https://leetcode.cn/problems/subsets-ii/)

```c++
class Solution {
public:
    vector<vector<int>> subsetsWithDup(vector<int>& nums) {
        sort(nums.begin(), nums.end());

        vector<int> path(nums.size(), 0);
        vector<vector<int>> ans;

        f(nums, 0, path, 0, ans);

        return ans;
    }

    void f(const vector<int>& nums, int i, vector<int>& path, int size, vector<vector<int>>& ans) {
        if(i == nums.size()) {
            vector<int> temp;
            for(int j = 0; j < size; j++) {
                temp.push_back(path[j]);
            }
            ans.push_back(temp);
        } else {
            int j = i + 1;
            while(j < nums.size() && nums[i] == nums[j]) {
                j++;
            }

            f(nums, j, path, size, ans);
            for(; i < j; i++){
                path[size++] = nums[i];
                f(nums, j, path, size, ans);
            }
        }
    }
};
```

没有重复项数字的全排列
[测试链接](https://leetcode.cn/problems/permutations/)

```c++
class Solution {
public:
    vector<vector<int>> permute(vector<int>& nums) {
        f(nums, 0);
        return ans;
    }

    void f(vector<int>& nums, int i) {
        if(i == nums.size()) {
            ans.push_back(nums);
        } else {
            for(int j = i; j < nums.size(); j++) {
                swap(nums[i], nums[j]);
                f(nums, i + 1);
                swap(nums[i], nums[j]);
            }
        }

    }

private:
    vector<vector<int>> ans;
};
```

有重复项数组的去重全排列
[测试链接](https://leetcode.cn/problems/permutations-ii/)

```c++
class Solution {
public:
    vector<vector<int>> permuteUnique(vector<int>& nums) {
        f(nums, 0);
        return ans;
    }

    void f(vector<int>& nums, int i) {
        if(i == nums.size()) {
            ans.push_back(nums);
        } else {
            unordered_set<int> set;
            for(int j = i; j < nums.size(); j++) {
                if(set.find(nums[j]) == set.end()) {
                    set.insert(nums[j]);
                    swap(nums[i], nums[j]);
                    f(nums, i + 1);
                    swap(nums[i], nums[j]);
                }
            }
        }
    }

private:
    vector<vector<int>> ans;
};
```

用递归函数逆序栈

```c++
#define N 1001
int top = -1;
int stack[N];

void reverse(void) {
    if(top == -1) {
        return;
    }

    int element = bottom_out();
    reverse();

    stack[++top] = element;
}

int bottom_out(void) {
    int cur = stack[top--];
    if(top == -1) {
        return cur;
    }

    int ans = bottom_out();
    stack[++top] = cur;

    return ans;
}
```
