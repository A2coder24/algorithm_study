---
title: 栈与队列
series: algorithm-study
series_order: 7
---

## 栈与队列

栈是先进后出，队列是先进先出，栈就像叠盘子一样，队列就像银行排队叫号一样。

**栈的数组实现**

```c++
int p = -1;
int size = 100;
vector<int> arr(size);

void push(int val) {
    if(p == size - 1)
        return;

    arr[++p] = val;
}

int top(void) {
    return arr[p];
}

void pop(void) {
    if(p < 0)
        return;
    p--;
}
```

**队列的数组实现**

普通队列的实现：

```c++
int l = 0, r = 0;
int size = 100;
vector<int> arr(size);

void push(int val) {
    arr[r++] = val;
}

int pop(void) {
    return arr[l++];
}

bool is_empty(void) {
    return l == r;
}

int get_len(void) {
    return r - l;
}
```

循环队列的实现：

```c++
int l = 0, r = 0;
int size = 100;
vector<int> arr(size);

void push(int val) {
    if((r + 1) % size == l)
        return;

    arr[r] = val;
    r = (r + 1) % size;
}

int pop(void) {
    if(l == r)
        return numeric_limits<int>::min();

    int val = arr[l];
    l = (l + 1) % size;

    return val;
}

bool is_empty(void) {
    return l == r;
}

int get_len(void) {
    return (r - l + size) % size;
}
```

双端队列实现：

```c++
int l = 0, r = 1;
int size = 100;
vector<int> arr(size);

void push_front(int val) {
    if((l - 1 + size) % size == r)
        return;

    arr[l] = val;
    l = (l - 1 + size) % size;
}

void push_back(int val) {
    if((r + 1) % size == l)
        return;

    arr[r] = val;
    r = (r + 1) % size;
}

int pop_front(void) {
    if((l + 1) % size == r)
        return numeric_limits<int>::min();

    l = (l + 1) % size;
    return arr[l];
}

int pop_back(void) {
    if((r - 1 + size) % size == l)
        return numeric_limits<int>::min();

    r = (r - 1 + size) % size;
    return arr[r];
}

bool is_empty(void) {
    return (l + 1) % size == r;
}

int get_len(void) {
    return (r - l + size) % size - 1;
}
```

最小栈实现：

```c++
#define SIZE 100000

int p = -1;
int arr[SIZE] = {0};
int min_arr[SIZE] = {0};

void push(int val) {
    if(p == SIZE - 1)
        return;


    p++;
	arr[p] = val;
    min_arr[p] = is_empty() ? val : val < min_arr[p - 1] ? val : min_arr[p - 1];
}

void pop(void) {
    if(is_empty())
        return;

    p--;
}

int top(void) {
    return is_empty() ? INT_MIN : arr[p];
}

int get_min(void) {
    return is_empty() ? INT_MIN : min_arr[p];
}

bool is_empty(void) {
    return p < 0 ? true : false;
}
```
