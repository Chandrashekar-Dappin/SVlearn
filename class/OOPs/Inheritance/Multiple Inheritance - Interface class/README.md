## Multiple Inheritance : here the child class is having multiple parent class. In such case we use interface class.
## Here we use 'implements' keyword instead of 'extends' for extending the classes.
## Interface class doesn't allow to write any properties ,it allows only methods.
## Inside interface class only pure virtual methods are allowed.

## Ex:
```
interface class A;
----------
----------
----------
endclass

interface class B;
----------
----------
----------
endclass


class C implements A,B;
-----------
-----------
-----------
endclass
```
