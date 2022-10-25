// Online C compiler to run C program online
#include <stdio.h>
void heapify(int a[],int i,int n)
{
    int j;
    for(j=2*i+2; j < n; j = 2*i+2)
    {
        int temp,bci = j;           DI==J   BCI ==CX
        if(j+2 < n)
            if(a[j] < a[j+2])
                bci = j+2;
        if(a[i] < a[bci])
        {
            temp=a[i];
            a[i]=a[bci];
            a[bci]=temp;
        }
        else
            break;
        i=bci;
    }
}

void BuildMaxHeap(int a[],int n)
{
    int i,j;
    int nt=n+2;
    for(i=nt/2;i>=0;i-=2){
        heapify(a,i,n);
    }
       
}
void sort(int a[],int n)
{
    int temp,i;
    BuildMaxHeap(a,n);
    for(i=2;i<n;i+=2)
    {
        temp=a[0];
        a[0]=a[n-i];
        a[n-i]=temp;
        heapify(a,0,n-i);
    }   
}
int main()
{
    int n,i;
    // 100, 'k',10,'a', 20,'a', 15,'a', 17,'a', 9,'a', 21,'a'
    n=14;
    int a[14] = {1, 'k',2,'a', 20,'a', 15,'a', 17,'a', 9,'a', 21,'a'};

    sort(a,n);
    for(i=0;i<n;i+=2)
        printf("%d  ",a[i]);
}