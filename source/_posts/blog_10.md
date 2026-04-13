---
title: 算法中的输入输出处理
series: algorithm-study
series_order: 8
---

## 算法中的输入输出处理

```c++
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <streambuf>


int main(void) {
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);

    std::stringstream ss;
    ss << std::cin.rdbuf();

    // int n = 0;
    // ss >> n;
    // std::vector<int> arr(n);

    // for(int i = 0; i < n; i++) {
    //     ss >> arr[i];
    // }

    int n = 0;
    ss >> n;

    ss.ignore();
    std::vector<std::string> arr(n);
    for(int i = 0; i < n; i++) {
        getline(ss, arr[i]);
    }

    return 0;
}
```

```c++
vector<string> split(const string& str, char delim) {
    vector<string> res;
    stringstream ss(str);
    string temp;
    while (getline(ss, temp, delim)) {
        res.push_back(temp);
    }
    return res;
}
```
