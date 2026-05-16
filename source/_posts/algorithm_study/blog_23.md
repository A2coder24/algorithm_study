---
title: 单调栈
categories: 算法学习
tags:
  - algorithm
---

## 单调栈

单调栈最经典的用法是解决如下问题：
每个位置都求：
0）当前位置的 左侧比当前位置的数字小，且距离最近的位置 在哪
1）当前位置的 右侧比当前位置的数字小，且距离最近的位置 在哪
或者
每个位置都求：
0）当前位置的 左侧比当前位置的数字大，且距离最近的位置 在哪
1）当前位置的 右侧比当前位置的数字大，且距离最近的位置 在哪

用单调栈的方式可以做到：求解过程中，单调栈所有调整的总代价为O(n)，单次操作的均摊代价为O(1)

单调栈求每个位置左右两侧，离当前位置最近、且值严格小于的位置
给定一个可能含有重复值的数组 arr
找到每一个 i 位置左边和右边离 i 位置最近且值比 arr[i] 小的位置
返回所有位置相应的信息。
输入描述：
第一行输入一个数字 n，表示数组 arr 的长度。
以下一行输入 n 个数字，表示数组的值
输出描述：
输出n行，每行两个数字 L 和 R，如果不存在，则值为 -1，下标从 0 开始。
[测试链接](https://www.nowcoder.com/practice/2a2c00e7a88a498693568cef63a4b7bb)

```c++
#include <iostream>
#include <vector>
using namespace std;

int main() {
    ios::sync_with_stdio(false);

    int n;
    cin >> n;
    vector<int> arr(n);
    for(int i = 0; i < n; i++) {
        cin >> arr[i];
    }

    vector<int> stack(n + 5);
    int top = 0;
    int cur;

    vector<vector<int>> ans(n, vector<int>(2));
    for(int i = 0; i < n; i++) {
        while(top > 0 && arr[stack[top - 1]] >= arr[i]) {
            cur = stack[--top];

            ans[cur][0] = top > 0 ? stack[top - 1] : -1;
            ans[cur][1] = i;
        }

        stack[top++] = i;
    }

    while(top > 0) {
        cur = stack[--top];
        ans[cur][0] = top > 0 ? stack[top - 1] : -1;
        ans[cur][1] = -1;
    }

    for(int i = n - 2; i >= 0; i--) {
        if(ans[i][1] != -1 && arr[ans[i][1]] == arr[i]) {
            ans[i][1] = ans[ans[i][1]][1];
        }
    }

    for(auto ans_arr : ans) {
        for(auto val : ans_arr) {
            cout << val << ' ';
        }
        cout << '\n';
    }

}

```

每日温度
给定一个整数数组 temperatures ，表示每天的温度，返回一个数组 answer
其中 answer[i] 是指对于第 i 天，下一个更高温度出现在几天后
如果气温在这之后都不会升高，请在该位置用 0 来代替。
[测试链接](https://leetcode.cn/problems/daily-temperatures/)

```c++
class Solution {
public:
    vector<int> dailyTemperatures(vector<int>& temperatures) {
        int n = temperatures.size();
        vector<int> stack(n);
        int top = 0;

        vector<int> ans(n);

        for(int i = 0, cur; i < n; i++) {
            while(top > 0 && temperatures[stack[top - 1]] < temperatures[i]) {
                cur = stack[--top];

                ans[cur] = i - cur;
            }

            stack[top++] = i;
        }

        return ans;
    }
};
```

子数组的最小值之和
给定一个整数数组 arr，找到 min(b) 的总和，其中 b 的范围为 arr 的每个（连续）子数组。
由于答案可能很大，答案对 1000000007 取模
[测试链接](https://leetcode.cn/problems/sum-of-subarray-minimums/)

```c++
class Solution {
public:
    int MOD = 1000000007;
    int sumSubarrayMins(vector<int>& arr) {
        int ans = 0;
        int n = arr.size();
        vector<int> stack(n);
        int top = 0;

        for(int i = 0; i < n; i++) {
            while(top > 0 && arr[stack[top - 1]] >= arr[i]) {
                int cur = stack[--top];
                int left = top == 0 ? -1 : stack[top - 1];
                ans = (ans + (long long)(cur - left) * (i - cur) * arr[cur]) % MOD;
            }
            stack[top++] = i;
        }

        while(top > 0) {
            int cur = stack[--top];
            int left = top == 0 ? -1 : stack[top - 1];
            ans = (ans + (long long)(cur -left) * (n - cur) * arr[cur]) % MOD;
        }

        return (int)ans;

    }
};
```

柱状图中最大的矩形
给定 n 个非负整数，用来表示柱状图中各个柱子的高度
每个柱子彼此相邻，且宽度为 1 。求在该柱状图中，能够勾勒出来的矩形的最大面积
[测试链接](https://leetcode.cn/problems/largest-rectangle-in-histogram)

```c++
class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        int n = heights.size();
        vector<int> stack(n);
        int top = 0;
        int ans = 0;

        for(int i = 0; i < n; i++) {
            while(top > 0 && heights[stack[top - 1]] >= heights[i]) {
                int cur = stack[--top];
                int left = top == 0 ? -1 : stack[top - 1];

                ans = max(ans, heights[cur] * (i - left - 1));
            }

            stack[top++] = i;
        }

        while(top > 0) {
            int cur = stack[--top];
            int left = top == 0 ? -1 : stack[top - 1];

            ans = max(ans, heights[cur] * (n - left - 1));
        }

        return ans;
    }
};
```

最大矩形
给定一个仅包含 0 和 1 、大小为 rows \* cols 的二维二进制矩阵
找出只包含 1 的最大矩形，并返回其面积
[测试链接](https://leetcode.cn/problems/maximal-rectangle/)

```c++
class Solution {
public:
    int maximalRectangle(vector<vector<char>>& matrix) {
        int n = matrix.size();
        int m = matrix[0].size();

        vector<int> height(m);
        int ans = 0;

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                height[j] = matrix[i][j] == '0' ? 0 : height[j] + 1;
            }

            ans = max(ans, largestRectangleArea(height));
        }

        return ans;
    }

    int largestRectangleArea(vector<int>& height) {
        int n = height.size();
        vector<int> stack(n);
        int top = 0;
        int ans = 0;

        for (int i = 0; i < n; i++) {
            while (top > 0 && height[stack[top - 1]] >= height[i]) {
                int cur = stack[--top];
                int left = top == 0 ? -1 : stack[top - 1];

                ans = max(ans, height[cur] * (i - left - 1));
            }

            stack[top++] = i;
        }

        while (top > 0) {
            int cur = stack[--top];
            int left = top == 0 ? -1 : stack[top - 1];

            ans = max(ans, height[cur] * (n - left - 1));
        }

        return ans;
    }
};
```

最大宽度坡
给定一个整数数组 A，坡是元组 (i, j)，其中  i < j 且 A[i] <= A[j]
这样的坡的宽度为 j - i，找出 A 中的坡的最大宽度，如果不存在，返回 0
[测试链接](https://leetcode.cn/problems/maximum-width-ramp/)

```c++
class Solution {
public:
    int maxWidthRamp(vector<int>& nums) {
        int n = nums.size();
        vector<int> stack(n);
        int top = 1;

        for(int i = 1; i < n; i++) {
            if(nums[stack[top - 1]] > nums[i]) {
                stack[top++] = i;
            }
        }

        int ans = 0;
        for(int i = n - 1; i >= 0; i--) {
            while(top > 0 && nums[stack[top - 1]] <= nums[i]) {
                ans = max(ans, i - stack[--top]);
            }
        }

        return ans;
    }
};
```

去除重复字母保证剩余字符串的字典序最小
给你一个字符串 s ，请你去除字符串中重复的字母，使得每个字母只出现一次
需保证 返回结果的字典序最小
要求不能打乱其他字符的相对位置
测试链接 : https://leetcode.cn/problems/remove-duplicate-letters/

```c++
class Solution {
public:
    string removeDuplicateLetters(string s) {
        int n = s.size();
        vector<bool> enter(26, false);
        vector<int> cnts(26, 0);
        for(char ch : s) {
            cnts[ch - 'a']++;
        }

        vector<char> stack(n);
        int top = 0;

        for(char ch : s) {
            int cur = ch - 'a';
            if(!enter[cur]) {
                while(top > 0 && stack[top - 1] > ch && cnts[stack[top - 1] - 'a'] > 0) {
                    enter[stack[top - 1] - 'a'] = false;
                    top--;
                }

                stack[top++] = ch;
                enter[cur] = true;
            }

            cnts[cur]--;
        }

        string ans = "";
        for(int i = 0; i < top; i++) {
            ans += stack[i];
        }

        return ans;
    }
};
```

大鱼吃小鱼问题
给定一个数组arr，每个值代表鱼的体重
每一轮每条鱼都会吃掉右边离自己最近比自己体重小的鱼，每条鱼向右找只吃一条
但是吃鱼这件事是同时发生的，也就是同一轮在A吃掉B的同时，A也可能被别的鱼吃掉
如果有多条鱼在当前轮找到的是同一条小鱼，那么在这一轮，这条小鱼同时被这些大鱼吃
请问多少轮后，鱼的数量就固定了
比如 : 8 3 1 5 6 7 2 4
第一轮 : 8吃3；3吃1；5、6、7吃2；4没有被吃。数组剩下 8 5 6 7 4
第二轮 : 8吃5；5、6、7吃4。数组剩下 8 6 7
第三轮 : 8吃6。数组剩下 8 7
第四轮 : 8吃7。数组剩下 8。
过程结束，返回4
[测试链接](https://leetcode.cn/problems/steps-to-make-array-non-decreasing/)

```c++
class Solution {
public:
    int totalSteps(vector<int>& nums) {
        int n = nums.size();
        vector<vector<int>> stack(n, vector<int>(2, 0));
        int top = 0;

        int ans = 0;

        for (int i = n - 1, cur; i >= 0; i--) {
            cur = 0;
            while (top > 0 && stack[top - 1][0] < nums[i]) {
                cur = max(cur + 1, stack[--top][1]);
            }

            stack[top][0] = nums[i];
            stack[top++][1] = cur;

            ans = max(ans, cur);
        }

        return ans;
    }
};
```

统计全1子矩形的数量
给你一个 m \* n 的矩阵 mat，其中只有0和1两种值
请你返回有多少个 子矩形 的元素全部都是1
[测试链接](https://leetcode.cn/problems/count-submatrices-with-all-ones/)

```c++
class Solution {
public:
    int numSubmat(vector<vector<int>>& mat) {
        int n = mat.size();
        int m = mat[0].size();
        vector<int> height(m);
        vector<int> stack(m);

        int ans = 0;
        for (auto& arr : mat) {
            for (int i = 0; i < m; i++) {
                height[i] = arr[i] == 0 ? 0 : height[i] + 1;
            }

            ans += count_mat(height, stack, 0);
        }

        return ans;
    }

    int count_mat(vector<int>& height, vector<int>& stack, int top) {
        int ans = 0;

        int n = height.size();
        for (int i = 0, left, len, bottom; i < n; i++) {
            while (top > 0 && height[stack[top - 1]] >= height[i]) {
                int cur = stack[--top];
                if (height[cur] > height[i]) {
                    left = top == 0 ? -1 : stack[top - 1];
                    len = i - left - 1;
                    bottom = max(left == -1 ? 0 : height[left], height[i]);

                    ans += (height[cur] - bottom) * len * (len + 1) / 2;
                }
            }

            stack[top++] = i;
        }

        while (top > 0) {
            int cur = stack[--top];
            int left = top == 0 ? -1 : stack[top - 1];
            int len = n - left - 1;
            int down = left == -1 ? 0 : height[left];

            ans += (height[cur] - down) * len * (len + 1) / 2;
        }

        return ans;
    }
};
```
