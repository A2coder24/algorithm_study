---
title: 位图
categories: 算法学习
tags:
  - algorithm
---

## 位图

位图的实现
Bitset是一种能以紧凑形式存储位的数据结构
Bitset(int n) : 初始化n个位，所有位都是0
void fix(int i) : 将下标i的位上的值更新为1
void unfix(int i) : 将下标i的位上的值更新为0
void flip() : 翻转所有位的值
boolean all() : 是否所有位都是1
boolean one() : 是否至少有一位是1
int count() : 返回所有位中1的数量
String toString() : 返回所有位的状态

[测试链接](https://leetcode-cn.com/problems/design-bitset/)

```c++
class Bitset {
public:
    Bitset(int size) {
        int n = (size + 31) / 32;

        this->data = vector<unsigned int>(n, 0);
        this->size = size;
    }

    void fix(int idx) {
        int i = idx / 32;
        int j = idx % 32;

        this->data[i] |= (1u << j);
    }

    void unfix(int idx) {
        int i = idx / 32;
        int j = idx % 32;

        this->data[i] &= ~(1u << j);
    }

    void flip() {
        int i = this->size / 32;
        int j = this->size % 32;

        for(int k = 0; k < i; k++) {
            this->data[k] = ~this->data[k];
        }

        if(j == 0) return;

        this->data[i] = ((~this->data[i]) << (32 - j)) >> (32 - j);
    }

    bool all() {
        return this->size == this->count();
    }

    bool one() {
        for(unsigned int& n : this->data) {
            if(n != 0) {
                return true;
            }
        }

        return false;
    }

    int count() {
        int ans = 0;

        for(unsigned int n : this->data) {
            n = (n & 0x55555555) + ((n >> 1) & 0x55555555);
            n = (n & 0x33333333) + ((n >> 2) & 0x33333333);
            n = (n & 0x0f0f0f0f) + ((n >> 4) & 0x0f0f0f0f);
            n = (n & 0x00ff00ff) + ((n >> 8) & 0x00ff00ff);
            n = (n & 0x0000ffff) + ((n >> 16) & 0x0000ffff);

            ans += n;
        }

        return ans;

    }

    string toString() {
        string str = "";
        int n = this->size / 32;
        int remain = this->size % 32;
        for(int i = 0; i < n; i++) {
            for(int j = 0; j < 32; j++) {
                str += (((this->data[i] >> j) & 1) + '0');
            }
        }

        if(remain == 0) return str;

        for(int j = 0; j < remain; j++) {
            str += (((this->data[n] >> j) & 1) + '0');
        }

        return str;
    }

private:
    vector<unsigned int> data;
    int size;
};
```
