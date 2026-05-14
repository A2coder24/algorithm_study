---
title: 前缀和
categories: 算法学习
tags:
  - algorithm
---

## 前缀和技巧解决数组问题

利用前缀和快速得到区域累加和
[测试链接](https://leetcode.cn/problems/range-sum-query-immutable/)

```c++
class NumArray {
public:
    vector<int> prefix_sum;
    NumArray(vector<int>& nums) {
        int sum = 0;
        for(int i = 0, n = nums.size(); i < n; i++) {
            sum += nums[i];
            prefix_sum.push_back(sum);
        }
    }

    int sumRange(int left, int right) {
        if(left == 0) {
            return prefix_sum[right];
        }

        return prefix_sum[right] - prefix_sum[left - 1];
    }
};
```

返回无序数组中累加和为给定值的最长子数组长度
给定一个无序数组arr, 其中元素可正、可负、可0
给定一个整数aim
求arr所有子数组中累加和为aim的最长子数组长度
[测试链接](https://www.nowcoder.com/practice/36fb0fd3c656480c92b569258a1223d5)

```c++
#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

int main() {
    int n, target;
    cin >> n >> target;

    unordered_map<int, int> mp;
    mp[0] = -1;

    int sum = 0;
    int ans = 0;

    for(int i = 0, val = 0; i < n; i++) {
        cin >> val;
        sum += val;
        if(mp.find(sum - target) != mp.end()) {
            ans = max(ans, i - mp[sum - target]);
        }

        if(mp.find(sum) == mp.end()){
            mp[sum] = i;
        }
    }

    cout << ans;

    return 0;

}
```

返回无序数组中累加和为给定值的子数组个数
[测试链接](https://leetcode.cn/problems/subarray-sum-equals-k/)

```c++
class Solution {
public:
    int subarraySum(vector<int>& nums, int k) {
        unordered_map<int, int> mp;
        mp[0] = 1;

        int ans = 0;
        for (int i = 0, n = nums.size(), prefix_sum = 0; i < n; i++) {
            prefix_sum += nums[i];

            auto it = mp.find(prefix_sum - k);
            if (it != mp.end()) {
                ans += it->second;
            }

            mp[prefix_sum]++;
        }

        return ans;
    }
};
```

返回无序数组中正数和负数个数相等的最长子数组长度
给定一个无序数组arr，其中元素可正、可负、可0
求arr所有子数组中正数与负数个数相等的最长子数组的长度
[测试链接](https://www.nowcoder.com/practice/545544c060804eceaed0bb84fcd992fb)

```c++
#include <iostream>
#include <sstream>
#include <unordered_map>
using namespace std;

int main() {
    stringstream ss;
    ss << cin.rdbuf();
    int n;
    ss >> n;

    unordered_map<int, int> mp;
    mp[0] = -1;
    int ans = 0;
    for (int i = 0, val = 0, prefix_sum = 0; i < n; i++) {
        ss >> val;
        prefix_sum += val > 0 ? 1 : val == 0 ? 0 : -1;

        if(mp.find(prefix_sum) != mp.end()) {
            ans = max(ans, i - mp[prefix_sum]);
        } else {
            mp[prefix_sum] = i;
        }

    }

    cout << ans;
}
```

表现良好的最长时间段
给你一份工作时间表 hours，上面记录着某一位员工每天的工作小时数
我们认为当员工一天中的工作小时数大于 8 小时的时候，那么这一天就是 劳累的一天
所谓 表现良好的时间段 ，意味在这段时间内，「劳累的天数」是严格 大于 不劳累的天数
请你返回 表现良好时间段 的最大长度
[测试链接](https://leetcode.cn/problems/longest-well-performing-interval/)

```c++
class Solution {
public:
    int longestWPI(vector<int>& hours) {
        unordered_map<int, int> mp;
        mp[0] = -1;

        int ans = 0;
        for (int i = 0, n = hours.size(), prefix_sum = 0; i < n; i++) {
            prefix_sum += hours[i] > 8 ? 1 : -1;

            if (prefix_sum > 0) {
                ans = i + 1;
            } else {
                if (mp.find(prefix_sum - 1) != mp.end()) {
                    ans = max(ans, i - mp[prefix_sum - 1]);
                }

                if (mp.find(prefix_sum) == mp.end()) {
                    mp[prefix_sum] = i;
                }
            }
        }

        return ans;
    }
};
```

每个元音包含偶数次的最长子字符串
给你一个字符串 s ，请你返回满足以下条件的最长子字符串的长度
每个元音字母，即 'a'，'e'，'i'，'o'，'u'
在子字符串中都恰好出现了偶数次。
[测试链接](https://leetcode.cn/problems/find-the-longest-substring-containing-vowels-in-even-counts/)

```c++
class Solution {
public:
    int findTheLongestSubstring(string s) {
        unordered_map<int, int> mp;
        mp[0] = -1;

        int ans = 0;
        for (int i = 0, n = s.size(), m = -2, state = 0; i < n; i++) {
            m = move_bit(s[i]);

            if (m != -1) {
                state ^= 1 << m;
            }

            if (mp.find(state) != mp.end()) {
                ans = max(ans, i - mp[state]);
            } else {
                mp[state] = i;
            }
        }

        return ans;
    }

    int move_bit(char ch) {
        int ans = -1;
        switch (ch) {
        case 'a':
            ans = 0;
            break;
        case 'e':
            ans = 1;
            break;
        case 'i':
            ans = 2;
            break;
        case 'o':
            ans = 3;
            break;
        case 'u':
            ans = 4;
            break;
        default:
            break;
        };

        return ans;
    }
};
```

使数组和能被P整除
给你一个正整数数组 nums，请你移除 最短 子数组（可以为 空）
使得剩余元素的 和 能被 p 整除。 不允许 将整个数组都移除。
请你返回你需要移除的最短子数组的长度，如果无法满足题目要求，返回 -1 。
子数组 定义为原数组中连续的一组元素。
[测试链接](https://leetcode.cn/problems/make-sum-divisible-by-p/)

```c++
class Solution {
public:
    int minSubarray(vector<int>& nums, int p) {
        int arr_mod = 0;
        for (int val : nums) {
            arr_mod = (arr_mod + val) % p;
        }

        if(arr_mod == 0) {
            return 0;
        }

        unordered_map<int, int> mp;
        mp[0] = -1;

        int ans = nums.size();
        for (int i = 0, n = nums.size(), prefix_sum = 0, tmp = 0; i < n; i++) {
            prefix_sum = (prefix_sum + nums[i]) % p;

            tmp = (prefix_sum - arr_mod + p) % p;
            if (mp.find(tmp) != mp.end()) {
                ans = min(ans, i - mp[tmp]);
            }

            mp[prefix_sum] = i;
        }

        return ans == nums.size() ? -1 : ans;
    }
};
```

航班预订统计
这里有 n 个航班，它们分别从 1 到 n 进行编号。
有一份航班预订表 bookings ，
表中第 i 条预订记录 bookings[i] = [firsti, lasti, seatsi]
意味着在从 firsti 到 lasti
（包含 firsti 和 lasti ）的 每个航班 上预订了 seatsi 个座位。
请你返回一个长度为 n 的数组 answer，里面的元素是每个航班预定的座位总数。
[测试链接](https://leetcode.cn/problems/corporate-flight-bookings/)

```c++
class Solution {
public:
    vector<int> corpFlightBookings(vector<vector<int>>& bookings, int n) {
        vector<int> ans(n + 1, 0);

        for(vector<int> record : bookings) {
            ans[record[0] - 1] += record[2];
            ans[record[1]] -= record[2];
        }

        for(int i = 1; i <= n; i++) {
            ans[i] += ans[i - 1];
        }

        ans.pop_back();

        return ans;
    }
};
```

一开始1~n范围上的数字都是0，一共有m个操作，每次操作为(l,r,s,e,d)
表示在l~r范围上依次加上首项为s、末项为e、公差为d的数列
m个操作做完之后，统计1~n范围上所有数字的最大值和异或和
[测试链接](https://www.luogu.com.cn/problem/P4231)

```c++
#include<iostream>
#include<vector>
#include<limits>
#include<sstream>

int main() {
    std::stringstream ss;
    ss << std::cin.rdbuf();

    int n, m;
    ss >> n >> m;
    std::vector<long long> arr(n + 5);

    for(int i = 0; i < m; i++) {
        int l, r;
        ss >> l >> r;
        long long s, e, d;
        ss >> s >> e;
        d = (e - s) / (r - l);

        arr[l] += s;
        arr[l + 1] += d - s;
        arr[r + 1] -= d + e;
        arr[r + 2] += e;
    }

    for(int i = 1; i <= n; i++) {
        arr[i] += arr[i - 1];
    }
    for(int i = 1; i <= n; i++) {
        arr[i] += arr[i - 1];
    }

    long long xor_val = 0, max_val = std::numeric_limits<long long>::min();
    for(int i = 1; i <= n; i++) {
        xor_val ^= arr[i];
        max_val = std::max(max_val, arr[i]);
    }

    std::cout << xor_val << ' ' << max_val;
    return 0;
}
```

利用二维前缀和信息迅速得到二维区域和
[测试链接](https://leetcode.cn/problems/range-sum-query-2d-immutable/)

```c++
class NumMatrix {
public:
    array<array<int, 205>, 205> arr = {{0}};
    NumMatrix(vector<vector<int>>& matrix) {
        int row = matrix.size();
        int col = matrix[0].size();
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                arr[i + 1][j + 1] = matrix[i][j];
            }
        }

        for (int i = 1; i <= row; i++) {
            for (int j = 1; j <= col; j++) {
                arr[i][j] += arr[i - 1][j] + arr[i][j - 1] - arr[i - 1][j - 1];
                cout << arr[i][j] << ' ';
            }
            cout << endl;
        }
    }

    int sumRegion(int row1, int col1, int row2, int col2) {
        return arr[row2 + 1][col2 + 1] - arr[row1][col2 + 1] - arr[row2 + 1][col1] +
               arr[row1][col1];
    }
};
```

边框为1的最大正方形
给你一个由若干 0 和 1 组成的二维网格 grid
请你找出边界全部由 1 组成的最大 正方形 子网格
并返回该子网格中的元素数量。如果不存在，则返回 0。
[测试链接](https://leetcode.cn/problems/largest-1-bordered-square/)

```c++
class Solution {
public:
    int largest1BorderedSquare(vector<vector<int>>& grid) {
        int n = grid.size(), m = grid[0].size();
        build(grid);

        cout << sum(grid, 0, 0, n - 1, m - 1) << endl;

        if (sum(grid, 0, 0, n - 1, m - 1) == 0) {
            return 0;
        }

        int ans = 1;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                // (i , j) == (a, b)
                // (c, d)

                for (int c = i + ans, d = j + ans, k = ans + 1; c < n && d < m;
                     c++, d++, k++) {
                    if (sum(grid, i, j, c, d) -
                            sum(grid, i + 1, j + 1, c - 1, d - 1) ==
                        (k - 1) << 2) {
                        ans = k;
                    }
                }
            }
        }

        return ans * ans;
    }

    void build(vector<vector<int>>& grid) {
        int n = grid.size();
        int m = grid[0].size();
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (i > 0 && j > 0) {
                    grid[i][j] +=
                        grid[i][j - 1] + grid[i - 1][j] - grid[i - 1][j - 1];
                } else if (j > 0) {
                    grid[i][j] += grid[i][j - 1];
                } else if (i > 0) {
                    grid[i][j] += grid[i - 1][j];
                }
            }
        }
    }

    int sum(vector<vector<int>>& grid, int a, int b, int c, int d) {
        if (a > c || b > d)
            return 0;

        if (a > 0 && b > 0) {
            return grid[c][d] - grid[a - 1][d] - grid[c][b - 1] +
                   grid[a - 1][b - 1];
        }

        if (a > 0) {
            return grid[c][d] - grid[a - 1][d];
        }

        if (b > 0) {
            return grid[c][d] - grid[c][b - 1];
        }

        return grid[c][d];
    }
};
```

二维差分模版(洛谷)
[测试链接](https://www.luogu.com.cn/problem/P3397)

```c++
#include<iostream>
#include<vector>
#include<sstream>

constexpr int MAX = 1005;
std::vector<std::vector<int>> arr(MAX, std::vector<int>(MAX));
std::stringstream ss;

int main() {
    ss << std::cin.rdbuf();

    int n, m;
    ss >> n >> m;

    int a, b, c, d;
    for(int i = 0; i < m; i++) {
        ss >> a >> b >> c >> d;

        arr[a][b] += 1;
        arr[a][d + 1] -= 1;
        arr[c + 1][b] -= 1;
        arr[c + 1][d + 1] += 1;
    }

    for(int i = 1; i <= n; i++) {
        for(int j = 1; j <= n; j++) {
            arr[i][j] += arr[i][j-1] + arr[i-1][j] - arr[i-1][j-1];
            std::cout << arr[i][j] << ' ';
        }
        std::cout << '\n';
    }
    return 0;
}
```

用邮票贴满网格图
给你一个 m _ n 的二进制矩阵 grid
每个格子要么为 0 （空）要么为 1 （被占据）
给你邮票的尺寸为 stampHeight _ stampWidth
我们想将邮票贴进二进制矩阵中，且满足以下 限制 和 要求 ：
覆盖所有空格子，不覆盖任何被占据的格子
可以放入任意数目的邮票，邮票可以相互有重叠部分
邮票不允许旋转，邮票必须完全在矩阵内
如果在满足上述要求的前提下，可以放入邮票，请返回 true ，否则返回 false
[测试链接](https://leetcode.cn/problems/stamping-the-grid/)

```c++
class Solution {
public:
    bool possibleToStamp(vector<vector<int>>& grid, int stampHeight,
                         int stampWidth) {
        int n = grid.size(), m = grid[0].size();

        vector<vector<int>> prefix_sum(n + 1, vector<int>(m + 1));

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                prefix_sum[i + 1][j + 1] = grid[i][j];
            }
        }

        build(prefix_sum);

        vector<vector<int>> diff(n + 2, vector<int>(m + 2));

        for (int a = 1, c = a + stampHeight - 1; c <= n; a++, c++) {
            for (int b = 1, d = b + stampWidth - 1; d <= m; b++, d++) {
                if (sum(prefix_sum, a, b, c, d) == 0) {
                    add(diff, a, b, c, d);
                }
            }
        }

        build(diff);

        for(int i = 0; i < n; i++) {
            for(int j = 0; j < m; j++) {
                if(grid[i][j] == 0 && diff[i + 1][j + 1] == 0) {
                    return false;
                }
            }
        }

        return true;
    }

    void add(vector<vector<int>>& grid, int a, int b, int c, int d) {
        grid[a][b] += 1;
        grid[a][d + 1] -= 1;
        grid[c + 1][b] -= 1;
        grid[c + 1][d + 1] += 1;
    }

    int sum(vector<vector<int>>& grid, int a, int b, int c, int d) {
        return grid[c][d] - grid[a - 1][d] - grid[c][b - 1] +
               grid[a - 1][b - 1];
    }

    void build(vector<vector<int>>& grid) {
        int n = grid.size(), m = grid[0].size();
        for (int i = 1; i < n; i++) {
            for (int j = 1; j < m; j++) {
                grid[i][j] +=
                    grid[i][j - 1] + grid[i - 1][j] - grid[i - 1][j - 1];
            }
        }
    }
};
```

最强祝福力场
小扣在探索丛林的过程中，无意间发现了传说中"落寞的黄金之都"
而在这片建筑废墟的地带中，小扣使用探测仪监测到了存在某种带有「祝福」效果的力场
经过不断的勘测记录，小扣将所有力场的分布都记录了下来
forceField[i] = [x,y,side]
表示第 i 片力场将覆盖以坐标 (x,y) 为中心，边长为 side 的正方形区域。
若任意一点的 力场强度 等于覆盖该点的力场数量
请求出在这片地带中 力场强度 最强处的 力场强度
注意：力场范围的边缘同样被力场覆盖。
[测试链接](https://leetcode.cn/problems/xepqZ5/)

```c++
class Solution {
public:
    int fieldOfGreatestBlessing(vector<vector<int>>& forceField) {
        int n = forceField.size();

        vector<long long> xs(n * 2);
        vector<long long> ys(n * 2);

        for (int i = 0, k = 0, p = 0; i < n; i++) {
            long long x = forceField[i][0];
            long long y = forceField[i][1];
            long long r = forceField[i][2];

            xs[k++] = x * 2 - r;
            xs[k++] = x * 2 + r;
            ys[p++] = y * 2 - r;
            ys[p++] = y * 2 + r;
        }

        unique_sort(xs);
        unique_sort(ys);

        vector<vector<int>> diff(xs.size() + 2, vector<int>(ys.size() + 2));

        for (int i = 0, a, b, c, d; i < n; i++) {
            long long x = forceField[i][0];
            long long y = forceField[i][1];
            long long r = forceField[i][2];

            a = rank(xs, x * 2 - r, xs.size());
            b = rank(ys, y * 2 - r, ys.size());
            c = rank(xs, x * 2 + r, xs.size());
            d = rank(ys, y * 2 + r, ys.size());
            add(diff, a, b, c, d);
        }

        int ans = 0;
        for (int i = 1; i <= xs.size(); i++) {
            for (int j = 1; j <= ys.size(); j++) {
                diff[i][j] +=
                    diff[i - 1][j] + diff[i][j - 1] - diff[i - 1][j - 1];
                ans = max(ans, diff[i][j]);
            }
        }
        return ans;
    }

    void add(vector<vector<int>>& diff, int a, int b, int c, int d) {
        diff[a][b] += 1;
        diff[a][d + 1] -= 1;
        diff[c + 1][b] -= 1;
        diff[c + 1][d + 1] += 1;
    }

    int rank(vector<long long>& arr, long long val, int size) {
        int l = 0, r = size - 1, mid;
        int ans = -1;
        while (l <= r) {
            mid = l + (r - l) / 2;
            if (arr[mid] == val) {
                ans = mid + 1;
                break;
            } else if (arr[mid] < val) {
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }

        return ans;
    }

    void unique_sort(vector<long long>& arr) {
        sort(arr.begin(), arr.end());
        int i = 0;

        for (int j = 1, n = arr.size(); j < n; j++) {
            if (arr[j] != arr[i]) {
                arr[++i] = arr[j];
            }
        }

        arr.resize(i + 1);
    }
};
```
