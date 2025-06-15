## Queue : a variable size ordered collection of homologous elements
## queue is homologous to 1-D ARRAY that grows and shrinks DYNAMICALLY.
## We can ADD or REMOVE the elements from anywhere in the queue.
## '0' represents the first element ant '$' represents the last elements of queue.

## Declaration: 
## int queue1[$];      //unbounded queue
## int queue1[$:100];      //unbounded queue...101 max size

## int queue3[a:b];      //0<a<b returns queue with b-a+1 elements
## int queue4[a:b];      //a=b=n returns queue with n elements
## int queue5[a:b];      //if a>b returns empty queue...reverse indexing not possible in queue
## int queue6[a:b];      //if a or b is 'x' or 'z' ...returns an empty queue

# Queue methods:
## int a[$] = '{1,2,3,4,5};
## a.size() : returns size of queue
## a.insert(index,element);
## a.pop_back();
## a.pop_front();
## a.push_back(item);
## a.push_front(item);

# Without using Queue methods:
## int a[$] = '{1,2,3,4,5};
## a.pop_back();    --->    a = a[0:$-1];
## a.pop_front();   --->    a = a[1:$];
## a.push_back(item);    --->    a = a[a,6];
## a.push_front(item);   --->    a = a[7,a];
## a = a[1:$-1]          ---> deleting first and last elements of a queue
