with Calculator; use Calculator;
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;

package MathArray with SPARK_Mode => On is

   type vec is array(Natural range <>) of Integer;
   type vecFloat is array(Natural range <>) of Float;
   
   function midpoint (point1 : vec; point2 : vec) return vec with
     Global => null,
     Depends => (midpoint'Result => (point1, point2)),
     Pre => (point1'First = point2'First) and then (point1'Last = point2'Last) and then (point1'Length=3 or point1'Length=2)
     and then (for all i in point1'Range => 
              (if point1(i) > 0 and point2(i) > 0 then
                   point1(i)  <= Integer'Last - point2(i))                
            and (if point1(i) < 0 and point2(i) < 0 then                   
                   point1(i) >= Integer'First - point2(i))),
     Post=>midpoint'Result'Length=point1'Length and then (midpoint'Result'Length=3 or midpoint'Result'Length=2) and then 
     (for all i in midpoint'Result'Range =>
     midpoint'Result(i)=Add(point1(i),point2(i))/2);
   --Return vector midpoint of both parameters. (Parameters must have length = 2 or length = 3 and must cover same range).
   
--     procedure module (vec1 : vecFloat; res : out Float) with 
--       Global => null,
--       Depends => (res => vec1),
--       Pre=>(vec1'length=3 or vec1'Length=2) and then (for all i in vec1'Range =>
--                                                         (vec1(i)/Float'Last)*vec1(i) <= 1.0) and then 
--                                                      (if vec1'Length = 2 then
--                                                         ((vec1(vec1'First)*vec1(vec1'First))/2.0)+((vec1(vec1'Last)*vec1(vec1'Last))/2.0)<=Float'Last/2.0
--                                                       else
--                                                         Float'Last >= vec1(vec1'First)*vec1(vec1'First) + vec1(vec1'First+1)*vec1(vec1'First+1) + vec1(vec1'Last)*vec1(vec1'Last)),
--       Post=>(if vec1'Length = 2 then                                          
--                  res=Ada.Numerics.Elementary_Functions.Sqrt(vec1(vec1'First)*vec1(vec1'First) + vec1(vec1'Last)*vec1(vec1'Last))
--              else
--                  res=Ada.Numerics.Elementary_Functions.Sqrt(vec1(vec1'First)*vec1(vec1'First) + vec1(vec1'First+1)*vec1(vec1'First+1) + vec1(vec1'Last)*vec1(vec1'Last)));
   --Return res, which is the module of a vector with length = 2 or length = 3.
   
   function derivative (vec1 : vec) return vec with
     Global => null,
     Depends => (derivative'Result => (vec1)),
     Pre => (vec1'Length = 1 or vec1'Length = 2 or vec1'Length = 3) and then 
            (for all i in vec1'Range =>
             Float((vec1(i)/Integer'Last))*Float((vec1'Length-(i-vec1'First+1))) <= 1.0),
     Post =>(derivative'Result'Length = vec1'Length and (for all i in derivative'Result'Range =>
             derivative'Result(i) = vec1(i)*(vec1'Length-(i-vec1'First+1))));
   --Return a derivative polynomial vec. (Vector must have length = 1, 2 or 3).
--     
--     function derivative_x (vec1 : vec; point : Integer) return Integer with
--       Global => null,
--       Depends => (derivative_x'Result => (vec1, point)),
--       Pre => (vec1'Length = 1 or vec1'Length = 2 or vec1'Length = 3) and then 
--              (for all i in derivative(vec1)'Range =>
--              point*(derivative(vec1)(i)**(vec1'Length-(i-vec1'First+2))) <= Integer'Last),
--       Post => vec1 = derivative(vec1) and then (if vec1'Length = 1 then
--                                                   derivative_x'Result = 0
--                                                 elsif vec1'Length = 2 then
--                                                   derivative_x'Result = derivative(vec1)(derivative(vec1)'Last-1));
                                                     
    --Return the derivative of a function in point (polynomial vec with length = 1, 2 or 3).

   procedure get(a:in out vec; x:Integer; bool:out Boolean) with
     Global => null,
     Depends => (a => (a,x) , bool => (a,x)),
     Pre => x /= 0 and then a'Length > 0 and then a'Last<Integer'Last,
     Post => (a /= a'Old) or (a = a'Old);
   --Search for x in the array and replace it with zero (x can't be zero).
   --In bool it is stored true if the operation was successful, if not false.
   
   function perpendicular_vec (vec1 : vec; vec2 : vec) return Boolean  with
     Global  => null,
     Depends => (perpendicular_vec'Result => (vec1, vec2)),
     Pre => vec1'Length=2 and then vec2'Length = vec1'Length and then
     (for all x in  vec1'Range => vec1(x) < 46340 and then vec1(x) > -46340)
     and then (for all x in vec2'Range =>  vec2(x) < 46340 and then vec2(x) > -46340)
       and then ((if  (vec1(vec1'First)*vec2(vec2'First)) > 0 and (vec1(vec1'Last)*vec2(vec2'Last)) > 0 then
                    (vec1(vec1'First)*vec2(vec2'First))  <= Integer'Last - (vec1(vec1'Last)*vec2(vec2'Last)))                
            and (if  (vec1(vec1'First)*vec2(vec2'First)) < 0 and (vec1(vec1'Last)*vec2(vec2'Last)) < 0 then                   
                    (vec1(vec1'First)*vec2(vec2'First)) >= Integer'First - (vec1(vec1'Last)*vec2(vec2'Last)))),
     Post => (if perpendicular_vec'Result 
                then 
                (vec1(vec1'First)*vec2(vec2'First))+(vec1(vec1'Last)*vec2(vec2'Last)) = 0
                else 
                (vec1(vec1'First)*vec2(vec2'First))+(vec1(vec1'Last)*vec2(vec2'Last)) /= 0);  
   --Return true if vectors with length = 2 are perpendicular between them.
end MathArray;
