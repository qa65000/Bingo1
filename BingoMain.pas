unit BingoMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Objects,
  Seg7ShapeFmx, FMX.Grid, FMX.Layouts;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    Button1: TButton;
    Seg7Shape1: TSeg7Shape;
    Seg7Shape2: TSeg7Shape;
    Button2: TButton;
    StringGrid1: TStringGrid;
    StyleBook2: TStyleBook;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private êÈåæ }
    procedure RollSegment(Sender: TObject ; Data : Byte );
    procedure RollSegmentSet( Count : Byte);
    function  ShuffleGet(): Byte;
    procedure ShuffleInitial();
  public
    { public êÈåæ }
  end;

var
  MainForm: TMainForm;
  ShuffleMarkCount   : Byte;
  ShuffleRemainCount : Byte;
  ShufflePoint : Byte;
  ShuffleData : array [0..99] of Byte;    //Å@èâä˙éûÇ…íËêîÇ∆ÇµÇƒÇ∑Ç◊ÇƒåàíËÇµÇƒÇµÇ‹Ç§ÅB

implementation

{$R *.fmx}


function TMainForm.ShuffleGet(): Byte;
begin
    result := ShuffleData[ShuffleRemainCount];
    Dec(ShuffleRemainCount)
end;

procedure TMainForm.ShuffleInitial();
var
    idx: Byte;
begin
    Randomize();
    fillChar(ShuffleData, sizeof(ShuffleData), $FF);
    ShuffleRemainCount := 0;
    repeat
        idx := Random(100);
        if (ShuffleData[idx] = $FF) then
        begin
            ShuffleData[idx] := ShuffleRemainCount;
            inc(ShuffleRemainCount);
        end;
    until (ShuffleRemainCount >= 100);
    Dec(ShuffleRemainCount)

end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
    if (ShuffleRemainCount = $FF) then
                                         ShuffleInitial();
    Timer1.Enabled := TRUE;
    Button1.Enabled := False;
    ShuffleMarkCount := 17;
    Seg7Shape1.Num := $FF;
    Seg7Shape2.Num := $FF;
    Seg7Shape1.Fill.Color := Seg7Shape1.Fill.Color + Random(Integer($FFFFFFFF));
    Seg7Shape2.Fill.Color := Seg7Shape1.Fill.Color + Random(Integer($FFFFFFFF));
    RollSegmentSet(ShuffleMarkCount);
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
    I : Byte;
begin
    ShuffleInitial();
    for I := 0 to 99 do
    StringGrid1.Cells[1,i] := '';
    Button1.Enabled := TRUE;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
    I : Byte;
begin
    ShuffleRemainCount := $ff;
    StringGrid1.Columns[0].Header := 'âÒêî';
    StringGrid1.Columns[1].Header := 'íl';

    StringGrid1.AddObject(TStringColumn.Create(StringGrid1));
    ShufflePoint :=0;
    for I := 0 to 99 do
           StringGrid1.Cells[0,i] := IntToStr(i);
end;

procedure TMainForm.RollSegment(Sender: TObject ; Data : Byte );
begin
    if(Data And $01) <> 0 then (Sender As TSeg7Shape).SEG_A := TRUE  else (Sender As TSeg7Shape).SEG_A := FALSE;
    if(Data And $02) <> 0 then (Sender As TSeg7Shape).SEG_B := TRUE  else (Sender As TSeg7Shape).SEG_B := FALSE;
    if(Data And $04) <> 0 then (Sender As TSeg7Shape).SEG_C := TRUE  else (Sender As TSeg7Shape).SEG_C := FALSE;
    if(Data And $08) <> 0 then (Sender As TSeg7Shape).SEG_D := TRUE  else (Sender As TSeg7Shape).SEG_D := FALSE;
    if(Data And $10) <> 0 then (Sender As TSeg7Shape).SEG_E := TRUE  else (Sender As TSeg7Shape).SEG_E := FALSE;
    if(Data And $20) <> 0 then (Sender As TSeg7Shape).SEG_F := TRUE  else (Sender As TSeg7Shape).SEG_F := FALSE;
    if(Data And $40) <> 0 then (Sender As TSeg7Shape).SEG_G := TRUE  else (Sender As TSeg7Shape).SEG_G := FALSE;
end;

procedure TMainForm.RollSegmentSet( Count : Byte);
BEGIN
        case Count of
           17,9,1 : begin  RollSegment(Seg7Shape1 , $01 );  RollSegment(Seg7Shape2 , $01 ); end;
           16,8 : begin  RollSegment(Seg7Shape1 , $00 );  RollSegment(Seg7Shape2 , $03 ); end;
           15,7 : begin  RollSegment(Seg7Shape1 , $00 );  RollSegment(Seg7Shape2 , $06 ); end;
           14,6 : begin  RollSegment(Seg7Shape1 , $00 );  RollSegment(Seg7Shape2 , $0C ); end;
           13,5 : begin  RollSegment(Seg7Shape1 , $08 );  RollSegment(Seg7Shape2 , $08 ); end;
           12,4 : begin  RollSegment(Seg7Shape1 , $18 );  RollSegment(Seg7Shape2 , $00 ); end;
           11,3 : begin  RollSegment(Seg7Shape1 , $30 );  RollSegment(Seg7Shape2 , $00 ); end;
           10,2 : begin  RollSegment(Seg7Shape1 , $21 );  RollSegment(Seg7Shape2 , $00 ); end;
        end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
    RandData: Byte;
begin
    if (ShuffleMarkCount = 0) then
    begin
        RandData := ShuffleGet();
        StringGrid1.Cells[1, 99 - byte(ShuffleRemainCount + 1)] := Format('%.02d',[RandData]);
        inc(ShufflePoint);
        Seg7Shape2.Num := RandData Mod 10;
        Seg7Shape1.Num := RandData div 10;
        Timer1.Enabled := False;
        Seg7Shape1.Fill.Color := TAlphaColorRec.Blue;
        Seg7Shape2.Fill.Color := TAlphaColorRec.Blue;
        if(ShuffleRemainCount <> $ff) then
                                         Button1.Enabled := TRUE;
    end
    else
    begin
        Seg7Shape1.Fill.Color := Seg7Shape1.Fill.Color + Random(Integer($FFFFFFFF));
        Seg7Shape2.Fill.Color := Seg7Shape1.Fill.Color + Random(Integer($FFFFFFFF));
        if (ShuffleMarkCount <> 0) then
                                        Dec(ShuffleMarkCount);
        RollSegmentSet(ShuffleMarkCount);
    end;

end;

end.
