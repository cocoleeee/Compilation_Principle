#define i item
#include <stdio.h>

int main()
{
    int i, n, f;//定义变量
    scanf("%d", &n); //接受输入
    i = 2;
    f = 1;
    while (i <= n)
    {
        f = f * i;
        i = i + 1;
    }
    printf("%d\n", f); 
    return 0;
}

