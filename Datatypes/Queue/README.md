## Queue : a variable size ordered collection of homogenous elements
## queue is homologous to 1-D ARRAY that grows and shrinks DYNAMICALLY.
## We can ADD or REMOVE the elements from anywhere in the queue.
## '0' represents the first element ant '$' represents the last elements of queue.

## Declaration: 
## int queue1[$];      //unbounded queue
## int queue1[$:100];      //unbounded queue...101 max size

## Queue Operators:
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
## a.pop_back();         --->         a = a[0:$-1];
## a.pop_front();        --->         a = a[1:$];
## a.push_back(item);    --->         a = a[a,6];
## a.push_front(item);   --->         a = a[7,a];
## a = a[1:$-1]          --->         deleting first and last elements of a queue


## Ex:
```
module tb;
  
  int queue[$];
  int y;
  
  initial begin
    $display("before initialising values size of queue : %0d",queue.size);
    $display("before initialising values queue : %p",queue);
    
    queue = '{1,2,3,4,5};
    
    $display("after initialising values queue : %p",queue);
    $display("after initialising values size of queue : %0d",queue.size);
    
    queue.insert(1,6);
    
    $display("after inserting value at 1st index queue : %p",queue);
    
    queue.delete(5);  // giving index as argument
    
    $display("after deleting value of 5th index queue : %p",queue);
    
    queue.delete();  //deletes entire queue with no args
    
    $display("after deleting entire queue : %p",queue);
    
    $display("after deleting size of queue : %0d",queue.size);
    
    queue = '{2,4,6,8};
    
    queue.push_front(10);
    
    $display("after push_front queue : %p ",queue);
    
    y = queue.pop_front();
    
    $display("after pop_front queue : %p ",queue);
    
    $display(" Y = %0d",y);



  end
  
endmodule

//Output
before initialising values size of queue : 0
before initialising values queue : '{}
after initialising values queue : '{1, 2, 3, 4, 5} 
after initialising values size of queue : 5
after inserting value at 1st index queue : '{1, 6, 2, 3, 4, 5} 
after deleting value of 5th index queue : '{1, 6, 2, 3, 4} 
after deleting entire queue : '{}
after deleting size of queue : 0
after push_front queue : '{10, 2, 4, 6, 8}  
after pop_front queue : '{2, 4, 6, 8}  
 Y = 10

```
