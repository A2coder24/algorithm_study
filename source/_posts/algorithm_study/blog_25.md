---
title: 并查集
categories: 算法学习
tags:
  - algorithm
---

## 并查集

并查集的使用是如下的场景
1）一开始每个元素都拥有自己的集合，在自己的集合里只有这个元素自己
2）int find(i)：查找i所在集合的代表元素，代表元素来代表i所在的集合
3）boolean isSameSet(a, b)：判断a和b在不在一个集合里
4）void union(a, b)：a所在集合所有元素 与 b所在集合所有元素 合并成一个集合
5）各种操作单次调用的均摊时间复杂度为O(1)

并查集的两个优化，都发生在find方法里
1）扁平化（一定要做）
2）小挂大（可以不做，原论文中是秩的概念，可以理解为 粗略高度 或者 大小）

并查集模版(牛客)
路径压缩 + 小挂大
[测试链接] (https://www.nowcoder.com/practice/e7ed657974934a30b2010046536a5372)

```c++
#include <iostream>
#include <array>
#include <sstream>
#include <string>
using namespace std;

constexpr int N = 1000005;
array<int, N> father;
array<int, N> count;
array<int, N> stack;

int n;

void build() {
    for(int i = 1; i <= n; i++) {
        father[i] = i;
        count[i] = 1;
    }
}

int find(int x) {
    int top = 0;

    while(father[x] != x) {
        stack[top++] = x;
        x = father[x];
    }

    while(top > 0) {
        father[stack[--top]] = x;
    }

    return x;
}

bool isSameSet(int x, int y) {
    return find(x) == find(y);
}

void unionSet(int x, int y) {
    int fx = find(x);
    int fy = find(y);

    if(fx != fy) {
        if(count[fx] >= count[fy]) {
            count[fx] += count[fy];
            father[fy] = fx;
        } else {
            count[fy] += count[fx];
            father[fx] = fy;
        }
    }

}

int main() {
    stringstream ss;
    ss << cin.rdbuf();

    int a, b;
    ss >> a >> b;
    n = a;

    build();

    int op, x, y;
    string  str;
    for(int i = 0, op, x, y; i < b; i++) {
        ss >> op >> x >> y;

        switch(op){
            case 1:
                str = isSameSet(x, y) == true ? "Yes" : "No";
                cout << str << endl;
                break;
            case 2:
                unionSet(x, y);
                break;
            default:
                break;
        }
    }

    return 0;
}
// 64 位输出请用 printf("%lld")
```

情侣牵手
n对情侣坐在连续排列的 2n 个座位上，想要牵到对方的手
人和座位由一个整数数组 row 表示，其中 row[i] 是坐在第 i 个座位上的人的ID
情侣们按顺序编号，第一对是 (0, 1)，第二对是 (2, 3)，以此类推，最后一对是 (2n-2, 2n-1)
返回 最少交换座位的次数，以便每对情侣可以并肩坐在一起
每次交换可选择任意两人，让他们站起来交换座位
[测试链接](https://leetcode.cn/problems/couples-holding-hands/)

```c++
class Solution {
public:
    array<int, 500> father;
    int sets;
    void build(int m) {
        for (int i = 0; i <= m; i++) {
            father[i] = i;
        }
        sets = m;
    }

    int find(int x) {
        if(x != father[x]) {
            father[x] = find(father[x]);
        }

        return father[x];
    }

    void unionSet(int x, int y) {
        int fx = find(x);
        int fy = find(y);

        if(fx != fy) {
            father[fx] = fy;
            sets--;
        }
    }


    int minSwapsCouples(vector<int>& row) {
        int n = row.size();
        build(n / 2);
        for(int i =  0; i < n; i+=2) {
            unionSet(row[i] / 2, row[i + 1] / 2);
        }

        return n / 2 - sets;

    }
};
```

相似字符串组
如果交换字符串 X 中的两个不同位置的字母，使得它和字符串 Y 相等
那么称 X 和 Y 两个字符串相似
如果这两个字符串本身是相等的，那它们也是相似的
例如，"tars" 和 "rats" 是相似的 (交换 0 与 2 的位置)；
"rats" 和 "arts" 也是相似的，但是 "star" 不与 "tars"，"rats"，或 "arts" 相似
总之，它们通过相似性形成了两个关联组：{"tars", "rats", "arts"} 和 {"star"}
注意，"tars" 和 "arts" 是在同一组中，即使它们并不相似
形式上，对每个组而言，要确定一个单词在组中，只需要这个词和该组中至少一个单词相似。
给你一个字符串列表 strs列表中的每个字符串都是 strs 中其它所有字符串的一个字母异位词。
返回 strs 中有多少字符串组
[测试链接](https://leetcode.cn/problems/similar-string-groups/)

```c++
class Solution {
public:
    array<int, 3005> father;
    int sets;

    void build(int n) {
        for (int i = 0; i < n; i++) {
            father[i] = i;
        }
        sets = n;
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

    bool isSimilar(string a, string b) {
        int diff = 0;
        for (int i = 0, n = a.size(); i < n; i++) {
            if (a[i] != b[i]) {
                diff++;
            }
        }

        return diff > 2 ? false : true;
    }

    int numSimilarGroups(vector<string>& strs) {
        int n = strs.size();
        build(n);

        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if(find(i) != find(j) && isSimilar(strs[i], strs[j])) {
                    union_set(i, j);
                }
            }
        }

        return sets;
    }
};
```

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
```

移除最多的同行或同列石头
n 块石头放置在二维平面中的一些整数坐标点上。每个坐标点上最多只能有一块石头
如果一块石头的 同行或者同列 上有其他石头存在，那么就可以移除这块石头
给你一个长度为 n 的数组 stones ，其中 stones[i] = [xi, yi] 表示第 i 块石头的位置
返回 可以移除的石子 的最大数量。
[测试链接](https://leetcode.cn/problems/most-stones-removed-with-same-row-or-column/)

```c++
class Solution {
public:
    unordered_map<int, int> father;

    int find(int x) {
        if (father.find(x) == father.end()) {
            father[x] = x;
        }
        if (father[x] != x) {
            father[x] = find(father[x]);
        }
        return father[x];
    }

    void unite(int x, int y) {
        int fx = find(x);
        int fy = find(y);
        if (fx != fy) {
            father[fx] = fy;
        }
    }

    int removeStones(vector<vector<int>>& stones) {
        int n = stones.size();
        father.clear();

        for (auto& s : stones) {
            int x = s[0];
            int y = s[1] + 10001;
            unite(x, y);
        }

        unordered_set<int> st;
        for (auto& s : stones) {
            st.insert(find(s[0]));
        }

        return n - st.size();
    }
};
```

找出知晓秘密的所有专家
给你一个整数 n ，表示有 n 个专家从 0 到 n - 1 编号
另外给你一个下标从 0 开始的二维整数数组 meetings
其中 meetings[i] = [xi, yi, timei] 表示专家 xi 和专家 yi 在时间 timei 要开一场会
一个专家可以同时参加 多场会议 。最后，给你一个整数 firstPerson
专家 0 有一个 秘密 ，最初，他在时间 0 将这个秘密分享给了专家 firstPerson
接着，这个秘密会在每次有知晓这个秘密的专家参加会议时进行传播
更正式的表达是，每次会议，如果专家 xi 在时间 timei 时知晓这个秘密
那么他将会与专家 yi 分享这个秘密，反之亦然。秘密共享是 瞬时发生 的
也就是说，在同一时间，一个专家不光可以接收到秘密，还能在其他会议上与其他专家分享
在所有会议都结束之后，返回所有知晓这个秘密的专家列表
你可以按 任何顺序 返回答案
[链接测试](https://leetcode.cn/problems/find-all-people-with-secret/)

```c++
class Solution {
public:
    array<int, 100005> father;
    array<bool, 100005> screte;

    void build(int n, int first) {
        for (int i = 0; i < n; i++) {
            father[i] = i;
            screte[i] = false;
        }

        father[first] = 0;
        screte[0] = true;
    }

    int find(int x) {
        if (x != father[x]) {
            father[x] = find(father[x]);
        }

        return father[x];
    }

    void union_set(int x, int y) {
        int fx = find(x), fy = find(y);
        if (fx != fy) {
            father[fx] = fy;
            screte[fy] |= screte[fx];
        }
    }

    vector<int> findAllPeople(int n, vector<vector<int>>& meetings,
                              int firstPerson) {
        sort(meetings.begin(), meetings.end(),
             [](const vector<int>& a, const vector<int>& b) {
                 return a.back() < b.back();
             });

        int m = meetings.size();
        build(n, firstPerson);

        for (int l = 0, r; l < m;) {
            r = l;
            while (r + 1 < m && meetings[l][2] == meetings[r + 1][2]) {
                r++;
            }

            for (int i = l; i <= r; i++) {
                union_set(meetings[i][0], meetings[i][1]);
            }

            for (int i = l, a, b; i <= r; i++) {
                a = meetings[i][0];
                b = meetings[i][1];
                if (!screte[find(a)]) {
                    father[a] = a;
                }

                if (!screte[find(b)]) {
                    father[b] = b;
                }
            }

            l = r + 1;
        }

        vector<int> ans;
        for(int i = 0; i < n; i++) {
            if(screte[find(i)]) {
                ans.push_back(i);
            }
        }

        return ans;
    }
};
```

好路径的数目
给你一棵 n 个节点的树（连通无向无环的图）
节点编号从0到n-1，且恰好有n-1条边
给你一个长度为 n 下标从 0 开始的整数数组 vals
分别表示每个节点的值。同时给你一个二维整数数组 edges
其中 edges[i] = [ai, bi] 表示节点 ai 和 bi 之间有一条 无向 边
好路径需要满足以下条件：开始和结束节点的值相同、 路径中所有值都小于等于开始的值
请你返回不同好路径的数目
注意，一条路径和它反向的路径算作 同一 路径
比方说， 0 -> 1 与 1 -> 0 视为同一条路径。单个节点也视为一条合法路径
[测试链接](https://leetcode.cn/problems/number-of-good-paths/)

```c++
class Solution {
public:
    array<int, 30005> father;
    array<int, 30005> maxcnt;

    void build(int n) {
        for (int i = 0; i < n; i++) {
            father[i] = i;
            maxcnt[i] = 1;
        }
    }

    int find(int x) {
        if (x != father[x]) {
            father[x] = find(father[x]);
        }

        return father[x];
    }

    int union_set(int x, int y, vector<int>& val) {
        int fx = find(x);
        int fy = find(y);

        int ans = 0;
        if (val[fx] > val[fy]) {
            father[fy] = fx;
        } else if (val[fx] < val[fy]) {
            father[fx] = fy;
        } else {
            ans = maxcnt[fx] * maxcnt[fy];
            father[fy] = fx;
            maxcnt[fx] += maxcnt[fy];
        }

        return ans;
    }
    int numberOfGoodPaths(vector<int>& vals, vector<vector<int>>& edges) {
        sort(edges.begin(), edges.end(), [&vals](vector<int>& a, vector<int>& b) {
            return max(vals[a.front()], vals[a.back()]) < max(vals[b.front()], vals[b.back()]);
        });

        int n = vals.size();
        build(n);

        int path = n;
        for(vector<int>& edge : edges) {
            path += union_set(edge.front(), edge.back(), vals);
        }

        return path;
    }
};
```

尽量减少恶意软件的传播 II
给定一个由 n 个节点组成的网络，用 n x n 个邻接矩阵 graph 表示
在节点网络中，只有当 graph[i][j] = 1 时，节点 i 能够直接连接到另一个节点 j。
一些节点 initial 最初被恶意软件感染。只要两个节点直接连接，
且其中至少一个节点受到恶意软件的感染，那么两个节点都将被恶意软件感染。
这种恶意软件的传播将继续，直到没有更多的节点可以被这种方式感染。
假设 M(initial) 是在恶意软件停止传播之后，整个网络中感染恶意软件的最终节点数。
我们可以从 initial 中删除一个节点，
并完全移除该节点以及从该节点到任何其他节点的任何连接。
请返回移除后能够使 M(initial) 最小化的节点。
如果有多个节点满足条件，返回索引 最小的节点 。
initial 中每个整数都不同
[测试链接](https://leetcode.cn/problems/minimize-malware-spread-ii/)

```c++
class Solution {
public:
    array<bool, 305> virus;
    array<int, 305> father;
    array<int, 305> cnts;
    array<int, 305> infect;
    array<int, 305> size;

    void buidl(int n, const vector<int>& initial) {
        for(int i = 0; i < n; i++) {
            father[i] = i;
            cnts[i] = 0;
            size[i] = 1;
            virus[i] = false;
            infect[i] = -1;
        }

        for(auto& val : initial) {
            virus[val] = true;
        }
    }

    int find(int x) {
        if(x != father[x]) {
            father[x] = find(father[x]);
        }

        return father[x];
    }

    void union_set(int x, int y) {
        int fx = find(x);
        int fy = find(y);

        if(fx != fy) {
            father[fx] = fy;
            size[fy] += size[fx];
        }
    }
    int minMalwareSpread(vector<vector<int>>& graph, vector<int>& initial) {
        sort(initial.begin(), initial.end());
        int n = graph.size();
        int m = graph[0].size();
        buidl(n, initial);

        for(int i = 0; i < n; i++) {
            for(int j = 0; j < m; j++) {
                if(graph[i][j] == 1 && !virus[i] && !virus[j]) {
                    union_set(i, j);
                }
            }
        }

        for(int& sick : initial) {
            for(int neighbor = 0; neighbor < n; neighbor++) {
                if(sick != neighbor && !virus[neighbor] && graph[sick][neighbor] == 1) {
                    int fn = find(neighbor);
                    if(infect[fn] == -1) {
                        infect[fn] = sick;
                    } else if(infect[fn] != -2 && infect[fn] != sick) {
                        infect[fn] = -2;
                    }
                }
            }
        }

        for(int i = 0; i < n; i++) {
            if(i == find(i) && infect[i] >= 0) {
                cnts[infect[i]] += size[i];
            }
        }

        sort(initial.begin(), initial.end());

        int ans = initial.front();
        int max = cnts[ans];
        for(int& sick : initial) {
            if(cnts[sick] > max) {
                ans = sick;
                max = cnts[sick];
            }
        }

        return ans;
    }
};
```
