---
title: 堆结构与堆排序
categories: 算法学习
tags:
  - algorithm
---

## 堆数据结构

```c++
// 最小堆
#define N 5001

int arr[N];
int size = 0;

void heap_push(int val) {
    arr[++size] = val;

    heap_up();
}

int heap_pop(void){
    if(size == 0) return INT_MIN;

    int ans = arr[1];

    swap(&arr[1], &arr[size--]);

    heap_down();

    return ans;
}

void heap_up(void) {
    int child = size;
    int parent = child / 2;

    while(parent > 0 && arr[child] < arr[parent]) {
        swap(&arr[child], &arr[parent]);

        child = parent;
        parent = child / 2;
    }
}

void heap_down(void) {
    int parent = 1;
    int child = parent * 2 <= size ? parent * 2 + 1 <= size ? arr[parent * 2] < arr[parent * 2 + 1] ? parent * 2 : parent * 2 + 1 : parent * 2 : size + 1;

    while(child <= size && arr[parent] > arr[child]) {
        swap(&arr[child], &arr[parent]);

        parent = child;
        child = parent * 2 <= size ? parent * 2 + 1 <= size ? arr[parent * 2] < arr[parent * 2 + 1] ? parent * 2 : parent * 2 + 1 : parent * 2 : size + 1;
    }


}

void swap(int* a, int* b){
    int temp = *a;
    *a = *b;
    *b = temp;
}

```

测试链接：[合并K个有序链表](https://www.nowcoder.com/practice/65cfde9e5b9b4cf2b6bafa5f3ef33fa6)

```c++
ListNode* generate_list(priority_queue<ListNode*, vector<ListNode*>, function<bool(ListNode*, ListNode*)>> min_heap) {
    if(min_heap.empty()) return nullptr;

    ListNode* temp = min_heap.top();
    min_heap.pop();

    temp->next = generate_list(min_heap);

    return temp;
}

ListNode* merge_k_lists(vector<ListNode*>& lists) {
    function<bool(ListNode*, ListNode*)> cmp = [](ListNode* a, ListNode* b)->bool{
        return a->val > b->val;
    };

    priority_queue<ListNode*, vector<ListNode*>, decltype(cmp)> min_heap(cmp);

    ListNode* temp = nullptr;
    for(ListNode* node : lists) {
        while(node) {
            temp = node;
            node = temp->next;
            temp->next = nullptr;

            min_heap.push(temp);
        }
    }

    return generate_list(min_heap);
}
```

测试链接: [最多线段重合问题](https://www.nowcoder.com/practice/1ae8d0b6bb4e4bcdbf64ec491f63fc37)

```c++
#include <iostream>
#include <queue>
#include <algorithm>
#include <functional>
#include <vector>
using namespace std;

int main() {
    priority_queue<int, vector<int>, greater<>> min_heap;
    int val = 0;
    int ans = 0;
    int n;

    cin >> n;
    vector<vector<int>> arr(n, vector<int>(2, 0));
    for(int i = 0; i < n; i++) {
        cin >> arr[i][0] >> arr[i][1];
    }

    sort(arr.begin(), arr.end(),
    [](vector<int>& a, vector<int>& b){
        return a.front() < b.front();
    });

    for(vector<int>& k : arr) {
        min_heap.push(k.back());
        val = k.front();

        while(!min_heap.empty() && min_heap.top() <= val) {
            min_heap.pop();
        }

        ans = ans < min_heap.size() ? min_heap.size() : ans;
    }

    cout << ans;

    return 0;
}
```

测试链接: [将数组和减半的最少操作次数](https://leetcode.cn/problems/minimum-operations-to-halve-array-sum/)

```c++
int halve_array(vector<int>& nums) {
    priority_queue<double, vector<double>> max_heap;
    int cnt = 0;
    double sum = accumulate(nums.begin(), nums.end(), 0.0);
    double val = 0;
    double sum_half = sum / 2;

    for(int& n : nums) {
        max_heap.push(n);
    }



    while(sum > sum_half) {
        val = max_heap.top();
        max_heap.pop();

        val /= 2;
        max_heap.push(val);

        sum -= val;
        cnt++;
    }

    return cnt;
}
```
