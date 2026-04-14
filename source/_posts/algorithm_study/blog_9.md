---
title: 二叉树
categories: 算法学习
tags:
  - 算法学习
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
