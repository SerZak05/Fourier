class Complex {
  float a, b;
  Complex(float a, float b) {
    this.a = a;
    this.b = b;
  }
  Complex() {
    a = 0;
    b = 0;
  }
  Complex(Complex z) {
    a = z.a;
    b = z.b;
  }
  
  Complex add(Complex z) {
    a += z.a;
    b += z.b;
    return this;
  }
  
  Complex sub(Complex z) {
    a -= z.a;
    b -= z.b;
    return this;
  }
  
  Complex mult(float k) {
    a *= k;
    b *= k;
    return this;
  }
  
  Complex div(float k) {
    a /= k;
    b /= k;
    return this;
  }
  
  float norm() {
    return a*a + b*b;
  }
  float mod() {
    return sqrt(norm());
  }
  Complex neg() {
    return new Complex(-a, -b);
  }
  
  void print() {
    println(toString());
  }
  
  String toString() {
    return a + "+" + b + "i";
  }
}

Complex add(Complex p, Complex q) {
  return new Complex(p.a + q.a, p.b + q.b);
}

Complex sub(Complex p, Complex q) {
  return add(p, q.neg());
}

Complex mult(Complex p, Complex q) {
  return new Complex(p.a*q.a - p.b*q.b, p.a*q.b + p.b*q.a);
}

Complex epowi(float a) {
  return new Complex(cos(a), sin(a));
}
