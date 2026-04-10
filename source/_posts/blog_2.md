---
title: 二进制和位运算
---

## 二进制和位运算

位运算符号：&, |, ~, ^, <<, >>
逻辑运算符：&&, ||, !
其中 &&, || 具有短路特性

**二进制打印**

```c++
// 打印二进制
// int 32位整数
void binary_print(int n) {
    for(int i = 31; i >= 0; i--) {
        cout << n >> i & 1 + '0';
    }
}
```

**八进制打印**

```c++
// 打印八进制
// int 32位整数
void binary_print(int n) {
    for(int i = 30; i >= 0; i -= 3) {
        cout << n >> i & 7 + '0';
    }
}
```

**十六进制打印**

```c++
// 打印十六进制
// int 32位整数
void binary_print(int n) {
    for(int i = 28; i >= 0; i -= 4) {
        tmp = n >> i & 15;
        if(tmp < 10) {
            cout << tmp + '0';
        } else {
            cout << tmp - 10 + 'a';
        }
    }
}
```

**相反数**

```c++
// int  long  long long 最小值的相反数是自己
int binary_print(int n) {
    return ^n + 1;
}
```
