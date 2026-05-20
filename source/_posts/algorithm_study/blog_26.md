---
title: 洪水填充
categories: 算法学习
tags:
  - algorithm
---

## 洪水填充

洪水填充是一种很简单的技巧，设置路径信息进行剪枝和统计，类似感染的过程
路径信息不撤销，来保证每一片的感染过程可以得到区分
看似是暴力递归过程，其实时间复杂度非常好，遍历次数和样本数量的规模一致

岛屿数量
给你一个由 '1'（陆地）和 '0'（水）组成的的二维网格，请你计算网格中岛屿的数量
岛屿总是被水包围，并且每座岛屿只能由水平方向和/或竖直方向上相邻的陆地连接形成
此外，你可以假设该网格的四条边均被水包围
[测试链接](https://leetcode.cn/problems/number-of-islands/)

```c++
class Solution {
public:
    array<int, 90005> father;
    int sets;
    void build(vector<vector<char>>& grid) {
        int n = grid.size(), m = grid[0].size();
        int temp = 0;

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] == '1') {
                    father[i * m + j] = i * m + j;
                    temp++;
                } else {
                    father[i * m + j] = -1;
                }
            }
        }

        sets = temp;
    }

    int find(int x) {
        if (x != father[x]) {
            father[x] = find(father[x]);
        }

        return father[x];
    }

    void union_set(int x, int y) {
        int fx = find(x);
        int fy = find(y);
        if (fx != fy) {
            father[fx] = fy;
            sets--;
        }
    }

    bool f(vector<vector<char>>& grid, int c, int d) {
        int n = grid.size(), m = grid[0].size();

        return c >= 0 && c < n && d >= 0 && d < m && grid[c][d] == '1';
    }

    int numIslands(vector<vector<char>>& grid) {
        int n = grid.size();
        int m = grid[0].size();

        build(grid);

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] == '1') {
                    if (f(grid, i, j + 1)) {
                        union_set(i * m + j, i * m + j + 1);
                    }

                    if (f(grid, i + 1, j)) {
                        union_set(i * m + j, (i + 1) * m + j);
                    }
                }
            }
        }

        return sets;
    }
};


class Solution {
public:
    int numIslands(vector<vector<char>>& grid) {
        int n = grid.size();
        int m = grid[0].size();

        int ans = 0;
        function<void(int, int)> dfs = [&dfs, &grid, &n, &m](int i, int j) {
            if (i < 0 || j < 0 || i == n || j == m || grid[i][j] != '1') {
                return;
            }

            grid[i][j] = 0;

            dfs(i, j - 1);
            dfs(i, j + 1);
            dfs(i - 1, j);
            dfs(i + 1, j);
        };

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] == '1') {
                    ans++;
                    dfs(i, j);
                }
            }
        }

        return ans;
    }
};
```

被围绕的区域
给你一个 m x n 的矩阵 board ，由若干字符 'X' 和 'O' ，找到所有被 'X' 围绕的区域
并将这些区域里所有的 'O' 用 'X' 填充。
[测试链接](https://leetcode.cn/problems/surrounded-regions/)

```c++
class Solution {
public:
    void solve(vector<vector<char>>& board) {
        int n = board.size();
        int m = board[0].size();

        function<void(int, int)> dfs = [&](int i, int j) {
            if (i < 0 || i == n || j < 0 || j == m || board[i][j] != 'O') {
                return;
            }

            board[i][j] = '#';

            dfs(i + 1, j);
            dfs(i - 1, j);
            dfs(i, j + 1);
            dfs(i, j - 1);
        };

        for (int j = 0; j < m; j++) {
            if (board[0][j] == 'O') {
                dfs(0, j);
            }
            if (board[n - 1][j] == 'O') {
                dfs(n - 1, j);
            }
        }

        for (int i = 0; i < n; i++) {
            if (board[i][0] == 'O') {
                dfs(i, 0);
            }
            if (board[i][m - 1] == 'O') {
                dfs(i, m - 1);
            }
        }

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j] == 'O') {
                    board[i][j] = 'X';
                }
                if (board[i][j] == '#') {
                    board[i][j] = 'O';
                }
            }
        }
    }
};
```

最大人工岛
给你一个大小为 n \* n 二进制矩阵 grid 。最多 只能将一格 0 变成 1 。
返回执行此操作后，grid 中最大的岛屿面积是多少？
岛屿 由一组上、下、左、右四个方向相连的 1 形成
[测试链接] (https://leetcode.cn/problems/making-a-large-island/)

```c++
class Solution {
public:
    int largestIsland(vector<vector<int>>& grid) {
        int n = grid.size();
        int m = grid[0].size();
        int id = 2;

        for(int i = 0; i < n; i++) {
            for(int j = 0; j < m; j++) {
                if(grid[i][j] == 1) {
                    dfs(grid, i, j, n, m, id++);
                }
            }
        }

        vector<int> sizes(id);
        int ans = 0;
        for(int i = 0; i < n; i++) {
            for(int j = 0; j < m; j++) {
                if(grid[i][j] > 1) {
                    ans = max(ans, ++sizes[grid[i][j]]);
                }
            }
        }

        vector<bool> visited(id);
        int up, down, left, right, merge;
        for(int i = 0; i < n; i++) {
            for(int j = 0; j < m; j++) {
                if(grid[i][j] == 0) {
                    up = i > 0 ? grid[i - 1][j] : 0;
                    down = i + 1 < n ? grid[i + 1][j] : 0;
                    left = j > 0 ? grid[i][j - 1] : 0;
                    right = j + 1 < m ? grid[i][j + 1] : 0;
                    visited[up] = true;
                    merge = 1 + sizes[up];
                    if(!visited[down]) {
                        merge += sizes[down];
                        visited[down] = true;
                    }
                    if(!visited[left]) {
                        merge += sizes[left];
                        visited[left] = true;
                    }
                    if(!visited[right]) {
                        merge += sizes[right];
                        visited[right] = true;
                    }

                    ans = max(ans, merge);

                    visited[up] = false;
                    visited[down] = false;
                    visited[left] = false;
                    visited[right] = false;
                }
            }
        }

        return ans;
    }

    void dfs(vector<vector<int>>& grid, int i, int j, int n, int m, int id) {
        if(i < 0 || i == n || j < 0 || j == m || grid[i][j] != 1) {
            return;
        }

        grid[i][j] = id;

        dfs(grid, i + 1, j, n, m, id);
        dfs(grid, i - 1, j, n, m, id);
        dfs(grid, i, j + 1, n, m, id);
        dfs(grid, i, j - 1, n, m, id);
    }
};
```

打砖块
有一个 m \* n 的二元网格 grid ，其中 1 表示砖块，0 表示空白
砖块 稳定（不会掉落）的前提是：
一块砖直接连接到网格的顶部，或者
至少有一块相邻（4 个方向之一）砖块 稳定 不会掉落时
给你一个数组 hits ，这是需要依次消除砖块的位置
每当消除 hits[i] = (rowi, coli) 位置上的砖块时，对应位置的砖块（若存在）会消失
然后其他的砖块可能因为这一消除操作而 掉落
一旦砖块掉落，它会 立即 从网格 grid 中消失（即，它不会落在其他稳定的砖块上）
返回一个数组 result ，其中 result[i] 表示第 i 次消除操作对应掉落的砖块数目。
注意，消除可能指向是没有砖块的空白位置，如果发生这种情况，则没有砖块掉落。
[测试链接](https://leetcode.cn/problems/bricks-falling-when-hit/)

```c++
class Solution {
public:
    vector<int> hitBricks(vector<vector<int>>& grid,
                          vector<vector<int>>& hits) {
        int n = grid.size();
        int m = grid[0].size();

        vector<int> ans(hits.size());
        if (n == 1) {
            return ans;
        }
        for (vector<int>& hit : hits) {
            grid[hit.front()][hit.back()]--;
        }
        for (int j = 0; j < m; j++) {
            dfs(grid, 0, j, n, m);
        }

        for (int i = hits.size() - 1, row, col; i >= 0; i--) {
            row = hits[i][0];
            col = hits[i][1];
            grid[row][col]++;
            if (worth(grid, row, col, n, m)) {
                ans[i] = dfs(grid, row, col, n, m) - 1;
            }
        }

        return ans;
    }
    int dfs(vector<vector<int>>& grid, int i, int j, int n, int m) {
        if (i < 0 || i == n || j < 0 || j == m || grid[i][j] != 1) {
            return 0;
        }

        grid[i][j] = 2;

        return 1 + dfs(grid, i + 1, j, n, m) + dfs(grid, i - 1, j, n, m) +
               dfs(grid, i, j + 1, n, m) + dfs(grid, i, j - 1, n, m);
    }

    bool worth(vector<vector<int>>& grid, int i, int j, int n, int m) {
        return grid[i][j] == 1 && (i == 0 || (i > 0 && grid[i - 1][j] == 2) ||
                                   (i < n - 1 && grid[i + 1][j] == 2) ||
                                   (j > 0 && grid[i][j - 1] == 2) ||
                                   (j < m - 1 && grid[i][j + 1] == 2));
    }
};
```
