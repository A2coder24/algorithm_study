---
title: 双指针
categories: 算法学习
tags:
  - algorithm
---

## 二分答案法

1）估计 最终答案可能的范围 是什么，可以定的粗略，反正二分不了几次
2）分析 问题的答案 和 给定条件 之间的 单调性，大部分时候只需要用到 自然智慧
3）建立一个f函数，当答案固定的情况下，判断 给定的条件是否达标
4）在 最终答案可能的范围上不断二分搜索，每次用f函数判断，直到二分结束，找到最合适的答案

核心点：分析单调性、建立f函数

爱吃香蕉的珂珂
珂珂喜欢吃香蕉。这里有 n 堆香蕉，第 i 堆中有 piles[i] 根香蕉
警卫已经离开了，将在 h 小时后回来。
珂珂可以决定她吃香蕉的速度 k (单位：根/小时)
每个小时，她将会选择一堆香蕉，从中吃掉 k 根
如果这堆香蕉少于 k 根，她将吃掉这堆的所有香蕉，然后这一小时内不会再吃更多的香蕉
珂珂喜欢慢慢吃，但仍然想在警卫回来前吃掉所有的香蕉。
返回她可以在 h 小时内吃掉所有香蕉的最小速度 k（k 为整数）
[测试链接](https://leetcode.cn/problems/koko-eating-bananas/)

```c++
class Solution {
public:
    int minEatingSpeed(vector<int>& piles, int h) {
        int l = 1, r = INT_MIN;
        for (int val : piles) {
            r = max(r, val);
        }

        int ans = INT_MAX;
        int mid = 0;
        long long times = 0;
        while (l <= r) {
            mid = l + (r - l) / 2;
            times = f(piles, mid);
            if (h < times) {
                l = mid + 1;
            } else if (h >= times) {
                ans = min(ans, mid);
                r = mid - 1;
            }
        }

        return ans;
    }

    long long f(vector<int>& piles, int v) {
        long long ans = 0;
        for (int val : piles) {
            ans += (val + v - 1) / v;
        }

        return ans;
    }
};
```

分割数组的最大值(画匠问题)
给定一个非负整数数组 nums 和一个整数 m
你需要将这个数组分成 m 个非空的连续子数组。
设计一个算法使得这 m 个子数组各自和的最大值最小。
[测试链接](https://leetcode.cn/problems/split-array-largest-sum/)

```c++
class Solution {
public:
    int splitArray(vector<int>& nums, int k) {
        int sum = 0;
        for (int val : nums) {
            sum += val;
        }
        int l = 0, r = sum;
        cout << "r = " << r << endl;

        int mid = 0;
        int ans = INT_MAX;
        while (l <= r) {
            mid = l + (r - l) / 2;

            int temp = f(nums, mid);

            if (temp > k) {
                l = mid + 1;
            } else if (temp <= k) {
                ans = mid;
                r = mid - 1;
            }
        }

        return ans;
    }

    int f(vector<int>& nums, int limit) {
        int ans = 1;
        int sum = 0;
        for (int val : nums) {
            if (val > limit) {
                return INT_MAX;
            }

            if (sum + val > limit) {
                ans++;
                sum = val;
            } else {
                sum += val;
            }
        }

        return ans;
    }
};
```

机器人跳跃问题
机器人正在玩一个古老的基于DOS的游戏
游戏中有N+1座建筑，从0到N编号，从左到右排列
编号为0的建筑高度为0个单位，编号为i的建筑的高度为H(i)个单位
起初机器人在编号为0的建筑处
每一步，它跳到下一个（右边）建筑。假设机器人在第k个建筑，且它现在的能量值是E
下一步它将跳到第个k+1建筑
它将会得到或者失去正比于与H(k+1)与E之差的能量
如果 H(k+1) > E 那么机器人就失去H(k+1)-E的能量值，否则它将得到E-H(k+1)的能量值
游戏目标是到达第个N建筑，在这个过程中，能量值不能为负数个单位
现在的问题是机器人以多少能量值开始游戏，才可以保证成功完成游戏
[测试链接](https://www.nowcoder.com/practice/7037a3d57bbd4336856b8e16a9cafd71)

```c++
#include <algorithm>
#include <climits>
#include <iostream>
#include <vector>
#include <sstream>
#include <vector>

using namespace std;
bool f(vector<long long >& h, long long  val, long long max_val) {
    for (int i = 0, n = h.size(); i < n; i++) {

        val = 2 * val - h[i];
        if (val < 0) return false;
        if(val >= max_val) return true;

    }

    return true;
}


int main() {
    stringstream ss;
    ss << cin.rdbuf();

    int n;
    ss >> n;

    vector<long long > h(n);
    long long  sum = 0, max_val = LONG_LONG_MIN;
    for (int i = 0; i < n; i++) {
        ss >> h[i];

        sum += h[i];
        max_val = max(max_val, h[i]);
    }

    long long  l = 0, r = sum;
    long long  mid, ans = 0;
    while (l <= r) {
        mid = l + (r - l) / 2;

        if (f(h, mid, max_val)) {
            ans = mid;
            r = mid - 1;
        } else {

            l = mid + 1;
        }
    }

    cout << ans << endl;

    return 0;
}
```

找出第K小的数对距离
数对 (a,b) 由整数 a 和 b 组成，其数对距离定义为 a 和 b 的绝对差值。
给你一个整数数组 nums 和一个整数 k
数对由 nums[i] 和 nums[j] 组成且满足 0 <= i < j < nums.length
返回 所有数对距离中 第 k 小的数对距离。
测试链接 : https://leetcode.cn/problems/find-k-th-smallest-pair-distance/

```c++
class Solution {
public:
    int smallestDistancePair(vector<int>& nums, int k) {
        sort(nums.begin(), nums.end());
        int l = 0, r = nums.back();
        long long cnt = 0, ans = 0;
        int m;
        while(l <= r) {
            m = l + (r - l) / 2;

            cnt = f(nums, m);
            if(cnt >= k) {
                ans = m;
                r = m - 1;
            } else {
                l = m + 1;
            }
        }

        return ans;
    }

    long long f(vector<int>& nums, int val) {
        long long ans = 0;
        for(int l = 0, r = 0; l < nums.size(); l++) {
            while(r + 1 < nums.size() && nums[r + 1] - nums[l] <= val) {
                r++;
            }

            ans += r - l;
        }

        return ans;
    }
};
```

同时运行N台电脑的最长时间
你有 n 台电脑。给你整数 n 和一个下标从 0 开始的整数数组 batteries
其中第 i 个电池可以让一台电脑 运行 batteries[i] 分钟
你想使用这些电池让 全部 n 台电脑 同时 运行。
一开始，你可以给每台电脑连接 至多一个电池
然后在任意整数时刻，你都可以将一台电脑与它的电池断开连接，并连接另一个电池，你可以进行这个操作 任意次
新连接的电池可以是一个全新的电池，也可以是别的电脑用过的电池
断开连接和连接新的电池不会花费任何时间。
注意，你不能给电池充电。
请你返回你可以让 n 台电脑同时运行的 最长 分钟数。
[测试链接](https://leetcode.cn/problems/maximum-running-time-of-n-computers/)

```c++
class Solution {
public:
    long long maxRunTime(int n, vector<int>& batteries) {
        long long l = 0, r = 0;
        long long sum = 0;

        for(int val : batteries) {
            r = max(r, (long long)val);
            sum += val;
        }

        if(sum >= (long long)n * r) {
            return sum / n;
        }

        long long m, ans = 0;

        while (l <= r) {
            m = l + (r - l) / 2;

            if (f(n, batteries, m)) {
                ans = m;
                l = m + 1;
            } else {
                r = m - 1;
            }
        }

        return ans;
    }

    bool f(int n, vector<int>& batteries, int limit) {
        long long sum = 0;
        for (int val : batteries) {
            if (val > limit) {
                n--;
            } else {
                sum += val;
            }

            if (sum >= ((long long)n * limit)) {
                return true;
            }
        }

        return false;
    }
};
```

完成旅途的最少时间(题目6的在线测试)
有同学找到了在线测试链接，和课上讲的题目6几乎是一个意思，但是有细微差别
实现的代码，除了一些变量需要改成long类型之外，仅有两处关键逻辑不同，都打上了注释
除此之外，和课上讲的题目6的实现，再无区别
可以仔细阅读如下测试链接里的题目，重点关注此题和题目6，在题意上的差别
[测试链接](https://leetcode.cn/problems/minimum-time-to-complete-trips/)

```c++
class Solution {
public:
    long long minimumTime(vector<int>& time, int totalTrips) {
        long long l = 0,
                  r = (long long)*min_element(time.begin(), time.end()) * totalTrips;
        long long ans = 0;

        long long m;
        long long cur;
        while (l <= r) {
            m = l + (r - l) / 2;

            cur = f(time, m);
            if (cur >= totalTrips) {
                ans = m;
                r = m - 1;
            } else {
                l = m + 1;
            }
        }

        return ans;
    }

    long long f(vector<int>& time, long long limit) {
        long long ans = 0;
        for(int val : time) {
            ans += limit / val;
        }

        return ans;
    }
};
```
