
{*****************************************}
{                                         }
{          Report Machine v3.0            }
{              Include file               }
{                                         }
{*****************************************}

{$B-} {- Complete Boolean Evaluation }
{$R-} {- Range-Checking }
{$V-} {- Var-String Checking }
{$T-} {- Typed @ operator }
{$X+} {- Extended syntax }
{$P+} {- Open string params }
{$J+} {- Writeable structured consts }
{$H+} {- Use long strings by default }

//{$DEFINE TrialVersion}

{$IFNDEF VER90}  { if it's not Delphi 2.0 }
  {$IFNDEF VER93}  { and it's not C++Builder 1.0 }
    {$DEFINE Delphi2}
    {$DEFINE Delphi3}  { then it must be at least Delphi 3 or C++Builder 3 }
    {$IFNDEF VER100}  { if it's not Delphi 3.0 }
      {$IFNDEF VER120}  { Delphi 4/5's command line compiler doesn't like the ObjExportAll directive, so don't include it on Delphi 4/5 }
        {$IFNDEF VER130}
          {$ObjExportAll On}  { <- needed for compatibility with run-time packages in C++Builder 3 }
        {$ENDIF}
      {$ENDIF}
      {$IFNDEF VER110}  { and it's not C++Builder 3.0 }
		    {$DEFINE Delphi2}
    		{$DEFINE Delphi3}  { then it must be at least Delphi 3 or C++Builder 3 }
        {$DEFINE Delphi4}  { then it must be at least Delphi 4 or C++Builder 4 }
        {$IFNDEF VER120} {$IFNDEF VER125}  { if it's not Delphi 4 or C++Builder 4 }
			    {$DEFINE Delphi2}
			    {$DEFINE Delphi3}
			    {$DEFINE Delphi4}
          {$DEFINE Delphi5}  { then it must be at least Delphi 5 or C++Builder 5 }
          {$IFNDEF VER130}  { if it's not Delphi 5 or C++Builder 5 }
				    {$DEFINE Delphi2}
				    {$DEFINE Delphi3}
				    {$DEFINE Delphi4}
				    {$DEFINE Delphi5}
            {$DEFINE Delphi6}  { then it must be at least Delphi 6 or C++Builder 6 }
            {$IFNDEF VER140} { if it's not Delphi 6 or C++Builder 6 }
					    {$DEFINE Delphi2}
					    {$DEFINE Delphi3}
					    {$DEFINE Delphi4}
					    {$DEFINE Delphi5}
        	    {$DEFINE Delphi6}
              {$DEFINE Delphi7} { then it must be at least Delphi 7 or C++Builder 7 }
            {$ENDIF}
          {$ENDIF}
        {$ENDIF} {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER90}       // Delphi 2.0
  {$DEFINE Delphi2}
{$ENDIF}

{$IFDEF VER100}      // Delphi 3.0
  {$DEFINE Delphi3}
{$ENDIF}

{$IFDEF VER120}      // Delphi 4.0
  {$DEFINE Delphi4}
{$ENDIF}

{$IFDEF VER130}      // Delphi 5.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
{$ENDIF}

{$IFDEF VER140}      // Delphi 6.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
{$ENDIF}

{$IFDEF VER150}      // Delphi 7.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$WARN UNSAFE_CODE OFF}
{$ENDIF}

{$IFDEF VER93}       // Borland C++ Builder 1.0
  {$DEFINE Delphi2}
{$ENDIF}

{$IFDEF VER110}      // Borland C++ Builder 3.0
  {$DEFINE Delphi3}
  {$ObjExportAll on}
{$ENDIF}

{$IFDEF VER125}      // Borland C++ Builder 4.0
  {$DEFINE Delphi4}
  {$ObjExportAll on}
{$ENDIF}

{$IFDEF VER130}      // Borland C++ Builder 5.0
 {$IFDEF BCB}
  {$ObjExportAll on}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER140}      // Borland C++ Builder 6.0
 {$IFDEF BCB}
  {$ObjExportAll on}
 {$ENDIF}
{$ENDIF}

//-------------------- Use Toolbutton 2K ---------------------------------------
//{$DEFINE USE_TB2K}  // 使用tb2K,取消此行的注释

//-------------------- Use Toolbutton 97 --------------------------------
{$DEFINE USE_INTERNALTB97} // 使用rm集成的tb97,如果已安装tb97,注释掉此行

//-------------------- Use SynEdit -------------------------------------
//{$DEFINE USE_SYNEDIT}

//-------------------- Raize ---------------------------------------------------
//{$DEFINE Raize}

//-------------------- FlatStyle -----------------------------------------------
//如果使用FlatStyle
//{$DEFINE FlatStyle}

//-------------------- JVCL ----------------------------------------------------
{$DEFINE USE_INTERNAL_JVCL}
//{$DEFINE JVCLCTLS}

//------------------- RX Rich 2.0 -----------------------------------
// RX RichEdit 2.0. You should install RX Library (2.60 or above) first.
// If you want to TRxRichEdit, Print TRxRichEdit, TRxDBRichEdit Use TRMFormReport,
// uncomment the following line:
//{$DEFINE RX}

//------------------- InfoPower -----------------------------------
// If you want to TwwDBRichEdit, Print TwwDBGrid Use TRMFormReport, uncomment
// the following line:
//{$DEFINE InfoPower}

//-------------------- Use RichEdit 2.0 ---------------------------------
{$DEFINE USE_RICHEDIT_VER_20}

//------------------- TeeChart component ----------------------------
{$DEFINE TeeChart}
//{$DEFINE TeeChart40}

//--------------------Decision Grid----------------------------------
//{$DEFINE DecisionGrid}

//------------------- JPEG images -----------------------------------
// JPEG images - only available in Delphi 3 and above. Adds approximately
// 100Kb to your EXE.
// If you want to show jpeg images in "Picture" object, uncomment
// the following line:
{$DEFINE JPEG}

//------------------- GIF images -----------------------------------
// GIF images - need RXLib. Adds approximately
// If you want to show GIF images in "Picture" object, uncomment
// the following line:
{$DEFINE RXGIF}

//------------------- "Open Picture" dialog -------------------------
// Only available in Delphi 3 and above. Adds approximately 60Kb to your EXE.
// If you want to use standard "Open picture" dialog in picture editor,
// uncomment the following line:
{$DEFINE OPENPICTUREDLG}

//------------------- EHLib 1.54 or Above -----------------------------------
// If you want to Print TDBGridEh Use TRMFormReport, uncomment
// the following line:
//{$DEFINE EHLib}
//{$DEFINE EHLib20}

//------------------ Use TurboPower --------------------------------
{$DEFINE TurboPower}

//------------------ Use TntUnicode, TRMRichView Support Unicode --------------------------------
//{$DEFINE TntUnicode}

//------------------ Use llPDFLib to Export PDF File --------------
//{$DEFINE llPDFLib}

//------------------ Use ImageEn to Export multi page Tiff File --------------
//{$DEFINE USE_IMAGEEN}

//-------------------- Zlib ---------------------------------------
{$DEFINE Zlib}

//-----------------Data Manager -----------------------------
{$DEFINE DM_ADO}  //Support ADO
{$DEFINE DM_BDE}  //Support BDE
{$DEFINE DM_IBX}  //Support InterBase Express
{$DEFINE DM_DBX}
{$DEFINE DM_MIDAS}

//-------------------------------------------------------------------
{$IFNDEF Delphi5}
	{$UNDEF DM_ADO}
	{$UNDEF DM_IBX}
{$ENDIF}

{$IFNDEF RX}
	{$UNDEF RXGIF}
{$ENDIF}

{$IFNDEF Delphi6}
	{$UNDEF DM_DBX}
{$ENDIF}

{$IFNDEF Delphi4}
	{$UNDEF USE_TB2K}
{$ENDIF}

{$IFDEF Raize }
  {$UNDEF FlatStyle}
  {$UNDEF JVCLCTLS}
{$ENDIF}
