---
title: 动态规划
categories: 算法学习
tags:
  - algorithm
---

## 动态规划

动态规划是用空间代替重复计算

有些递归在展开计算时，总是重复调用同一个子问题的解，这种重复调用的递归变成动态规划很有收益
如果每次展开都是不同的解，或者重复调用的现象很少，那么没有改动态规划的必要

任何动态规划问题都一定对应着一个有重复调用行为的递归
所以任何动态规划的题目都一定可以从递归入手，逐渐实现动态规划的方法

**尝试策略** 就是 **转移方程**，完全一回事！
推荐从尝试入手，因为代码好写，并且一旦发现尝试错误，重新想别的递归代价轻！

当熟悉了从递归到动态规划的转化过程，那么就可以纯粹用动态规划的视角来分析问题了

动态规划的大致过程：
想出设计优良的递归尝试(方法、经验、固定套路很多)，有关尝试展开顺序的说明
-> 记忆化搜索(从顶到底的动态规划) ，如果每个状态的计算枚举代价很低，往往到这里就可以了
-> 严格位置依赖的动态规划(从底到顶的动态规划) ，更多是为了下面说的 进一步优化枚举做的准备
-> 进一步优化空间（空间压缩），一维、二维、多维动态规划都存在这种优化
-> 进一步优化枚举也就是优化时间（本节没有涉及，但是后续巨多内容和这有关）

## 一维动态规划

斐波那契数 （通常用 F(n) 表示）形成的序列称为 斐波那契数列
该数列由 0 和 1 开始，后面的每一项数字都是前面两项数字的和。
也就是：F(0) = 0，F(1) = 1
F(n) = F(n - 1) + F(n - 2)，其中 n > 1
给定 n ，请计算 F(n)
[测试链接](https://leetcode.cn/problems/fibonacci-number/)

```c++
class Solution {
public:
    int fib(int n) {
        if(n == 0) return 0;
        if(n == 1) return 1;

        return fib(n - 1) + fib(n - 2);
    }
};

class Solution {
public:
    array<int, 35> f;
    int fib(int n) {
        if(n == 0) return 0;
        if(n == 1) return 1;

        if(f[n] != 0) return f[n];

        f[n] = fib(n - 1) + fib(n - 2);
        return f[n];
    }
};


class Solution {
public:
    int fib(int n) {
        if(n == 0) return 0;
        if(n == 1) return 1;

        int a = 0, b = 1;
        for(int i = 2, cur; i <= n; i++) {
            cur = a + b;
            a = b;
            b = cur;
        }

        return b;
    }
};
```

最低票价
在一个火车旅行很受欢迎的国度，你提前一年计划了一些火车旅行
在接下来的一年里，你要旅行的日子将以一个名为 days 的数组给出
每一项是一个从 1 到 365 的整数
火车票有 三种不同的销售方式
一张 为期1天 的通行证售价为 costs[0] 美元
一张 为期7天 的通行证售价为 costs[1] 美元
一张 为期30天 的通行证售价为 costs[2] 美元
通行证允许数天无限制的旅行
例如，如果我们在第 2 天获得一张 为期 7 天 的通行证
那么我们可以连着旅行 7 天(第2~8天)
返回 你想要完成在给定的列表 days 中列出的每一天的旅行所需要的最低消费
[测试链接](https://leetcode.cn/problems/minimum-cost-for-tickets/)

```c++
class Solution {
public:
    int mincostTickets(vector<int>& days, vector<int>& costs) {
        array<int, 3> holidays = {1, 7, 30};
        return f(days, costs, 0, holidays);
    }

    int f(vector<int>& days, vector<int>& costs, int i, array<int, 3>& holidays) {
        if(i == days.size()) return 0;

        int ans = INT_MAX;
        for(int k = 0, j = i; k < holidays.size(); k++) {
            while(j < days.size() && days[i] + holidays[k] > days[j]) {
                j++;
            }

            ans = min(ans, costs[k] + f(days, costs, j, holidays));
        }

        return ans;
    }
};


class Solution {
public:
    array<int, 370> dp;
    int mincostTickets(vector<int>& days, vector<int>& costs) {
        array<int, 3> holidays = {1, 7, 30};
        fill(dp.begin(), dp.end(), -1);

        return f(days, costs, 0, holidays);
    }

    int f(vector<int>& days, vector<int>& costs, int i, array<int, 3>& holidays) {
        if(i == days.size()) return 0;

        if(dp[i] != -1) return dp[i];

        int ans = INT_MAX;
        for(int k = 0, j = i; k < holidays.size(); k++) {
            while(j < days.size() && days[i] + holidays[k] > days[j]) {
                j++;
            }

            ans = min(ans, costs[k] + f(days, costs, j, holidays));
        }

        dp[i] = ans;

        return ans;
    }
};

class Solution {
public:
    array<int, 370> dp;

    int mincostTickets(vector<int>& days, vector<int>& costs) {
        array<int, 3> holidays = {1, 7, 30};
        int n = days.size();
        int h = holidays.size();

        fill(dp.begin(), dp.end(), numeric_limits<int>::max());
        dp[n] = 0;
        for (int i = n - 1; i >= 0; i--) {
            for (int k = 0, j = i; k < h; k++) {
                while (j < n && days[j] < days[i] + holidays[k])  {
                    j++;
                }

                dp[i] = min(dp[i], costs[k] + dp[j]);
            }
        }

        return dp[0];
    }
};
```

解码方法
一条包含字母 A-Z 的消息通过以下映射进行了 编码 ：
'A' -> "1"
'B' -> "2"
...
'Z' -> "26"
要 解码 已编码的消息，所有数字必须基于上述映射的方法，反向映射回字母（可能有多种方法）
例如，"11106" 可以映射为："AAJF"、"KJF"
注意，消息不能分组为(1 11 06)，因为 "06" 不能映射为 "F"
这是由于 "6" 和 "06" 在映射中并不等价
给你一个只含数字的 非空 字符串 s ，请计算并返回 解码 方法的 总数
题目数据保证答案肯定是一个 32位 的整数
[测试链接](https://leetcode.cn/problems/decode-ways/)

```c++
class Solution {
public:
    int numDecodings(string s) {
        return f(s, 0);
    }

    int f(string& s, int i) {
        if(i == s.size()) {
            return 1;
        }

        if(s[i] == '0') {
            return 0;
        }

        int ans = 0;

        ans += f(s, i + 1);

        if(i + 1 < s.size() && ((s[i] - '0') * 10 + (s[i + 1] - '0') <= 26)) {
            ans += f(s, i + 2);
        }

        return ans;
    }
};


class Solution {
public:
    array<int, 105> dp;

    int numDecodings(string s) {
        fill(dp.begin(), dp.end(), -1);
        return f(s, 0);
    }

    int f(string& s, int i) {
        if(i == s.size()) {
            return 1;
        }

        if(s[i] == '0') {
            return 0;
        }

        if(dp[i] != -1) return dp[i];

        int ans = 0;

        ans += f(s, i + 1);

        if(i + 1 < s.size() && ((s[i] - '0') * 10 + (s[i + 1] - '0') <= 26)) {
            ans += f(s, i + 2);
        }

        dp[i] = ans;

        return ans;
    }
};


class Solution {
public:
    array<int, 105> dp;

    int numDecodings(string s) {
        fill(dp.begin(), dp.end(), 0);
        int n = s.size();
        dp[n] = 1;

        for (int i = n - 1; i >= 0; i--) {
            if (s[i] == '0') {
                continue;
            }

            dp[i] += dp[i + 1];
            if (i + 1 < n && ((s[i] - '0') * 10 + (s[i + 1] - '0') <= 26)) {
                dp[i] += dp[i + 2];
            }
        }

        return dp[0];
    }
};
```

解码方法 II
一条包含字母 A-Z 的消息通过以下的方式进行了 编码 ：
'A' -> "1"
'B' -> "2"
...
'Z' -> "26"
要 解码 一条已编码的消息，所有的数字都必须分组
然后按原来的编码方案反向映射回字母（可能存在多种方式）
例如，"11106" 可以映射为："AAJF"、"KJF"
注意，像 (1 11 06) 这样的分组是无效的，"06"不可以映射为'F'
除了上面描述的数字字母映射方案，编码消息中可能包含 '_' 字符
可以表示从 '1' 到 '9' 的任一数字（不包括 '0'）
例如，"1_" 可以表示 "11"、"12"、"13"、"14"、"15"、"16"、"17"、"18" 或 "19"
对 "1*" 进行解码，相当于解码该字符串可以表示的任何编码消息
给你一个字符串 s ，由数字和 '*' 字符组成，返回 解码 该字符串的方法 数目
由于答案数目可能非常大，答案对 1000000007 取模
[测试链接](https://leetcode.cn/problems/decode-ways-ii/)

```c++
class Solution {
public:
    int n;
    int numDecodings(string s) {
        n = s.size();
        return (int)f(s, 0);
    }

    long long f(string& s, int i) {
        if (i == n) {
            return 1;
        }

        if (s[i] == '0') {
            return 0;
        }

        long long ans = 0;
        if (s[i] != '*') {
            ans += f(s, i + 1);

            if (i + 1 < n && s[i + 1] != '*' &&
                ((s[i] - '0') * 10 + (s[i + 1] - '0') <= 26)) {
                ans += f(s, i + 2);
            }

            if (i + 1 < n && s[i + 1] == '*' && s[i] == '1') {
                ans += f(s, i + 2) * 9;
            }

            if (i + 1 < n && s[i + 1] == '*' && s[i] == '2') {
                ans += f(s, i + 2) * 6;
            }
        } else {
            ans += f(s, i + 1) * 9;

            if (i + 1 < n && s[i + 1] != '*' && (s[i + 1] >= '7' && s[i + 1] <= '9')) {
                ans += f(s, i + 2);
            }

            if (i + 1 < n && s[i + 1] != '*' && (s[i + 1] >= '0' && s[i + 1] <= '6')) {
                ans += f(s, i + 2) * 2;
            }

            if(i + 1 < n && s[i + 1] == '*') {
                ans += f(s, i + 2) * 15;
            }
        }

        return ans % 1000000007;
    }
};


class Solution {
public:
    int n;
    array<int, 100005> dp;
    int numDecodings(string s) {
        n = s.size();
        fill(dp.begin(), dp.end(), -1);
        return (int)f(s, 0);
    }

    long long f(string& s, int i) {
        if (i == n) {
            return 1;
        }

        if (s[i] == '0') {
            return 0;
        }

        if(dp[i] != -1) return dp[i];

        long long ans = 0;
        if (s[i] != '*') {
            ans += f(s, i + 1);

            if (i + 1 < n && s[i + 1] != '*' &&
                ((s[i] - '0') * 10 + (s[i + 1] - '0') <= 26)) {
                ans += f(s, i + 2);
            }

            if (i + 1 < n && s[i + 1] == '*' && s[i] == '1') {
                ans += f(s, i + 2) * 9;
            }

            if (i + 1 < n && s[i + 1] == '*' && s[i] == '2') {
                ans += f(s, i + 2) * 6;
            }
        } else {
            ans += f(s, i + 1) * 9;

            if (i + 1 < n && s[i + 1] != '*' && (s[i + 1] >= '7' && s[i + 1] <= '9')) {
                ans += f(s, i + 2);
            }

            if (i + 1 < n && s[i + 1] != '*' && (s[i + 1] >= '0' && s[i + 1] <= '6')) {
                ans += f(s, i + 2) * 2;
            }

            if(i + 1 < n && s[i + 1] == '*') {
                ans += f(s, i + 2) * 15;
            }
        }
        dp[i] = ans % 1000000007;
        return dp[i];
    }
};


class Solution {
public:
    int n;
    array<long long, 100005> dp;

    int numDecodings(string s) {
        n = s.size();
        fill(dp.begin(), dp.end(), 0);
        dp[n] = 1;

        for (int i = n - 1; i >= 0; i--) {
            if (s[i] == '0') {
                continue;
            }

            if (s[i] != '*') {
                dp[i] += dp[i + 1];

                if (i + 1 < n && s[i + 1] != '*' &&
                    ((s[i] - '0') * 10 + (s[i + 1] - '0') <= 26)) {
                    dp[i] += dp[i + 2];
                }

                if (i + 1 < n && s[i + 1] == '*' && s[i] == '1') {
                    dp[i] += dp[i + 2] * 9;
                }

                if (i + 1 < n && s[i + 1] == '*' && s[i] == '2') {
                    dp[i] += dp[i + 2] * 6;
                }
            } else {
                dp[i] += dp[i + 1] * 9;

                if (i + 1 < n && s[i + 1] != '*' &&
                    (s[i + 1] >= '7' && s[i + 1] <= '9')) {
                    dp[i] += dp[i + 2];
                }

                if (i + 1 < n && s[i + 1] != '*' &&
                    (s[i + 1] >= '0' && s[i + 1] <= '6')) {
                    dp[i] += dp[i + 2] * 2;
                }

                if (i + 1 < n && s[i + 1] == '*') {
                    dp[i] += dp[i + 2] * 15;
                }
            }
            dp[i] %= 1000000007;
        }

        return (int)dp[0];
    }
};
```

丑数 II
给你一个整数 n ，请你找出并返回第 n 个 丑数
丑数 就是只包含质因数 2、3 或 5 的正整数
[测试链接](https://leetcode.cn/problems/ugly-number-ii/)

```c++
class Solution {
public:
    array<int, 1700> dp;
    int nthUglyNumber(int n) {
       dp[1] = 1;

       for(int i = 2, i2 = 1, i3 = 1, i5 = 1, a, b, c, cur; i <= n; i++) {
            a = dp[i2] * 2;
            b = dp[i3] * 3;
            c = dp[i5] * 5;

            cur = min(a, min(b, c));
            if(cur == a) {
                i2++;
            }
            if(cur == b) {
                i3++;
            }
            if(cur == c) {
                i5++;
            }

            dp[i] = cur;
       }

       return dp[n];
    }
};
```

最长有效括号
给你一个只包含 '(' 和 ')' 的字符串
找出最长有效（格式正确且连续）括号子串的长度。
[测试链接](https://leetcode.cn/problems/longest-valid-parentheses/)

```c++
class Solution {
public:
    array<int, 30005> dp;
    int longestValidParentheses(string s) {
        fill(dp.begin(), dp.end(), 0);

        int n = s.size();
        int ans = 0;
        for(int i = 1, p; i < n; i++) {
            if(s[i] == ')') {
                p = i - dp[i - 1] - 1;

                if(p >= 0 && s[p] == '(') {
                    dp[i] = dp[i - 1] + 2 + (p - 1 >= 0 ? dp[p - 1] : 0);
                }
            }

            ans = max(ans, dp[i]);
        }

        return ans;
    }
};
```

环绕字符串中唯一的子字符串
定义字符串 base 为一个 "abcdefghijklmnopqrstuvwxyz" 无限环绕的字符串
所以 base 看起来是这样的：
"..zabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcd.."
给你一个字符串 s ，请你统计并返回 s 中有多少 不同非空子串 也在 base 中出现
[测试链接](https://leetcode.cn/problems/unique-substrings-in-wraparound-string/)

```c++
class Solution {
public:
    array<int, 26> dp;
    int n;
    int findSubstringInWraproundString(string s) {
        n = s.size();
        vector<int> arr;

        for(char ch : s) {
            arr.push_back(ch - 'a');
        }

        dp[arr[0]] = 1;
        for(int i = 1, cur, pre, len = 1; i < n; i++) {
            cur = arr[i];
            pre = arr[i - 1];

            if((pre == 25 && cur == 0) || cur == pre + 1) {
                len++;
            } else {
                len = 1;
            }

            dp[cur] = max(dp[cur], len);
        }

        return accumulate(dp.begin(), dp.end(), 0);

    }
};
```

不同的子序列 II
给定一个字符串 s，计算 s 的 不同非空子序列 的个数
因为结果可能很大，答案对 1000000007 取模
字符串的 子序列 是经由原字符串删除一些（也可能不删除）
字符但不改变剩余字符相对位置的一个新字符串
例如，"ace" 是 "abcde" 的一个子序列，但 "aec" 不是
[测试链接](https://leetcode.cn/problems/distinct-subsequences-ii/)

```c++
class Solution {
public:
    array<int, 26> cnt;
    int distinctSubseqII(string s) {
        int all = 1, newAdd;
        int mod = 1000000007;

        for (char ch : s) {
            newAdd = (all - cnt[ch - 'a'] + mod) % mod;
            cnt[ch - 'a'] = (cnt[ch - 'a'] + newAdd) % mod;
            all = (all + newAdd) % mod;
        }

        return (all - 1 + mod) % mod;
    }
};
```

## 二维动态规划

最小路径和
给定一个包含非负整数的 m x n 网格 grid
请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。
说明：每次只能向下或者向右移动一步。
[测试链接](https://leetcode.cn/problems/minimum-path-sum/)

```c++
class Solution {
public:
    int n, m;
    int minPathSum(vector<vector<int>>& grid) {
        n = grid.size();
        m = grid[0].size();

        for (int j = 1; j < m; j++) {
            grid[0][j] += grid[0][j - 1];
        }

        for (int i = 1; i < n; i++) {
            grid[i][0] += grid[i - 1][0];
        }

        for(int i = 1; i < n; i++) {
            for(int j = 1; j < m; j++) {
                grid[i][j] = min(grid[i - 1][j] + grid[i][j], grid[i][j - 1] + grid[i][j]);
            }
        }
        return grid[n - 1][m - 1];
    }
};
```

单词搜索（无法改成动态规划）
给定一个 m x n 二维字符网格 board 和一个字符串单词 word
如果 word 存在于网格中，返回 true ；否则，返回 false 。
单词必须按照字母顺序，通过相邻的单元格内的字母构成
其中"相邻"单元格是那些水平相邻或垂直相邻的单元格
同一个单元格内的字母不允许被重复使用
[测试链接](https://leetcode.cn/problems/word-search/)

```c++
class Solution {
public:
    bool exist(vector<vector<char>>& board, string word) {
        int n = board.size();
        int m = board[0].size();

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j] == word[0]) {
                    if (f(board, i, j, word, 0)) {
                        return true;
                    }
                }
            }
        }

        return false;
    }

    bool f(vector<vector<char>>& board, int i, int j, string& word, int k) {
        if (k == word.size()) {
            return true;
        }
        if (i < 0 || i == board.size() || j < 0 || j == board[0].size()) {
            return false;
        }

        if (board[i][j] != word[k]) {
            return false;
        }

        char temp = board[i][j];

        board[i][j] = '0';

        if(f(board, i + 1, j, word, k + 1)) {
            return true;
        }


        if(f(board, i - 1, j, word, k + 1)){
            return true;
        }

        if(f(board, i, j + 1, word, k + 1)){
            return true;
        }

        if(f(board, i, j - 1, word, k + 1)) {
            return true;
        }

        board[i][j] = temp;

        return false;
    }
};
```

最长公共子序列
给定两个字符串text1和text2
返回这两个字符串的最长 公共子序列 的长度
如果不存在公共子序列，返回0
两个字符串的 公共子序列 是这两个字符串所共同拥有的子序列
[测试链接](https://leetcode.cn/problems/longest-common-subsequence/)

```c++
class Solution {
public:
    int n, m;
    int longestCommonSubsequence(string text1, string text2) {
        n = text1.size();
        m = text2.size();
        return f(text1, text2, n - 1, m - 1);
    }

    int f(string& s1, string& s2, int i, int j) {
        if(i < 0 || j < 0) {
            return 0;
        }

        int l1 = f(s1, s2, i - 1, j - 1);
        int l2 = f(s1, s2, i - 1, j);
        int l3 = f(s1, s2, i, j - 1);

        int l4 = s1[i] == s2[j] ? (l1 + 1) : 0;

        return max(max(l1, l2), max(l3, l4));
    }
};


class Solution {
public:
    int n, m;
    array<array<int, 1005>, 1005> dp;
    int longestCommonSubsequence(string text1, string text2) {
        n = text1.size();
        m = text2.size();

        for(auto& arr : dp) {
            arr.fill(-1);
        }
        return f(text1, text2, n - 1, m - 1);
    }

    int f(string& s1, string& s2, int i, int j) {
        if(i < 0 || j < 0) {
            return 0;
        }

        if(dp[i][j] != -1) {
            return dp[i][j];
        }

        int l1 = f(s1, s2, i - 1, j - 1);
        int l2 = f(s1, s2, i - 1, j);
        int l3 = f(s1, s2, i, j - 1);
        int l4 = s1[i] == s2[j] ? (l1 + 1) : 0;

        dp[i][j] = max(max(l1, l2), max(l3, l4));
        return dp[i][j];
    }
};

class Solution {
public:
    int n, m;
    array<array<int, 1005>, 1005> dp;
    int longestCommonSubsequence(string text1, string text2) {
        n = text1.size();
        m = text2.size();

        for (int j = 0; j < m; j++) {
            dp[0][j] = 0;
        }

        for (int i = 0; i < n; i++) {
            dp[i][0] = 0;
        }

        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                if(text1[i - 1] == text2[j - 1]) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
                }

            }
        }

        return dp[n][m];
    }
};
```

最长回文子序列
给你一个字符串 s ，找出其中最长的回文子序列，并返回该序列的长度
[测试链接](https://leetcode.cn/problems/longest-palindromic-subsequence/)

```c++
class Solution {
public:
    int longestPalindromeSubseq(string s) {
        return f(s, 0, s.size() - 1);
    }

    int f(string& s, int i, int j) {
        if(i == j) {
            return 1;
        }

        if(i == j - 1) {
            return s[i] == s[j] ? 2 : 1;
        }

        if(s[i] == s[j]) {
            return 2 + f(s, i + 1, j - 1);
        }

        return max(f(s, i + 1, j), f(s, i, j - 1));
    }
};

class Solution {
public:
    array<array<int, 1005>, 1005> dp;
    int longestPalindromeSubseq(string s) {
        for (auto& arr : dp) {
            arr.fill(-1);
        }
        return f(s, 0, s.size() - 1);
    }

    int f(string& s, int i, int j) {
        if (i == j) {
            return 1;
        }

        if (i == j - 1) {
            return s[i] == s[j] ? 2 : 1;
        }

        if(dp[i][j] != -1) {
            return dp[i][j];
        }

        if (s[i] == s[j]) {
            dp[i][j] =  2 + f(s, i + 1, j - 1);
            return dp[i][j];
        }

        dp[i][j] = max(f(s, i + 1, j), f(s, i, j - 1));
        return dp[i][j] ;
    }
};

class Solution {
public:
    array<array<int, 1005>, 1005> dp;
    int longestPalindromeSubseq(string s) {
        int n = s.size();

        for (int l = n - 1; l >= 0; l--) {
            dp[l][l] = 1;
            if (l + 1 < n) {
                dp[l][l + 1] = s[l] == s[l + 1] ? 2 : 1;
            }

            for (int r = l + 2; r < n; r++) {
                if (s[l] == s[r]) {
                    dp[l][r] = 2 + dp[l + 1][r - 1];
                } else {
                    dp[l][r] = max(dp[l + 1][r], dp[l][r - 1]);
                }
            }
        }

        return dp[0][n - 1];
    }
};
```

节点数为n高度不大于m的二叉树个数
现在有n个节点，计算出有多少个不同结构的二叉树
满足节点个数为n且树的高度不超过m的方案
因为答案很大，所以答案需要模上1000000007后输出
[测试链接](https://www.nowcoder.com/practice/aaefe5896cce4204b276e213e725f3ea)

```c++
#include <iostream>
using namespace std;

constexpr long long mod = 1000000007;

int f(int n, int m) {
    if(n == 0) {
        return 1;
    }

    if(m == 0) {
        return 0;
    }

    long long ans = 0;
    for(int k = 0; k < n; k++) {
        ans = (ans + ((long long)f(k, m -1) * f(n - k - 1, m - 1)) % mod) % mod;
    }

    return (int) ans;
}

int main() {
    int a, b;
    cin >> a >> b;

    cout << f(a, b);
}



#include <iostream>
#include <array>
using namespace std;

constexpr long long mod = 1000000007;
array<array<int, 100>, 100> dp;

int f(int n, int m) {
    if(n == 0) {
        return 1;
    }

    if(m == 0) {
        return 0;
    }

    if(dp[n][m] != -1) {
        return dp[n][m] % mod;
    }

    long long ans = 0;
    for(int k = 0; k < n; k++) {
        ans = (ans + ((long long)f(k, m -1) * f(n - k - 1, m - 1)) % mod) % mod;
    }

    dp[n][m] = (int) ans;

    return dp[n][m];
}

int main() {
    int a, b;
    cin >> a >> b;

    for(auto& arr : dp) {
        arr.fill(-1);
    }

    cout << f(a, b);
}


#include <iostream>
#include <array>
using namespace std;

constexpr long long mod = 1000000007;
array<array<int, 100>, 100> dp;

int main() {
    int a, b;
    cin >> a >> b;

    for (int j = 0; j <= b; j++) {
        dp[0][j] = 1;
    }

    for (int i = 1; i <= a; i++) {
        dp[i][0] = 0;
    }

    for (int i = 1; i <= a; i++) {
        for (int j = 1; j <= b; j++) {
            long long ans = 0;
            for (int k = 0; k < i; k++) {
                ans = (ans + ((long long)dp[k][j - 1] * dp[i - k - 1][j - 1]) % mod) % mod;
            }

            dp[i][j] = (int) ans;
        }
    }

    cout << dp[a][b];

    return 0;
}

```

矩阵中的最长递增路径
给定一个 m x n 整数矩阵 matrix ，找出其中 最长递增路径 的长度
对于每个单元格，你可以往上，下，左，右四个方向移动
你 不能 在 对角线 方向上移动或移动到 边界外（即不允许环绕）
[测试链接](https://leetcode.cn/problems/longest-increasing-path-in-a-matrix/)

```c++
class Solution {
public:
    int n, m;
    int longestIncreasingPath(vector<vector<int>>& matrix) {
        int ans = INT_MIN;
        n = matrix.size();
        m = matrix[0].size();

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                ans = max(ans, f(matrix, i, j));
            }
        }

        return ans;
    }

    int f(vector<vector<int>>& matrix, int i, int j) {

        int next = 0;

        if (i > 0 && matrix[i][j] < matrix[i - 1][j]) {
            next = max(next, f(matrix, i - 1, j));
        }
        if (i < n - 1 && matrix[i][j] < matrix[i + 1][j]) {
            next = max(next, f(matrix, i + 1, j));
        }
        if (j > 0 && matrix[i][j] < matrix[i][j - 1]) {
            next = max(next, f(matrix, i, j - 1));
        }
        if (j < m - 1 && matrix[i][j] < matrix[i][j + 1]) {
            next = max(next, f(matrix, i, j + 1));
        }

        return next + 1;
    }
};


class Solution {
public:
    int n, m;
    array<array<int, 205>, 205> dp;
    int longestIncreasingPath(vector<vector<int>>& matrix) {
        int ans = INT_MIN;
        n = matrix.size();
        m = matrix[0].size();

        for(auto& arr : dp) {
            arr.fill(-1);
        }

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                ans = max(ans, f(matrix, i, j));
            }
        }

        return ans;
    }

    int f(vector<vector<int>>& matrix, int i, int j) {
        if(dp[i][j] != -1) {
            return dp[i][j];
        }

        int next = 0;

        if (i > 0 && matrix[i][j] < matrix[i - 1][j]) {
            next = max(next, f(matrix, i - 1, j));
        }
        if (i < n - 1 && matrix[i][j] < matrix[i + 1][j]) {
            next = max(next, f(matrix, i + 1, j));
        }
        if (j > 0 && matrix[i][j] < matrix[i][j - 1]) {
            next = max(next, f(matrix, i, j - 1));
        }
        if (j < m - 1 && matrix[i][j] < matrix[i][j + 1]) {
            next = max(next, f(matrix, i, j + 1));
        }

        dp[i][j] = next + 1;
        return dp[i][j];
    }
};
```
