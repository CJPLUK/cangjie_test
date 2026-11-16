// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>& 1 | compare %f

@ObjC
foreign class M {
    public const let y: Int64
}

/* SCAN-IN
error: unexpected modifier 'const' on var or let variable
 ==> objc_mirror_const_field.cj:5:12:
  | 
5 |     public const let y: Int64
  |            ^^^^^ ~~~ 
  |            |
  |            unexpected modifier
  | 

1 error generated, 1 error printed. 
*/
