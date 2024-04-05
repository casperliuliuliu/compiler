program errorProne;
var
  1invalidID: integer; (* Mistake: Identifiers cannot start with a digit *)
  good_id, _anotherGoodOne: string;
  faultyNumber : float = 0.123.45; (* Mistake: Invalid float number *)
begin
  good_id := 'This is a valid string';
  _anotherGoodOne := 'An ''escaped'' quote'; (* Common mistake: incorrect handling of escaped quotes *)
  faultyNumber := 1e-; (* Mistake: Incomplete scientific notation *)
  (* Unmatched comment start
  good_id := 'Missing the end of comment'; 
end.
