---
title: 二叉树
categories: 算法学习
tags:
  - algorithm
---

## 二叉树

树节点定义：

```c++
typedef struct node {
    int val;
    node* left;
    node* right;
} node;
```

二叉树的遍历：前序遍历，中序遍历，后序遍历

[先序遍历测试链接](https://leetcode.cn/problems/binary-tree-preorder-traversal/)
[中序遍历测试链接](https://leetcode.cn/problems/binary-tree-inorder-traversal/)
[后序遍历测试链接](https://leetcode.cn/problems/binary-tree-postorder-traversal/)

递归版本：

```c++
// 先序遍历
void pre_order(node* root) {
    if(!root)
        return;
    printf("%d ", root->val);

    pre_order(root->left);
    pre_order(root->right);
}

// 中序遍历
void in_order(node* root) {
    if(!root)
        return;

    in_order(root->left);

    printf("%d ", root->val);

    in_order(root->right);
}

// 后序遍历
void pos_order(node* root) {
    if(!root)
        return;

    pos_order(root->left);
    pos_order(root->right);

    printf("%d ", root->val);
}
```

迭代版本：

```c++
// 先序遍历
void pre_order_iter(node* root) {
    if(!root) return;

    stack<node*> st;
    st.push(root);

    node* cur = nullptr;

    while(!st.empty()) {
        cur = st.top();
        st.pop();

        cout << cur->val << ' ';

        if(cur->right)
            st.push(cur->right);

        if(cur->left)
            st.push(cur->left);
    }
}

// 中序遍历
void in_order_iter(node* root) {
    if(!root) return;

    stack<node*> st;
    node* cur = root;

    while (cur != nullptr || !st.empty()) {
        while (cur != nullptr) {
            st.push(cur);
            cur = cur->left;
        }

        cur = st.top();
        st.pop();
        cout << cur->val << ' ';

        cur = cur->right;
    }
}

// 后序遍历
void pos_order_iter(node* root) {
    if(!root) return;

    stack<node*> st;
    st.push(root);

    stack<node*> collect;

    node* cur = nullptr;
    while(!st.empty()) {
        cur = st.top();
        st.pop();

        collect.push(cur);

        if(cur->left)
           st.push(cur->left);

        if(cur->right)
            st.push(cur->right);
    }

    while(!collect.empty()) {
        cur = collect.top();
        collect.pop();

        cout << cur->val << ' ';
    }
}
```

## 二叉树题目

二叉树的层序遍历
[测试链接](https://leetcode.cn/problems/binary-tree-level-order-traversal/)

```c++
class Solution {
public:
    vector<vector<int>> levelOrder(TreeNode* root) {
        if(!root) return {};
        vector<vector<int>> result;
        que[r++] = root;

        while(l < r) {
            int size = r - l;
            vector<int> tmp;
            for(int i = 0; i < size; i++) {
                TreeNode* node = que[l++];
                tmp.push_back(node->val);


                if(node->left) que[r++] = node->left;
                if(node->right) que[r++] = node->right;
            }

            result.push_back(tmp);
        }

        return result;
    }
private:
    TreeNode* que[20001];
    int l = 0;
    int r = 0;
};
```

二叉树的锯齿形层序遍历
[测试链接](https://leetcode.cn/problems/binary-tree-zigzag-level-order-traversal/)

```c++
class Solution {
public:
    vector<vector<int>> zigzagLevelOrder(TreeNode* root) {
        if (!root)
            return {};
        vector<vector<int>> result;
        que[r++] = root;
        bool reverse = false;

        while (l < r) {
            int size = r - l;
            vector<int> tmp;
            if(!reverse) {
                for(int i = l; i < r; i++) {
                    tmp.push_back(que[i]->val);
                }
            } else {
                for(int i = r - 1; i >=l; i--) {
                    tmp.push_back(que[i]->val);
                }
            }
            for (int i = 0; i < size; i++) {
                TreeNode* node = que[l++];

                if (node->left)
                    que[r++] = node->left;
                if (node->right)
                    que[r++] = node->right;
            }

            reverse = !reverse;
            result.push_back(tmp);
        }

        return result;
    }

private:
    TreeNode* que[20001];
    int l = 0;
    int r = 0;
};
```

二叉树的最大特殊宽度
[测试链接](https://leetcode.cn/problems/maximum-width-of-binary-tree/)

```c++
// 记录节点序号，使用int, long, long long都会溢出
// 改变思路由于序号都是非负整数, 建议使用unsigned long long
class Solution {
public:
    int widthOfBinaryTree(TreeNode* root) {
        int ans = 1;
        l = r = 0;

        que[r] = root;
        iq[r++] = 1ull;

        while(l < r) {
            int n = r - l;
            ans = max(ans, (int)(iq[r - 1] - iq[l] + 1));
            for(int i = 0; i < n; i++) {
                TreeNode* node = que[l];
                unsigned long long id = iq[l++];

                if(node->left) {
                    que[r] = node->left;
                    iq[r++] = id * 2;
                }

                if(node->right) {
                    que[r] = node->right;
                    iq[r++] = id * 2 + 1;
                }
            }
        }

        return ans;
    }

private:
    TreeNode* que[3001];
    unsigned long long iq[3001];
    int l;
    int r;
};
```

[最大深度](https://leetcode.cn/problems/maximum-depth-of-binary-tree/)

```c++
class Solution {
public:
    int maxDepth(TreeNode* root) {
        return root ? max(maxDepth(root->left), maxDepth(root->right)) + 1 : 0;
    }
};
```

[最小深度](https://leetcode.cn/problems/minimum-depth-of-binary-tree/)

```c++
class Solution {
public:
    int minDepth(TreeNode* root) {
        if(!root) return 0;
        if(!root->left && !root->right) {
            return 1;
        }

        int l = INT_MAX, r = INT_MAX;
        if(root->left) {
            l = minDepth(root->left);
        }

        if(root->right) {
            r = minDepth(root->right);
        }

        return min(l, r) + 1;
    }
};
```

二叉树先序序列化和反序列化
[测试链接](https://leetcode.cn/problems/serialize-and-deserialize-binary-tree/)

```c++
// 先序遍历进行序列化和反序列化
class Codec {
public:
    // Encodes a tree to a single string.
    string serialize(TreeNode* root) {
        if (root) {
            stringstream ss;

            top = -1;
            stack[++top] = root;

            TreeNode* node = nullptr;
            while (top != -1) {
                node = stack[top--];
                if (!node) {
                    ss << "#,";
                    continue;
                }

                ss << node->val << ',';

                stack[++top] = node->right;
                stack[++top] = node->left;
            }
            return ss.str();
        }

        return "";
    }

    // Decodes your encoded data to tree.
    TreeNode* deserialize(string data) {
        if (data == "")
            return nullptr;
        stringstream ss(data);
        vector<string> node;
        string subStr;
        while (getline(ss, subStr, ',')) {
            node.push_back(subStr);
        }

        return buildBinaryTree(node);
    }

    TreeNode* buildBinaryTree(const vector<string>& arr) {
        string cur = arr[cnt++];
        if (cur == "#")
            return nullptr;

        TreeNode* node = new TreeNode(stoi(cur));
        node->left = buildBinaryTree(arr);
        node->right = buildBinaryTree(arr);

        return node;
    }

private:
    int cnt = 0;
    TreeNode* stack[20005];
    int top;
};

// 层序遍历进行序列化和反序列化
class Codec {
public:
    // Encodes a tree to a single string.
    string serialize(TreeNode* root) {
        if (!root)
            return "";

        stringstream ss;
        l = r = 0;
        que[r++] = root;
        ss << root->val << ',';

        int size = 0;
        TreeNode* node = nullptr;

        while (l < r) {
            size = r - l;
            for (int i = 0; i < size; i++) {
                node = que[l++];

                if (node->left) {
                    que[r++] = node->left;
                    ss << node->left->val << ',';
                } else {
                    ss << "#,";
                }

                if (node->right) {
                    que[r++] = node->right;
                    ss << node->right->val << ',';
                } else {
                    ss << "#,";
                }
            }
        }

        return ss.str();
    }

    // Decodes your encoded data to tree.
    TreeNode* deserialize(string data) {
        if (data.empty())
            return nullptr;

        vector<string> leveOrder = split(data, ',');
        int i = 0;
        TreeNode* root = new TreeNode(stoi(leveOrder[i++]));
        TreeNode* node = nullptr;

        l = r = 0;
        que[r++] = root;

        while (l != r) {
            node = que[l++];

            if (leveOrder[i] == "#") {
                i++;
            } else {
                node->left = new TreeNode(stoi(leveOrder[i++]));
                que[r++] = node->left;
            }

            if (leveOrder[i] == "#") {
                i++;
            } else {
                node->right = new TreeNode(stoi(leveOrder[i++]));
                que[r++] = node->right;
            }
        }

        return root;
    }

    vector<string> split(string data, char delim) {
        if (data.empty())
            return {};

        stringstream ss(data);
        vector<string> ans;
        string subStr;
        while (getline(ss, subStr, delim)) {
            if (subStr.empty())
                continue;

            ans.push_back(subStr);
        }

        return ans;
    }

private:
    TreeNode* que[10005];
    int l;
    int r;
};
```

利用先序与中序遍历序列构造二叉树
[测试链接](https://leetcode.cn/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)

```c++
class Solution {
public:
    TreeNode* buildTree(vector<int>& preorder, vector<int>& inorder) {
        return func(preorder, 0, preorder.size(), inorder, 0, inorder.size());
    }

    TreeNode* func(vector<int>& preorder, int preorderBegin, int preorderEnd, vector<int>& inorder, int inorderBegin, int inorderEnd) {
        if(preorderBegin == preorderEnd) return nullptr;

        int val = preorder[preorderBegin];
        TreeNode* root = new TreeNode(val);

        if(preorderEnd - preorderBegin == 1) return root;

        int partitionIdx;
        for(int i = inorderBegin; i < inorderEnd; i++) {
            if(val == inorder[i]) {
                partitionIdx = i;
                break;
            }
        }

        int inorderLeftBegin = inorderBegin;
        int inorderLeftEnd = partitionIdx;
        int inorderRightBegin = partitionIdx + 1;
        int inorderRightEnd = inorderEnd;

        int preorderLeftBegin = preorderBegin + 1;
        int preorderLeftEnd = preorderLeftBegin + (inorderLeftEnd - inorderLeftBegin);
        int preorderRightBegin = preorderLeftEnd;
        int preorderRightEnd = preorderEnd;

        root->left = func(preorder, preorderLeftBegin, preorderLeftEnd ,inorder, inorderLeftBegin, inorderLeftEnd);
        root->right = func(preorder, preorderRightBegin, preorderRightEnd, inorder, inorderRightBegin, inorderRightEnd);

        return root;
    }
};
```

验证完全二叉树
[测试链接](https://leetcode.cn/problems/check-completeness-of-a-binary-tree/)

```c++
class Solution {
public:
    bool isCompleteTree(TreeNode* root) {
        l = r = 0;
        que[r++] = root;

        TreeNode* node = nullptr;
        bool leaf = false;
        while(l < r) {
            node = que[l++];

            if((!node->left && node->right) || (leaf && (node->left || node->right))){
                return false;
            }

            if(node->left){
                que[r++] = node->left;
            }
            if(node->right) {
                que[r++] = node->right;
            }

            if(!node->left || !node->right){
                leaf = true;
            }
        }

        return true;
    }

private:
    TreeNode* que[105];
    int l;
    int r;
};
```

求完全二叉树的节点个数
[测试链接](https://leetcode.cn/problems/count-complete-tree-nodes/)

```c++
class Solution {
public:
    int countNodes(TreeNode* root) {
        if(!root) return 0;

        return getCnt(root, 1, mostLeft(root, 1));
    }

    int getCnt(TreeNode* node, int level, int h) {
        if(level == h) {
            return 1;
        }

        if(mostLeft(node->right, level + 1) == h){
            return (1 << (h - level)) + getCnt(node->right, level + 1, h);
        }

        return (1 << (h - level - 1)) + getCnt(node->left, level + 1, h);
    }

    int mostLeft(TreeNode* node, int level){
        while(node) {
            node = node->left;
            level++;
        }

        return level - 1;
    }
};
```

普通二叉树上寻找两个节点的最近公共祖先
[测试链接](https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-tree/)

```c++
class Solution {
public:
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        if (!root || root == p || root == q) {
            return root;
        }

        TreeNode* left = lowestCommonAncestor(root->left, p, q);
        TreeNode* right = lowestCommonAncestor(root->right, p, q);

        if(left && right) return root;
        if(!left && !right) return nullptr;

        return left ? left :right;
    }
};
```

搜索二叉树上寻找两个节点的最近公共祖先
[测试链接](https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-search-tree/)

```c++
class Solution {
public:
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        while(root != p && root != q) {
            if(root->val > min(p->val, q->val) && root->val < max(p->val, q->val)) {
                break;
            }

            root = root->val < min(p->val, q->val) ? root->right : root->left;
        }

        return root;
    }
};
```

收集累加和等于aim的所有路径
[测试链接](https://leetcode.cn/problems/path-sum-ii/)

```c++
class Solution {
public:
    vector<vector<int>> pathSum(TreeNode* root, int targetSum) {
        if(!root) return {};
        getArr(root, targetSum);

        return ans;
    }

    void getArr(TreeNode* root, int targetSum){
        if(!root) return;

        if(targetSum - root->val == 0 && (!root->left && !root->right)) {
            ret.push_back(root->val);
            ans.push_back(ret);
            ret.pop_back();

            return;
        }

        ret.push_back(root->val);

        getArr(root->left, targetSum - root->val);
        getArr(root->right, targetSum - root->val);

        ret.pop_back();
    }



private:
    vector<vector<int>> ans;
    vector<int> ret;
};
```

验证平衡二叉树
[测试链接](https://leetcode.cn/problems/balanced-binary-tree/)

```c++
class Solution {
public:
    bool isBalanced(TreeNode* root) {
        if(!root) return true;

        if(!isBalanced(root->left) || !isBalanced(root->right)) return false;

        int left = getDepth(root->left);
        int right = getDepth(root->right);

        return abs(left - right) > 1 ? false : true;
    }

    int getDepth(TreeNode* root) {
        if(!root) return 0;

        if(!root->left && !root->right) return 1;

        int left = getDepth(root->left);
        int right = getDepth(root->right);

        return max(left, right) + 1;
    }
};
```

验证搜索二叉树
[测试链接](https://leetcode.cn/problems/validate-binary-search-tree/)

```c++
class Solution {
public:
    bool isValidBST(TreeNode* root) {
        top = -1;

        TreeNode* node = root;
        while(top != -1 || node) {
            while(node) {
                stack[++top] = node;
                node = node->left;
            }

            node = stack[top--];
            if(pre >= node->val) {
                return false;
            } else {
                pre = node->val;
            }

            node = node->right;
        }

        return true;

    }
private:
    TreeNode* stack[10005];
    int top;
    long pre = LONG_MIN;
};
```

修剪搜索二叉树
[测试链接](https://leetcode.cn/problems/trim-a-binary-search-tree/)

```c++
class Solution {
public:
    TreeNode* trimBST(TreeNode* root, int low, int high) {
        if (!root)
            return root;

        if (root->val < low) {
            return trimBST(root->right, low, high);
        }
        if (root->val > high) {
            return trimBST(root->left, low, high);
        }
        root->left = trimBST(root->left, low, high);
        root->right = trimBST(root->right, low, high);

        return root;
    }
};
```

二叉树打家劫舍问题
[测试链接](https://leetcode.cn/problems/house-robber-iii/)

```c++
class Solution {
public:
    int rob(TreeNode* root) {
        f(root);
        return max(yes, no);
    }

    void f(TreeNode* root){
        if(!root) {
            yes = 0;
            no = 0;

            return;
        }

        int y = root->val, n = 0;

        f(root->left);
        y += no;
        n += max(yes, no);

        f(root->right);
        y += no;
        n += max(yes, no);

        yes = y;
        no = n;
    }

private:
    int yes;
    int no;
};
```
