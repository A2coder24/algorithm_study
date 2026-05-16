---
title: 单调队列
categories: 算法学习
tags:
  - algorithm
---

## 单调队列

单调队列最经典的用法是解决如下问题：
滑动窗口在滑动时，r++代表右侧数字进窗口，l++代表左侧数字出窗口
这个过程中，想随时得到当前滑动窗口的 最大值 或者 最小值
窗口滑动的过程中，单调队列所有调整的总代价为O(n)，单次操作的均摊代价为O(1)

除了单调队列最经典的用法之外，在很多问题里单调队列还可以 维持求解答案的可能性
1）单调队列里的所有对象按照 规定好的单调性来组织
2）当某个对象从队尾进入单调队列时，
会从 队头 或者 队尾 依次淘汰单调队列里，对后续求解答案没有帮助 的对象
3）每个对象一旦从单调队列弹出，可以结算此时这个对象参与的答案，
随后这个对象 不再参与后续求解答案的过程
4）其实是 先有对题目的分析！进而发现单调性，然后利用 单调队列的特征 去实现

滑动窗口最大值（单调队列经典用法模版）
给你一个整数数组 nums，有一个大小为 k 的滑动窗口从数组的最左侧移动到数组的最右侧
你只可以看到在滑动窗口内的 k 个数字。滑动窗口每次只向右移动一位。
返回 滑动窗口中的最大值 。
[测试链接](https://leetcode.cn/problems/sliding-window-maximum/)

```c++
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        vector<int> ans;

        int n = nums.size();
        deque<int> que;
        for (int i = 0; i < k; i++) {
            while (!que.empty() && nums[que.back()] < nums[i]) {
                que.pop_back();
            }

            que.push_back(i);
        }

        ans.push_back(nums[que.front()]);

        for (int i = k; i < n; i++) {
            if(que.front() <= i - k) {
                que.pop_front();
            }
            while (!que.empty() && nums[que.back()] < nums[i]) {
                que.pop_back();
            }
            que.push_back(i);

            ans.push_back(nums[que.front()]);
        }

        return ans;
    }
};
```

绝对差不超过限制的最长连续子数组
给你一个整数数组 nums ，和一个表示限制的整数 limit
请你返回最长连续子数组的长度
该子数组中的任意两个元素之间的绝对差必须小于或者等于 limit
如果不存在满足条件的子数组，则返回 0
[测试链接](https://leetcode.cn/problems/longest-continuous-subarray-with-absolute-diff-less-than-or-equal-to-limit/)

```c++
class Solution {
public:
    int longestSubarray(vector<int>& nums, int limit) {
        int n = nums.size();
        int ans = 1;

        deque<int> que_max;
        deque<int> que_min;

        for (int l = 0, r = 0; r < n; r++) {
            while (!que_max.empty() && nums[que_max.back()] < nums[r]) {
                que_max.pop_back();
            }
            que_max.push_back(r);

            while (!que_min.empty() && nums[que_min.back()] > nums[r]) {
                que_min.pop_back();
            }
            que_min.push_back(r);


            while (nums[que_max.front()] - nums[que_min.front()] > limit) {
                if(que_max.front() == l) que_max.pop_front();
                if(que_min.front() == l) que_min.pop_front();
                l++;
            }

            ans = max(ans, r - l + 1);
        }

        return ans;
    }
};
```

和至少为K的最短子数组
给定一个数组arr，其中的值有可能正、负、0
给定一个正数k
返回累加和>=k的所有子数组中，最短的子数组长度
[测试链接](https://leetcode.cn/problems/shortest-subarray-with-sum-at-least-k/)

```c++
class Solution {
public:
    int shortestSubarray(vector<int>& nums, int k) {
        int n = nums.size();
        vector<long long> prefix_sum(n + 1);


        for (int i = 0; i < n; i++) {
            prefix_sum[i + 1] = nums[i] + prefix_sum[i];
        }

        int ans = INT_MAX;

        deque<int> que;
        que.push_back(0);

        for(int i = 0; i <= n; i++) {
            while(!que.empty() && prefix_sum[i] - prefix_sum[que.front()] >= k) {
                ans = min(ans, i - que.front());
                que.pop_front();
            }

            while(!que.empty() && prefix_sum[que.back()] >= prefix_sum[i]) {
                que.pop_back();
            }

            que.push_back(i);
        }

        return ans != INT_MAX ? ans : -1;

    }
};
```

满足不等式的最大值
给你一个数组 points 和一个整数 k
数组中每个元素都表示二维平面上的点的坐标，并按照横坐标 x 的值从小到大排序
也就是说 points[i] = [xi, yi]
并且在 1 <= i < j <= points.length 的前提下，xi < xj 总成立
请你找出 yi + yj + |xi - xj| 的 最大值，
其中 |xi - xj| <= k 且 1 <= i < j <= points.length
题目测试数据保证至少存在一对能够满足 |xi - xj| <= k 的点。
[测试链接](https://leetcode.cn/problems/max-value-of-equation/)

```c++
class Solution {
public:
    int findMaxValueOfEquation(vector<vector<int>>& points, int k) {
        int ans = INT_MIN;

        deque<int> que;
        int n = points.size();

        for (int i = 0; i < n; i++) {
            while (!que.empty() && points[i][0] - points[que.front()][0] > k) {
                que.pop_front();
            }

            if (!que.empty()) {
                ans = max(ans, points[i][0] - points[que.front()][0] +
                                   points[i][1] + points[que.front()][1]);
            }

            while (!que.empty() &&
                   points[que.back()][1] - points[que.back()][0] <= points[i][1] - points[i][0]) {
                que.pop_back();
            }

            que.push_back(i);
        }

        return ans;
    }
};
```

你可以安排的最多任务数目
给你 n 个任务和 m 个工人。每个任务需要一定的力量值才能完成
需要的力量值保存在下标从 0 开始的整数数组 tasks 中，
第i个任务需要 tasks[i] 的力量才能完成
每个工人的力量值保存在下标从 0 开始的整数数组workers中，
第j个工人的力量值为 workers[j]
每个工人只能完成一个任务，且力量值需要大于等于该任务的力量要求值，即workers[j]>=tasks[i]
除此以外，你还有 pills 个神奇药丸，可以给 一个工人的力量值 增加 strength
你可以决定给哪些工人使用药丸，但每个工人 最多 只能使用 一片 药丸
给你下标从 0 开始的整数数组tasks 和 workers 以及两个整数 pills 和 strength
请你返回 最多 有多少个任务可以被完成。
[测试链接](https://leetcode.cn/problems/maximum-number-of-tasks-you-can-assign/)

```c++
class Solution {
public:
    int maxTaskAssign(vector<int>& tasks, vector<int>& workers, int pills,
                      int strength) {
        sort(tasks.begin(), tasks.end());
        sort(workers.begin(), workers.end());

        int ans = 0;
        int m = 0;
        for (int l = 0, r = min(tasks.size(), workers.size()); l <= r;) {
            m = l + (r - l) / 2;

            if (f(tasks, 0, m - 1, workers, workers.size() - m, workers.size() - 1, strength, pills)) {
                ans = m;
                l = m + 1;
            } else {
                r = m - 1;
            }
        }

        return ans;
    }

    bool f(vector<int>& tasks, int tl, int tr, vector<int>& workers, int wl, int wr, int s, int pills) {
        deque<int> que;

        int cnt = 0;
        for(int i = wl, j = tl; i <= wr; i++) {
            for(; j <= tr && workers[i] >= tasks[j]; j++) {
                que.push_back(j);
            }

            if(!que.empty() && tasks[que.front()] <= workers[i]) {
                que.pop_front();
            } else {
                for(; j <= tr && tasks[j] <= workers[i] + s; j++) {
                    que.push_back(j);
                }

                if(!que.empty()) {
                    cnt++;
                    que.pop_back();
                } else {
                    return false;
                }
            }
        }

        return cnt <= pills;
    }
};
```
