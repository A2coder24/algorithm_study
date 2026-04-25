---
title: 链表
categories: 算法学习
tags:
  - algorithm
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

返回两个无环链表相交的第一个节点
[测试链接](https://leetcode.cn/problems/intersection-of-two-linked-lists/)

```c++
int getLen(ListNode* head) {
    int ans = 0;
    while(head) {
        ans++;

        head = head->next;
    }

    return ans;
}

ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
    int aLen = getLen(headA);
    int bLen = getLen(headB);

    if(aLen < bLen) {
        ListNode* temp = headA;
        headA = headB;
        headB = temp;

        int tmp = aLen;
        aLen = bLen;
        bLen = tmp;
    }


    for(int i = 0, diff = aLen - bLen; i < diff; i++){
        headA = headA->next;
    }

    while(headA && headA != headB) {
        headA = headA->next;
        headB = headB->next;
    }

    return headA;
}
```

每k个节点一组翻转链表
[测试链接](https://leetcode.cn/problems/reverse-nodes-in-k-group/)

```c++
ListNode* reverse(ListNode* head) {
    ListNode* dummy = new ListNode(-1, head);
    ListNode* temp = new ListNode(-1, nullptr);
    ListNode* cur = dummy->next;
    ListNode* ans = nullptr;

    while(cur) {
        dummy->next = cur->next;

        cur->next = temp->next;
        temp->next = cur;

        cur = dummy->next;
    }

    ans = temp->next;

    delete dummy;
    delete temp;

    return ans;
}
ListNode* reverseKGroup(ListNode* head, int k) {
    ListNode* dummy = new ListNode(-1, head);
    ListNode* pre_left = nullptr, * left = nullptr, * right = nullptr, * right_back = nullptr, * end_node = nullptr;
    int cnt = 0;

    pre_left = dummy;
    left = dummy->next;
    right = dummy;

    while(right) {
        cnt = k;
        while(right && cnt) {
            right = right->next;
            cnt--;
        }

        if(right){
            right_back = right->next;

            right->next = nullptr;
            end_node = pre_left->next;
            pre_left->next = nullptr;

            pre_left->next = reverse(left);
            end_node->next = right_back;

            pre_left = end_node;
            left = pre_left->next;
            right = pre_left;
            right_back = nullptr;
        }
    }

    ListNode* ans = dummy->next;
    delete dummy;

    return ans;
}
```

复制带随机指针的链表
[测试链接](https://leetcode.cn/problems/copy-list-with-random-pointer/)

```c++
Node* copy_random_list(Node* head) {
    if(!head) return nullptr;

    Node* cur = head, * next = nullptr;
    while(cur){
        next = cur->next;
        cur->next = new Node(cur->val);
        cur->next->next = next;

        cur = next;
    }

    cur = head;
    while(cur) {
        cur->next->random = cur->random ? cur->random->next : nullptr;

        cur = cur->next->next;
    }

    Node* temp = new Node(-1);
    Node* node = nullptr;
    next = head;
    cur = temp;

    while(next) {
        node = next->next;
        next->next = node->next;
        node->next = cur->next;
        cur->next = node;

         cur = cur->next;
        next = next->next;
    }

    Node* ans = temp->next;

    delete temp;
    return ans;
}
```

判断链表是否是回文结构
[测试链接](https://leetcode.cn/problems/palindrome-linked-list/)

```c++
int get_len(ListNode* head) {
    int cnt = 0;
    while(head){
        cnt++;
        head = head->next;
    }
    return cnt;
}

ListNode* reverse_list(ListNode* head) {
    ListNode* dummy = new ListNode(-1, nullptr);
    ListNode* cur = dummy, * temp = nullptr;

    while(head) {
        temp = head->next;

        head->next = cur->next;
        cur->next = head;

        head = temp;
    }

    cur = dummy->next;
    delete dummy;

    return cur;
}

bool is_palindrome(ListNode* head) {
    ListNode* head_1 = nullptr, * head_2 = nullptr;
    bool flag = true;

    int len = get_len(head);
    if (len == 1)
        return flag;

    head_2 = head;
    for(int i = 0, n = len / 2; i < n; i++){
        head_2 = head_2->next;
    }

    if(len % 2) {
        head_1 = head_2->next;
        head_2 = head_1->next;
        head_1->next = nullptr;
    } else {
        head_1 = head_2;
        head_2 = head_1->next;
        head_1->next = nullptr;
    }

    head_1 = head;
    head_2 = reverse_list(head_2);

    ListNode* node = head_2;
    while(node) {
        if(node->val != head_1->val) {
            flag = false;
            break;
        }

        head_1 = head_1->next;
        node = node->next;
    }

    head_2 = reverse_list(head_2);
    head_1 = head;
    while(head_1->next){
        head_1 = head_1->next;
    }

    head_1->next = head_2;


    return flag;
}
```

返回链表的第一个入环节点
[测试链接](https://leetcode.cn/problems/linked-list-cycle-ii/)

```c++
ListNode *detectCycle(ListNode *head) {
    if(!head) return head;

    ListNode* slow = head;
    ListNode* fast = slow;
    while(fast && fast->next) {
        slow = slow->next;
        fast = fast->next->next;

        if(slow == fast) break;
    }

    if(!fast || !fast->next) return nullptr;

    slow = head;
    while(slow != fast) {
        slow = slow->next;
        fast = fast->next;
    }

    return slow;
}
```

排序链表
[测试链接](https://leetcode.cn/problems/sort-list/)
递归版本：

```c++
int get_len(ListNode* head) {
    int cnt = 0;
    while(head){
        cnt++;
        head = head->next;
    }
    return cnt;
}


ListNode* merge_sort(ListNode* left, ListNode* right) {
    ListNode* dummy = new ListNode(-1), * cur = dummy;

    while(left && right) {
        if(left->val < right->val) {
            cur->next = left;
            left = left->next;
        } else {
            cur->next = right;
            right = right->next;
        }

        cur = cur->next;
    }

    cur->next = left ? left : right;

    cur = dummy->next;
    delete dummy;

    return cur;
}
ListNode* sort(ListNode* head, int len){
    if(len == 1) return head;

    ListNode* node = head, * left = nullptr, * right = nullptr;
    int left_len = len / 2, right_len = len - len / 2;
    for(int i = 1, n = len / 2; i < n; i++){
        node = node->next;
    }

    left = head;
    right = node->next;
    node->next = nullptr;

    ListNode* left_list = sort(left, left_len);
    ListNode* right_list = sort(right, right_len);

    return merge_sort(left_list, right_list);
}
ListNode* sortList(ListNode* head) {
    if(!head) return head;

    int len = get_len(head);

    return sort(head, len);
}
```

迭代版本：

```c++
int get_len(ListNode* head) {
    int cnt = 0;
    while(head){
        cnt++;
        head = head->next;
    }
    return cnt;
}

ListNode* merge_sort(ListNode* left, ListNode* right) {
    ListNode* dummy = new ListNode(-1), * cur = dummy;

    while(left && right) {
        if(left->val < right->val) {
            cur->next = left;
            left = left->next;
        } else {
            cur->next = right;
            right = right->next;
        }

        cur = cur->next;
    }

    cur->next = left ? left : right;

    cur = dummy->next;
    delete dummy;

    return cur;
}

ListNode* sortList(ListNode* head) {
    if (!head)
        return head;

    int len = get_len(head);

    ListNode* dummy = new ListNode(-1, head);
    ListNode *pre = nullptr, *left = nullptr, *right = nullptr, *back = dummy;
    ListNode* temp = nullptr;
    for (int step = 1; step < len; step <<= 1) {
        back = dummy;
        while (back) {
            pre = back;

            left = pre->next;

            right = left;
            for (int i = 1; i < step && right; i++) {
                right = right->next;
            }

            if (right) {
                temp = right;
                right = temp->next;
                temp->next = nullptr;

                temp = right;
                for (int i = 1; i < step && temp; i++) {
                    temp = temp->next;
                }

                if (temp) {
                    back = temp->next;
                    temp->next = nullptr;
                } else {
                        back = temp;
                }
            } else {
                back = right;
            }

            pre->next = merge_sort(left, right);
            temp = pre->next;

            while (temp && temp->next) {
                temp = temp->next;
            }

            if(temp) {
                temp->next = back;
                back = temp;
            }
        }
    }

    temp = dummy->next;
    delete dummy;

    return temp;
}

```
