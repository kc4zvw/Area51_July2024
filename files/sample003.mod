
(* An example of the Shell sort *)

(* $Id: sample003.mod,v 0.22 2024/03/07 18:36:03 kc4zvw Exp kc4zvw $ *)

MODULE sample003;

IMPORT Out, RandomNumbers := ethRandomNumbers;

CONST
  MaxN = 50;

TYPE
  Item = LONGINT;
  array1 = ARRAY MaxN OF Item;

VAR
  a : array1;

(* Generate a set of random numbers ---  0 .. n-1 *)

PROCEDURE GenerateNum(n: LONGINT): LONGINT;

VAR choice: LONGINT;

BEGIN
  choice := ENTIER(n * RandomNumbers.Uniform());
  RETURN choice;
END GenerateNum;

PROCEDURE ReadNumbers;

VAR
  i : INTEGER;
  x, num, range : LONGINT;

BEGIN
  RandomNumbers.InitSeed(300);

  Out.String("Input: "); Out.Ln;
  Out.String(" adding ... ");
  range := 5000;

  FOR i := 1 TO MaxN DO
    num := GenerateNum(range);
    Out.Int(num, 5);
    a[i] := num;
  END;

  Out.Ln;
END ReadNumbers;

PROCEDURE DisplayNumbers(a : array1);

VAR
  i, width : INTEGER;
  num : LONGINT;

BEGIN
  width := -1;

  Out.Ln;
  Out.String("Output: ");
  Out.Ln;

  FOR i := 1 TO MaxN - 1 DO
    num := (a[i]);
    width := width + 1;
    IF width MOD 20 = 0 THEN Out.Ln END;
	Out.Int(num, 5);
  END;

  Out.Ln;
END DisplayNumbers;


PROCEDURE ShellSort; (* ADenS2_Sorts *)

CONST T = 4;

VAR
  i, j, k, m, s: INTEGER;
  n: INTEGER;
  x: Item;
  h: ARRAY T OF INTEGER;

BEGIN
  n := MaxN;
  Out.Ln;
  Out.String("Sorting ... ");

  h[0] := 9; h[1] := 5; h[2] := 3; h[3] := 1;
  FOR m := 0 TO T-1 DO
    k := h[m];
    FOR i := k TO n-1 DO
      x := a[i]; j := i-k;
      WHILE (j >= k) & (x < a[j]) DO
        a[j+k] := a[j]; j := j-k
      END;
      IF (j >= k) OR (x >= a[j]) THEN
        a[j+k] := x
      ELSE
        a[j+k] := a[j];
        a[j] := x
      END
    END
  END;

  Out.String("Done.");
  Out.Ln;
END ShellSort;

BEGIN
  Out.String("Sorting numbers with a Shell sort"); Out.Ln;
  Out.Ln;
  ReadNumbers();
  DisplayNumbers(a);
  ShellSort();
  DisplayNumbers(a);
  Out.Ln;
  Out.String("Finished.");
  Out.Ln;
END sample003.

(* $Log: sample003.mod,v $
 * Revision 0.22  2024/03/07 18:36:03  kc4zvw
 * Added more comments and printed output
 * *)

(* End of File *)
