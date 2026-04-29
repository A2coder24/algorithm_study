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

买苹果使用最少袋子
有装下8个苹果的袋子、装下6个苹果的袋子，一定要保证买苹果时所有使用的袋子都装满
对于无法装满所有袋子的方案不予考虑，给定n个苹果，返回至少要多少个袋子
如果不存在每个袋子都装满的方案返回-1
感谢热心的同学，找到了题目1的在线测试
测试链接 : https://www.nowcoder.com/practice/73e0552b78474a9086781e47f4e01d73

```c++
#include <iostream>
using namespace std;

int f(int n) {
    if(n & 1) {
        return -1;
    }

    if(n < 18) {
        if(n == 6 || n == 8){
            return 1;
        }
        if(n == 12 || n == 14 || n == 16) {
            return 2;
        }

        return -1;
    }

    return (n - 18) / 8 + 3;
}

int main() {
    int n = 0;
    cin >> n;

    cout << f(n) << endl;

    return 0;
}
```

草一共有n的重量，两只牛轮流吃草，A牛先吃，B牛后吃
每只牛在自己的回合，吃草的重量必须是4的幂，1、4、16、64....
谁在自己的回合正好把草吃完谁赢，根据输入的n，返回谁赢

```c++
char f1(int n) {
    int mod = n % 5;
    return mod == 0 || mod == 2 ? 'B' : 'A';
}


// 使用对数器打印答案，找规律
char f2(int rest, char cur) {
    char enemy = cur == 'A' ? 'B' : 'A';
    if(rest < 5) {
        return (rest == 0 || rest == 2) ? enemy : cur;
    }

    int pick = 1;
    while(pick <= rest) {
        if(f(rest - pick, enemy) == cur) {
            return cur;
        }

        pick *= 4;
    }

    return enemy;
}
```

判断一个数字是否是若干数量(数量>1)的连续正整数的和

```c++
bool is1(int num) {
    for(int i = 1, start = 0, j = 0; i <= num; i++) {
        start = i;
        for(j = start + 1; start < num; j++) {
            start += j;
        }

        if(start == num) {
            return j - i > 1 ? true : false;
        }
    }

    return false;
}

bool is2(int num) {
    return (num > 0 && num == (num & -num)) ? true : false;
}
```

可以用r、e、d三种字符拼接字符串，如果拼出来的字符串中
有且仅有1个长度>=2的回文子串，那么这个字符串定义为"好串"
返回长度为n的所有可能的字符串中，好串有多少个
结果对 1000000007 取模， 1 <= n <= 10^9
示例：
n = 1, 输出0
n = 2, 输出3
n = 3, 输出18

```c++
int num1(int n) {
    vector<char> arr(n);

    return f(arr, 0);
}

int f(vector<int>& arr, int i) {
    if(i == arr.size()) {
        int cnt = 0;
        for(int j = 0; j < arr.size(); j++) {
            for(int k = j + 1; k < arr.size(); k++) {
                if(is(arr, j, k)) {
                    cnt++;
                }
                if(cnt > 1) {
                    return 0;
                }
            }
        }

        cnt = cnt == 1 ? 1 : 0;
    } else {
        int ans = 0;
        arr[i] = 'r';
        ans += f(arr, i + 1);
        arr[i] = 'e';
        ans += f(arr, i + 1);
        arr[i] = 'd';
        ans += f(arr, i + 1);

        return ans;
    }
}

bool is(vector<char>& arr, int l, int r) {
    while(l < r) {
        if(arr[l++] != arr[r--]) {
            return false;
        }
    }

    return true;
}

int num2(int n) {
    if(n == 1) return 0;
    if(n == 2) return 3;
    if(n == 3) return 18;

    return (int)(((n + 1) * 6l) % 1000000007) ;
}
```
