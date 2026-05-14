---
title: 滑动窗口
categories: 算法学习
tags:
  - algorithm
---

## 滑动窗口技巧和题目

滑动窗口：维持左、右边界都不回退的一段范围，来求解很多子数组（串）的相关问题
滑动窗口的关键：找到 范围 和 答案指标 之间的 单调性关系（类似贪心）
滑动过程：滑动窗口可以用 简单变量 或者 结构 来 维护信息

累加和大于等于target的最短子数组长度
给定一个含有 n 个正整数的数组和一个正整数 target
找到累加和 >= target 的长度最小的子数组并返回其长度
如果不存在符合条件的子数组返回0
[测试链接](https://leetcode.cn/problems/minimum-size-subarray-sum/)

```c++
class Solution {
public:
    int minSubArrayLen(int target, vector<int>& nums) {
        int ans = numeric_limits<int>::max();
        int i = 0, j = 0;
        int sum = 0;
        while(j < nums.size()) {
            sum += nums[j];
            while(sum >= target) {
                ans = (j - i + 1) < ans ? (j - i + 1) : ans;
                sum -= nums[i++];
            }

            j++;
        }

        return ans == numeric_limits<int>::max() ? 0 : ans;
    }
};
```

无重复字符的最长子串
给定一个字符串 s ，请你找出其中不含有重复字符的 最长子串 的长度。
[测试链接](https://leetcode.cn/problems/longest-substring-without-repeating-characters/)

```c++
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        unordered_map<int, int> mp;

        int l = 0, r = 0;
        int n = s.size();
        int ans = INT_MIN;

        while (r < n) {
            // if (mp.find(s[r]) == mp.end()) {
            //     mp[s[r]] = r;

            //     ans = max(ans, r - l + 1);
            // } else {
            //     l = max(l, mp[s[r]] + 1);
            //     ans = max(ans, r - l + 1);
            //     mp[s[r]] = r;
            // }

            if (mp.find(s[r]) != mp.end()) {
                l = max(l, mp[s[r]] + 1);
            }

            mp[s[r]] = r;
            ans = max(ans, r - l + 1);

            r++;
        }

        return ans == INT_MIN ? 0 : ans;
    }
};
```

最小覆盖子串
给你一个字符串 s 、一个字符串 t 。返回 s 中涵盖 t 所有字符的最小子串
如果 s 中不存在涵盖 t 所有字符的子串，则返回空字符串 "" 。
[测试链接](https://leetcode.cn/problems/minimum-window-substring/)

```c++
class Solution {
public:
    string minWindow(string s, string t) {
        vector<int> cnts(256);
        for (auto ch : t) {
            cnts[ch]--;
        }
        int len = numeric_limits<int>::max();
        int start = 0;
        int debt = t.size();
        for(int l = 0, r = 0, n = s.size(); r < n; r++) {
            if(cnts[s[r]]++ < 0) {
                debt--;
            }

            if(debt == 0) {
                while(cnts[s[l]] > 0) {
                    cnts[s[l++]]--;
                }

                if(r - l + 1 < len) {
                    len = r - l + 1;
                    start = l;
                }
            }
        }

        return len == numeric_limits<int>::max() ? "" : s.substr(start, len);
    }
};
```

加油站
在一条环路上有 n 个加油站，其中第 i 个加油站有汽油 gas[i] 升。
你有一辆油箱容量无限的的汽车，从第 i 个加油站开往第 i+1 个加油站需要消耗汽油 cost[i] 升
你从其中的一个加油站出发，开始时油箱为空。
给定两个整数数组 gas 和 cost ，如果你可以按顺序绕环路行驶一周
则返回出发时加油站的编号，否则返回 -1
如果存在解，则 保证 它是 唯一 的。
[测试链接](https://leetcode.cn/problems/gas-station/)

```c++
class Solution {
public:
    int canCompleteCircuit(vector<int>& gas, vector<int>& cost) {
        vector<int> diff(gas.size());
        int sum = 0;
        for(int i = 0, n = gas.size(); i < n; i++) {
            diff[i] = gas[i] - cost[i];
            sum += diff[i];
        }

        if(sum < 0) return -1;

        int l = 0, r = 0;
        while(r < diff.size()) {
            while(diff[r] < 0) {
                r++;
            }

            l = r;
            int sum = 0;
            while(r < diff.size() && sum >= 0) {
                sum += diff[r++];
            }
        }

        return l;
    }
};
```

替换子串得到平衡字符串
有一个只含有 'Q', 'W', 'E', 'R' 四种字符，且长度为 n 的字符串。
假如在该字符串中，这四个字符都恰好出现 n/4 次，那么它就是一个「平衡字符串」。
给你一个这样的字符串 s，请通过「替换一个子串」的方式，使原字符串 s 变成一个「平衡字符串」。
你可以用和「待替换子串」长度相同的 任何 其他字符串来完成替换。
请返回待替换子串的最小可能长度。
如果原字符串自身就是一个平衡字符串，则返回 0。
[测试链接](https://leetcode.cn/problems/replace-the-substring-for-balanced-string/)

```c++
class Solution {
public:
    int balancedString(string s) {
        vector<int> arr(4);
        for (char ch : s) {
            int idx = ch == 'Q' ? 0 : ch == 'W' ? 1 : ch == 'E' ? 2 : 3;
            arr[idx]++;
        }

        int debt = 0;
        for (int i = 0, cnt = s.size() / 4; i < 4; i++) {
            arr[i] = arr[i] > cnt ? cnt - arr[i] : 0;
            debt += ~arr[i] + 1;
        }

        if(debt == 0) return debt;

        int len = numeric_limits<int>::max();
        for (int l = 0, r = 0, idx = -1; r < s.size(); r++) {
            idx = s[r] == 'Q' ? 0 : s[r] == 'W' ? 1 : s[r] == 'E' ? 2 : 3;
            if (arr[idx]++ < 0) {
                debt--;
            }

            if (debt == 0) {
                idx = s[l] == 'Q' ? 0 : s[l] == 'W' ? 1 : s[l] == 'E' ? 2 : 3;
                while (arr[idx] > 0) {
                    arr[idx]--;

                    l++;
                    idx = s[l] == 'Q'   ? 0
                          : s[l] == 'W' ? 1
                          : s[l] == 'E' ? 2
                                        : 3;
                }

                len = min(len, r - l + 1);
            }
        }

        return len;
    }
};
```

K个不同整数的子数组
给定一个正整数数组 nums和一个整数 k，返回 nums 中 「好子数组」 的数目。
如果 nums 的某个子数组中不同整数的个数恰好为 k
则称 nums 的这个连续、不一定不同的子数组为 「好子数组 」。
例如，[1,2,3,1,2] 中有 3 个不同的整数：1，2，以及 3。
子数组 是数组的 连续 部分。
[测试链接](https://leetcode.cn/problems/subarrays-with-k-different-integers/)

```c++
class Solution {
public:
    vector<int> cnt{vector<int>(20005)};
    int subarraysWithKDistinct(vector<int>& nums, int k) {
        return f(nums, k) - f(nums, k - 1);
    }

    int f(vector<int>& nums, int k) {
        fill(cnt.begin(), cnt.end(), 0);

        int ans = 0;
        int collect = 0;

        for (int l = 0, r = 0; r < nums.size(); r++) {
            if (++cnt[nums[r]] == 1) {
                collect++;
            }

            while (collect > k) {
                if (--cnt[nums[l++]] == 0) {
                    collect--;
                }
            }

            ans += r - l + 1;
        }

        return ans;
    }
};
```

至少有K个重复字符的最长子串
给你一个字符串 s 和一个整数 k ，请你找出 s 中的最长子串
要求该子串中的每一字符出现次数都不少于 k 。返回这一子串的长度
如果不存在这样的子字符串，则返回 0。
[测试链接](https://leetcode.cn/problems/longest-substring-with-at-least-k-repeating-characters/)

```c++
class Solution {
public:
    int longestSubstring(string s, int k) {
        array<int, 256> cnt; // 词频统计，字符串s仅有小写字母组成

        int ans = numeric_limits<int>::min();

        // 问题转化 只有require种字符满足次数 >= k
        for (int require = 1; require <= 26; require++) {
            fill(cnt.begin(), cnt.end(), 0);

            for (int l = 0, r = 0, collect = 0, statify = 0, n = s.size(); r < n; r++) {
                cnt[s[r]]++;

                if (cnt[s[r]] == 1) {
                    collect++; // 第一次统计，类数加1
                }

                if (cnt[s[r]] == k) {
                    statify++; // 满足字符出现次数，加1
                }

                while (collect > require) {
                    if (cnt[s[l]] == 1) {
                        collect--;
                    }

                    if (cnt[s[l]] == k) {
                        statify--;
                    }

                    cnt[s[l++]]--;
                }

                if (statify == require) {
                    ans = max(ans, r - l + 1);
                }
            }
        }

        return ans == numeric_limits<int>::min() ? 0 : ans;
    }
};
```
