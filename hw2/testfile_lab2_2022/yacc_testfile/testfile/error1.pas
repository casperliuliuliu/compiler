program test;
var
  i: integer; //err i, j
begin
  i = 3; //err :=
  j = 4; //err :=
  if (i > j) then
    Write('ok');
end.