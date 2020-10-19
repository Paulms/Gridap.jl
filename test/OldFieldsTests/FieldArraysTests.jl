module FieldArraysTests

using Test
using Gridap.Arrays
using Gridap.Fields
using Gridap.Fields: MockField, MockBasis
using Gridap.Fields: Valued, FieldOpMap
using FillArrays
using Gridap.TensorValues

np = 4
p = Point(1,2)
x = fill(p,np)

v = 3.0
d = 2
f = MockField{d}(v)
fx = fill(v,np)
∇fx = fill(VectorValue(v,0.0),np)

l = 10
af = Fill(f,l)
ax = fill(x,l)
afx = fill(fx,l)
a∇fx = fill(∇fx,l)
test_array_of_fields(af,ax,afx,grad=a∇fx)

ag = lazy_map_to_field_array(FieldOpMap(+),af,af)
gx = fill(v+v,np)
∇gx = fill(VectorValue(v+v,0.0),np)
agx = fill(gx,l)
a∇gx = fill(∇gx,l)
test_array_of_fields(ag,ax,agx,grad=a∇gx)

struct FieldPlaceHolder <: Field end

ag = lazy_map_to_field_array(FieldPlaceHolder,FieldOpMap(+),af,af)
test_array(evaluate_field_array(ag,ax),agx)

c = 0.5
ac = fill(c,l)
ag = lazy_map_to_field_array(FieldOpMap(*),ac,af)
gx = fill(c*v,np)
∇gx = fill(VectorValue(c*v,0.0),np)
agx = fill(gx,l)
a∇gx = fill(∇gx,l)
test_array_of_fields(ag,ax,agx,grad=a∇gx)

w = 2.0
aw = fill(w,l)
ag = lazy_map_to_field_array(FieldOpMap(+),af,aw)
gx = fill(v+w,np)
∇gx = fill(VectorValue(v,0.0),np)
agx = fill(gx,l)
a∇gx = fill(∇gx,l)
test_array_of_fields(ag,ax,agx,grad=a∇gx)

ag = lazy_map_to_field_array(FieldPlaceHolder,FieldOpMap(+),af,aw)
test_array(evaluate_field_array(ag,ax),agx)

l = 10
af = Fill(f,l)
ax = Fill(x,l)
ag = lazy_map_to_field_array(FieldOpMap(+),af,af)
r1 = evaluate(ag,ax)
@test isa(r1,Fill)

np = 4
p = Point(1,2)
x = fill(p,np)
v = 2.0
d = 2
ndof = 8
wi = 3.0
w = fill(wi,ndof)
r = fill(v+wi,np,ndof)
f = MockBasis{d}(v,ndof)
∇fx = evaluate(∇(f),x)
af = Fill(f,l)
ax = fill(x,l)
aw = fill(w,l)
ag = lazy_map_to_field_array(FieldOpMap(+),af,aw)
agx = fill(r,l)
a∇gx = fill(∇fx,l)
test_array_of_fields(ag,ax,agx,grad=a∇gx)

v = 2.0
d = 2
wi = 3.0
w = fill(wi,ndof)
r = fill(v+wi,np,ndof)
f = MockField{d}(v)
∇r = fill(VectorValue(v,0.0),np,ndof)
af = Fill(f,l)
ax = fill(x,l)
aw = fill(w,l)
ag = lazy_map_to_field_array(FieldOpMap(+),af,aw)
agx = fill(r,l)
a∇gx = fill(∇r,l)
test_array_of_fields(ag,ax,agx,grad=a∇gx)

# lazy_append

np = 4
p = Point(1,2)
x = fill(p,np)

v = 3.0
d = 2
f = MockField{d}(v)
fx = evaluate(f,x)
∇fx = evaluate(∇(f),x)

l = 10
af = Fill(f,l)
ax = fill(x,l)
afx = fill(fx,l)
a∇fx = fill(∇fx,l)

np = 5
p = Point(4,3)
x = fill(p,np)

v = 5.0
d = 2
f = MockField{d}(v)
fx = evaluate(f,x)
∇fx = evaluate(∇(f),x)

l = 15
bf = Fill(f,l)
bx = fill(x,l)
bfx = fill(fx,l)
b∇fx = fill(∇fx,l)

cf = lazy_append(af,bf)
cx = lazy_append(ax,bx)

cfx = evaluate(cf,cx)
∇cfx = evaluate(∇(cf),cx)
rfx = vcat(afx,bfx)
∇rfx = vcat(a∇fx,b∇fx)
test_array_of_fields(cf,cx,rfx,grad=∇rfx)
@test isa(cfx, AppendedArray)
@test isa(∇cfx, AppendedArray)

end # module