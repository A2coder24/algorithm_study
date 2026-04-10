---
title: 排序算法
series: algorithm-study
series_order: 2
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
