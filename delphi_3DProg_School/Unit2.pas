unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, unit1, ExtCtrls;

type
  TForm2 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ComboBox1: TComboBox;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Edit3: TEdit;
    Edit2: TEdit;
    Edit1: TEdit;
    Button1: TButton;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit7: TEdit;
    Label7: TLabel;
    GroupBox4: TGroupBox;
    Label8: TLabel;
    Edit8: TEdit;
    Label9: TLabel;
    Edit9: TEdit;
    Label10: TLabel;
    Edit10: TEdit;
    GroupBox5: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    Edit12: TEdit;
    Edit11: TEdit;
    ColorDialog1: TColorDialog;
    ColorDialog2: TColorDialog;
    ColorDialog3: TColorDialog;
    ColorDialog4: TColorDialog;
    ColorDialog5: TColorDialog;
    ColorDialog6: TColorDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Label13: TLabel;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Label14: TLabel;
    RichEdit1: TRichEdit;
    PaintBox1: TPaintBox;
    ComboBox2: TComboBox;
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure Edit13Change(Sender: TObject);
    procedure Edit14Change(Sender: TObject);
    procedure Edit15Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

procedure pyramidenfarbenanzeigen;

var
  Form2: TForm2;
  e1,e2,e3,gp3:integer;
  ausfuehrbar:boolean;

implementation

uses Unit4;

var Hoch:integer;

{$R *.dfm}

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
  Form2.Height:=Hoch;
  if combobox1.ItemIndex=0 then
    begin
      groupbox2.Caption:='Seitenlaenge';
      label2.Caption:='Breite:'; label3.Caption:='Höhe:'; label1.Caption:='Tiefe:';
      label4.Caption:='x:'; label5.Caption:='y:'; label6.Caption:='z:';
      groupbox1.Caption:='Koordinaten des linken unteren Eckpunkts';
      edit1.left:=e1-20; edit2.left:=e2-20; edit3.left:=e3-20;
      panel1.Visible:=true; panel2.Visible:=true; panel3.Visible:=true;
      panel4.Visible:=true; panel5.Visible:=true; panel6.Visible:=true;
      label13.Visible:=false;
      edit15.Visible:=false;  edit13.Visible:=false; edit14.Visible:=false;
      richedit1.visible:=false;
      groupbox3.Width:=gp3-30;
      paintbox1.Visible:=false; combobox2.Visible:=false;
    end;
  if combobox1.Itemindex=1 then
    begin
      groupbox2.Caption:='allgemeine Beschreibung der Pyramide';
      label2.Caption:='Anzahl der Ecken der Grundfläche:'; label3.Caption:='Höhe:'; label1.Caption:='Seitenlänge von Grundfläche:';
      label4.Caption:='x:'; label5.Caption:='y:'; label6.Caption:='z:';
      groupbox1.Caption:='Koordinaten des Fußpunkts';
      edit1.left:=e1+20; edit2.left:=e2+20; edit3.left:=e3+20;
      panel1.Visible:=false; panel2.Visible:=false; panel3.Visible:=false;
      panel4.Visible:=false; panel5.Visible:=false;
      label13.Visible:=true;
      edit15.Visible:=true;  edit13.Visible:=true; edit14.Visible:=true;
      richedit1.Visible:=true;
      groupbox3.Width:=gp3+30;
      paintbox1.left:=richedit1.Width+richedit1.left+5; paintbox1.Top:=5;
      paintbox1.Height:=groupbox3.Height-7; paintbox1.Width:=63;
      paintbox1.Visible:=true; combobox2.Visible:=true;
      pyramidenfarbenanzeigen;
    end;
end;

procedure TForm2.Button1Click(Sender: TObject);
const
  strUmbruch = #13 + #10;
var b: array of unit1.Rpunktspezifisches;
    i:integer;
begin
  if button1.Caption='Punkte berechnen' then begin
  button1.Caption:='Einklappen';
  if combobox1.ItemIndex=0 then
    begin
      setlength(b,9);
      unit1.quader.Laenge_Nullsetzen;
      unit1.quader.init(strtoint(unit2.Form2.Edit1.text),strtoint(unit2.Form2.Edit2.text),strtoint(unit2.Form2.Edit3.text),strtoint(unit2.Form2.Edit4.text),strtoint(unit2.Form2.Edit5.text),strtoint(unit2.Form2.Edit6.text));
      unit1.quader.Punkteausgeben(b);
      form2.height:=hoch+57;
      memo1.Text:='';
      for i:=1 to 8 do memo1.Text:=memo1.Text+inttostr(round(b[i].x))+^I; memo1.Text:=memo1.Text+strUmbruch;
      for i:=1 to 8 do memo1.Text:=memo1.Text+inttostr(round(b[i].y))+^I; memo1.Text:=memo1.Text+strUmbruch;
      for i:=1 to 8 do memo1.Text:=memo1.Text+inttostr(round(b[i].z))+^I; memo1.Text:=memo1.Text+strUmbruch;
    end;
  if combobox1.ItemIndex=1 then
  begin
  setlength(b,strtoint(edit1.text)+2);
  unit1.pyramide.Laenge_Nullsetzen;
  unit1.pyramide.init(strtoint(unit2.Form2.Edit1.text),strtoint(unit2.Form2.Edit2.text),strtoint(unit2.Form2.Edit3.text),strtoint(unit2.Form2.Edit4.text),strtoint(unit2.Form2.Edit5.text),strtoint(unit2.Form2.Edit6.text));
  unit1.Pyramide.Punkteausgeben(b);
  form2.Height:=hoch+(((high(b))div 24)+1)*57;
  memo1.Text:='';
  for i:=1 to high(b) do
    begin
      if i<=24 then begin memo1.Text:=memo1.Text+inttostr(round(b[i].x))+^I;
      if i=high(b) then memo1.Text:=memo1.Text+strUmbruch; end;
    end;
  for i:=1 to high(b) do
    begin
      if i<=24 then begin memo1.Text:=memo1.Text+inttostr(round(b[i].y))+^I;
      if i=high(b) then memo1.Text:=memo1.Text+strUmbruch; end;
    end;
  for i:=1 to high(b) do
    begin
      if i<= 24 then begin memo1.Text:=memo1.Text+inttostr(round(b[i].z))+^I;
      if i=high(b) then memo1.Text:=memo1.Text+strUmbruch; end;
    end;
  end;
  if high(b)>24 then begin
    memo2.text:='';
    for i:=25 to high(b) do
      begin
        if i<=48 then begin memo2.Text:=memo2.Text+inttostr(round(b[i].x))+^I;
        if i=high(b) then memo2.Text:=memo2.Text+strUmbruch; end;
      end;
    for i:=25 to high(b) do
      begin
        if i<=48 then begin memo2.Text:=memo2.Text+inttostr(round(b[i].y))+^I;
        if i=high(b) then memo2.Text:=memo2.Text+strUmbruch; end;
      end;
    for i:=25 to high(b) do
      begin
        if i<= 48 then begin memo2.Text:=memo2.Text+inttostr(round(b[i].z))+^I;
        if i=high(b) then memo2.Text:=memo2.Text+strUmbruch; end;
      end;
    end;
  if high(b)>48 then begin
    memo3.text:='';
    for i:=49 to high(b) do
      begin
        if i<=72 then begin memo3.Text:=memo3.Text+inttostr(round(b[i].x))+^I;
        if i=high(b) then memo3.Text:=memo3.Text+strUmbruch; end;
      end;
    for i:=49 to high(b) do
      begin
        if i<=72 then begin memo3.Text:=memo3.Text+inttostr(round(b[i].y))+^I;
        if i=high(b) then memo3.Text:=memo3.Text+strUmbruch; end;
      end;
    for i:=49 to high(b) do
      begin
        if i<= 72 then begin memo3.Text:=memo3.Text+inttostr(round(b[i].z))+^I;
        if i=high(b) then memo3.Text:=memo3.Text+strUmbruch; end;
      end;
    end;
  if high(b)>72 then begin
    memo4.text:='';
    for i:=73 to high(b) do
      begin
        if i<=96 then begin memo4.Text:=memo4.Text+inttostr(round(b[i].x))+^I;
        if i=high(b) then memo4.Text:=memo4.Text+strUmbruch; end;
      end;
    for i:=73 to high(b) do
      begin
        if i<=96 then begin memo4.Text:=memo4.Text+inttostr(round(b[i].y))+^I;
        if i=high(b) then memo4.Text:=memo4.Text+strUmbruch; end;
      end;
    for i:=73 to high(b) do
      begin
        if i<=96 then begin memo4.Text:=memo4.Text+inttostr(round(b[i].z))+^I;
        if i=high(b) then memo4.Text:=memo4.Text+strUmbruch; end;
      end;
    end;
  if high(b)>96 then begin
    memo5.text:='';
    for i:=97 to high(b) do
      begin
        if i<=120 then begin memo5.Text:=memo5.Text+inttostr(round(b[i].x))+^I;
        if i=high(b) then memo5.Text:=memo5.Text+strUmbruch; end;
      end;
    for i:=97 to high(b) do
      begin
        if i<=120 then begin memo5.Text:=memo5.Text+inttostr(round(b[i].y))+^I;
        if i=high(b) then memo5.Text:=memo5.Text+strUmbruch; end;
      end;
    for i:=97 to high(b) do
      begin
        if i<=120 then begin memo5.Text:=memo5.Text+inttostr(round(b[i].z))+^I;
        if i=high(b) then memo5.Text:=memo5.Text+strUmbruch; end;
      end;
    end;
  end
  else if button1.Caption='Einklappen' then begin
    button1.Caption:='Punkte berechnen';
    form2.height:=Hoch;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  hoch:=form2.height;
  colordialog1.Color:=RGB(100,30,100); colordialog2.Color:=RGB(100,60,100); colordialog3.Color:=RGB(100,90,100);
  colordialog4.Color:=RGB(100,120,100); colordialog5.Color:=RGB(100,150,100); colordialog6.Color:=RGB(100,180,100);
  panel1.Color:=colordialog1.Color; panel2.Color:=colordialog2.Color; panel3.Color:=colordialog3.Color;
  panel4.Color:=colordialog4.Color; panel5.Color:=colordialog5.Color; panel6.Color:=colordialog6.Color;
  e1:=edit1.left; e2:=edit2.left; e3:=edit3.left; gp3:=groupbox3.width;
end;

procedure TForm2.Panel1Click(Sender: TObject);
begin
  colordialog1.Execute;
  panel1.color:=colordialog1.Color;
end;

procedure TForm2.Panel2Click(Sender: TObject);
begin
  colordialog2.Execute;
  panel2.color:=colordialog2.Color;
end;

procedure TForm2.Panel3Click(Sender: TObject);
begin
  colordialog3.Execute;
  panel3.color:=colordialog3.Color;
end;

procedure TForm2.Panel4Click(Sender: TObject);
begin
  colordialog4.Execute;
  panel4.color:=colordialog4.Color;
end;

procedure TForm2.Panel5Click(Sender: TObject);
begin
  colordialog5.Execute;
  panel5.color:=colordialog5.Color;
end;

procedure TForm2.Panel6Click(Sender: TObject);
begin
  colordialog6.Execute;
  panel6.color:=colordialog6.Color;
end;

procedure pyramidenfarbenanzeigen;
var Varia: array[1..3] of boolean;
    Konst: array[1..3] of boolean;
    i,r,g,b,j:integer;
begin
  ausfuehrbar:=false;
  with form2 do begin
  paintbox1.Refresh;
  for i:=1 to 3 do begin varia[i]:=false; konst[i]:=false; end;
  if edit13.Text='v' then Varia[1]:=true
  else
    try
      strtoint(edit13.Text);
      Konst[1]:=true;
    except
    end;
  if edit14.Text='v' then Varia[2]:=true
  else
    try
      strtoint(edit14.Text);
      Konst[2]:=true;
    except
    end;
  if edit15.Text='v' then Varia[3]:=true
  else
    try
      strtoint(edit15.Text);
      Konst[3]:=true;
    except
    end;
  if combobox2.ItemIndex=0 then
    begin
     try
        for i:=1 to strtoint(edit1.text) do
          begin
            if varia[1]=true then r:=trunc(i/strtoint(edit1.text)*255);
            if konst[1]=true then r:=strtoint(edit13.Text);
            if varia[2]=true then g:=trunc(i/strtoint(edit1.text)*255);
            if konst[2]=true then g:=strtoint(edit14.Text);
            if varia[3]=true then b:=trunc(i/strtoint(edit1.text)*255);
            if konst[3]=true then b:=strtoint(edit15.Text);
            paintbox1.Canvas.Brush.color:=RGB(r,g,b);
            if ((varia[1]=true)or(konst[1]=true))and((varia[2]=true)or(konst[2]=true))and((varia[3]=true)or(konst[3]=true)) then
              begin
                paintbox1.Canvas.FillRect(rect(0,trunc((i-1)/strtoint(edit1.text)*paintbox1.height),paintbox1.Width,trunc((i)/strtoint(edit1.text)*paintbox1.height)));
                ausfuehrbar:=true;
              end;
          end;
      except
      end;
    end;
    if combobox2.ItemIndex=1 then
    begin
     try
        for i:=1 to strtoint(edit1.text) do
          begin
            j:=i*2;
            if j>strtoint(edit1.text) then j:=strtoint(edit1.text)*2-j;
            if varia[1]=true then r:=trunc(j/strtoint(edit1.text)*255);
            if konst[1]=true then r:=strtoint(edit13.Text);
            if varia[2]=true then g:=trunc(j/strtoint(edit1.text)*255);
            if konst[2]=true then g:=strtoint(edit14.Text);
            if varia[3]=true then b:=trunc(j/strtoint(edit1.text)*255);
            if konst[3]=true then b:=strtoint(edit15.Text);
            paintbox1.Canvas.Brush.color:=RGB(r,g,b);
            if ((varia[1]=true)or(konst[1]=true))and((varia[2]=true)or(konst[2]=true))and((varia[3]=true)or(konst[3]=true)) then
              begin
                paintbox1.Canvas.FillRect(rect(0,trunc((i-1)/strtoint(edit1.text)*paintbox1.height),paintbox1.Width,trunc((i)/strtoint(edit1.text)*paintbox1.height)));
                ausfuehrbar:=true;
              end;
          end;
      except
      end;
    end;
  end;
end;

procedure TForm2.Edit13Change(Sender: TObject);
begin
  pyramidenfarbenanzeigen;
end;

procedure TForm2.Edit14Change(Sender: TObject);
begin
  pyramidenfarbenanzeigen;
end;

procedure TForm2.Edit15Change(Sender: TObject);
begin
  pyramidenfarbenanzeigen;
end;

procedure TForm2.ComboBox2Change(Sender: TObject);
begin
  pyramidenfarbenanzeigen;
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  if combobox1.ItemIndex=1 then pyramidenfarbenanzeigen;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    if combobox1.ItemIndex=0 then ausfuehrbar:=false;
    strtoint(edit1.text); strtoint(edit2.text); strtoint(edit3.text); strtoint(edit4.text); strtoint(edit5.text); strtoint(edit6.text);
    if combobox1.ItemIndex=0 then ausfuehrbar:=true;
  except ausfuehrbar:=false;
  end;
  if ausfuehrbar=false then
    begin
      Form4.show;
    end;
end;

procedure TForm2.FormPaint(Sender: TObject);
begin
  if combobox1.ItemIndex=1 then pyramidenfarbenanzeigen;
end;

procedure TForm2.PageControl1Change(Sender: TObject);
begin
  Form2.Height:=Hoch;
end;

end.
