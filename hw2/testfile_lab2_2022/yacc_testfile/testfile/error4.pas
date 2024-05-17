program test;
var
  i, j : integer;
  c : string;
begin
  i := 5;
  c := 'aa';
  i = i+c; //err integer + string
end.