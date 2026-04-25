---
title: 常见数据结构设计
categories: 算法学习
tags:
  - algorithm
---

## 常见数据结构设计

setAll功能的哈希表
[测试链接](https://www.nowcoder.com/practice/7c4559f138e74ceb9ba57d76fd169967)

```c++
#include <iostream>
#include <sstream>
#include <string>
#include <streambuf>
#include <vector>
#include <unordered_map>
using namespace std;

int timestamp = 0;
int setVal = 0;
int setTime = 0;

int main() {
    stringstream ss;
    ss << cin.rdbuf();

    int n;
    ss >> n;

    unordered_map<int, vector<int>> dict;

    int op = 0, k = 0, v = 0;
    for(int i = 0; i < n; i++) {
        ss >> op;
        if(op == 1) {
            ss >> k >> v;
            dict[k] = {v, timestamp++};
        }

        if(op == 2) {
            ss >> k;
            auto it = dict.find(k);
            if(it == dict.end()) {
                cout << -1 << endl;
                continue;
            }

            int time = it->second.back();
            cout << (time < setTime ? setVal : it->second.front()) << endl;
        }

        if(op == 3) {
            ss >> k;
            setVal = k;
            setTime = timestamp++;
        }
    }
}
```

实现LRU结构
[测试链接](https://leetcode.cn/problems/lru-cache/)

```c++
class LRUCache {
public:
    LRUCache(int capacity) {
        this->capacity = capacity;
    }

    int get(int key) {
        if(dict.find(key) == dict.end()) {
            return -1;
        }

        pair<int, int> ans = *(dict[key]);
        doubleList.erase(dict[key]);
        doubleList.push_back(ans);
        dict[key] = --doubleList.end();

        return ans.second;
    }

    void put(int key, int value) {
        if(dict.find(key) != dict.end()) {
            get(key);
            doubleList.rbegin()->second = value;
            return;
        }

        if(dict.size() < this->capacity) {
            doubleList.push_back({key, value});
            dict[key] = --doubleList.end();
            return;
        }

        dict.erase(doubleList.begin()->first);
        doubleList.pop_front();
        doubleList.push_back({key, value});
        dict[key] = --doubleList.end();
    }
private:
    int capacity;
    unordered_map<int, list<pair<int, int>>::iterator> dict;
    list<pair<int, int>> doubleList;
};
```

插入、删除和获取随机元素O(1)时间的结构
[测试链接](https://leetcode.cn/problems/insert-delete-getrandom-o1/)

```c++
class RandomizedSet {
public:
    RandomizedSet() {
        e = mt19937(rd());
    }

    bool insert(int val) {
        if (dict.find(val) != dict.end()) {
            return false;
        }

        arr.push_back(val);
        dict[val] = arr.size() - 1;

        return true;
    }

    bool remove(int val) {
        if(dict.find(val) == dict.end()) {
            return false;
        }

        if(val == arr.back()) {
            arr.pop_back();
            dict.erase(val);
            return true;
        }

        int idx = dict[val];
        swap(arr[idx], arr.back());
        arr.pop_back();
        dict.erase(val);
        dict[arr[idx]] = idx;

        return true;
    }

    int getRandom() {
        uniform_int_distribution<int> index(0, arr.size() - 1);

        return arr[index(e)];
    }

private:
    unordered_map<int, int> dict;
    vector<int> arr;

    random_device rd;
    mt19937 e;
};
```

插入、删除和获取随机元素O(1)时间且允许有重复数字的结构
[测试链接](https://leetcode.cn/problems/insert-delete-getrandom-o1-duplicates-allowed/)

```c++
class RandomizedCollection {
public:
    RandomizedCollection() { e = mt19937(rd()); }

    bool insert(int val) {
        bool ans = true;
        if (dict.find(val) != dict.end()) {
            ans = false;
        }

        arr.push_back(val);
        dict[val].insert(arr.size() - 1);

        return ans;
    }

    bool remove(int val) {
        if (dict.find(val) == dict.end()) {
            return false;
        }

        if(val == arr.back()) {
            dict[val].erase(arr.size() - 1);
            arr.pop_back();
            if(dict[val].empty()) {
                dict.erase(val);
            }

            return true;
        }

        int valIdx = *dict[val].begin();
        int endIdx = arr.size() - 1;

        arr[valIdx] = arr[endIdx];
        arr.pop_back();

        dict[arr[valIdx]].erase(endIdx);
        dict[arr[valIdx]].insert(valIdx);

        dict[val].erase(valIdx);
        if(dict[val].empty()) {
            dict.erase(val);
        }

        return true;
    }

    int getRandom() {
        uniform_int_distribution<int> index(0, arr.size() - 1);

        return arr[index(e)];
    }

private:
    unordered_map<int, unordered_set<int>> dict;
    vector<int> arr;

    random_device rd;
    mt19937 e;
};
```

快速获得数据流的中位数的结构
[测试链接](https://leetcode.cn/problems/find-median-from-data-stream/)

```c++
class MedianFinder {
public:
    MedianFinder() {}

    void addNum(int num) {
        if (max_heap.empty() || num < max_heap.top()) {
            max_heap.push(num);
        } else {
            min_heap.push(num);
        }

        balance();
    }

    void balance() {
        while(max_heap.size() > (min_heap.size() + 1)) {
            min_heap.push(max_heap.top());
            max_heap.pop();
        }

        while(max_heap.size() < min_heap.size()) {
            max_heap.push(min_heap.top());
            min_heap.pop();
        }
    }

    double findMedian() {
        return (max_heap.size() + min_heap.size()) % 2
                   ? max_heap.top()
                   : (double)(max_heap.top() + min_heap.top()) / 2;
    }

private:
    priority_queue<int, vector<int>, less<int>> max_heap;
    priority_queue<int, vector<int>, greater<int>> min_heap;
};

```

最大频率栈
[测试链接](https://leetcode.cn/problems/maximum-frequency-stack/)

```c++
class FreqStack {
public:
    FreqStack() {}

    void push(int val) {
        valTimes[val]++;
        cntTimes[valTimes[val]].push_back(val);
        topTimes = max(valTimes[val], topTimes);
    }

    int pop() {
        int ans = 0;
        ans = cntTimes[topTimes].back();
        valTimes[ans]--;
        if (cntTimes[topTimes].size() == 1) {
            cntTimes.erase(topTimes--);
        } else {
            cntTimes[topTimes].pop_back();
        }

        return ans;
    }

private:
    int topTimes;
    unordered_map<int, list<int>> cntTimes;
    unordered_map<int, int> valTimes;
};
```

全O(1)的数据结构
[测试链接](https://leetcode.cn/problems/all-oone-data-structure/)

```c++
class AllOne {
public:
    class Bucket {
    public:
        unordered_set<string> string_set;
        int cnt;
        Bucket* next;
        Bucket* last;

        Bucket(string s, int n) {
            string_set.insert(s);
            cnt = n;
        }
    };
    AllOne() {
        head = new Bucket("", 0);
        tail = new Bucket("", INT_MAX);
        head->next = tail;
        head->last = nullptr;
        tail->last = head;
        tail->next = nullptr;
    }

    void inc(string key) {
        if (dict.find(key) == dict.end()) {
            if (head->next->cnt == 1) {
                dict[key] = head->next;
                head->next->string_set.insert(key);
            } else {
                Bucket* bucket = new Bucket(key, 1);
                dict[key] = bucket;
                insert(head, bucket);
            }
        } else {
            Bucket* bucket = dict[key];
            if (bucket->cnt + 1 == bucket->next->cnt) {
                bucket->next->string_set.insert(key);
                dict[key] = bucket->next;
            } else {
                Bucket* newBucket = new Bucket(key, bucket->cnt + 1);
                newBucket->string_set.insert(key);
                dict[key] = newBucket;
                insert(bucket, newBucket);
            }

            bucket->string_set.erase(key);
            if (bucket->string_set.empty()) {
                remove(bucket);
            }
        }
    }

    void dec(string key) {
        if (dict.find(key) == dict.end()) {
            return;
        }
        Bucket* bucket = dict[key];
        if (bucket->cnt == 1) {
            bucket->string_set.erase(key);
            dict.erase(key);
            if (bucket->string_set.empty()) {
                remove(bucket);
            }
            return;
        }

        if (bucket->cnt == bucket->last->cnt + 1) {
            bucket->last->string_set.insert(key);
            dict[key] = bucket->last;
        } else {
            Bucket* newBucket = new Bucket(key, bucket->cnt - 1);
            dict[key] = newBucket;
            insert(bucket->last, newBucket);
        }

        bucket->string_set.erase(key);
        if (bucket->string_set.empty()) {
            remove(bucket);
        }
    }

    string getMaxKey() { return *(tail->last->string_set.begin()); }

    string getMinKey() { return *(head->next->string_set.begin()); }

    void insert(Bucket* cur, Bucket* pos) {
        cur->next->last = pos;
        pos->next = cur->next;
        cur->next = pos;
        pos->last = cur;
    }

    void remove(Bucket* cur) {
        cur->last->next = cur->next;
        cur->next->last = cur->last;

        delete cur;
    }

private:
    Bucket* head;
    Bucket* tail;

    unordered_map<string, Bucket*> dict;
};
```
