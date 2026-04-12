---
title: 链表
series: algorithm-study
series_order: 6
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

```c++
Node* reverse_list(Node* head) {
    if(!head) return head;

    Node* pre = new Node(-1, head);
    Node* result = new Node(-1);
    Node* cur = nullptr;

    while(pre->next) {
        cur = pre->next;
        pre->next = cur->next;

        cur->next = result->next;
        result->next = cur;
    }

    delete pre;

    Node* head = result->next;
    result->next = nullptr;

    delete result;


    return head;
}
```
