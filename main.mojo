from complex import ComplexFloat64
from tensor import Tensor
from math import abs
from time import now
from python import Python

alias height = 1024
alias width = 1024
alias min_x = -2.0
alias max_x = 0.47
alias min_y = -1.12
alias max_y = 1.12
alias scalex = (max_x - min_x) / width
alias scaley = (max_y - min_y) / height
alias MAX_ITERS = 256

struct Array[T: AnyType]:
    var data: Pointer[T]
    var size: Int

    fn __init__(inout self, size: Int):
        self.size = size
        self.data = Pointer[T].alloc(self.size)
              
    fn __getitem__(self, i: Int) -> T:
        return self.data.load(i)
    
    fn __setitem__(self, i: Int, value: T):
        self.data.store(i, value)

    fn __moveinit__(inout self, owned existing: Self):
      self.data = existing.data
      self.size = existing.size

    fn __del__(owned self):
        self.data.free()


fn mandelbrot_0(c: ComplexFloat64) -> Int:
    var z = c
    var nv = 0
    for i in range(1, MAX_ITERS):
      if abs(z) > 2:
        break
      z = z*z + c
      nv += 1
    return nv
   

fn mandelbrot() -> Array[Int]:
    let output = Array[Int](width*height)

    for h in range(height):
        let cy = min_y + h * scaley
        for w in range(width):
            let cx = min_x + w * scalex
            let i = mandelbrot_0(ComplexFloat64(cx,cy))
            output[width*h+w] = i
    return output^

fn main():
  for i in range(3):
      print_no_newline(i+1)
      let start_time = now()
      let x = mandelbrot()
      let end_time = now()
      let execution_time = end_time - start_time

      var s = 0;
      for h in range(height):
        for w in range(width):
          s += x[width*h+w]
      print_no_newline(" Execution Time:", execution_time/1000/1000/1000)
      print('\t\t', s);
