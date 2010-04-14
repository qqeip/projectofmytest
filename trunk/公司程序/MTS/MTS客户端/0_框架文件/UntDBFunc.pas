unit UntDBFunc;

interface

uses
  DBClient, Classes, SysUtils, cxGrid, cxGridDBTableView, cxGridTableView, cxDataStorage,
  Ut_DataModule;

//�������ݼ����Grid�ֶ�
//aGrid: TcxGrid Ҫ����ֶε�Grid
//CDSData: TClientDataSet �������ݵ����ݼ�������������ݼ��е��ֶ������
//sDisplayName: String �ֶε���ʾ���� �Զ��Ÿ��� 
function AddGridFields(aView: TcxGridDBTableView; CDSData: TClientDataSet; sDisplayName: String=''): boolean;

//��ʼ��Items��ֵ
//��һ���ֶ�Ϊ��ʾ��ֵ
procedure InitItems(OwnerData: Variant; aItems: TStrings); overload;
procedure InitItems(CDSData: TClientDataSet; aItems: TStrings; ShowFieldName: String); overload;

implementation

uses Ut_Common;  

//------------------------�������ݼ����Grid�ֶ�------------------------------//
procedure AddGridField(aView: TcxGridDBTableView; sFieldName, sCaption: String; iWidth: Integer);
begin
  aView.BeginUpdate;
  with aView.CreateColumn as TcxGridColumn do
  begin
    Caption := sCaption;
    DataBinding.FieldName := sFieldName;
    DataBinding.ValueTypeClass := TcxStringValueType;
    HeaderAlignmentHorz := taCenter;
    //Width:=iWidth;
  end;
  aView.EndUpdate;
end;

function AddGridFields(aView: TcxGridDBTableView; CDSData: TClientDataSet; sDisplayName: String=''): boolean;
var
  I, Index: Integer;
begin
  Result := false;

  if Trim(sDisplayName) = '' then
  begin
    for I := 0 to CDSData.FieldCount - 1 do
    begin
      AddGridField(aView, CDSData.Fields[I].FieldName, CDSData.Fields[I].DisplayLabel, CDSData.Fields[I].DisplayWidth);
    end;
  end
  else
  begin 
    for I := 0 to CDSData.FieldCount - 1 do
    begin
      Index := pos(',', sDisplayName);
      if Index>0 then
      begin
        CDSData.Fields[I].DisplayLabel := Copy(sDisplayName, 1, Index-1);
        sDisplayName := Copy(sDisplayName, Index+1, Length(sDisplayName)-Index);
      end
      else
      if Trim(sDisplayName) <> '' then
      begin
        CDSData.Fields[I].DisplayLabel := sDisplayName;
        sDisplayName := '';
      end; 
      
      AddGridField(aView, CDSData.Fields[I].FieldName, CDSData.Fields[I].DisplayLabel, CDSData.Fields[I].DisplayWidth);
    end;
  end;

  Result := true;
end;

{procedure Use;
begin
  DSMTUList.DataSet := nil;
  with CDSMTUList do
  begin
    Close;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,1]),0);
  end;

  AddGridFields(cxGrid1, CDSMTUList, 'MTUID,MTU���,MTU����');
  DSMTUList.DataSet := CDSMTUList;

  cxGridDBTableView3.ApplyBestFit();  

  //���ò���ʾ
  aView.Columns[0].Visible:=false;
  aView.GetColumnByFieldName('ID').Visible:=false;
end;}

//------------------------�������ݼ����Grid�ֶ�------------------------------//

//----------------------------��ʼ��Items��ֵ---------------------------------//
procedure InitItems(OwnerData:Variant; aItems: TStrings);
var
  obj :TCommonObj;
begin
  aItems.Clear;
  With Dm_Mts.cds_common do
  begin
    Data:=Dm_Mts.TempInterface.GetCDSData(OwnerData,0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := Fields[1].AsInteger;
      obj.Name := Fields[0].AsString;
      aItems.AddObject(Fields[0].AsString, obj);
      Next;
    end;
  end;  
end;

procedure InitItems(CDSData: TClientDataSet; aItems: TStrings; ShowFieldName: String); overload;
begin
  CDSData.First;
  while not CDSData.Eof do
  begin
    aItems.AddObject(CDSData.FieldByName(ShowFieldName).AsString, Dm_Mts.cds_common.Fields);
    CDSData.Next;
  end;
end;


//showmessage(TFields(CheckListBox1.Items.Objects[0])[0].AsString);


//----------------------------��ʼ��Items��ֵ---------------------------------//

end.
