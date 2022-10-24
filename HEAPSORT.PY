def buildMaxHeap(arr, n):
 
    for i in range(0,n,2):
         
        # if child is bigger than parent
        if arr[i] > arr[int((i - 1) / 2)*2]:
            j = i
     
            # swap child and parent until
            # parent is smaller
            while arr[j] > arr[int((j - 1) / 2)*2]:
                (arr[j],
                 arr[int((j - 1) / 2)*2]) = (arr[int((j - 1) / 2)*2],
                                           arr[j])
                j = int((j - 1) / 2)*2
 
def heapSort(arr, n):
 
    buildMaxHeap(arr, n)
 
    for i in range(n - 2, 0, -2):
         
        # swap value of first indexed
        # with last indexed
        arr[0], arr[i] = arr[i], arr[0]
     
        # maintaining heap property
        # after each swapping
        j, index = 0, 0
         
        while True:
            index = 2 * j + 2
             
            # if left child is smaller than
            # right child point index variable
            # to right child
            if (index < (i - 2) and
                arr[index] < arr[index + 2]):
                index += 2
         
            # if parent is smaller than child
            # then swapping parent with child
            # having higher value
            if index < i and arr[j] < arr[index]:
                arr[j], arr[index] = arr[index], arr[j]
         
            j = index
            if index >= i:
                break
 
# Driver Code
if __name__ == '__main__':
	arr = [100, 'k',10,'a', 20,'a', 15,'a', 17,'a', 9,'a', 21,'a']
	n = len(arr)
	
	print("Given array: ")
	for i in range(0,n,2):
		print(arr[i], end = " ")
		
	print()
	heapSort(arr, n)

	# print array after sorting
	print("Sorted array: ")
	for i in range(0,n,2):
		print(arr[i], end = " ")

# This code is contributed by PranchalK
