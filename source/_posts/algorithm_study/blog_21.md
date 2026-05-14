---
title: 双指针
categories: 算法学习
tags:
  - algorithm
---

## 双指针

设置两个指针的技巧，其实这种说法很宽泛，似乎 没什么可总结的
1）有时候所谓的双指针技巧，就单纯是代码过程用双指针的形式表达出来而已。
没有单调性（贪心）方面的考虑
2）有时候的双指针技巧包含单调性（贪心）方面的考虑，牵扯到可能性的取舍。
对分析能力的要求会变高。其实是先有的思考和优化，然后代码变成了 双指针的形式。
3）所以，双指针这个“皮”不重要，分析题目**单调性（贪心）方面的特征**，这个能力才重要。

常见的双指针类型：
1）同向双指针
2）快慢双指针
3）从两头往中间的双指针
4）其他

按奇偶排序数组II
给定一个非负整数数组 nums。nums 中一半整数是奇数 ，一半整数是偶数
对数组进行排序，以便当 nums[i] 为奇数时，i也是奇数
当 nums[i] 为偶数时， i 也是 偶数
你可以返回 任何满足上述条件的数组作为答案
[测试链接](https://leetcode.cn/problems/sort-array-by-parity-ii/)

```c++
class Solution {
public:
    vector<int> sortArrayByParityII(vector<int>& nums) {
        // 设置两个指针，一个偶数索引指针，一个奇数索引指针
        // 如果偶数数组上有奇数，那奇数数组上肯定有一个偶数，找到并交换，反之亦然
        int even_p = 0, odd_p = 1;
        int n = nums.size();

        while (odd_p < n && even_p < n) {
            if (is_odd(nums[even_p])) {
                while (odd_p < n && is_odd(nums[odd_p])) {
                    odd_p += 2;
                }

                if (odd_p < n) {
                    swap(nums[even_p], nums[odd_p]);
                    even_p += 2;
                }
            } else {
                even_p += 2;
            }
        }

        return nums;
    }
    bool is_odd(int val) { return val & 1 ? true : false; }
};
```

寻找重复数
给定一个包含 n + 1 个整数的数组 nums ，其数字都在 [1, n] 范围内（包括 1 和 n）
可知至少存在一个重复的整数。
假设 nums 只有 一个重复的整数 ，返回 这个重复的数 。
你设计的解决方案必须 不修改 数组 nums 且只用常量级 O(1) 的额外空间。
[测试链接](https://leetcode.cn/problems/find-the-duplicate-number/)

```c++
class Solution {
public:
    int findDuplicate(vector<int>& nums) {
        int slow = 0, fast = 0;

        do{
            slow = nums[slow];
            fast = nums[nums[fast]];
        } while(slow != fast);

        slow = 0;
        while(slow != fast) {
            slow = nums[slow];
            fast = nums[fast];
        }
        return slow;
    }
};
```

接雨水
给定 n 个非负整数表示每个宽度为 1 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水
[测试链接](https://leetcode.cn/problems/trapping-rain-water/)

```c++
// 暴力解法
class Solution {
public:
    int trap(vector<int>& height) {
        int ans = 0;
        for (int i = 0; i < height.size(); i++) {
            int l_max = 0, r_max = 0;
            for (int j = i; j < height.size(); j++) {
                r_max = max(r_max, height[j]);
            }
            for (int j = i; j >= 0; j--) {
                l_max = max(l_max, height[j]);
            }

            ans += min(l_max, r_max) - height[i];
        }

        return ans;
    }
};


// 空间换时间，备忘录优化
class Solution {
public:
    int trap(vector<int>& height) {
        int ans = 0;
        vector<int> l_max(height.size());
        vector<int> r_max(height.size());
        l_max[0] = height[0];

        r_max[height.size() - 1] = height.back();

        for(int i = 1; i < height.size(); i++) {
            l_max[i] = max(height[i], l_max[i - 1]);
        }

        for(int i = height.size() - 2; i >= 0; i--) {
            r_max[i] = max(height[i], r_max[i + 1]);
        }

        for (int i = 0; i < height.size(); i++) {
            ans += min(l_max[i], r_max[i]) - height[i];
        }

        return ans;
    }
};

// 双指针
class Solution {
public:
    int trap(vector<int>& height) {
        int ans = 0;
        int l_max = 0, r_max = 0;

        l_max = height.front();
        r_max = height.back();

        int left = 0, right = height.size() - 1;

        while(left <= right) {
            l_max = max(height[left], l_max);
            r_max = max(height[right], r_max);

            if(l_max < r_max) {
                ans += l_max - height[left++];
            } else {
                ans += r_max - height[right--];
            }
        }

        return ans;
    }
};
```

救生艇
给定数组 people
people[i]表示第 i 个人的体重 ，船的数量不限，每艘船可以承载的最大重量为 limit
每艘船最多可同时载两人，但条件是这些人的重量之和最多为 limit
返回 承载所有人所需的最小船数
[测试链接](https://leetcode.cn/problems/boats-to-save-people/)

```c++
class Solution {
public:
    int numRescueBoats(vector<int>& people, int limit) {
        sort(people.begin(), people.end());

        int n = people.size();
        int l = 0, r = n - 1;
        int weight = 0;
        int ans = 0;
        while(l <= r) {
            weight = people[l] + people[r];
            if(weight <= limit) {
                ans++;

                l++;
                r--;
            } else {
                ans++;

                r--;
            }
        }

        return ans;
    }
};
```

盛最多水的容器
给定一个长度为 n 的整数数组 height 。有 n 条垂线，第 i 条线的两个端点是 (i, 0) 和 (i, height[i]) 。
找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水
返回容器可以储存的最大水量
说明：你不能倾斜容器
[测试链接](https://leetcode.cn/problems/container-with-most-water/)

```c++
class Solution {
public:
    int maxArea(vector<int>& height) {
        int l = 0, r = height.size() - 1;
        int ans = numeric_limits<int>::min();

        int h = 0, w = 0, area = 0;
        while (l < r) {
            h = min(height[l], height[r]);
            w = r - l;
            area = h * w;

            ans = max(ans, area);

            if (h == height[l]) {
                l++;
            } else {
                r--;
            }
        }

        return ans;
    }
};
```

供暖器
冬季已经来临。 你的任务是设计一个有固定加热半径的供暖器向所有房屋供暖。
在加热器的加热半径范围内的每个房屋都可以获得供暖。
现在，给出位于一条水平线上的房屋 houses 和供暖器 heaters 的位置
请你找出并返回可以覆盖所有房屋的最小加热半径。
说明：所有供暖器都遵循你的半径标准，加热的半径也一样。
[测试链接](https://leetcode.cn/problems/heaters/)

```c++
class Solution {
public:
    int findRadius(vector<int>& houses, vector<int>& heaters) {
        sort(houses.begin(), houses.end());
        sort(heaters.begin(), heaters.end());

        int ans = 0;
        for(int i = 0, j = 0; i < houses.size(); i++) {
            while(!best(houses, heaters, i, j)) {
                j++;
            }

            ans = max(ans, abs(heaters[j] - houses[i]));
        }

        return ans;
    }

    bool best(vector<int>& houses, vector<int>& heaters, int i, int j) {
        return j == heaters.size() - 1 || abs(heaters[j] - houses[i]) < abs(heaters[j + 1] - houses[i]);
    }
};
```

缺失的第一个正数
给你一个未排序的整数数组 nums ，请你找出其中没有出现的最小的正整数。
请你实现时间复杂度为 O(n) 并且只使用常数级别额外空间的解决方案。
[测试链接](https://leetcode.cn/problems/first-missing-positive/)

```c++
// 原地哈希
class Solution {
public:
    int firstMissingPositive(vector<int>& nums) {
        int n = nums.size();
        for(int& val : nums) {
            if(val <= 0) {
                val = n + 1;
            }
        }

        for(int i = 0; i < n; i++) {
            while(nums[i] >= 1 && nums[i] <= n && nums[i] != i + 1 && nums[i] != nums[nums[i] - 1]) {
                swap(nums[i], nums[nums[i] - 1]);
            }
        }

        for(int i = 0; i < n; i++) {
            if(nums[i] != i + 1) return i + 1;
        }

        return n + 1;

    }
};
```
