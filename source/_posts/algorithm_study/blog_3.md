---
title: 排序算法
categories: 算法学习
tags:
  - algorithm
order: 2
---

## 排序算法

#### 选择排序

```c++
// 数组 0 ~ size-1，遍历最大值，记录最大值索引 k，与索引 size-1 交换
void select_sort(vector<int>& arr){
    int n = arr.size() - 1;


    for(int i = n; i > 0; i--) {
        int max_val = arr[0];
        int max_val_index = 0;

        for(int j = 1; j <= i; j++) {
            if(arr[j] > max_val) {
                max_val = arr[j];
                max_val_index = j;
            }
        }

        swap(arr[i], arr[max_val_index]);
    }
}
```

#### 冒泡排序

```c++
// 数组 1 ~ size-1，与临近的左值比较，如果左值大，交换，反之不交换
// 也可以添加一个信息位 break_flag，如果内层循环全程不调用swap，就跳出外层循环，说明数组已经有序
void bubble_sort(vector<int>& arr) {
    int n = arr.size() - 1;

    for(int i = n; i > 0; i--) {
        for(int j = 1; j <= i; j++){
            if(arr[j] < arr[j - 1]) {
                swap(arr[j], arr[j - 1]);
            }
        }
    }
}
```

#### 插入排序

```c++
// 从索引1开始，往前遍历，当遍历到比索引1值小(索引位 k，k < 1)，把arr[1]插入arr[k]后面
// 就像玩斗地主，拿牌一样
void insertion_sort(vector<int>& arr) {
    int n = arr.size() - 1;

    for(int i = 1; i <= n; i++) {
        for(int j = i - 1; j >= 0; j--) {
            if(arr[j] > arr[j + 1]) {
                swap(arr[j], arr[j + 1]);
            }
        }
    }
}
```

#### 归并排序

**递归版本**

```c++
// 一个数组，分为左右两部分，递归实现左边有序，右边有序，然后合并左右两部分，整个数组有序
#define SIZE 10000

int temp[SIZE] = {0};

void merge(int* arr, int l, int mid, int r) {
    int n = r - l + 1, i = 0;
    int l_1 = l, l_2 = mid + 1;
    while(l_1 <= mid && l_2 <= r) {
        if(arr[l_1] < arr[l_2]) {
            temp[i] = arr[l_1++];
        } else {
            temp[i] = arr[l_2++];
        }

        i++;
    }

    while(l_1 <= mid) {
        temp[i++] = arr[l_1++];
    }

    while(l_2 <= r) {
        temp[i++] = arr[l_2++];
    }

    for(int j = 0; j < n; j++) {
        arr[j + l] = temp[j];
    }
}

void merge_sort(int* arr, int l, int r) {
    if(l >= r) return;
    int mid = l + ((r - l) >> 1);

    merge_sort(arr, l, mid);
    merge_sort(arr, mid + 1, r);

    merge(arr, l, mid, r);
}
```

**非递归版本**

```c++
#define SIZE 10000

int temp[SIZE] = {0};

void merge_sort(int* arr, int n) {
    for(int l, m, r, step = 1; step < n; step <<= 1) {
        l = 0;
        while (l < n) {
            m = l + step - 1;
            if (m + 1 >= n) {
                break;
            }
            r = (l + (step << 1) - 1) < (n - 1) ? (l + (step << 1) - 1) : (n - 1);
            merge(arr, l, m, r);
            l = r + 1;
        }
    }
}
```
