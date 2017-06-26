unit Punkt_in_Polypon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, math, Menus, ActnList;

implementation

function Schnittpunkt(a,b,c:TPoint):boolean;
var m,n,sx:real;
begin
  m:=(a.X-b.x)/(a.Y-b.Y);
  n:=a.y-m*a.X;
  sx:=(c.Y-n)/m;
  if sx>c.X then result:=true;
end;

function inside(Ecken_des_Polyeder:array of TPoint; Pruefpunkt:TPoint):boolean;
var i, Zahl_der_Kreuzungen: integer;
begin
  if (Ecken_des_Polyeder[0].y=Pruefpunkt.Y) then
        Ecken_des_Polyeder[0].y:=Ecken_des_Polyeder[0].y+1;
  Zahl_der_Kreuzungen:=0;
  for i:=0 to high(Ecken_des_Polyeder) do
    begin
      if i+1<=high(Ecken_des_Polyeder) then f:=i+1
        else f:=0;
      if (Ecken_des_Polyeder[f].y=Pruefpunkt.Y) then
        Ecken_des_Polyeder[f].y:=Ecken_des_Polyeder[f].y+1;
      if (((Ecken_des_Polyeder[i].y>Pruefpunkt.y) and
         (Ecken_des_Polyeder[f].y<Pruefpunkt.Y)) or
         ((Ecken_des_Polyeder[i].y<Pruefpunkt.y) and
         (Ecken_des_Polyeder[f].y>Pruefpunkt.Y))) then
         begin
           if (Ecken_des_Polyeder[i].x>=x) and (Ecken_des_Polyeder[f].X>=x) then
             Zahl_der_Kreuzungen:=Zahl_der_Kreuzungen+1;
           else
             begin
               if Schnittpunkt(Ecken_des_Polyeder[i],Ecken_des_Polyeder[f],Pruefpunkt)
                 then Zahl_der_Kreuzungen:=Zahl_der_Kreuzungen+1;
             end;
         end;
    end;
  if (Zahl_der_Kreuzungen mod 2)=1 then result:=true;
end;
end.
 