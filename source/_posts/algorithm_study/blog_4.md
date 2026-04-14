---
title: 对数器
categories: 算法学习
tags:
  - algorithm
---

## 对数器-验证算法的正确性

#### 对数器的实现

1. 你想要测的方法a（最优解）
2. 实现复杂度不好但是容易实现的方法b（暴力解）
3. 实现一个随机样本产生器（长度也随机、值也随机）
4. 把方法a和方法b跑相同的输入样本，看看得到的结果是否一样
5. 如果有一个随机样本使得比对结果不一致，打印这个出错的样本进行人工干预，改对方法a和方法b
6. 当样本数量很多时比对测试依然正确，可以确定方法a（最优解）已经正确。

> 重要的是第5步，先找一个数据量小的错误样本，带入debug，一步一步排查
> 对数器使用的前提是，有两种思路来实现方法解决题目，一个暴力，一个理想中的最优解
> 很多题目都会用到对数器，几乎可以验证任何方法，特别是在验证贪心、观察规律方面很有用

**例子：排序算法的验证**

自己实现的排序算法

```c++
std::vector<int> select_sort(std::vector<int> arr){
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

        std::swap(arr[i], arr[max_val_index]);
    }

    return arr;
}


std::vector<int> bubble_sort(std::vector<int> arr) {
    int n = arr.size() - 1;

    for(int i = n; i > 0; i--) {
        for(int j = 1; j <= i; j++){
            if(arr[j] < arr[j - 1]) {
                std::swap(arr[j], arr[j - 1]);
            }
        }
    }

    return arr;
}


std::vector<int> insertion_sort(std::vector<int> arr) {
    int n = arr.size() - 1;

    for(int i = 1; i <= n; i++) {
        for(int j = i - 1; j >= 0; j--) {
            if(arr[j] > arr[j + 1]) {
                std::swap(arr[j], arr[j + 1]);
            }
        }
    }

    return arr;
}
```

对数器的实现

```c++
void arr_print(std::vector<int> arr) {
	for(int n : arr) {
		std::cout << n << ' ';
	}
	std::cout << std::endl;
}


std::vector<int> validator(int max_size, int min_val, int max_val){
	std::random_device rd;
    std::mt19937 engine(rd());
    // 左闭右闭
    std::uniform_int_distribution<int> size(1, max_size);
    std::uniform_int_distribution<int> val(min_val, max_val);

    int len = size(engine);
    std::vector<int> arr(len);

    for(int i = 0; i < len; i++) {
        arr[i] = val(engine);
    }

    return arr;
}


int main(int argc, char** argv) {
	std::vector<int> arr = validator(20, -100, 100);

	arr_print(arr);

	std::cout << "select_sort:\n";
	arr_print(select_sort(arr));

	std::cout << "bubble_sort:\n";
	arr_print(bubble_sort(arr));

	std::cout << "insertion_sort:\n";
	arr_print(insertion_sort(arr));


	return 0;
}
```
