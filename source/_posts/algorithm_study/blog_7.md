---
title: 链表
categories: 算法学习
tags:
  - 算法学习
---

## 链表

链表就像用一根绳子把多个排队蚂蚱栓起来，以蚂蚱的视角只能看到之后的蚂蚱，如果绳子足够长看不到，蚂蚱也可以通过绳子找到后面的蚂蚱。

链表有两种形式，一种是含有假头节点，一种是没有假头节点。前者设计的目的是为了操作链表容易，本博客都采用第二种形式。

**单链表组成**

```c++
// 节点定义
class Node {
    public:
        Node(int v) : val(v), next(nullptr) {}
        Node(int v, Node* n) : val(v), next(n) {}
    public:
        int val;
        Node* next;
};
```

**双链表组成**

```c++
// 节点定义
class Node {
    public:
        Node(int v) : val(v), pre(nullptr), next(nullptr) {}
        Node(int v, Node* p, Node* n) : val(v), pre(p), next(n) {}
    public:
        int val;
        Node* pre;
        Node* next;
};
```

> 其中循环链表又分为循环单链表和循环双链表，骑士就是把链表首尾连接

## 链表相关题目

**链表反转**
反转单链表测试链接 : [反转单链表](https://leetcode.cn/problems/reverse-linked-list/)

```c++
Node* reverse_list(Node* head) {
    Node* prev = nullptr;
    Node* cur = head;
    Node* next = nullptr;

    while (cur) {
        next = cur->next;
        cur->next = prev;
        prev = cur;
        cur = next;
    }


    return prev;
}
```

**有序链表合并**
将两个升序链表合并为一个新的 升序 链表并返回
新链表是通过拼接给定的两个链表的所有节点组成的
测试链接: [有序链表合并](https://leetcode.cn/problems/merge-two-sorted-lists/)

```c++
Node* merge_list(Node* head_1, Node* head_2) {
    if(!head_1) return head_2;
    if(!head_2) return head_1;

    Node* head = nullptr;
    if(head_1->val < head_2->val) {
        head = head_1;
        head_1 = head_1->next;
    } else {
        head = head_2;
        head_2 = head_2->next;
    }

    Node* cur = head;

    while(head_1 && head_2) {
        if(head_1->val < head_2->val) {
            cur->next = head_1;
            head_1 = head_1->next;
        } else {
            cur->next = head_2;
            head_2 = head_2->next;
        }
        cur = cur->next;
    }

    if(head_1) {
        cur->next = head_1;
    }

    if(head_2) {
        cur->next = head_2;
    }

    return head;
}
```

**链表相加**
给你两个 非空 的链表，表示两个非负的整数
它们每位数字都是按照 逆序 的方式存储的，并且每个节点只能存储 一位 数字
请你将两个数相加，并以相同形式返回一个表示和的链表。
你可以假设除了数字 0 之外，这两个数都不会以 0 开头
测试链接：[两数相加](https://leetcode.cn/problems/add-two-numbers/)

```c++
Node* add_two_numbers(Node* head_1, Node* head_2) {
    Node* dummy = new Node(-1);
    Node* cur = dummy;
    int c = 0, sum = 0;

    while(head_1 || head_2 || c) {
        sum = c;

        if(head_1) {
            sum += head_1->val;
        }

        if(head_2) {
            sum += head_2->val;
        }

        c = sum / 10;
        cur->next = new Node(sum % 10);
        cur = cur->next;
    }

    Node* head = dummy->next;
    delete dummy;

    return head;
}
```

**链表分区**

给你一个链表的头节点 head 和一个特定值 x
请你对链表进行分隔，使得所有 小于 x 的节点都出现在 大于或等于 x 的节点之前。
你应当 保留 两个分区中每个节点的初始相对位置
测试链接: [链表分区](https://leetcode.cn/problems/partition-list/)

```c++
Node* partition_list(Node* head, int  mid) {
    if(!head) return head;
    Node* dummy_less = new Node(-1);
    Node* tmp = dummy_less;
    Node* dummy_greater = new Node(-1, head);
    Node* pre = dummy_greater, * cur = head;

    while(cur) {
        if (cur->val < mid) {
            pre->next = cur->next;

            cur->next = tmp->next;
            tmp->next = cur;
            tmp = cur;

            cur = pre->next;
        } else {
            pre = cur;
            cur = cur->next;
        }
    }

    tmp->next = dummy_greater->next;
    delete tmp_head;

    tmp = dummy_less->next;
    delete dummy_less;

    return tmp;
}

```
