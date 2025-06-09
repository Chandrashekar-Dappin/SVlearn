# Abstraction : It can be implemented by writing a 'virtual' keyword before the class.
## Ex:
```
virtual class ABC;
  --------
  --------  prop.
  --------

  --------
  -------- methods
endclass

module tb;
 ABC x;

initial begin
  x  = new();  // ERROR
```

**1. object for virtual class cannot be created**

**2. Abstract class is used for prototyping**

**3. Abstract class can be extended and creation of child class is allowed**

**4. inside abstract class we can write i) normal methods ii) virtual methods iii) pure virtual methods**


![WhatsApp Image 2025-06-09 at 22 20 04_a328fc8a](https://github.com/user-attachments/assets/e9a57ff9-d2c2-47af-a9c9-e5984ebd32be)

