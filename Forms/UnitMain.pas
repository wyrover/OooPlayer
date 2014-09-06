{ *
  * Copyright (C) 2014 ozok <ozok26@gmail.com>
  *
  * This file is part of OooPlayer.
  *
  * OooPlayer is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License, or
  * (at your option) any later version.
  *
  * OooPlayer is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with OooPlayer.  If not, see <http://www.gnu.org/licenses/>.
  *
  * }

unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Generics.Collections, Vcl.Menus, JvExControls,
  JvArrowButton, JvComponentBase, JvSearchFiles, JvBaseDlg, JvBrowseFolder,
  MediaInfoDll, JvExComCtrls, JvComCtrls, Vcl.ImgList, JvThreadTimer,
  windows7taskbar,
  JvExStdCtrls, JvListBox, IniFiles, Vcl.Buttons, JvFormPlacement, JvAppStorage,
  JvAppIniStorage, StrUtils, ShellAPI, JvComputerInfoEx, UnitTagTypes, UnitTagReader, PNGImage, JvDragDrop,
  JvThread, JvUrlListGrabber, JvUrlGrabbers, JvTrayIcon, Jpeg, UnitMusicPlayer, Bass,
  IdBaseComponent, IdThreadComponent, Vcl.Samples.Gauges;

type
  TPlaybackType = (music = 0, radio = 1);

type
  TRadioStation = packed record
    Name: string;
    URL: Ansistring;
  end;

  TRadioList = TList<TRadioStation>;

type
  TCurrentItemInfo = packed record
    ItemIndex: integer;
    FullFileName: string;
    DurationBass: int64;
    DurationAsSecInt: Integer;
    InfoStr: string;
    StatusInfoText: string;
  end;

type
  TMyDragObject = class(TDragObject)
  public
    ItemIndex: Integer;
  end;

type
  TFFTData = array [0 .. 128] of single;

type
  TVisData = array [0 .. 3] of Double;

type
  TMainForm = class(TForm)
    TopBarPnl: TPanel;
    OpenFolder: TJvBrowseForFolderDialog;
    MusicSearch: TJvSearchFiles;
    VolumeBar: TJvTrackBar;
    MainMenu1: TMainMenu;
    F1: TMenuItem;
    E1: TMenuItem;
    P1: TMenuItem;
    P2: TMenuItem;
    P3: TMenuItem;
    S1: TMenuItem;
    P4: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    V1: TMenuItem;
    V2: TMenuItem;
    P5: TMenuItem;
    J1: TMenuItem;
    A3: TMenuItem;
    A4: TMenuItem;
    S2: TMenuItem;
    C1: TMenuItem;
    PlayListMenu: TPopupMenu;
    o1: TMenuItem;
    F2: TMenuItem;
    PlayBackImgs: TImageList;
    AppIniFileStorage: TJvAppIniFileStorage;
    FormStorage: TJvFormStorage;
    PlaybackOrderList: TComboBox;
    G1: TMenuItem;
    PositionLabel: TLabel;
    PlayList: TListView;
    InfoPanel: TPanel;
    TitleLabel: TLabel;
    AlbumLabel: TLabel;
    ArtistLabel: TLabel;
    PlaybackInfoLabel: TLabel;
    PlayBtn: TButton;
    PauseBtn: TButton;
    StopBtn: TButton;
    PrevBtn: TButton;
    NextBtn: TButton;
    SysInfo: TJvComputerInfoEx;
    R1: TMenuItem;
    StatusBar1: TStatusBar;
    N1: TMenuItem;
    s3: TMenuItem;
    L1: TMenuItem;
    N4: TMenuItem;
    E2: TMenuItem;
    PositionBar: TJvTrackBar;
    CoverImage: TImage;
    L2: TMenuItem;
    ProgressPanel: TPanel;
    AbortBtn: TButton;
    ProgressLabel: TLabel;
    R2: TMenuItem;
    D2: TMenuItem;
    DragDrop: TJvDragDrop;
    H1: TMenuItem;
    C2: TMenuItem;
    E3: TMenuItem;
    A1: TMenuItem;
    UpdateChecker: TJvHttpUrlGrabber;
    UpdateThread: TJvThread;
    OpenDialog: TOpenDialog;
    S4: TMenuItem;
    D1: TMenuItem;
    TrayIcon: TJvTrayIcon;
    TrayMenu: TPopupMenu;
    P6: TMenuItem;
    P7: TMenuItem;
    S5: TMenuItem;
    v3: TMenuItem;
    V4: TMenuItem;
    PositionTimer: TTimer;
    FuncPages: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    RadioCatList: TComboBox;
    RadioList: TListView;
    RadioThread: TIdThreadComponent;
    VisTimer: TTimer;
    Gauge1: TGauge;
    Gauge2: TGauge;
    Gauge3: TGauge;
    Gauge4: TGauge;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MusicSearchProgress(Sender: TObject);
    procedure MusicSearchFindFile(Sender: TObject; const AName: string);
    procedure PlayListDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure PauseBtnClick(Sender: TObject);
    procedure VolumeBarChange(Sender: TObject);
    procedure PositionTimerTimer(Sender: TObject);
    procedure PlayListMouseEnter(Sender: TObject);
    procedure PlayListMouseLeave(Sender: TObject);
    procedure PositionBarChanged(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PlayBtnMouseEnter(Sender: TObject);
    procedure PauseBtnMouseEnter(Sender: TObject);
    procedure StopBtnMouseEnter(Sender: TObject);
    procedure PrevBtnMouseEnter(Sender: TObject);
    procedure NextBtnMouseEnter(Sender: TObject);
    procedure TopBarPnlMouseEnter(Sender: TObject);
    procedure PositionBarMouseEnter(Sender: TObject);
    procedure VolumeBarMouseEnter(Sender: TObject);
    procedure BotBarPnlMouseEnter(Sender: TObject);
    procedure V1Click(Sender: TObject);
    procedure V2Click(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure PrevBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure J1Click(Sender: TObject);
    procedure PlayBtnClick(Sender: TObject);
    procedure A4Click(Sender: TObject);
    procedure PositionBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure S2Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure PlayListAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure PlayListData(Sender: TObject; Item: TListItem);
    procedure G1Click(Sender: TObject);
    procedure PlaybackOrderListChange(Sender: TObject);
    procedure o1Click(Sender: TObject);
    procedure F2Click(Sender: TObject);
    procedure LyricListMouseLeave(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure E2Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure s3Click(Sender: TObject);
    procedure L2Click(Sender: TObject);
    procedure AbortBtnClick(Sender: TObject);
    procedure R2Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure DragDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
    procedure C2Click(Sender: TObject);
    procedure E3Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure UpdateCheckerDoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
    procedure UpdateThreadExecute(Sender: TObject; Params: Pointer);
    procedure A3Click(Sender: TObject);
    procedure S4Click(Sender: TObject);
    procedure PlayListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PlayListDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure PlayListStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure D1Click(Sender: TObject);
    procedure RadioListData(Sender: TObject; Item: TListItem);
    procedure RadioCatListChange(Sender: TObject);
    procedure FuncPagesMouseLeave(Sender: TObject);
    procedure RadioListMouseLeave(Sender: TObject);
    procedure RadioListMouseEnter(Sender: TObject);
    procedure RadioListDblClick(Sender: TObject);
    procedure RadioListAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure FuncPagesChange(Sender: TObject);
    procedure RadioThreadRun(Sender: TIdThreadComponent);
    procedure VisTimerTimer(Sender: TObject);
  private
    { Private declarations }
    FStoppedByUser: Boolean;
    FShuffleIndexes: TList<Integer>;
    FShuffleIndex: Integer;
    FLastCoverPath: string;
    FLastDir: string;
    FStopAddFiles: Boolean;
    FDraggingCurrentFile: Boolean;
    FJpeg: TJPEGImage;
    FPng: TPngImage;
    FRadioStations: TRadioList;
    FCurrentRadioIndex: integer;
    FPlaybackType: TPlaybackType;
    FRadioURL: Ansistring;
    FRadioLogItem: string;
    FFFTData: TFFTData;

    procedure AddFile(const FileName: string);
    procedure ReScanFile(const FileIndex: integer);

    procedure LoadPlayList;
    procedure SavePlayList;

    procedure LoadSettings;
    procedure SaveSettings;

    procedure ScrollToCurrentSong;

    procedure GenerateShuffleList;

    function GetImage(const Dir: string): string;
    procedure LoadPicFromStream(const Stream: TStream; const PicType: TCoverArtType);
    procedure LoadCoverArt(const FileName: string);
    function LoadExternalCoverArt(const FileName: string): Boolean;
    function LoadInternalCoverArt(const FileName: string): Boolean;

    procedure LoadM3UPlaylist(const PlaylistPath: string);
    procedure LoadPPFPlaylist(const PlaylistPath: string);
    procedure SaveM3UPlayList(const FileName: string; const UTF8: Boolean);
    procedure SavePPFPlaylist(const FileName: string);

    function GetVisData(const Stream: HSTREAM): TVisData;

    // Radio player funcs
    function IsRadioPlayerPaused: Boolean;
    function IsRadioPlayerStopped: Boolean;

    procedure LoadRadioStations;
    procedure PlayRadio(const URL: Ansistring);
    procedure PauseRadio;
    procedure ResumeRadio;
    procedure StopRadio;
    procedure SetRadioVolume(const Volume: integer);

    procedure AddToRadioLog;

    procedure RadioResetUI;
    // Radio player funcs
  public
    { Public declarations }
    FPlayListItems: TList<TPlayListItem>;
    FCurrentItemInfo: TCurrentItemInfo;
    FPlayer: TMusicPlayer;
    FTagReader: TTagReader;
    FAppDataFolder: string;

    procedure ScrollToItem(const ItemIndex: integer);

    procedure PlayItem(const ItemIndex: integer);

    function RemoveInvalidChars(const Title: string): string;

    // handles msgessent from radio thread
    procedure WndProc(var Msg: TMessage); override;
  end;

var
  MainForm: TMainForm;
  WinHandle: HWND;
  FRadioHandle: HSTREAM;

const
  BuildInt = 781;
  Portable = False;
  WM_INFO_UPDATE = WM_USER + 101;
  RESET_UI = 0;
  SHOW_ERROR = 1;
  UPDATE_PROGRESS = 2;
  UPDATE_META_NAME = 3;
  UPDATE_META_BITRATE = 4;
  UPDATE_META = 7;
  STATUS_UPDATE = 8;
  REPAINT_RADIO_LIST = 9;

implementation

{$R *.dfm}

uses UnitSearch, UnitSettings, UnitFileInfo, UnitLog, UnitAbout;

// radio sync func
procedure StatusProc(buffer: Pointer; len: DWORD; user: Pointer); stdcall;
begin
  if (buffer <> nil) and (len = 0) then
    SendMessage(WinHandle, WM_INFO_UPDATE, STATUS_UPDATE, DWORD(PAnsiChar(buffer)));
end;

// radio meta sync funcs
procedure DoMeta();
var
  meta: PAnsiChar;
  p: Integer;
begin
  meta := BASS_ChannelGetTags(FRadioHandle, BASS_TAG_META);
  if (meta <> nil) then
  begin
    p := Pos('StreamTitle=', String(AnsiString(meta)));
    if (p = 0) then
      Exit;
    p := p + 13;
    SendMessage(WinHandle, WM_INFO_UPDATE, UPDATE_META, DWORD(PAnsiChar(AnsiString(Copy(meta, p, Pos(';', String(meta)) - p - 1)))));
  end;
end;

procedure MetaSync(handle: HSYNC; channel, data: DWORD; user: Pointer); stdcall;
begin
  DoMeta();
end;

procedure TMainForm.A1Click(Sender: TObject);
begin
  Self.Enabled := False;
  AboutForm.Show;
end;

procedure TMainForm.A3Click(Sender: TObject);
var
  I: Integer;
begin
  if DirectoryExists(FLastDir) then
  begin
    OpenDialog.InitialDir := FLastDir;
  end;
  if OpenDialog.Execute then
  begin
    FStopAddFiles := False;
    PlayList.Items.BeginUpdate;
    ProgressPanel.Visible := True;
    try
      for I := 0 to OpenDialog.Files.Count - 1 do
      begin
        Application.ProcessMessages;
        ProgressLabel.Caption := ExtractFileDir(OpenDialog.Files[i]);
        if FStopAddFiles then
        begin
          Break;
        end
        else
        begin
          AddFile(OpenDialog.Files[i]);
        end;
      end;
    finally
      ProgressPanel.Visible := False;
      PlayList.Items.EndUpdate;
      SavePlayList;
      FLastDir := OpenFolder.Directory;
      Self.Width := Self.Width + 1;
      Self.Width := Self.Width - 1;
      GenerateShuffleList;
      StatusBar1.Panels[0].Text := Format('%d files', [PlayList.Items.Count]);
    end;
  end;
end;

procedure TMainForm.A4Click(Sender: TObject);
begin
  if DirectoryExists(FLastDir) then
  begin
    OpenFolder.Directory := FLastDir;
  end;
  if OpenFolder.Execute then
  begin
    PlayList.Items.BeginUpdate;
    ProgressPanel.Visible := True;
    try
      MusicSearch.RecurseDepth := MaxInt;
      MusicSearch.RootDirectory := OpenFolder.Directory;
      MusicSearch.Search;
    finally
      ProgressPanel.Visible := False;
      PlayList.Items.EndUpdate;
      SavePlayList;
      FLastDir := OpenFolder.Directory;
      Self.Width := Self.Width + 1;
      Self.Width := Self.Width - 1;
      GenerateShuffleList;
      StatusBar1.Panels[0].Text := Format('%d files', [PlayList.Items.Count]);
    end;
  end;
end;

procedure TMainForm.AbortBtnClick(Sender: TObject);
begin
  if MusicSearch.Searching then
  begin
    MusicSearch.Abort;
    ProgressPanel.Visible := False;
    PlayList.Items.EndUpdate;
    SavePlayList;
    FLastDir := OpenFolder.Directory;
    Self.Width := Self.Width + 1;
    Self.Width := Self.Width - 1;
    GenerateShuffleList;
    StatusBar1.Panels[0].Text := Format('%d files', [PlayList.Items.Count]);
  end;
  FStopAddFiles := True;
end;

procedure TMainForm.AddFile(const FileName: string);
var
  MediaInfoHandle: Cardinal;
  LPlayListItem, LTmpItem: TPlayListItem;
  LTitle, LArtist, LAlbum, LDuration, LBitrate, LChannels, LCodec, LSampleRate: string;
begin

  if (FileExists(FileName)) then
  begin

    // New handle for mediainfo
    MediaInfoHandle := MediaInfo_New();

    // initial values
    LTitle := 'unknown';
    LArtist := 'unknown';
    LAlbum := 'unknown';
    LDuration := '00:00:00.000';

    if (MediaInfoHandle <> 0) then
    begin

      try
        // read duration of file
        MediaInfo_Open(MediaInfoHandle, PWideChar(FileName));
        MediaInfo_Option(MediaInfoHandle, 'Complete', '1');

        // info
        LDuration := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'Duration/String3', Info_Text, Info_Name);
        LBitrate := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'BitRate/String', Info_Text, Info_Name);
        LChannels := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'Channel(s)/String', Info_Text, Info_Name);
        LCodec := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'Codec/String', Info_Text, Info_Name);
        if LCodec = 'Lossless' then
        begin
          LCodec := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'Format', Info_Text, Info_Name);
        end;
        LSampleRate := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'SamplingRate', Info_Text, Info_Name);
        // tags
        LTmpItem := FTagReader.ReadTags(FileName);
        LTitle := LTmpItem.Title;
        LArtist := LTmpItem.Artist;
        LAlbum := LTmpItem.Album;

        LTitle := Trim(LTitle);
        LArtist := Trim(LArtist);
        LAlbum := Trim(LAlbum);
        LDuration := Trim(LDuration);
        LCodec := Trim(LCodec);
        LSampleRate := Trim(LSampleRate);

        if (Length(LTitle) < 1) then
        begin
          // if cannot get title
          // set to file name
          LTitle := ChangeFileExt(ExtractFileName(FileName), '');
        end;

        if (Length(LArtist) < 1) then
        begin
          LArtist := 'unkown';
        end;

        if (Length(LAlbum) < 1) then
        begin
          LAlbum := 'unkown';
        end;

        if (Length(LDuration) < 1) then
        begin
          LDuration := '00:00:00.000';
        end;

        if (Length(LBitrate) < 1) then
        begin
          LBitrate := 'N/A';
        end;

        if (Length(LChannels) < 1) then
        begin
          LChannels := 'N/A';
        end;

        if (Length(LCodec) < 1) then
        begin
          LCodec := 'N/A';
        end;

        if (Length(LSampleRate) < 1) then
        begin
          LSampleRate := 'N/A';
        end;
        // increase playlist item count
        PlayList.Items.Count := PlayList.Items.Count + 1;

        LPlayListItem.FullFileName := FileName;
        LPlayListItem.DurationStr := LDuration;
        LPlayListItem.Title := LTitle;
        LPlayListItem.Artist := LArtist;
        LPlayListItem.Album := LAlbum;
        LPlayListItem.DurationStr := LDuration;
        LPlayListItem.Bitrate := LBitrate;
        LPlayListItem.Channels := LChannels;
        LPlayListItem.Codec := LCodec;
        LPlayListItem.SampleRate := LSampleRate;
        FPlayListItems.Add(LPlayListItem);

      finally
        MediaInfo_Close(MediaInfoHandle);
      end;
    end;
  end;
end;

procedure TMainForm.AddToRadioLog;
begin
  LogForm.LogList.Lines.Add(FRadioLogItem);
  if LogForm.Visible = False then
  begin
    LogForm.Show;
  end;
end;

procedure TMainForm.BotBarPnlMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.C1Click(Sender: TObject);
begin
  PlayList.Items.Clear;
  FPlayListItems.Clear;
  PlayList.Items.Count := 0;
  FCurrentItemInfo.ItemIndex := -1;
  FCurrentItemInfo.FullFileName := '';
  FShuffleIndexes.Clear;
  FShuffleIndex := -1;
  SavePlayList;
  StatusBar1.Panels[0].Text := '0 files';
end;

procedure TMainForm.C2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PWideChar(ExtractFileDir(Application.ExeName) + '\changelog.txt'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.D1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FPlayListItems.Count - 1 do
  begin
    if PlayList.Items[i].Selected then
    begin
      PlayList.Items.Count := PlayList.Items.Count - 1;
      FPlayListItems.Delete(i);
      if i < FCurrentItemInfo.ItemIndex then
      begin
        FCurrentItemInfo.ItemIndex := FCurrentItemInfo.ItemIndex - 1;
      end
      else if i = FCurrentItemInfo.ItemIndex then
      begin
        if (FCurrentItemInfo.ItemIndex + 1) < FPlayListItems.Count then
        begin
          FCurrentItemInfo.ItemIndex := FCurrentItemInfo.ItemIndex + 1;
        end
        else if (FCurrentItemInfo.ItemIndex - 1) > -1 then
        begin
          FCurrentItemInfo.ItemIndex := 0;
        end
        else
        begin
          FCurrentItemInfo.ItemIndex := -1;
        end;
      end;
    end;
  end;
  PlayList.Invalidate;
end;

procedure TMainForm.D2Click(Sender: TObject);
begin
  if (PlayList.ItemIndex > -1) then
  begin
    if ID_YES = Application.MessageBox('Do you want to delete this file from disc permanently?', 'Confirm', MB_YESNO or MB_ICONQUESTION) then
    begin
      if FileExists(FPlayListItems[PlayList.ItemIndex].FullFileName) then
      begin
        DeleteFile(FPlayListItems[PlayList.ItemIndex].FullFileName)
      end
      else
      begin
        LogForm.LogList.Lines.Add('Unable to find ' + FPlayListItems[PlayList.ItemIndex].FullFileName)
      end;
      PlayList.Items[PlayList.ItemIndex].Delete;
      FPlayListItems.Delete(PlayList.ItemIndex);
      PlayList.Repaint;
      if PlayList.ItemIndex < FCurrentItemInfo.ItemIndex then
      begin
        FCurrentItemInfo.ItemIndex := FCurrentItemInfo.ItemIndex - 1;
      end;
      StatusBar1.Panels[0].Text := Format('%d files', [PlayList.Items.Count]);
    end;
  end;
end;

procedure TMainForm.DragDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
var
  i: Integer;
  Extension: string;
  DirectoriesToSearch: TStringList;
begin
  FStopAddFiles := False;
  PlayList.Items.BeginUpdate;
  ProgressPanel.Visible := True;
  DirectoriesToSearch := TStringList.Create;
  try
    for i := 0 to Value.Count - 1 do
    begin
      Application.ProcessMessages;
      Extension := LowerCase(ExtractFileExt(Value[i]));
      if FStopAddFiles then
      begin
        Break;
      end
      else
      begin
        // decide if file or directory
        if DirectoryExists(Value[i]) then
        begin
          DirectoriesToSearch.Add(Value[i]);
        end
        else
        begin
          if (Extension = '.mp3') or (Extension = '.aac') or (Extension = '.ogg') or (Extension = '.opus') or (Extension = '.flac') or (Extension = '.alac') or (Extension = '.ape') or (Extension = '.mpc') or (Extension = '.tta') or
            (Extension = '.wv') or (Extension = '.wma') or (Extension = '.ac3') or (Extension = '.spx') or (Extension = '.tak') or (Extension = '.ofr') or (Extension = '.wav') then
          begin
            AddFile(Value[i]);
            FLastDir := ExtractFileDir(Value[i]);
          end;
        end;
      end;
    end;
    // add directory content
    if not FStopAddFiles then
    begin
      if DirectoriesToSearch.Count > 0 then
      begin
        for I := 0 to DirectoriesToSearch.Count - 1 do
        begin
          Application.ProcessMessages;
          MusicSearch.RootDirectory := DirectoriesToSearch[i];
          MusicSearch.Search;
          FLastDir := DirectoriesToSearch[i];
        end;
      end;
    end;
  finally
    ProgressPanel.Visible := False;
    PlayList.Items.EndUpdate;
    SavePlayList;
    FLastDir := OpenFolder.Directory;
    Self.Width := Self.Width + 1;
    Self.Width := Self.Width - 1;
    GenerateShuffleList;
    StatusBar1.Panels[0].Text := Format('%d files', [PlayList.Items.Count]);
  end;
end;

procedure TMainForm.E2Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TMainForm.E3Click(Sender: TObject);
const
  NewLine = '%0D%0A';
var
  mail: PChar;
  mailbody: string;
begin
  mailbody := AboutForm.Label1.Caption;
  mailbody := mailbody + NewLine + 'Bugs: ' + NewLine + NewLine + NewLine + 'Suggestions: ' + NewLine + NewLine + NewLine;
  mail := PwideChar('mailto:ozok26@gmail.com?subject=OooPlayer&body=' + mailbody);

  ShellExecute(0, 'open', mail, nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.F2Click(Sender: TObject);
begin
  if PlayList.ItemIndex > -1 then
  begin
    TInfoForm.Create(Application).Show;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SavePlayList;
  SaveSettings;
  TrayIcon.Active := False;
  Sleep(100);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FPlayer := TMusicPlayer.Create(Handle);
  case FPlayer.ErrorMsg of
    MY_ERROR_BASS_NOT_LOADED:
      begin
        Application.MessageBox('Couldn''t load bass.dll library.', 'Fatal Error', MB_ICONERROR);
        Application.Terminate;
      end;
  end;
  if not MediaInfoDLL_Load(ExtractFileDir(Application.ExeName) + '\mediainfo.dll') then
  begin
    Application.MessageBox('Couldn''t load mediainfo.dll library.', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;
  // windows 7 taskbar
  if CheckWin32Version(6, 1) then
  begin
    if not InitializeTaskbarAPI then
    begin
      Application.MessageBox('You seem to have Windows 7 but OooPlayer can''t start taskbar progressbar!', 'Error', MB_ICONERROR);
    end;
  end;

  // radio playe config
  BASS_SetConfig(BASS_CONFIG_NET_PLAYLIST, 1);
  BASS_SetConfig(BASS_CONFIG_NET_PREBUF, 0);
  WinHandle := Handle;

  if Portable then
  begin
    FAppDataFolder := ExtractFileDir(Application.ExeName) + '\'
  end
  else
  begin
    FAppDataFolder := SysInfo.Folders.AppData + '\OooPlayer\'
  end;
  if not DirectoryExists(FAppDataFolder) then
  begin
    if not ForceDirectories(FAppDataFolder) then
    begin
      Application.MessageBox('Unable to create profile folder.', 'FATAL ERROR', MB_ICONERROR);
      Application.Terminate;
    end;
  end;

  FPlayListItems := TList<TPlayListItem>.Create;
  FCurrentItemInfo.ItemIndex := -1;
  FCurrentRadioIndex := -1;
  FStoppedByUser := False;
  AppIniFileStorage.FileName := FAppDataFolder + 'position.ini';
  FShuffleIndexes := TList<Integer>.Create;
  FTagReader := TTagReader.Create;
  CoverImage.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\logo.png');
  FPng := TPngImage.Create;
  FJpeg := TJPEGImage.Create;
  FRadioStations := TRadioList.Create;
  PositionBar.Max := MaxInt;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FPlayer.Free;
  FPlayListItems.Free;
  FShuffleIndexes.Free;
  FTagReader.Free;
  FJpeg.Free;
  FPng.Free;
  FRadioStations.Free;
  BASS_Free;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  PlayList.Columns[0].Width := PlayList.ClientWidth - PlayList.Columns[1].Width;
  StatusBar1.Panels[0].Width := StatusBar1.ClientWidth - StatusBar1.Panels[1].Width;
  RadioList.Columns[0].Width := RadioList.ClientWidth - 20;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  LoadPlayList;
  LoadSettings;
  LoadRadioStations;
  GenerateShuffleList;
  StatusBar1.Panels[0].Text := Format('%d files', [PlayList.Items.Count]);
  if FCurrentItemInfo.ItemIndex < FPlayListItems.Count then
  begin
    PlayList.ItemIndex := FCurrentItemInfo.ItemIndex;
    ScrollToCurrentSong;
  end;
  if (FCurrentRadioIndex < FRadioStations.Count) and (FCurrentRadioIndex > -1) then
  begin
    RadioList.ItemIndex := FCurrentRadioIndex;
    RadioList.Items[FCurrentRadioIndex].MakeVisible(False);
  end;
  // update check
  if SettingsForm.CheckUpdateBtn.Checked then
  begin
    UpdateThread.Execute(nil)
  end;
end;

procedure TMainForm.G1Click(Sender: TObject);
begin
  SettingsForm.Show;
end;

procedure TMainForm.GenerateShuffleList;
var
  I: Integer;
  LIndex: Integer;
begin
  FShuffleIndexes.Clear;
  for I := 0 to FPlayListItems.Count - 1 do
  begin
    FShuffleIndexes.Add(i);
  end;
  Randomize;
  for I := FShuffleIndexes.Count - 1 downto 0 do
  begin
    LIndex := Random(FShuffleIndexes.Count);
    FShuffleIndexes.Exchange(i, LIndex);
  end;
end;

function TMainForm.GetImage(const Dir: string): string;
var
  Search: TSearchRec;
  FileName: String;
  Extension: String;
begin
  Result := '';
  if DirectoryExists(Dir) then
  begin
    if (FindFirst(Dir + '\*.*', faAnyFile, Search) = 0) then
    Begin
      repeat
        Application.ProcessMessages;
        if (Search.Name <> '.') and (Search.Name <> '..') then
        begin
          FileName := Dir + '\' + Search.Name;

          Extension := LowerCase(ExtractFileExt(FileName));
          if (Extension = '.jpg') or (Extension = '.jpeg') then
          begin
            if ContainsText(Search.Name, 'folder') or ContainsText(Search.Name, 'cover') or ContainsText(Search.Name, 'front') or ContainsText(Search.Name, 'cd') then
            begin
              Result := FileName;
              Break;
            end;
          end;
        end;
      until (FindNext(Search) <> 0);
      FindClose(Search);
    end;
  end;
end;

function TMainForm.GetVisData(const Stream: HSTREAM): TVisData;
var
  I: Integer;
  LSegmentLength: integer;
begin
  for I := Low(Result) to High(Result) do
    Result[i] := 0;

  if Stream <> 0 then
  begin
    LSegmentLength := (Length(FFFTData) div Length(Result));
    BASS_ChannelGetData(Stream, @FFFTData, BASS_DATA_FFT256);
    for I := Low(FFFTData) to High(FFFTData) do
    begin
      Result[i div LSegmentLength] := Result[i div LSegmentLength] + Abs(FFFTData[i]);
    end;
    for I := Low(Result) to High(Result) do
      Result[i] := (Result[i] * 32767) / LSegmentLength;
  end;
end;

function TMainForm.IsRadioPlayerPaused: Boolean;
begin
  Result := BASS_ChannelIsActive(FRadioHandle) = BASS_ACTIVE_PAUSED
end;

function TMainForm.IsRadioPlayerStopped: Boolean;
begin
  Result := BASS_ChannelIsActive(FRadioHandle) = BASS_ACTIVE_STOPPED
end;

procedure TMainForm.J1Click(Sender: TObject);
begin
  ScrollToCurrentSong;
end;

procedure TMainForm.L1Click(Sender: TObject);
var
  LOpenDlg: TOpenDialog;
  LExt: string;
begin
  PlayList.Items.BeginUpdate;
  LOpenDlg := TOpenDialog.Create(Self);
  try
    LOpenDlg.Filter := 'Supported|*.m3u;*.m3u8;*.ppf';
    if LOpenDlg.Execute then
    begin
      LExt := LowerCase(ExtractFileExt(LOpenDlg.FileName));
      if LExt = '.m3u' then
      begin
        LoadM3UPlaylist(LOpenDlg.FileName);
      end
      else if LExt = '.m3u8' then
      begin
        LoadM3UPlaylist(LOpenDlg.FileName);
      end
      else if LExt = '.ppf' then
      begin
        LoadPPFPlaylist(LOpenDlg.FileName);
      end;
    end;
  finally
    LOpenDlg.Free;
    PlayList.Items.Count := FPlayListItems.Count;
    Self.Width := Self.Width + 1;
    Self.Width := Self.Width - 1;
    PlayList.Items.EndUpdate;
  end;
end;

procedure TMainForm.L2Click(Sender: TObject);
begin
  LogForm.Show;
end;

procedure TMainForm.LoadCoverArt(const FileName: string);
begin
  case SettingsForm.CoverArtList.ItemIndex of
    0: // external
      begin
        if not LoadExternalCoverArt(FileName) then
        begin
          LoadInternalCoverArt(FileName)
        end;
      end;
    1: // internal first
      begin
        if not LoadInternalCoverArt(FileName) then
        begin
          LoadExternalCoverArt(FileName)
        end;
      end;
  end;
end;

function TMainForm.LoadExternalCoverArt(const FileName: string): Boolean;
var
  LImageFile: string;
begin
  Result := False;
  LImageFile := GetImage(ExtractFileDir(FileName));
  if FileExists(LImageFile) then
  begin
    if FLastCoverPath <> LImageFile then
    begin
      CoverImage.Picture.LoadFromFile(LImageFile);
    end;
    FLastCoverPath := LImageFile;
    Result := True;
  end
  else
  begin
    CoverImage.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\logo.png');
    FLastCoverPath := '';
  end;
end;

function TMainForm.LoadInternalCoverArt(const FileName: string): Boolean;
var
  LImageFile: string;
begin
  Result := False;
  FTagReader.ReadArtwork(FileName);
  if FTagReader.PicType <> none then
  begin
    LoadPicFromStream(FTagReader.PicStream, FTagReader.PicType);
    Result := True;
  end
  else
  begin
    LImageFile := ExtractFileDir(Application.ExeName) + '\logo.png';
    CoverImage.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\logo.png');
    FLastCoverPath := LImageFile;
  end;
end;

procedure TMainForm.LoadM3UPlaylist(const PlaylistPath: string);
var
  LStreamReader: TStreamReader;
  LLine: string;
begin
  if FileExists(PlaylistPath) then
  begin
    LStreamReader := TStreamReader.Create(PlaylistPath, True);
    try
      while not LStreamReader.EndOfStream do
      begin
        Application.ProcessMessages;
        LLine := Trim(LStreamReader.ReadLine);
        if copy(LLine, 1, 1) <> '#' then
        begin
          AddFile(LLine);
        end;
      end;
    finally
      LStreamReader.Close;
      LStreamReader.Free;
    end;
  end;
end;

procedure TMainForm.LoadPicFromStream(const Stream: TStream; const PicType: TCoverArtType);
begin
  if PicType = none then
  begin
    CoverImage.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\logo.png');
  end
  else if PicType = TCoverArtType.jpeg then
  begin
    FJpeg.LoadFromStream(Stream);
    CoverImage.Picture.Assign(FJpeg);
  end
  else if PicType = png then
  begin
    FPng.LoadFromStream(Stream);
    CoverImage.Picture.Assign(FPng);
  end
  else if PicType = bmp then
  begin
    CoverImage.Picture.Bitmap.LoadFromStream(Stream);
  end;
end;

procedure TMainForm.LoadPlayList;
var
  LStreamReader: TStreamReader;
  LPlayListItem: TPlayListItem;
  LLine: string;
  LSpltLst: TStringList;
begin
  if FileExists(FAppDataFolder + '\playlist.dat') then
  begin
    LStreamReader := TStreamReader.Create(FAppDataFolder + '\playlist.dat', True);
    LSpltLst := TStringList.Create;
    try
      LSpltLst.Delimiter := '|';
      LSpltLst.StrictDelimiter := True;

      while not LStreamReader.EndOfStream do
      begin
        LLine := Trim(LStreamReader.ReadLine);

        LSpltLst.DelimitedText := LLine;
        if LSpltLst.Count >= 9 then
        begin
          LPlayListItem.FullFileName := LSpltLst[0];
          LPlayListItem.Artist := LSpltLst[1];
          LPlayListItem.Album := LSpltLst[2];
          LPlayListItem.Title := LSpltLst[3];
          LPlayListItem.DurationStr := LSpltLst[4];
          LPlayListItem.Bitrate := LSpltLst[5];
          LPlayListItem.Channels := LSpltLst[6];
          LPlayListItem.Codec := LSpltLst[7];
          LPlayListItem.SampleRate := LSpltLst[8];
          FPlayListItems.Add(LPlayListItem);
        end;
      end;
    finally
      LStreamReader.Close;
      LStreamReader.Free;
      LSpltLst.Free;
      PlayList.Items.Count := FPlayListItems.Count;
    end;
  end;
end;

procedure TMainForm.LoadPPFPlaylist(const PlaylistPath: string);
var
  LStreamReader: TStreamReader;
  LPlayListItem: TPlayListItem;
  LLine: string;
  LSpltLst: TStringList;
begin
  if FileExists(PlaylistPath) then
  begin
    LStreamReader := TStreamReader.Create(PlaylistPath, True);
    LSpltLst := TStringList.Create;
    try
      LSpltLst.Delimiter := '|';
      LSpltLst.StrictDelimiter := True;

      while not LStreamReader.EndOfStream do
      begin
        LLine := Trim(LStreamReader.ReadLine);

        LSpltLst.DelimitedText := LLine;
        if LSpltLst.Count >= 9 then
        begin
          LPlayListItem.FullFileName := LSpltLst[0];
          LPlayListItem.Artist := LSpltLst[1];
          LPlayListItem.Album := LSpltLst[2];
          LPlayListItem.Title := LSpltLst[3];
          LPlayListItem.DurationStr := LSpltLst[4];
          LPlayListItem.Bitrate := LSpltLst[5];
          LPlayListItem.Channels := LSpltLst[6];
          LPlayListItem.Codec := LSpltLst[7];
          LPlayListItem.SampleRate := LSpltLst[8];
          FPlayListItems.Add(LPlayListItem);
        end;
      end;
    finally
      LStreamReader.Close;
      LStreamReader.Free;
      LSpltLst.Free;
    end;
  end;
end;

procedure TMainForm.LoadRadioStations;
var
  LStreamReader: TStreamReader;
  LLine: string;
  LRadioStation: TRadioStation;
  LSplitList: TStringList;
begin
  // remove all radio stations
  FRadioStations.Clear;
  RadioList.Items.Count := 0;
  RadioList.Invalidate;
  LStreamReader := TStreamReader.Create(ExtractFileDir(Application.ExeName) + '\Radios\' + RadioCatList.Text + '.txt');
  LSplitList := TStringList.Create;
  try
    LSplitList.StrictDelimiter := True;
    LSplitList.Delimiter := ';';
    while not LStreamReader.EndOfStream do
    begin
      LLine := Trim(LStreamReader.ReadLine);
      if Length(LLine) > 0 then
      begin
        LSplitList.DelimitedText := LLine;
        if LSplitList.Count = 3 then
        begin
          LRadioStation.Name := LSplitList[0];
          LRadioStation.URL := LSplitList[2];

          RadioList.Items.Count := RadioList.Items.Count + 1;
          FRadioStations.Add(LRadioStation);
        end;
      end;
    end;
  finally
    LStreamReader.Close;
    LStreamReader.Free;
    LSplitList.Free;
  end;
end;

procedure TMainForm.LoadSettings;
var
  SettingsFile: TIniFile;
begin
  SettingsFile := TIniFile.Create(FAppDataFolder + '\settings.ini');
  try
    with SettingsFile do
    begin
      FCurrentItemInfo.ItemIndex := ReadInteger('player', 'itemindex', -1);
      VolumeBar.Position := ReadInteger('player', 'volume', 50);
      PlaybackOrderList.ItemIndex := ReadInteger('player', 'order', 0);
      FLastDir := ReadString('player', 'lastdir', SysInfo.Folders.Personal);
      RadioCatList.ItemIndex := ReadInteger('radio', 'cat', 0);
      FuncPages.ActivePageIndex := ReadInteger('general', 'func', 0);
      FCurrentRadioIndex := ReadInteger('radio', 'curr', -1);
    end;
  finally
    SettingsFile.Free;
  end;
end;

procedure TMainForm.LyricListMouseLeave(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.MusicSearchFindFile(Sender: TObject; const AName: string);
begin
  ProgressLabel.Caption := ExtractFileDir(AName);
  AddFile(AName);
end;

procedure TMainForm.MusicSearchProgress(Sender: TObject);
begin
  Application.ProcessMessages;
end;

procedure TMainForm.NextBtnClick(Sender: TObject);
var
  LRndIndex: Integer;
begin
  if FPlaybackType = music then
  begin
    case PlaybackOrderList.ItemIndex of
      0: // normal
        begin
          PositionTimer.Enabled := False;
          VisTimer.Enabled := False;
          // playback follows selection
          if SettingsForm.PlayCursorBtn.Checked then
          begin
            // try selected file
            if PlayList.ItemIndex > -1 then
            begin
              if PlayList.ItemIndex <> FCurrentItemInfo.ItemIndex then
              begin
                PlayItem(PlayList.ItemIndex);
              end
              else
              begin
                if FCurrentItemInfo.ItemIndex + 1 < PlayList.Items.Count then
                begin
                  PlayItem(FCurrentItemInfo.ItemIndex + 1);
                end;
              end;
            end
            else
            begin
              // play next item
              if FCurrentItemInfo.ItemIndex + 1 < PlayList.Items.Count then
              begin
                PlayItem(FCurrentItemInfo.ItemIndex + 1);
              end;
            end;
          end
          else
          begin
            // ignore selection and try next song
            if FCurrentItemInfo.ItemIndex + 1 < PlayList.Items.Count then
            begin
              PlayItem(FCurrentItemInfo.ItemIndex + 1);
            end;
          end;
        end;
      1: // random
        begin
          Randomize;
          LRndIndex := Random(FPlayListItems.Count);
          PositionTimer.Enabled := False;
          VisTimer.Enabled := False;
          FPlayer.Stop;
          PlayItem(LRndIndex);
        end;
      2: // repear track
        begin
          PositionTimer.Enabled := False;
          VisTimer.Enabled := False;
          try
            if (FCurrentItemInfo.ItemIndex > -1) and (FCurrentItemInfo.ItemIndex < PlayList.Items.Count) then
            begin
              PlayItem(FCurrentItemInfo.ItemIndex);
            end;
          finally
            PositionTimer.Enabled := True;
            if SettingsForm.VisEnableBtn.Checked then
              VisTimer.Enabled := True;
          end;
        end;
      3: // shuffle
        begin
          PositionTimer.Enabled := False;
          VisTimer.Enabled := False;
          try
            if FShuffleIndex + 1 < FShuffleIndexes.Count then
            begin
              FShuffleIndex := 1 + FShuffleIndex;
              if FShuffleIndexes[FShuffleIndex] < FPlayListItems.Count then
              begin
                PlayItem(FShuffleIndexes[FShuffleIndex]);
              end;
            end;
          finally
            PositionTimer.Enabled := True;

            if SettingsForm.VisEnableBtn.Checked then
              VisTimer.Enabled := True;
          end;
        end;
    end;
  end;
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.NextBtnMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.o1Click(Sender: TObject);
var
  FileDir: string;
  index: Integer;
begin
  index := PlayList.ItemIndex;
  if index > -1 then
  begin
    FileDir := ExtractFileDir(FPlayListItems[index].FullFileName);

    if DirectoryExists(FileDir) then
    begin
      ShellExecute(Handle, 'open', 'explorer', PChar(' /n,/select, ' + '"' + FPlayListItems[index].FullFileName + '"'), nil, SW_SHOWNORMAL);
    end;
  end;
end;

procedure TMainForm.FuncPagesChange(Sender: TObject);
begin
  Self.Width := Self.Width + 1;
  Self.Width := Self.Width - 1;
end;

procedure TMainForm.FuncPagesMouseLeave(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.PauseBtnClick(Sender: TObject);
begin
  if FPlaybackType = music then
  begin
    if FPlayer.PlayerStatus = psPlaying then
    begin
      FPlayer.Pause;
      PositionTimer.Enabled := False;
      VisTimer.Enabled := False;
      SetProgressState(Handle, tbpsPaused);
      PlaybackInfoLabel.Caption := 'Paused | ' + FCurrentItemInfo.StatusInfoText;
    end
    else if FPlayer.PlayerStatus = psPaused then
    begin
      FPlayer.Resume;
      FPlayer.SetVolume(100 - VolumeBar.Position);
      PositionTimer.Enabled := True;
      if SettingsForm.VisEnableBtn.Checked then
        VisTimer.Enabled := True;
      SetProgressState(Handle, tbpsNormal);
      PlaybackInfoLabel.Caption := 'Playing | ' + FCurrentItemInfo.StatusInfoText;
    end;
  end
  else if FPlaybackType = radio then
  begin
    if not IsRadioPlayerStopped then
    begin
      if IsRadioPlayerPaused then
      begin
        ResumeRadio;
        PlaybackInfoLabel.Caption := 'Playing';
      end
      else
      begin
        PauseRadio;
        PlaybackInfoLabel.Caption := 'Paused';
      end;
    end;
  end;
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.PauseBtnMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.PauseRadio;
begin
  if BASS_ChannelIsActive(FRadioHandle) = BASS_ACTIVE_PLAYING then
  begin
    BASS_ChannelPause(FRadioHandle)
  end;
end;

procedure TMainForm.PlaybackOrderListChange(Sender: TObject);
begin
  if PlaybackOrderList.ItemIndex = 2 then
  begin
    GenerateShuffleList;
    FShuffleIndex := -1;
  end;
end;

procedure TMainForm.PlayBtnClick(Sender: TObject);
var
  LRndIndex: Integer;
begin
  case FuncPages.ActivePageIndex of
    0: // music player
      begin
{$REGION 'music play'}
        if FPlayer.PlayerStatus2 = psPaused then
        begin
          // if paused then resume
          FPlayer.Pause;
          FPlayer.SetVolume(100 - VolumeBar.Position);
          PositionTimer.Enabled := True;

          if SettingsForm.VisEnableBtn.Checked then
            VisTimer.Enabled := True;
          SetProgressState(Handle, tbpsNormal);
          PlaybackInfoLabel.Caption := 'Playing | ' + FCurrentItemInfo.StatusInfoText;
        end
        else
        begin
          if PlayList.ItemIndex = -1 then
          begin
            if PlayList.Items.Count > 0 then
            begin
              PlayList.ItemIndex := 0;
            end;
          end;
          if PlayList.ItemIndex > -1 then
          begin
            case PlaybackOrderList.ItemIndex of
              0: // normal
                begin
                  if SettingsForm.PlayCursorBtn.Checked then
                  begin
                    // follow the cursor
                    // if selected a different item
                    if PlayList.ItemIndex <> FCurrentItemInfo.ItemIndex then
                    begin
                      PositionTimer.Enabled := False;
                      VisTimer.Enabled := False;
                      FPlayer.Stop;
                      PlayItem(PlayList.ItemIndex);
                    end
                    else
                    begin
                      // current item is selected
                      // if paused continue
                      if FPlayer.PlayerStatus2 = psPaused then
                      begin
                        FPlayer.Pause;
                      end
                      else if FPlayer.PlayerStatus2 = psStopped then
                      begin
                        // if stopped start platyng
                        PositionTimer.Enabled := False;
                        VisTimer.Enabled := False;
                        FPlayer.Stop;
                        PlayItem(PlayList.ItemIndex);
                      end;
                    end;
                  end
                  else
                  begin
                    // don't follow the cursor
                    // if paused continue
                    if FPlayer.PlayerStatus2 = psPaused then
                    begin
                      FPlayer.Pause;
                    end
                    else if FPlayer.PlayerStatus2 = psStopped then
                    begin
                      // if stopped start platyng
                      PositionTimer.Enabled := False;
                      FPlayer.Stop;
                      PlayItem(PlayList.ItemIndex);
                    end;
                  end;
                end;
              1: // random
                begin
                  Randomize;
                  LRndIndex := Random(FPlayListItems.Count);
                  PositionTimer.Enabled := False;
                  VisTimer.Enabled := False;
                  FPlayer.Stop;
                  PlayItem(LRndIndex);
                end;
              2: // repear track
                begin
                  PositionTimer.Enabled := False;
                  VisTimer.Enabled := False;
                  try
                    if (FCurrentItemInfo.ItemIndex > -1) and (FCurrentItemInfo.ItemIndex < PlayList.Items.Count) then
                    begin
                      PlayItem(FCurrentItemInfo.ItemIndex);
                    end;
                  finally
                    PositionTimer.Enabled := True;
                  end;
                end;
              3: // shuffle
                begin
                  PositionTimer.Enabled := False;
                  VisTimer.Enabled := False;
                  try
                    if FShuffleIndex + 1 < FShuffleIndexes.Count then
                    begin
                      FShuffleIndex := 1 + FShuffleIndex;
                      if FShuffleIndexes[FShuffleIndex] < FPlayListItems.Count then
                      begin
                        PlayItem(FShuffleIndexes[FShuffleIndex]);
                      end;
                    end;
                  finally
                    PositionTimer.Enabled := True;

                    if SettingsForm.VisEnableBtn.Checked then
                      VisTimer.Enabled := True;
                  end;
                end;
            end;
          end;
          if Self.Enabled then
            Self.FocusControl(VolumeBar);
        end;
{$ENDREGION}
      end;
    1: // radio
      begin
        if IsRadioPlayerPaused then
        begin
          // resume
          ResumeRadio;
          SetProgressState(Handle, tbpsNormal);
        end
        else
        begin
          // start playing selected radio
          // make sure a radio is selected
          if RadioList.ItemIndex = -1 then
          begin
            if RadioList.Items.Count > 0 then
            begin
              RadioList.ItemIndex := 0;
            end;
          end;
          // start playing
          // if selected a different radio
          if PlayList.ItemIndex <> FCurrentRadioIndex then
          begin
            // kill prev process
            if not IsRadioPlayerStopped then
            begin
              StopRadio;
            end;
            FCurrentRadioIndex := RadioList.ItemIndex;
            PlayRadio(FRadioStations[FCurrentRadioIndex].URL);
          end
          else
          begin
            // current radio is selected
            if IsRadioPlayerPaused then
            begin
              ResumeRadio
            end
            else if IsRadioPlayerStopped then
            begin
              // kill prev process
              if not IsRadioPlayerStopped then
              begin
                StopRadio;
              end;
              FCurrentRadioIndex := RadioList.ItemIndex;
              PlayRadio(FRadioStations[FCurrentRadioIndex].URL);
            end;
          end;
        end;
      end;
  end;
end;

procedure TMainForm.PlayBtnMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.PlayItem(const ItemIndex: integer);
var
  LImageFile: string;
  LPlayIndex: integer;
begin
  FPlaybackType := music;
  PositionTimer.Enabled := False;
  VisTimer.Enabled := False;
  StopRadio;

  FPlayer.Stop;

  if FPlayer.ErrorMsg = MY_ERROR_OK then
  begin
    LPlayIndex := ItemIndex;
    while not FileExists(FPlayListItems[LPlayIndex].FullFileName) do
    begin
      LogForm.LogList.Lines.Add('[' + DateTimeToStr(Now) + '] Unable to find ' + FPlayListItems[LPlayIndex].FullFileName);
      if not LogForm.Visible then
      begin
        LogForm.Show;
      end;
      Inc(LPlayIndex);
      if LPlayIndex >= FPlayListItems.Count then
      begin
        Break;
      end;
    end;

    if LPlayIndex < FPlayListItems.Count then
    begin
      FCurrentItemInfo.ItemIndex := LPlayIndex;
      FCurrentItemInfo.FullFileName := FPlayListItems[FCurrentItemInfo.ItemIndex].FullFileName;
      FPlayer.FileName := FCurrentItemInfo.FullFileName;
      FPlayer.Play;
      FCurrentItemInfo.DurationBass := FPlayer.TotalLength;
      FCurrentItemInfo.DurationAsSecInt := FPlayer.DurationAsSec;
      FPlayer.Play;
      FCurrentItemInfo.StatusInfoText := FPlayListItems[FCurrentItemInfo.ItemIndex].Bitrate + ' | ' + FPlayListItems[FCurrentItemInfo.ItemIndex].Channels + ' | ' + FPlayListItems[FCurrentItemInfo.ItemIndex].Codec + ' | ' +
        FPlayListItems[FCurrentItemInfo.ItemIndex].SampleRate + ' Hz';
      PlaybackInfoLabel.Caption := 'Playing | ' + FCurrentItemInfo.StatusInfoText;
      PositionBar.Position := 0;
      FPlayer.SetVolume(100 - VolumeBar.Position);
      FStoppedByUser := False;

      PositionTimer.Enabled := True;

      if SettingsForm.VisEnableBtn.Checked then
        VisTimer.Enabled := True;
      PlayList.ItemIndex := -1;
      PlayList.ItemIndex := FCurrentItemInfo.ItemIndex;
      SetProgressState(Handle, tbpsNormal);
      PlayList.Refresh;
      with FPlayListItems[FCurrentItemInfo.ItemIndex] do
      begin
        Self.Caption := Title + ' - ' + Album + ' - ' + Artist + ' - [OooPlayer]';
        TitleLabel.Caption := Title;
        AlbumLabel.Caption := Album;
        ArtistLabel.Caption := Artist;
        // PositionLabel.Caption := '00:00:00/' + FPlayer.IntToTime(FCurrentItemInfo.DurationAsSecInt) + '/' + FPlayer.IntToTime(FCurrentItemInfo.DurationAsSecInt);
      end;
      // jump to current song
      if SettingsForm.PlayJumpBtn.Checked then
      begin
        J1Click(Self);
      end;
      if SettingsForm.LoadArtBtn.Checked then
      begin
        LoadCoverArt(FCurrentItemInfo.FullFileName);
      end
      else
      begin
        LImageFile := ExtractFileDir(Application.ExeName) + '\logo.png';
        if FLastCoverPath <> LImageFile then
        begin
          CoverImage.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\logo.png');
          FLastCoverPath := LImageFile;
        end;
      end;
    end
    else
    begin
      FPlayer.Stop;
      FStoppedByUser := False;
      LImageFile := ExtractFileDir(Application.ExeName) + '\logo.png';
      CoverImage.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\logo.png');
      FLastCoverPath := LImageFile;

      LogForm.LogList.Lines.Add('[' + DateTimeToStr(Now) + '] Reached the end of the playlist');
      if not LogForm.Visible then
      begin
        LogForm.Show;
      end;
    end;
  end
  else
  begin
    FPlayer.Stop;
    FStoppedByUser := False;
  end;
end;

procedure TMainForm.PlayListAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  if FPlayer.PlayerStatus2 = psStopped then
  begin
    Sender.Canvas.Font.Style := []
  end
  else
  begin
    if Item.Index = FCurrentItemInfo.ItemIndex then
    begin
      Sender.Canvas.Font.Style := [fsBold]
    end
    else
    begin
      Sender.Canvas.Font.Style := []
    end;
  end;
end;

procedure TMainForm.PlayListData(Sender: TObject; Item: TListItem);
begin
  if Item.Index < FPlayListItems.Count then
  begin
    Item.Caption := FPlayListItems[Item.Index].Artist + ' - ' + FPlayListItems[Item.Index].Album + ' - ' + FPlayListItems[Item.Index].Title;
    Item.SubItems.Add(FPlayListItems[Item.Index].DurationStr);
  end;
end;

procedure TMainForm.PlayListDblClick(Sender: TObject);
begin
  if PlayList.ItemIndex > -1 then
  begin
    PositionTimer.Enabled := False;
    VisTimer.Enabled := False;
    FPlayer.Stop;
    PlayItem(PlayList.ItemIndex);
  end;
end;

procedure TMainForm.PlayListDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Item: TListItem;
begin
  Item := PlayList.GetItemAt(X, Y);
  if Item <> nil then
  begin
    FPlayListItems.Move(TMyDragObject(Source).ItemIndex, Item.Index);
    if FDraggingCurrentFile then
    begin
      FCurrentItemInfo.ItemIndex := Item.Index;
    end;
    PlayList.Items[TMyDragObject(Source).ItemIndex].Selected := True;
    PlayList.Items[Item.Index].Selected := False;
    PlayList.Invalidate;
  end;
end;

procedure TMainForm.PlayListDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TMyDragObject);
end;

procedure TMainForm.PlayListMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(PlayList);
end;

procedure TMainForm.PlayListMouseLeave(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.PlayListStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  Item: TListItem;
begin
  Item := PlayList.Selected;
  if Item <> nil then
  begin
    DragObject := TMyDragObject.Create;
    TMyDragObject(DragObject).ItemIndex := Item.Index;
    FDraggingCurrentFile := Item.Index = FCurrentItemInfo.ItemIndex;
  end;
end;

procedure TMainForm.PlayRadio(const URL: Ansistring);
begin
  // stop music player
  FStoppedByUser := True;
  FPlayer.Stop;
  PositionBar.Position := 0;
  Self.Caption := 'OooPlayer';
  CoverImage.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\logo.png');
  TitleLabel.Caption := '';
  ArtistLabel.Caption := '';
  AlbumLabel.Caption := '';
  PlaybackInfoLabel.Caption := '';
  SetProgressValue(Handle, 0, MaxInt);
  PlayList.Invalidate;
  PositionTimer.Enabled := False;
  VisTimer.Enabled := False;
  FPlaybackType := radio;
  // stop radio player
  if not IsRadioPlayerStopped then
  begin
    StopRadio;
  end;
  // stop thread because we wiil run it again
  if not RadioThread.Terminated then
  begin
    RadioThread.Terminate;
  end;
  while not RadioThread.Terminated do
  begin
    Application.ProcessMessages;
    Sleep(50);
  end;

  RadioList.Invalidate;
  FRadioURL := URL;
  PlaybackInfoLabel.Caption := 'Connecting...';
  RadioThread.Start;
end;

procedure TMainForm.PositionBarChanged(Sender: TObject);
begin
  if (FPlayer.PlayerStatus2 = psPlaying) or (FPlayer.PlayerStatus2 = psPaused) then
  begin
    PositionTimer.Enabled := False;
    VisTimer.Enabled := False;
    try
      if not FPlayer.SetPosition((FPlayer.TotalLength * PositionBar.Position) div MaxInt) then
      begin
        PositionBar.Position := FPlayer.Position;
      end;
    finally
      PositionTimer.Enabled := True;

      if SettingsForm.VisEnableBtn.Checked then
        VisTimer.Enabled := True;
    end;
  end;
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.PositionBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewTractBarPosition: Integer;
begin
  if FPlayer.PlayerStatus2 = psPlaying then
  begin
    NewTractBarPosition := Round((X / PositionBar.ClientWidth) * MaxInt);

    if (NewTractBarPosition <> PositionBar.Position) then
    begin
      PositionBar.Position := NewTractBarPosition;
      PositionTimer.Enabled := False;
      VisTimer.Enabled := False;
      FPlayer.Pause;
      try
        if not FPlayer.SetPosition((FPlayer.TotalLength * PositionBar.Position) div MaxInt) then
        begin
          PositionBar.Position := FPlayer.Position;
        end;
      finally
        sleep(100);
        PositionTimer.Enabled := True;

        if SettingsForm.VisEnableBtn.Checked then
          VisTimer.Enabled := True;
        FPlayer.Resume;
      end;
    end;
  end;

  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.PositionBarMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.PositionTimerTimer(Sender: TObject);
var
  LRndIndex: Integer;
  LPosition: integer;
  LVisData: TVisData;
begin
  if FPlayer.PlayerStatus2 = psPlaying then
  begin
    LPosition := (MaxInt * FPlayer.Position) div FCurrentItemInfo.DurationBass;
    if LPosition > PositionBar.Position then
    begin
      PositionBar.Position := LPosition;
      SetProgressValue(Handle, LPosition, MaxInt);
      PositionLabel.Caption := FPlayer.PositionStr + '/' + FPlayer.IntToTime(FCurrentItemInfo.DurationAsSecInt - FPlayer.PositionAsSec) + '/' + FPlayer.IntToTime(FCurrentItemInfo.DurationAsSecInt);
    end;
    SetProgressValue(Handle, PositionBar.Position, PositionBar.Max);
  end
  else
  begin
    // stopped
    if FStoppedByUser then
    begin
      PositionTimer.Enabled := False;
      VisTimer.Enabled := False;
      PlaybackInfoLabel.Caption := '';
      Gauge1.Progress := 0;
      Gauge2.Progress := 0;
      Gauge3.Progress := 0;
      Gauge4.Progress := 0;
    end
    else
    begin
      case PlaybackOrderList.ItemIndex of
        0: // normal
          begin
            PositionTimer.Enabled := False;
            VisTimer.Enabled := False;
            // if playlist is not empty
            if PlayList.Items.Count > 0 then
            begin
              // playback follows selection
              if SettingsForm.PlayCursorBtn.Checked then
              begin
                // try selected file
                if PlayList.ItemIndex > -1 then
                begin
                  // if not last played item selected
                  if PlayList.ItemIndex <> FCurrentItemInfo.ItemIndex then
                  begin
                    PlayItem(PlayList.ItemIndex);
                  end
                  else
                  begin
                    // if last played item selected then try next item
                    if FCurrentItemInfo.ItemIndex + 1 < PlayList.Items.Count then
                    begin
                      PlayItem(FCurrentItemInfo.ItemIndex + 1);
                    end;
                  end;
                end
                else
                begin
                  // play next item
                  if FCurrentItemInfo.ItemIndex + 1 < PlayList.Items.Count then
                  begin
                    PlayItem(FCurrentItemInfo.ItemIndex + 1);
                  end;
                end;
              end
              else
              begin
                // ignore selection and try next song
                if FCurrentItemInfo.ItemIndex + 1 < PlayList.Items.Count then
                begin
                  PlayItem(FCurrentItemInfo.ItemIndex + 1);
                end;
              end;
            end
            else
            begin
              // empty playlist
              FPlayer.Stop;
              PositionBar.Position := 0;
              Self.Caption := 'OooPlayer';
              CoverImage.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\logo.png');
              TitleLabel.Caption := '';
              ArtistLabel.Caption := '';
              AlbumLabel.Caption := '';
              PlaybackInfoLabel.Caption := '';
              SetProgressValue(Handle, 0, MaxInt);
              if Self.Enabled then
                Self.FocusControl(VolumeBar);
            end;
          end;
        1: // random
          begin
            Randomize;
            LRndIndex := Random(FPlayListItems.Count);
            PositionTimer.Enabled := False;
            VisTimer.Enabled := False;
            FPlayer.Stop;
            PlayItem(LRndIndex);
          end;
        2: // repear track
          begin
            PositionTimer.Enabled := False;
            VisTimer.Enabled := False;
            try
              if (FCurrentItemInfo.ItemIndex > -1) and (FCurrentItemInfo.ItemIndex < PlayList.Items.Count) then
              begin
                PlayItem(FCurrentItemInfo.ItemIndex);
              end;
            finally
              PositionTimer.Enabled := True;

              if SettingsForm.VisEnableBtn.Checked then
                VisTimer.Enabled := True;
            end;
          end;
        3: // shuffle
          begin
            PositionTimer.Enabled := False;
            VisTimer.Enabled := False;
            try
              if FShuffleIndex + 1 < FShuffleIndexes.Count then
              begin
                FShuffleIndex := 1 + FShuffleIndex;
                if FShuffleIndexes[FShuffleIndex] < FPlayListItems.Count then
                begin
                  PlayItem(FShuffleIndexes[FShuffleIndex]);
                end;
              end;
            finally
              PositionTimer.Enabled := True;

              if SettingsForm.VisEnableBtn.Checked then
                VisTimer.Enabled := True;
            end;
          end;
      end;
    end;
  end;
end;

procedure TMainForm.PrevBtnClick(Sender: TObject);
var
  LRndIndex: Integer;
begin
  if FPlaybackType = music then
  begin
    case PlaybackOrderList.ItemIndex of
      0: // normal
        begin
          PositionTimer.Enabled := False;
          VisTimer.Enabled := False;
          if FCurrentItemInfo.ItemIndex > 0 then
          begin
            FPlayer.Stop;
            PlayItem(FCurrentItemInfo.ItemIndex - 1);
          end;
        end;
      1: // random
        begin
          Randomize;
          LRndIndex := Random(FPlayListItems.Count);
          PositionTimer.Enabled := False;
          VisTimer.Enabled := False;
          FPlayer.Stop;
          PlayItem(LRndIndex);
        end;
      2: // repear track
        begin
          PositionTimer.Enabled := False;
          VisTimer.Enabled := False;
          try
            if (FCurrentItemInfo.ItemIndex > -1) and (FCurrentItemInfo.ItemIndex < PlayList.Items.Count) then
            begin
              PlayItem(FCurrentItemInfo.ItemIndex);
            end;
          finally
            PositionTimer.Enabled := True;

            if SettingsForm.VisEnableBtn.Checked then
              VisTimer.Enabled := True;
          end;
        end;
      3: // shuffle
        begin
          PositionTimer.Enabled := False;
          VisTimer.Enabled := False;
          try
            if FShuffleIndex + 1 < FShuffleIndexes.Count then
            begin
              FShuffleIndex := 1 + FShuffleIndex;
              if FShuffleIndexes[FShuffleIndex] < FPlayListItems.Count then
              begin
                PlayItem(FShuffleIndexes[FShuffleIndex]);
              end;
            end;
          finally
            PositionTimer.Enabled := True;

            if SettingsForm.VisEnableBtn.Checked then
              VisTimer.Enabled := True;
          end;
        end;
    end;
  end;
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.PrevBtnMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.R1Click(Sender: TObject);
var
  I: Integer;
begin
  PlayList.Items.BeginUpdate;
  try
    for I := 0 to FPlayListItems.Count - 1 do
    begin
      Application.ProcessMessages;
      ReScanFile(i);
    end;
  finally
    PlayList.Items.EndUpdate;
  end;
end;

procedure TMainForm.R2Click(Sender: TObject);
begin
  if PlayList.ItemIndex > -1 then
  begin
    PlayList.Items[PlayList.ItemIndex].Delete;
    FPlayListItems.Delete(PlayList.ItemIndex);
    PlayList.Items.Count := PlayList.Items.Count - 1;
    PlayList.Repaint;
    StatusBar1.Panels[0].Text := Format('%d files', [PlayList.Items.Count]);
  end;
end;

procedure TMainForm.RadioCatListChange(Sender: TObject);
begin
  LoadRadioStations;
  FCurrentRadioIndex := -1;
  RadioList.Invalidate;
end;

procedure TMainForm.RadioListAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  if IsRadioPlayerStopped then
  begin
    Sender.Canvas.Font.Style := []
  end
  else
  begin
    if Item.Index = FCurrentRadioIndex then
    begin
      Sender.Canvas.Font.Style := [fsBold]
    end
    else
    begin
      Sender.Canvas.Font.Style := []
    end;
  end;
end;

procedure TMainForm.RadioListData(Sender: TObject; Item: TListItem);
begin
  if Item.Index < RadioList.Items.Count then
  begin
    Item.Caption := FRadioStations[Item.Index].Name;
  end;
end;

procedure TMainForm.RadioListDblClick(Sender: TObject);
begin
  if RadioList.ItemIndex > -1 then
  begin
    // do nothing if current stations is double clicked
    if RadioList.ItemIndex <> FCurrentRadioIndex then
    begin
      FCurrentRadioIndex := RadioList.ItemIndex;
      PlayRadio(FRadioStations[FCurrentRadioIndex].URL);
    end
    else
    begin
      if IsRadioPlayerStopped or (FRadioHandle = 0) then
      begin
        PlayRadio(FRadioStations[FCurrentRadioIndex].URL);
      end;
    end;
  end;
end;

procedure TMainForm.RadioListMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(RadioList);
end;

procedure TMainForm.RadioListMouseLeave(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.RadioResetUI;
begin
  PlaybackInfoLabel.Caption := '';
  TitleLabel.Caption := '';
  ArtistLabel.Caption := '';
  AlbumLabel.Caption := '';
  PlaybackInfoLabel.Caption := '';
  Self.Caption := 'OooPlayer';
end;

procedure TMainForm.RadioThreadRun(Sender: TIdThreadComponent);
var
  LCacheProgress: Integer;
  LLen: Cardinal;
  LMeta: PAnsiChar;
begin
  // previous stream
  BASS_StreamFree(FRadioHandle);
  // reset UI
  SendMessage(WinHandle, WM_INFO_UPDATE, RESET_UI, 0);
  LCacheProgress := 0;

  // create radio stream
  FRadioHandle := BASS_StreamCreateURL(PAnsiChar(FRadioURL), 0, BASS_STREAM_BLOCK or BASS_STREAM_STATUS or BASS_STREAM_AUTOFREE, @StatusProc, nil);
  if FRadioHandle = 0 then
  begin
    FRadioLogItem := 'Unable to play: ' + FRadioURL;
    RadioThread.Synchronize(AddToRadioLog);
    FRadioLogItem := 'Bass radio code: ' + FloatToStr(BASS_ErrorGetCode);
    RadioThread.Synchronize(AddToRadioLog);
    RadioThread.Synchronize(RadioResetUI);
  end
  else
  begin
    // cache progress
    repeat
      LLen := BASS_StreamGetFilePosition(FRadioHandle, BASS_FILEPOS_END);
      if (LLen = DW_Error) then
      begin
        break;
      end;
      LCacheProgress := (BASS_StreamGetFilePosition(FRadioHandle, BASS_FILEPOS_BUFFER) * 100) div LLen;
      // update ui
      SendMessage(WinHandle, WM_INFO_UPDATE, UPDATE_PROGRESS, LCacheProgress);
    until (LCacheProgress > 75) or (BASS_StreamGetFilePosition(FRadioHandle, BASS_FILEPOS_CONNECTED) = 0);

    // get meta data
    LMeta := BASS_ChannelGetTags(FRadioHandle, BASS_TAG_ICY);
    if (LMeta = nil) then
    begin
      // try http if icy fails
      LMeta := BASS_ChannelGetTags(FRadioHandle, BASS_TAG_HTTP);
    end;
    if (LMeta <> nil) then
      while (LMeta^ <> #0) do
      begin
        if (Copy(LMeta, 1, 9) = 'icy-name:') then
          SendMessage(WinHandle, WM_INFO_UPDATE, UPDATE_META_NAME, DWORD(PAnsiChar(Copy(LMeta, 10, MaxInt))))
        else if (Copy(LMeta, 1, 7) = 'icy-br:') then
          SendMessage(WinHandle, WM_INFO_UPDATE, UPDATE_META_BITRATE, DWORD(PAnsiChar('Bitrate: ' + Copy(LMeta, 8, MaxInt))));
        LMeta := LMeta + Length(LMeta) + 1;
      end;
    // get the stream title and set sync for subsequent titles
    DoMeta();
    BASS_ChannelSetSync(FRadioHandle, BASS_SYNC_META, 0, @MetaSync, nil);
    // play it!
    BASS_ChannelPlay(FRadioHandle, FALSE);
    SetRadioVolume(100 - VolumeBar.Position);
    // re-paint radio list
    SendMessage(WinHandle, WM_INFO_UPDATE, REPAINT_RADIO_LIST, 0);
  end;
  RadioThread.Terminate;
end;

function TMainForm.RemoveInvalidChars(const Title: string): string;
const
  InvalidCharacters: set of char = ['\', '/', ':', '*', '?', '"', '<', '>', '|', ' '];
var
  Tmp: string;
  I: Integer;
begin
  Result := Title;
  Tmp := '';
  for I := 1 to Length(Title) do
  begin
    if not CharInSet(Title[i], InvalidCharacters) then
    begin
      Tmp := Tmp + Title[i];
    end;
  end;
  Result := Tmp;
end;

procedure TMainForm.ReScanFile(const FileIndex: integer);
var
  MediaInfoHandle: Cardinal;
  LPlayListItem, LTmpItem: TPlayListItem;
  LTitle, LArtist, LAlbum, LDuration, LBitrate, LChannels, LCodec, LSampleRate: string;
begin

  if (FileExists(FPlayListItems[FileIndex].FullFileName)) then
  begin

    // New handle for mediainfo
    MediaInfoHandle := MediaInfo_New();
    { BassTagHandle := Bass_StreamCreateFile(false, PChar(FileName), 0, 0,
      Bass_Stream_Decode or BASS_UNICODE); }

    // initial values
    LTitle := 'unknown';
    LArtist := 'unknown';
    LAlbum := 'unknown';
    LDuration := '00:00:00.000';

    if (MediaInfoHandle <> 0) then
    begin

      try
        // read duration of file
        MediaInfo_Open(MediaInfoHandle, PWideChar(FPlayListItems[FileIndex].FullFileName));
        MediaInfo_Option(MediaInfoHandle, 'Complete', '1');

        LDuration := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'Duration/String3', Info_Text, Info_Name);
        LBitrate := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'BitRate/String', Info_Text, Info_Name);
        LChannels := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'Channel(s)/String', Info_Text, Info_Name);
        LCodec := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'Codec/String', Info_Text, Info_Name);
        LSampleRate := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'SamplingRate', Info_Text, Info_Name);
        // tags
        LTmpItem := FTagReader.ReadTags(FPlayListItems[FileIndex].FullFileName);
        LTitle := LTmpItem.Title;
        LArtist := LTmpItem.Artist;
        LAlbum := LTmpItem.Album;

        LTitle := Trim(LTitle);
        LArtist := Trim(LArtist);
        LAlbum := Trim(LAlbum);
        LDuration := Trim(LDuration);
        LCodec := Trim(LCodec);
        LSampleRate := Trim(LSampleRate);

        if (Length(LTitle) < 1) then
        begin
          // if cannot get title
          // set to file name
          LTitle := ChangeFileExt(ExtractFileName(FPlayListItems[FileIndex].FullFileName), '');
        end;

        if (Length(LArtist) < 1) then
        begin
          LArtist := 'unkown';
        end;

        if (Length(LAlbum) < 1) then
        begin
          LAlbum := 'unkown';
        end;

        if (Length(LDuration) < 1) then
        begin
          LDuration := '00:00:00.000';
        end;

        if (Length(LBitrate) < 1) then
        begin
          LBitrate := 'N/A';
        end;

        if (Length(LChannels) < 1) then
        begin
          LChannels := 'N/A';
        end;

        if (Length(LCodec) < 1) then
        begin
          LCodec := 'N/A';
        end;

        if (Length(LSampleRate) < 1) then
        begin
          LSampleRate := 'N/A';
        end;

        LPlayListItem := FPlayListItems[FileIndex];

        LPlayListItem.DurationStr := LDuration;
        LPlayListItem.Title := LTitle;
        LPlayListItem.Artist := LArtist;
        LPlayListItem.Album := LAlbum;
        LPlayListItem.DurationStr := LDuration;
        LPlayListItem.Bitrate := LBitrate;
        LPlayListItem.Channels := LChannels;
        LPlayListItem.Codec := LCodec;
        LPlayListItem.SampleRate := LSampleRate;
        FPlayListItems[FileIndex] := LPlayListItem;
      finally
        MediaInfo_Close(MediaInfoHandle);
      end;
    end;
  end;
end;

procedure TMainForm.ResumeRadio;
begin
  if BASS_ChannelIsActive(FRadioHandle) = BASS_ACTIVE_PAUSED then
  begin
    BASS_ChannelPlay(FRadioHandle, False)
  end;
end;

procedure TMainForm.S2Click(Sender: TObject);
begin
  Self.Enabled := False;
  SearchForm.ActiveControl := SearchForm.QueryEdit;
  SearchForm.Show;
end;

procedure TMainForm.s3Click(Sender: TObject);
var
  LSaveDlg: TSaveDialog;
begin
  if PlayList.Items.Count < 1 then
    Exit;

  LSaveDlg := TSaveDialog.Create(Self);
  try
    LSaveDlg.Filter := 'Player Playlist|*.ppf|M3U|*.m3u|M3U8|*.m3u8';
    if LSaveDlg.Execute then
    begin
      case LSaveDlg.FilterIndex of
        1:
          SavePPFPlaylist(ChangeFileExt(LSaveDlg.FileName, '.ppf'));
        2:
          SaveM3UPlayList(ChangeFileExt(LSaveDlg.FileName, '.m3u'), False);
        3:
          SaveM3UPlayList(ChangeFileExt(LSaveDlg.FileName, '.m3u8'), True);
      end;
    end;
  finally
    LSaveDlg.Free;
  end;
end;

procedure TMainForm.S4Click(Sender: TObject);
begin
  PlayList.SelectAll;
end;

procedure TMainForm.SaveM3UPlayList(const FileName: string; const UTF8: Boolean);
var
  LStreamWriter: TStreamWriter;
  I: Integer;
begin
  if not UTF8 then
  begin
    LStreamWriter := TStreamWriter.Create(FileName, False, TEncoding.ANSI);
  end
  else
  begin
    LStreamWriter := TStreamWriter.Create(FileName, False, TEncoding.UTF8);
  end;
  try
    for I := 0 to FPlayListItems.Count - 1 do
    begin
      Application.ProcessMessages;
      with FPlayListItems[i] do
      begin
        LStreamWriter.WriteLine(FullFileName);
      end;
    end;
  finally
    LStreamWriter.Close;
    LStreamWriter.Free;
  end;
end;

procedure TMainForm.SavePlayList;
var
  LStreamWriter: TStreamWriter;
  I: Integer;
begin
  if FileExists(FAppDataFolder + '\playlist.dat') then
  begin
    DeleteFile(FAppDataFolder + '\playlist.dat')
  end;
  LStreamWriter := TStreamWriter.Create(FAppDataFolder + '\playlist.dat', False, TEncoding.UTF8);
  try
    for I := 0 to FPlayListItems.Count - 1 do
    begin
      with FPlayListItems[i] do
      begin
        LStreamWriter.WriteLine(FullFileName + '|' + Artist + '|' + Album + '|' + Title + '|' + DurationStr + '|' + Bitrate + '|' + Channels + '|' + Codec + '|' + SampleRate);
      end;
    end;
  finally
    LStreamWriter.Close;
    LStreamWriter.Free;
  end;
end;

procedure TMainForm.SavePPFPlaylist(const FileName: string);
var
  LStreamWriter: TStreamWriter;
  I: Integer;
begin
  LStreamWriter := TStreamWriter.Create(FileName, False, TEncoding.UTF8);
  try
    for I := 0 to FPlayListItems.Count - 1 do
    begin
      Application.ProcessMessages;
      with FPlayListItems[i] do
      begin
        LStreamWriter.WriteLine(FullFileName + '|' + Artist + '|' + Album + '|' + Title + '|' + DurationStr + '|' + Bitrate + '|' + Channels + '|' + Codec + '|' + SampleRate);
      end;
    end;
  finally
    LStreamWriter.Close;
    LStreamWriter.Free;
  end;
end;

procedure TMainForm.SaveSettings;
var
  SettingsFile: TIniFile;
begin
  SettingsFile := TIniFile.Create(FAppDataFolder + '\settings.ini');
  try
    with SettingsFile do
    begin
      WriteInteger('player', 'itemindex', FCurrentItemInfo.ItemIndex);
      WriteInteger('player', 'volume', VolumeBar.Position);
      WriteInteger('player', 'order', PlaybackOrderList.ItemIndex);
      WriteString('player', 'lastdir', FLastDir);
      WriteInteger('radio', 'cat', RadioCatList.ItemIndex);
      WriteInteger('general', 'func', FuncPages.ActivePageIndex);
      WriteInteger('radio', 'curr', FCurrentRadioIndex);
    end;
  finally
    SettingsFile.Free;
  end;
end;

procedure TMainForm.ScrollToCurrentSong;
begin
  if (FCurrentItemInfo.ItemIndex < FPlayListItems.Count) and (FCurrentItemInfo.ItemIndex > -1) then
  begin
    PlayList.Items[FCurrentItemInfo.ItemIndex].MakeVisible(False);
    PlayList.ItemIndex := -1;
    PlayList.ItemIndex := FCurrentItemInfo.ItemIndex;
  end;
end;

procedure TMainForm.ScrollToItem(const ItemIndex: integer);
begin
  if (ItemIndex < FPlayListItems.Count) and (ItemIndex > -1) then
  begin
    PlayList.Items[ItemIndex].MakeVisible(False);
    PlayList.ItemIndex := -1;
    PlayList.ItemIndex := ItemIndex;
  end;
end;

procedure TMainForm.SetRadioVolume(const Volume: integer);
begin
  BASS_ChannelSetAttribute(FRadioHandle, BASS_ATTRIB_VOL, Volume / 100.0)
end;

procedure TMainForm.Splitter1Moved(Sender: TObject);
begin
  PlayList.Columns[0].Width := PlayList.ClientWidth - PlayList.Columns[1].Width;
end;

procedure TMainForm.StopBtnClick(Sender: TObject);
begin
  if FPlaybackType = music then
  begin
    // music
    FStoppedByUser := True;
    FPlayer.Stop;
  end
  else if FPlaybackType = radio then
  begin
    // radio
    if not IsRadioPlayerStopped then
    begin
      StopRadio;
    end;
  end;
  PositionBar.Position := 0;
  Self.Caption := 'OooPlayer';
  CoverImage.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\logo.png');
  TitleLabel.Caption := '';
  ArtistLabel.Caption := '';
  AlbumLabel.Caption := '';
  PlaybackInfoLabel.Caption := '';
  SetProgressValue(Handle, 0, MaxInt);
  PlayList.Invalidate;
  RadioList.Invalidate;
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.StopBtnMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.StopRadio;
begin
  if BASS_ChannelIsActive(FRadioHandle) <> BASS_ACTIVE_STOPPED then
  begin
    BASS_ChannelStop(FRadioHandle)
  end;
end;

procedure TMainForm.TopBarPnlMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.UpdateCheckerDoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
var
  VersionFile: TStringList;
  LatestVersion: Integer;
begin
  VersionFile := TStringList.Create;
  try
    if StreamSize > 0 then
    begin
      VersionFile.LoadFromStream(Stream);
      if VersionFile.Count = 1 then
      begin
        if TryStrToInt(VersionFile.Strings[0], LatestVersion) then
        begin
          if LatestVersion > BuildInt then
          begin
            if ID_YES = Application.MessageBox('There is a new version. Would you like to go homepage and download it?', 'New Version', MB_ICONQUESTION or MB_YESNO) then
            begin
              ShellExecute(Handle, 'open', 'https://sourceforge.net/projects/oooplayer/', nil, nil, SW_NORMAL);
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(VersionFile);
  end;
end;

procedure TMainForm.UpdateThreadExecute(Sender: TObject; Params: Pointer);
begin
  with UpdateChecker do
  begin
    Url := 'http://sourceforge.net/projects/oooplayer/files/version.txt/download';
    Start;
  end;

  UpdateThread.CancelExecute;
end;

// function TMainForm.TPlayerErrorToStr(const ErrorMsg: Integer): string;
// begin
// case ErrorMsg of
// 0:
// Result := 'OK.';
// 1:
// Result := 'Bass not loaded.';
// 2:
// Result := 'Could not stop previous stream.';
// 3:
// Result := 'Stream is zero.';
// 4:
// Result := 'OK';
// 5:
// Result := 'OK';
// 6:
// Result := 'OK';
// end;
// end;

procedure TMainForm.V1Click(Sender: TObject);
begin
  if VolumeBar.Position > 0 then
  begin
    VolumeBar.Position := VolumeBar.Position - 1
  end;
end;

procedure TMainForm.V2Click(Sender: TObject);
begin
  if VolumeBar.Position < 100 then
  begin
    VolumeBar.Position := VolumeBar.Position + 1
  end;
end;

procedure TMainForm.VisTimerTimer(Sender: TObject);
var
  LVis: TVisData;
begin
  if FPlayer.PlayerStatus2 = psPlaying then
  begin
    LVis := GetVisData(FPlayer.Channel);
    Gauge1.Progress := Trunc(lVis[0]);
    Gauge2.Progress := Trunc(lVis[1]);
    Gauge3.Progress := Trunc(lVis[2]);
    Gauge4.Progress := Trunc(lVis[3]);
  end;
end;

procedure TMainForm.VolumeBarChange(Sender: TObject);
begin
  if FPlaybackType = music then
  begin
    if (FPlayer.PlayerStatus = psPlaying) or (FPlayer.PlayerStatus = psPaused) then
    begin
      FPlayer.SetVolume(100 - VolumeBar.Position);
    end;
    StatusBar1.Panels[1].Text := FloatToStr(100 - VolumeBar.Position) + '%'
  end
  else if FPlaybackType = radio then
  begin
    // radio
    if not IsRadioPlayerStopped then
    begin
      SetRadioVolume(100 - VolumeBar.Position);
    end;
  end;
  StatusBar1.Panels[1].Text := FloatToStr(100 - VolumeBar.Position) + '%'
end;

procedure TMainForm.VolumeBarMouseEnter(Sender: TObject);
begin
  if Self.Enabled then
    Self.FocusControl(VolumeBar);
end;

procedure TMainForm.WndProc(var Msg: TMessage);
begin
  inherited;
  if Msg.Msg = WM_INFO_UPDATE then
  begin
    case msg.WParam of
      RESET_UI:
        begin
          TitleLabel.Caption := 'Connecting...';
          PlaybackInfoLabel.Caption := '';
          TitleLabel.Caption := '';
          ArtistLabel.Caption := '';
          AlbumLabel.Caption := '';
          PlaybackInfoLabel.Caption := '';
          Self.Caption := 'RAdio [OooPlayer]';
        end;
      SHOW_ERROR:
        begin
          TitleLabel.Caption := 'Error';
          FRadioLogItem := 'Unable to play radio. Error code: ' + IntToStr(msg.LParam);
          AddToRadioLog;
        end;
      UPDATE_PROGRESS:
        TitleLabel.Caption := Format('Buffering... %d%%', [msg.LParam]);
      UPDATE_META_NAME:
        begin
          TitleLabel.Caption := String(PAnsiChar(msg.LParam));
          Self.Caption := String(PAnsiChar(msg.LParam)) + ' [OooPlayer]';
        end;
      UPDATE_META_BITRATE:
        AlbumLabel.Caption := String(PAnsiChar(msg.LParam)) + ' kbps';
      // 5:
      // Label5.Caption := String(PAnsiChar(msg.LParam));
      // 6:
      // Label3.Caption := String(PAnsiChar(msg.LParam));
      UPDATE_META:
        ArtistLabel.Caption := String(PAnsiChar(msg.LParam));
      STATUS_UPDATE:
        begin
          if (String(PAnsiChar(msg.LParam)) = 'ICY 200 OK') or (String(PAnsiChar(msg.LParam)) = 'HTTP/1.0 200 OK') then
          begin
            PlaybackInfoLabel.Caption := 'Playing';
          end
          else
          begin
            PlaybackInfoLabel.Caption := String(PAnsiChar(msg.LParam));
          end;
        end;
      REPAINT_RADIO_LIST:
        RadioList.Invalidate;
    end;
  end;
end;

end.