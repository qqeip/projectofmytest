unit uVCLADOLib;
{----------------------------------------------------------------------------}
{ RemObjects SDK Library - Core Library                                      }
{                                                                            }
{ compiler: Delphi 5 and up, Kylix 2 and up                                  }
{ platform: Win32, Linux                                                     }
{                                                                            }
{ (c)opyright RemObjects Software. all rights reserved.                      }
{                                                                            }
{ Using this code requires a valid license of the RemObjects SDK             }
{ which can be obtained at http://www.remobjects.com.                        }
{----------------------------------------------------------------------------}


interface

uses ADODB;

{ Summary: Loads the ADO-XML data stream into the TADODataset
  Description:
    Loads the ADO-XML data stream into the TADODataset. This function expects a full ADO-XML datapacket to
    be provided along with field descriptors and so on. You can generate these XML streams using
    functions such as OpenXMLRecordset contained in uADOLib.pas. Make sure you set IncludeSchema
    to TRUE if you do so. }
procedure XMLToVCLRecordset(const XML : string; anADODataset : TADODataset);

{ Summary: Extracts the updates that have been made to the dataset and converts them in XML
  Description:
    This function packs the delta of changes made to the dataset (i.e. inserts, field updates, row deletes)
    into an XML string that can be sent to the middle tier. By using the function DoXMLBatchUpdate
    contained in uADOLib.pas you will then be able to automatically apply all the changes to the original
    datasource (i.e. a database). }
function ADODatasetUpdatesToXML(const anADODataset : TADODataset) : widestring;

implementation

uses ADODB_TLB, uADOLib, SysUtils;

procedure XMLToVCLRecordset(const XML : string; anADODataset : TADODataset);
var rs : ADODB_TLB._Recordset;
begin
  anADODataset.Close;

  XMLToRecordset(XML, rs);
  anADODataset.Recordset := rs as ADODB._Recordset
end;

function ADODatasetUpdatesToXML(const anADODataset : TADODataset) : widestring;
begin
  result := RecordsetUpdatesToXML(anADODataSet.Recordset as _Recordset);
end;

end.
